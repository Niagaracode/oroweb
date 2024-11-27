import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:oro_irrigation_new/screens/Customer/IrrigationProgram/irrigation_program_main.dart';
import 'package:provider/provider.dart';
import '../../../Models/Customer/Dashboard/DashboardNode.dart';
import '../../../constants/MQTTManager.dart';
import '../../../constants/MyFunction.dart';
import '../../../constants/http_service.dart';
import '../../../constants/snack_bar.dart';
import '../../../constants/theme.dart';
import '../../../state_management/MqttPayloadProvider.dart';
import '../ScheduleView.dart';

class ScheduledProgramList extends StatelessWidget {
  ScheduledProgramList({Key? key, required this.siteData, required this.userId, required this.scheduledPrograms, required this.masterInx}) : super(key: key);
  final DashboardModel siteData;
  final int userId, masterInx;
  final AudioPlayer audioPlayer = AudioPlayer();
  final List<ScheduledProgram> scheduledPrograms;

  @override
  Widget build(BuildContext context) {

    final spaPayload = Provider.of<MqttPayloadProvider>(context).spa;

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if(spaPayload.toString().isNotEmpty){
        MyFunction().clearAg(context);
        String message = spaPayload['Message'];
        String code = spaPayload['Code'];
        GlobalSnackBar.show(context, message, int.parse(code));
      }
    });


    scheduledPrograms.sort((a, b) {
      DateTime dateTimeA = a.getDateTime();
      DateTime dateTimeB = b.getDateTime();
      return dateTimeA.compareTo(dateTimeB);
    });

    var screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: screenWidth > 600 ? buildWideLayout(context):
                buildNarrowLayout(context),
              ),
              Positioned(
                top: 5,
                left: 0,
                child: Container(
                  width: 200,
                  padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 2),
                  decoration: BoxDecoration(
                      color: primaryColorSolarGray,
                      borderRadius: const BorderRadius.all(Radius.circular(2)),
                      border: Border.all(width: 0.5, color: primaryColorSolarGray)
                  ),
                  child: const Text('SCHEDULED PROGRAM',  style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );

  }

  Widget buildNarrowLayout(context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: scheduledPrograms.length * 210,
      child: Card(
        surfaceTintColor: Colors.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(3))),
        elevation: 5,
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: scheduledPrograms.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Program Name', style: TextStyle(fontWeight: FontWeight.normal),),
                              SizedBox(height: 3,),
                              Text('Scheduled method', style: TextStyle(fontWeight: FontWeight.normal),),
                              SizedBox(height: 3,),
                              Text('Message', style: TextStyle(fontWeight: FontWeight.normal),),
                              SizedBox(height: 3,),
                              Text('Total Zone', style: TextStyle(fontWeight: FontWeight.normal),),
                              SizedBox(height: 3,),
                              Text('Start Date & Time', style: TextStyle(fontWeight: FontWeight.normal),),
                              SizedBox(height: 3,),
                              Text('End Date', style: TextStyle(fontWeight: FontWeight.normal),),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(scheduledPrograms[index].progName),
                              const SizedBox(height: 3,),
                              Text(getSchedulingMethodName(scheduledPrograms[index].schedulingMethod)),
                              const SizedBox(height: 3,),
                              Text(getContentByCode(scheduledPrograms[index].startStopReason), style: const TextStyle(fontSize: 11, color: Colors.black),),
                              const SizedBox(height: 3,),
                              Text('${scheduledPrograms[index].totalZone}'),
                              const SizedBox(height: 3,),
                              Text('${changeDateFormat(scheduledPrograms[index].startDate)} : ${convert24HourTo12Hour(scheduledPrograms[index].startTime)}'),
                              const SizedBox(height: 3,),
                              Text(changeDateFormat(scheduledPrograms[index].endDate))
                            ],
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          scheduledPrograms[index].progOnOff == 0 ? MaterialButton(
                            color: primaryColorPureGreen,
                            textColor: Colors.white,
                            onPressed:() {
                              String localFilePath = 'assets/audios/button_click_sound.mp3';
                              audioPlayer.play(UrlSource(localFilePath));
                              String payload = '${scheduledPrograms[index].sNo},1';
                              String payLoadFinal = jsonEncode({
                                "2900": [{"2901": payload}]
                              });
                              MQTTManager().publish(payLoadFinal, 'AppToFirmware/${siteData.master[masterInx].deviceId}');
                              sentUserOperationToServer('${scheduledPrograms[index].progName} Started Manually', payLoadFinal);
                            },
                            child: const Text('Start by Manual'),
                          ):
                          MaterialButton(
                            color: Colors.redAccent,
                            textColor: Colors.white,
                            onPressed:() {
                              String localFilePath = 'assets/audios/audio_off.mp3';
                              audioPlayer.play(UrlSource(localFilePath));
                              String payload = '${scheduledPrograms[index].sNo},0';
                              String payLoadFinal = jsonEncode({
                                "2900": [{"2901": payload}]
                              });
                              MQTTManager().publish(payLoadFinal, 'AppToFirmware/${siteData.master[masterInx].deviceId}');
                              sentUserOperationToServer('${scheduledPrograms[index].progName} Stopped Manually', payLoadFinal);
                            },
                            child: const Text('Stop by Manual'),
                          ),
                          const SizedBox(width: 5),
                          MaterialButton(
                            color: Colors.orange,
                            textColor: Colors.white,
                            onPressed:() {
                              String payload = '${scheduledPrograms[index].sNo},2';
                              String payLoadFinal = jsonEncode({
                                "2900": [{"2901": payload}]
                              });
                              MQTTManager().publish(payLoadFinal, 'AppToFirmware/${siteData.master[masterInx].deviceId}');
                              sentUserOperationToServer('${scheduledPrograms[index].progName} Paused Manually', payLoadFinal);
                            },
                            child: const Text('Pause'),
                          ),
                          const SizedBox(width: 5),
                        ],
                      ),
                    ],
                  ),
                ),
                if(index != scheduledPrograms.length - 1)
                  const Padding(
                    padding: EdgeInsets.only(right: 5,left: 5),
                    child: Divider(color: primaryColorPureGreen, thickness: 0.3,),
                  ),
                const SizedBox(height: 5,),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildWideLayout(context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: primaryColorLightGray,
          width: 0.7,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      height: (scheduledPrograms.length * 45) + 45,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: DataTable2(
          columnSpacing: 12,
          horizontalMargin: 12,
          minWidth: 1000,
          dataRowHeight: 45.0,
          headingRowHeight: 40.0,
          headingRowColor: WidgetStateProperty.all<Color>(primaryColorLightGray),
          columns:  [
            const DataColumn2(
              label: Text('Line Id', style: TextStyle(fontSize: 13),),
              fixedWidth: 50,
            ),
            const DataColumn2(
              label: Text('Name', style: TextStyle(fontSize: 13),),
              size: ColumnSize.M,
            ),
            const DataColumn2(
              label: Text('Method', style: TextStyle(fontSize: 13)),
              size: ColumnSize.M,
            ),
            const DataColumn2(
              label: Text('Status or Reason', style: TextStyle(fontSize: 13)),
              size: ColumnSize.L,
            ),
            const DataColumn2(
              label: Center(child: Text('Zone', style: TextStyle(fontSize: 13),)),
              fixedWidth: 50,
            ),
            const DataColumn2(
              label: Center(child: Text('Start Date & Time', style: TextStyle(fontSize: 13),)),
              size: ColumnSize.M,
            ),
            const DataColumn2(
              label: Center(child: Text('End Date', style: TextStyle(fontSize: 13),)),
              size: ColumnSize.S,
            ),
            DataColumn2(
              label: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      tooltip: 'Scheduled Program details',
                      onPressed: getPermissionStatusBySNo(context, 3) ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ScheduleViewScreen(deviceId: siteData.master[masterInx].deviceId, userId: userId, controllerId: siteData.master[masterInx].controllerId, customerId: siteData.customerId),
                          ),
                        );
                      }:null,
                      icon: const Icon(Icons.view_list_outlined)),
                ],
              ),
              fixedWidth: 265,
            ),
          ],
          rows: List<DataRow>.generate(scheduledPrograms.length, (index) {
            String buttonName = getButtonName(int.parse(scheduledPrograms[index].progOnOff));
            bool isStop = buttonName.contains('Stop');
            bool isBypass = buttonName.contains('Bypass');

            return DataRow(cells: [
              DataCell(Text(scheduledPrograms[index].progCategory)),
              DataCell(Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(scheduledPrograms[index].progName),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: scheduledPrograms[index].programStatusPercentage / 100.0,
                          borderRadius: const BorderRadius.all(Radius.circular(3)),
                          color: Colors.blue.shade300,
                          backgroundColor: Colors.grey.shade200,
                          minHeight: 2.5,
                        ),
                      ),
                      const SizedBox(width: 7),
                      Text(
                        '${scheduledPrograms[index].programStatusPercentage}%',
                        style: const TextStyle(fontSize: 12, color: Colors.black45),
                      ),
                    ],
                  ),
                ],
              )),
              DataCell(Text(getSchedulingMethodName(scheduledPrograms[index].schedulingMethod))),
              DataCell(Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Start Stop: ',
                                style: TextStyle(
                                  color: primaryColorPureGreen,
                                  fontSize: 12,
                                ),
                              ),
                              TextSpan(
                                text: getContentByCode(scheduledPrograms[index].startStopReason),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        scheduledPrograms[index].pauseResumeReason!=30?RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Pause Resume: ',
                                style: TextStyle(
                                  color: primaryColorPureGreen,
                                  fontSize: 12,
                                ),
                              ),
                              TextSpan(
                                text: getContentByCode(scheduledPrograms[index].pauseResumeReason),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ):
                        const SizedBox(),
                      ],
                    ),
                  ),
                  scheduledPrograms[index].startCondition.condition.isNotEmpty ||
                      scheduledPrograms[index].stopCondition.condition.isNotEmpty?
                  IconButton(
                    tooltip: 'view condition',
                    onPressed: () {
                      showAutoUpdateDialog(context,
                        scheduledPrograms[index].sNo,
                      );
                    },
                    icon: const Icon(Icons.visibility_outlined, color: primaryColorPureGreen,),
                  ):
                  const SizedBox(),
                ],
              )),
              DataCell(Center(child: Text('${scheduledPrograms[index].totalZone}'))),
              DataCell(Center(child: Text('${changeDateFormat(scheduledPrograms[index].startDate)} : ${convert24HourTo12Hour(scheduledPrograms[index].startTime)}'))),
              DataCell(Center(child: Text(changeDateFormat(scheduledPrograms[index].endDate)))),
              DataCell(Row(
                children: [
                  Tooltip(
                    message: getDescription(int.parse(scheduledPrograms[index].progOnOff)),
                    child: MaterialButton(
                      color: int.parse(scheduledPrograms[index].progOnOff) >= 0? isStop?primaryColorPureRed: isBypass?Colors.orange :primaryColorPureGreen : Colors.grey.shade300,
                      textColor: Colors.white,
                      onPressed: () {

                        if(getPermissionStatusBySNo(context, 3)){
                          if (int.parse(scheduledPrograms[index].progOnOff) >= 0) {
                            String localFilePath = 'assets/audios/button_click_sound.mp3';
                            audioPlayer.play(UrlSource(localFilePath));
                            String payload = '${scheduledPrograms[index].sNo},${scheduledPrograms[index].progOnOff}';
                            String payLoadFinal = jsonEncode({
                              "2900": [
                                {"2901": payload}
                              ]
                            });
                            MQTTManager().publish(payLoadFinal, 'AppToFirmware/${siteData.master[masterInx].deviceId}');
                            sentUserOperationToServer(
                              '${scheduledPrograms[index].progName} ${getDescription(int.parse(scheduledPrograms[index].progOnOff))}',
                              payLoadFinal,
                            );
                          }
                        }else{
                          GlobalSnackBar.show(context, 'Permission denied', 400);
                        }
                      },
                      child: Text(
                        buttonName,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  MaterialButton(
                    color: getButtonName(int.parse(scheduledPrograms[index].progPauseResume)) == 'Pause' ? Colors.orange : Colors.yellow,
                    textColor: getButtonName(int.parse(scheduledPrograms[index].progPauseResume)) == 'Pause' ? Colors.white : Colors.black,
                    onPressed: () {
                      if(getPermissionStatusBySNo(context, 3)){
                        String payload = '${scheduledPrograms[index].sNo},${scheduledPrograms[index].progPauseResume}';
                        String payLoadFinal = jsonEncode({
                          "2900": [
                            {"2901": payload}
                          ]
                        });
                        MQTTManager().publish(payLoadFinal, 'AppToFirmware/${siteData.master[masterInx].deviceId}');
                        sentUserOperationToServer(
                          '${scheduledPrograms[index].progName} ${getDescription(int.parse(scheduledPrograms[index].progPauseResume))}',
                          payLoadFinal,
                        );
                      }else{
                        GlobalSnackBar.show(context, 'Permission denied', 400);
                      }

                    },
                    child: Text(getButtonName(int.parse(scheduledPrograms[index].progPauseResume))),
                  ),
                  const Spacer(),
                  getPermissionStatusBySNo(context, 3) ?PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (String result) {
                      if(result=='Edit program'){
                        String prgType = '';
                        bool conditionL = false;
                        if (scheduledPrograms[index].progCategory.contains('IL')) {
                          prgType = 'Irrigation Program';
                        } else {
                          prgType = 'Agitator Program';
                        }
                        if (siteData.master[masterInx].conditionLibraryCount > 0) {
                          conditionL = true;
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => IrrigationProgram(
                              deviceId: siteData.master[masterInx].deviceId,
                              userId: siteData.customerId,
                              controllerId: siteData.master[masterInx].controllerId,
                              serialNumber: scheduledPrograms[index].sNo,
                              programType: prgType,
                              conditionsLibraryIsNotEmpty: conditionL, toDashboard: true,
                            ),
                          ),
                        );
                      }
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'Edit program',
                        child: Text('Edit program'),
                      ),
                      PopupMenuItem<String>(
                        value: 'Change to',
                        child: ClickableSubmenu(
                          title: 'Change to',
                          submenuItems: scheduledPrograms[index].zoneList.split('_'),
                          onItemSelected: (selectedItem, selectedIndex) {
                            String payload = '${scheduledPrograms[index].sNo},${selectedIndex+1}';
                            String payLoadFinal = jsonEncode({
                              "6700": [
                                {"6701": payload}
                              ]
                            });
                            MQTTManager().publish(payLoadFinal, 'AppToFirmware/${siteData.master[masterInx].deviceId}');
                            sentUserOperationToServer(
                              '${scheduledPrograms[index].progName} ${'Changed to $selectedItem'}',
                              payLoadFinal,
                            );
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ):
                  const IconButton(onPressed: null, icon: Icon(Icons.more_vert, color: Colors.grey,)),
                ],
              )),
            ]);
          }),
        ),
      ),
    );
  }

  String getSchedulingMethodName(int code) {
    switch (code) {
      case 1:
        return 'No Schedule';
      case 2:
        return 'Schedule by days';
      case 3:
        return 'Schedule as run list';
      default:
        return 'Day count schedule';
    }
  }

  String getButtonName(int code) {
    const Map<int, String> codeDescriptionMap = {
      -1: 'Paused Couldn\'t',
      1: 'Start Manually',
      -2: 'Cond Couldn\'t',
      -3: 'Started By Rtc',
      7: 'Stop Manually',
      13: 'Bypass Start',
      11: 'Bypass Cond',
      12: 'Bypass Stop',
      0: 'Stop Manually',
      2: 'Pause',
      3: 'Resume',
      4: 'Cont Manually',
    };
    return codeDescriptionMap[code] ?? 'Code not found';
  }

  String getDescription(int code) {
    const Map<int, String> codeDescriptionMap = {
      -1: 'Paused Couldn\'t Start',
      1: 'Start Manually',
      -2: 'Started By Condition Couldn\'t Stop',
      -3: 'Started By Rtc Couldn\'t Stop',
      7: 'Stop Manually',
      13: 'Bypass Start Condition',
      11: 'Bypass Condition',
      12: 'Bypass Stop Condition and Start',
      0: 'Stop Manually',
      2: 'Pause',
      3: 'Resume',
      4: 'Continue Manually',
    };
    return codeDescriptionMap[code] ?? 'Code not found';
  }

  void showAutoUpdateDialog(BuildContext context, int prmSNo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConditionDialog(
          prmSNo: prmSNo,
        );
      },
    );
  }

  String getContentByCode(int code) {
    return GemProgramStartStopReasonCode.fromCode(code).content;
  }

  void sentUserOperationToServer(String msg, String data) async
  {
    Map<String, Object> body = {"userId": siteData.customerId, "controllerId": siteData.master[masterInx].controllerId, "messageStatus": msg, "hardware": jsonDecode(data), "createUser": userId};
    final response = await HttpService().postRequest("createUserSentAndReceivedMessageManually", body);
    if (response.statusCode == 200) {
      print(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

}

class ConditionDialog extends StatefulWidget {
  final int prmSNo;
  const ConditionDialog({super.key, required this.prmSNo});
  @override
  _ConditionDialogState createState() => _ConditionDialogState();
}

class _ConditionDialogState extends State<ConditionDialog> {

  final List<Color> colorList = [
    Colors.red.shade50,
    Colors.green.shade50,
    Colors.blue.shade50,
    Colors.orange.shade50,
    Colors.purple.shade50,
    Colors.yellow.shade50,
  ];

  @override
  Widget build(BuildContext context) {

    var scheduleProgram = Provider.of<MqttPayloadProvider>(context).scheduledProgram;
    final filteredScheduledPrograms = filterProgramsBySNo(scheduleProgram, widget.prmSNo);
    final Condition startCondition = filteredScheduledPrograms[0].startCondition;
    final Condition stopCondition = filteredScheduledPrograms[0].stopCondition;


    return AlertDialog(
      title: Text(filteredScheduledPrograms[0].progName),
      content: SizedBox(
        width: 600,
        height: 400,
        child: ListView(
          children: [
            ExpansionPanelList(
              elevation: 1,
              expandedHeaderPadding: const EdgeInsets.all(0),
              expandIconColor: Colors.transparent,
              children: [
                ExpansionPanel(
                  backgroundColor: startCondition.status==1? Colors.green.shade50:Colors.red.shade50,
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8, left: 8),
                      child: Text('START CONDITION', style: TextStyle(fontSize: 17, color: startCondition.status==1?primaryColorPureGreen:Colors.red),),
                    );
                  },
                  body: _buildConditionPanel(startCondition),
                  isExpanded: startCondition.condition.isNotEmpty?true:false,
                ),
                ExpansionPanel(
                  backgroundColor: stopCondition.status==1?Colors.green.shade50:Colors.red.shade50,
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8, left: 8),
                      child: Text('STOP CONDITION', style: TextStyle(fontSize: 17, color: stopCondition.status==1?primaryColorPureGreen:Colors.red),),
                    );
                  },
                  body: _buildConditionPanel(stopCondition),
                  isExpanded: stopCondition.condition.isNotEmpty?true:false,
                ),
              ],
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget _buildConditionPanel(Condition condition, {bool isLast = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(condition.condition),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Set Value: ',
                            style: TextStyle(
                              color: Colors.black45,
                              fontSize: 15,
                            ),
                          ),
                          TextSpan(
                            text: '${condition.set}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Actual Value: ',
                            style: TextStyle(
                              color: Colors.black45,
                              fontSize: 15,
                            ),
                          ),
                          TextSpan(
                            text: '${condition.actual}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (condition.combined.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(condition.combined.length, (index) {
                    return Container(
                      margin: const EdgeInsets.only(left: 10.0, right: 5, bottom: 5),
                      decoration: BoxDecoration(
                        color: condition.combined[index].status == 1 ? Colors.green.shade50 : Colors.red.shade50,
                        border: Border.all(
                          color: condition.combined[index].status == 1 ? Colors.green.shade100 : Colors.red.shade100,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: _buildConditionPanel(
                        condition.combined[index],
                        isLast: index == condition.combined.length - 1,
                      ),
                    );
                  }),
                ),
            ],
          ),
        ),
      ],
    );
  }

  List<ScheduledProgram> filterProgramsBySNo(List<ScheduledProgram> prg, int sNo) {
    return prg.where((program) => program.sNo == sNo).toList();
  }
}

class ClickableSubmenu extends StatelessWidget {
  final String title;
  final List<String> submenuItems;
  final Function(String selectedItem, int selectedIndex) onItemSelected;

  const ClickableSubmenu({super.key,
    required this.title,
    required this.submenuItems,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showSubmenu(context);
      },
      child: Row(
        children: [
          Text(title),
          const Icon(Icons.arrow_right),
        ],
      ),
    );
  }

  void _showSubmenu(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset(button.size.width, 0), ancestor: overlay),
        button.localToGlobal(Offset(button.size.width, button.size.height), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showMenu<String>(
      context: context,
      position: position,
      items: submenuItems.map((String item) {
        return PopupMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
    ).then((String? selectedItem) {
      if (selectedItem != null) {
        int selectedIndex = submenuItems.indexOf(selectedItem);
        onItemSelected(selectedItem, selectedIndex);
      }
    });
  }
}