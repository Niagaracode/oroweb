import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/MQTTManager.dart';
import '../../constants/http_service.dart';
import '../../state_management/program_queue_provider.dart';
import '../../widgets/SCustomWidgets/custom_snack_bar.dart';

class ProgramQueueScreen extends StatefulWidget {
  final int userId;
  final int controllerId, customerId;
  final String deviceId;

  const ProgramQueueScreen({Key? key, required this.userId, required this.controllerId, required this.customerId, required this.deviceId, required int cutomerId}) : super(key: key);

  @override
  _ProgramQueueScreenState createState() => _ProgramQueueScreenState();
}

class _ProgramQueueScreenState extends State<ProgramQueueScreen> {
  late ProgramQueueProvider programQueueProvider;
  HttpService httpService = HttpService();
  late MQTTManager manager;

  @override
  void initState() {
    super.initState();
    manager = MQTTManager();
    programQueueProvider = Provider.of<ProgramQueueProvider>(context, listen: false);
    if(mounted) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        programQueueProvider.getUserProgramQueueData(widget.userId, widget.controllerId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProgramQueueProvider>(
        builder: (context, programQueueProvider, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Program Queue"),
              automaticallyImplyLeading: false,
            ),
            body: _buildBody(),
            floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Visibility(
                  visible: programQueueProvider.select || programQueueProvider.select2,
                  child: OutlinedButton(
                      onPressed: programQueueProvider.selectedIndexes1.isNotEmpty || programQueueProvider.selectedIndexes2.isNotEmpty ? (){
                        programQueueProvider.updatePriority();
                      } : null,
                      child: Text(
                        programQueueProvider.select ? "Move To Low Priority" : "Move To High Priority",
                        style: TextStyle(color: programQueueProvider.selectedIndexes1.isNotEmpty || programQueueProvider.selectedIndexes2.isNotEmpty ? null : Colors.grey),
                      )
                  ),
                ),
                const SizedBox(width: 20,),
                OutlinedButton(
                    onPressed: () async{
                      Map<String, dynamic> userData = {
                        "userId": widget.userId,
                        "controllerId": widget.controllerId,
                        "createUser": widget.userId
                      };
                      userData.addAll({
                        "programQueue": programQueueProvider.programQueueResponse!.data.toJson()
                      });
                      try {
                        final createUserProgramQueue = await httpService.postRequest('createUserProgramQueue', userData);
                        final response = jsonDecode(createUserProgramQueue.body);
                        final payload = {"2800": [{"2801": programQueueProvider.programQueueResponse!.data.toHardware()}]};
                        if(createUserProgramQueue.statusCode == 200) {
                          manager.publish(jsonEncode(payload), "AppToFirmware/${widget.deviceId}");
                          ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(message: response['message']));
                        }
                      } catch (error) {
                        ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(message: 'Failed to update because of $error'));
                        print("Error: $error");
                      }
                    },
                    child: const Text("SAVE")
                ),
                const SizedBox(width: 20,),
              ],
            ),
          );
        }
    );
  }

  Widget _buildBody() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return programQueueProvider.programQueueResponse?.data != null
            ? Consumer<ProgramQueueProvider>(
            builder: (context, programQueueProvider, _) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    _buildColumn(context, programQueueProvider.programQueueResponse!.data.low, "NORMAL PRIORITY"),
                    _buildColumn(context, programQueueProvider.programQueueResponse!.data.high, "HIGH PRIORITY"),
                  ],
                ),
              );
            }
        )
            : const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildColumn(BuildContext context, programs, priorityType) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            priorityType == "HIGH PRIORITY"
                ? _buildCategory(
                context,
                priorityType,
                programQueueProvider,
                    () {
                  programQueueProvider.updateSelection();
                  if(!programQueueProvider.select) {
                    programQueueProvider.selectedIndexes1.clear();
                    programQueueProvider.selectAll = false;
                  }
                },
                programQueueProvider.select,
                    () {
                  programQueueProvider.updateSelectAll();
                  programQueueProvider.toggleSelectAll(programQueueProvider.programQueueResponse!.data.high.length);
                },
                programQueueProvider.selectAll,
                programQueueProvider.programQueueResponse!.data.high.isEmpty || programQueueProvider.select2 ? true : false
            )
                : _buildCategory(
                context,
                priorityType,
                programQueueProvider,
                    () {
                  programQueueProvider.updateSelection2();
                  if(!programQueueProvider.select2) {
                    programQueueProvider.selectedIndexes2.clear();
                    programQueueProvider.selectAll2 = false;
                  }
                },
                programQueueProvider.select2,
                    () {
                  programQueueProvider.updateSelectAll2();
                  programQueueProvider.toggleSelectAll2(programQueueProvider.programQueueResponse!.data.low.length);
                },
                programQueueProvider.selectAll2,
                programQueueProvider.programQueueResponse!.data.low.isEmpty || programQueueProvider.select ? true : false
            ),
            _buildHeaderRow(context),
            _buildProgramList(context, programs, programQueueProvider, priorityType),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderRow(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8)
      ),
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            _buildHeaderText(context, "ID"),
            _buildHeaderText(context, 'Program Name'),
            _buildHeaderText(context, 'Waiting in Q'),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderText(BuildContext context, String text,) {
    return Expanded(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            text,
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildCategory(BuildContext context, String text, programQueueProvider, VoidCallback onPressed, bool visible, VoidCallback onPressed2, allSelection, ignoring) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            text,
            style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          OutlinedButton(
            onPressed: ignoring ? null : onPressed,
            child: Text(visible ? "CANCEL" : "SELECT",
              style: TextStyle(color: visible ? Colors.red : ignoring ? Colors.grey : null),),
          ),
          visible ? OutlinedButton(
            onPressed: onPressed2,
            child: Text(allSelection ? "UNSELECT ALL" : "SELECT ALL", style: TextStyle(color: allSelection ? Colors.red : null),),
          ) : Container()
        ],
      ),
    );
  }

  Widget _buildProgramList(BuildContext context, programs, programQueueProvider, priorityType) {
    return Expanded(
      child: ListView.builder(
        itemCount: programs.length,
        itemBuilder: (context, index) {
          final program = programs[index];
          return Visibility(
            visible: program.programName != "" ? true : false,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                // side: index == programQueueProvider.selectedIndex ? BorderSide(color: Theme.of(context).primaryColor) : BorderSide.none
              ),
              elevation: priorityType == "HIGH PRIORITY"
                  ? programQueueProvider.selectedIndexes1.contains(index) ? 10 : 3
                  : programQueueProvider.selectedIndexes2.contains(index) ? 10 : 3,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildProgramInfo(
                      context,
                      CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                        child: Text(
                          '${program.programQueueId}',
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    _buildProgramInfo(context, '${program.programName}'),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildProgramInfo(context, '${program.startTime}'),
                          Visibility(
                              visible: priorityType == "HIGH PRIORITY"
                                  ? programQueueProvider.select : programQueueProvider.select2,
                              child: Checkbox(
                                  value: priorityType == "HIGH PRIORITY" ? programQueueProvider.selectedIndexes1.contains(index) : programQueueProvider.selectedIndexes2.contains(index),
                                  onChanged: (newValue){
                                    priorityType == "HIGH PRIORITY" ? programQueueProvider.toggleSelectIndex(index) : programQueueProvider.toggleSelectIndex2(index);
                                  }
                              )
                          )
                        ],
                      ),
                    )
                    // _buildProgramInfo(
                    //   context,
                    //   CustomNativeTimePicker(
                    //     initialValue: program.startTime,
                    //     onChanged: (newTime) {},
                    //     is24HourMode: true,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProgramInfo(BuildContext context, dynamic content) {
    return Expanded(
      child: Center(
        child: content is Widget ? content : Text(content),
      ),
    );
  }
}
