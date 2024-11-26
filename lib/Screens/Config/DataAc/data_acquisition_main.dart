import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:oro_irrigation_new/constants/MQTTManager.dart';
import 'package:provider/provider.dart';

import '../../../constants/http_service.dart';
import '../../../state_management/data_acquisition_provider.dart';

class DataAcquisitionMain extends StatefulWidget {
  const DataAcquisitionMain({super.key, required this.customerID, required this.controllerID, required this.userId, required this.deviceID});
  final int customerID, controllerID, userId;
  final String deviceID;

  @override
  State<DataAcquisitionMain> createState() => _DataAcquisitionMainState();
}

class _DataAcquisitionMainState extends State<DataAcquisitionMain> with SingleTickerProviderStateMixin{
  late TabController _tabController;
  final HttpService httpService = HttpService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(mounted) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Provider.of<DataAcquisitionProvider>(context, listen: false).dataAcquisitionFromApi(widget.customerID, widget.controllerID).then((_) {
          _tabController = TabController(
            length: Provider.of<DataAcquisitionProvider>(context, listen: false).dataModel?.data.length ?? 0,
            vsync: this,
          );
          _tabController.addListener(() {
            Provider.of<DataAcquisitionProvider>(context, listen: false).updateTabIndex(_tabController.index);
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataAcquisitionProvider>(context);

    if (dataProvider.dataModel != null && dataProvider.dataModel?.data != null) {
      return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final isScreenSizeLarge = constraints.maxWidth >= 565;
            final List<IconData> tabIcons= [Icons.leak_add, Icons.electric_meter_outlined, Icons.terrain];
            return DefaultTabController(
              length: dataProvider.dataModel!.data.length,
              child: Scaffold(
                body: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      color: Theme.of(context).colorScheme.background,
                      child: TabBar(
                        controller: _tabController,
                        // isScrollable: dataProvider.dataModel!.data.length > 3 && !isScreenSizeLarge,
                        isScrollable: true,
                        tabs: [
                          ...dataProvider.dataModel!.data.asMap().entries.map((entry) {
                            final index = entry.key;
                            final dataItem = entry.value;
                            final tab = dataItem.nameDescription;
                            final icon = index < tabIcons.length ? tabIcons[index] : Icons.sensor_occupied;

                            return Tab(
                              icon: Icon(icon),
                              text: tab,
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: dataProvider.dataModel!.data.asMap().entries.map((entry){
                          final dataIndex = entry.key;
                          final dataItem = entry.value;
                          // final tab = dataItem.nameDescription;
                          final dataAcquisition = dataItem.dataAcquisition;
                          var rowIndex = 0;

                          return Container(
                            margin: isScreenSizeLarge ? const EdgeInsets.symmetric(horizontal: 20, vertical: 20) : const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            child: Column(
                              children: [
                                Table(
                                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                  columnWidths: {
                                    0: !isScreenSizeLarge ? const FlexColumnWidth(1.2) : const FlexColumnWidth(1),
                                    for (int i = 1; i < dataAcquisition.length + 1; i++)
                                      i: const FlexColumnWidth(1),
                                  },
                                  children: [
                                    TableRow(
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor
                                      ),
                                      children: const [
                                        TableCell(verticalAlignment: TableCellVerticalAlignment.middle, child: Center(child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text('Location', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                        ))),
                                        TableCell(verticalAlignment: TableCellVerticalAlignment.middle, child: Center(child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text('Object', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                        ))),
                                        TableCell(verticalAlignment: TableCellVerticalAlignment.middle, child: Center(child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text('Name', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                        ))),
                                        TableCell(verticalAlignment: TableCellVerticalAlignment.middle, child: Center(child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text('Sampling Rate', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                        ))),
                                      ],
                                    )
                                  ],
                                ),
                                Expanded(
                                  child: ListView(
                                    children: [
                                      Table(
                                        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                        columnWidths: {
                                          0: !isScreenSizeLarge ? const FlexColumnWidth(1.2) : const FlexColumnWidth(1),
                                          for (int i = 1; i < dataAcquisition.length + 1; i++)
                                            i: const FlexColumnWidth(1),
                                        },
                                        children: dataAcquisition.asMap().entries.map((entry) {
                                          rowIndex = entry.key;
                                          final rowIndex2 = entry.key;
                                          final item = entry.value;
                                          final name = item.id;
                                          final object = item.name;
                                          final location = item.location;
                                          final sampleRate = item.sampleRate;

                                          return TableRow(
                                            decoration: BoxDecoration(
                                              color: rowIndex % 2 == 0
                                                  ? isScreenSizeLarge
                                                  ? Theme.of(context).primaryColor.withOpacity(0.05)
                                                  : Colors.white
                                                  : Theme.of(context).primaryColor.withOpacity(0.2),
                                            ),
                                            children: [
                                              TableCell(verticalAlignment: TableCellVerticalAlignment.middle, child: Center(child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(location == "" ? "No location" : location),
                                              ))),
                                              TableCell(verticalAlignment: TableCellVerticalAlignment.middle, child: Center(child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(object),
                                              ))),
                                              TableCell(verticalAlignment: TableCellVerticalAlignment.middle, child: Center(child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(name == "" ? "No name" : name),
                                              ))),
                                              TableCell(verticalAlignment: TableCellVerticalAlignment.middle, child: Center(child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: SizedBox(
                                                  width: 100,
                                                  child: DropdownButton<String>(
                                                    focusColor: Colors.transparent,
                                                    isExpanded: true,
                                                    value: sampleRate == '' ? 'None' : sampleRate,
                                                    underline: Container(),
                                                    onChanged: (newValue) => dataProvider.updateSelectedValue(dataIndex, rowIndex2, newValue!),
                                                    items: _buildDropdownItems(DataAcquisitionProvider.durationList),
                                                  ),
                                                ),
                                              ))),
                                            ],
                                          );
                                        }).toList(),
                                      ),
                                      if(rowIndex == dataAcquisition.length -1)
                                        const SizedBox(height: 70,)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                floatingActionButton: MaterialButton(
                    color: const Color(0xFFFFCB3A),
                    splashColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)
                    ),
                    onPressed: () async {
                      final dataAcquisition = Provider.of<DataAcquisitionProvider>(context, listen: false).dataModel;
                      Map<String, dynamic> jsonData = {
                        "createUser" : widget.userId,
                        "userId": widget.customerID,
                        "controllerId": widget.controllerID,
                        "dataAcquisitions": dataAcquisition!.toJson(),
                      };
                      // print(dataAcquisition.toMqtt().join(';'));
                      var dataToHardware = {"600": [{"601": dataAcquisition.toMqtt().join(';')}]};
                      MQTTManager().publish(jsonEncode(dataToHardware), 'AppToFirmware/${widget.deviceID}');

                      try {
                        final crateDataAcquisition = await httpService.postRequest('createUserDataAcquisition', jsonData);
                        final message = jsonDecode(crateDataAcquisition.body);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              message['message'],
                              textAlign: TextAlign.center,
                            )
                        ));
                      } catch (error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to update because of $error'))
                        );
                        print("Error: $error");
                      }
                    },
                    child: const Text("Save", style: TextStyle(fontWeight: FontWeight.bold),)
                ),
              ),
            );
          }
      );
    } else {
      return Scaffold(
        body: Center(
          child: dataProvider.isLoading
              ? const CircularProgressIndicator()
              : const Text('Error: Data not available'),
        ),
      );
    }
  }
  List<DropdownMenuItem<String>> _buildDropdownItems(List<String> items) {
    return items.map((contact) {
      return DropdownMenuItem<String>(
        value: contact,
        child: Text(contact),
      );
    }).toList();
  }
}
