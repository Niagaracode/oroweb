import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oro_irrigation_new/Screens/Customer/IrrigationProgram/irrigation_program_main.dart';
import 'package:oro_irrigation_new/Screens/Customer/IrrigationProgram/program_library.dart';
import 'package:oro_irrigation_new/state_management/irrigation_program_main_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../Models/IrrigationModel/sequence_model.dart';
import '../../../Widgets/SCustomWidgets/custom_snack_bar.dart';
import '../../../constants/http_service.dart';
import '../../../state_management/MqttPayloadProvider.dart';
import '../../../widgets/SCustomWidgets/custom_alert_dialog.dart';
import '../../../widgets/SCustomWidgets/custom_data_table.dart';
import '../ProgramSchedule.dart';

final dateFormat = DateFormat('dd-MM-yyyy');

class PreviewScreen extends StatefulWidget {
  final int userId;
  final int controllerId;
  final String deviceId;
  final int serialNumber;
  final bool toDashboard;
  final String? programType;
  final bool? conditionsLibraryIsNotEmpty;
  const PreviewScreen({super.key, required this.userId, required this.controllerId, required this.deviceId, required this.serialNumber, required this.toDashboard, this.programType, this.conditionsLibraryIsNotEmpty});

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  late IrrigationProgramProvider irrigationProvider;
  List<ChartData>? _chartDataList;
  late MqttPayloadProvider mqttPayloadProvider;
  List<ChartData>? get chartDataList => _chartDataList;
  final PageController pageController = PageController();

  @override
  void initState() {
    irrigationProvider =  Provider.of<IrrigationProgramProvider>(context, listen: false);
    mqttPayloadProvider =  Provider.of<MqttPayloadProvider>(context, listen: false);
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        irrigationProvider.waterAndFert();
        _chartDataList = List<ChartData>.from(irrigationProvider.sequenceData.map((json) => ChartData.fromJson(json, irrigationProvider.constantSetting, json['valve'])));
        // irrigationProvider.sequenceData.forEach((element) {
        //   print(element['localDosing']);
        //   // print(element['localDosing'][0]['fertilizer']);
        // });

        // print(irrigationProvider.sequenceData[0]['localDosing'][0]['fertilizer'].where((e) => e['onOff'] == true).toList());
      });
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    irrigationProvider =  Provider.of<IrrigationProgramProvider>(context);
    mqttPayloadProvider =  Provider.of<MqttPayloadProvider>(context);
    final scheduleTypeCondition = irrigationProvider.sampleScheduleModel!.selected == irrigationProvider.scheduleTypes[1]
        ? irrigationProvider.sampleScheduleModel!.scheduleAsRunList
        : irrigationProvider.sampleScheduleModel!.scheduleByDays;
    final noScheduleCondition = irrigationProvider.selectedScheduleType != irrigationProvider.scheduleTypes[0] && irrigationProvider.selectedScheduleType != irrigationProvider.scheduleTypes[3];
    final rtcList = irrigationProvider.sampleScheduleModel!.selected == irrigationProvider.scheduleTypes[1]
        ? irrigationProvider.sampleScheduleModel!.scheduleAsRunList.rtc
        : irrigationProvider.sampleScheduleModel!.scheduleByDays.rtc;
    final fertilizerCondition = (irrigationProvider.sequenceData.any((element) => element['applyFertilizerForCentral'] == true))
        || (irrigationProvider.sequenceData.any((element) => element['applyFertilizerForLocal'] == true));
    final applyCentralFert = irrigationProvider.sequenceData.any((element) => element['applyFertilizerForCentral'] == true);
    final applyLocalFert = irrigationProvider.sequenceData.any((element) => element['applyFertilizerForLocal'] == true);
    final allowStopMethodCondition = irrigationProvider.sampleScheduleModel!.defaultModel.allowStopMethod;
    final defaultOffTime = irrigationProvider.sampleScheduleModel!.defaultModel.rtcOffTime;
    final defaultMaxTime = irrigationProvider.sampleScheduleModel!.defaultModel.rtcMaxTime;
    final centralSelectorCondition = irrigationProvider.selectionModel!.data.selectorForCentral!.isNotEmpty;
    final localFilterCondition = irrigationProvider.selectionModel!.data.localFilterSite!.isNotEmpty;
    final filterCategoryCondition = (irrigationProvider.selectionModel!.data.centralFilterSite!.isNotEmpty || irrigationProvider.selectionModel!.data.localFilterSite!.isNotEmpty);
    final fertilizerCategoryCondition = (irrigationProvider.selectionModel!.data.centralFertilizerSite!.isNotEmpty || irrigationProvider.selectionModel!.data.localFertilizerSite!.isNotEmpty);
    // final List<ChartData> chartData2 = <ChartData>[
    //   ChartData(irrigationProvider.sequenceData, valves, preValue, postValue, waterValue)
    // ];
    // return Container();
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Container(
            margin: MediaQuery.of(context).size.width > 1200 ? const EdgeInsets.all(10) : null,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        color: Colors.yellow.shade100
                    ),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Note: ',
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: ' Detailed scheduled program can be viewed in the dashboard by navigating',
                            style: TextStyle(color: Colors.black, ),
                          ),
                          TextSpan(
                            text: ' Dashboard -- > ',
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                          WidgetSpan(
                            child: Icon(Icons.view_list_outlined, size: 18, color: Colors.orange,),
                            alignment: PlaceholderAlignment.middle,
                          ),
                          TextSpan(
                            text: ' in the right side menu',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  MediaQuery.of(context).size.width > 1200 ?
                  SizedBox(
                    height: irrigationProvider.sampleScheduleModel!.selected != irrigationProvider.scheduleTypes[3] ? 300 : 335,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(left: 20, right: 20),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: customBoxShadow
                            ),
                            child: buildGraph(),
                          ),
                        ),
                        const SizedBox(width: 10,),
                        if(!noScheduleCondition)
                          Expanded(child: buildNoSchedule()),
                        if(noScheduleCondition)
                          Expanded(
                              child: buildRtcDetails(rtcList: rtcList, constraints: constraints, allowStopMethodCondition: allowStopMethodCondition, defaultOffTime: defaultOffTime, defaultMaxTime: defaultMaxTime)
                          ),
                      ],
                    ),
                  ) :
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        height: 300,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: customBoxShadow
                        ),
                        child: buildGraph(),
                      ),
                      const SizedBox(width: 10,),
                      if(!noScheduleCondition)
                        buildNoSchedule(),
                      if(noScheduleCondition)
                        buildRtcDetails(rtcList: rtcList, constraints: constraints, allowStopMethodCondition: allowStopMethodCondition, defaultOffTime: defaultOffTime, defaultMaxTime: defaultMaxTime),
                    ],
                  ),
                  if(MediaQuery.of(context).size.width < 1200)
                    const SizedBox(height: 20,),
                  if(noScheduleCondition)
                    Container(
                      margin: MediaQuery.of(context).size.width > 1200
                          ? const EdgeInsets.only(top: 10, left: 10, right: 10)
                          : const EdgeInsets.symmetric(horizontal: 10),
                      // height: MediaQuery.of(context).size.width > 1200 ? 220 : 485,
                      child: MediaQuery.of(context).size.width > 1200 ?
                      Row(
                        children: [
                            Expanded(
                                child: buildGeneralDetails()
                            ),
                          const SizedBox(width: 10,),
                          if(irrigationProvider.sampleScheduleModel!.selected != irrigationProvider.scheduleTypes[0])
                            Expanded(
                                child: buildScheduleDetails(scheduleTypeCondition: scheduleTypeCondition)
                            ),
                        ],
                      ) :
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if(noScheduleCondition)
                            buildGeneralDetails(),
                          const SizedBox(height: 10,),
                          if(irrigationProvider.sampleScheduleModel!.selected != irrigationProvider.scheduleTypes[0])
                            buildScheduleDetails(scheduleTypeCondition: scheduleTypeCondition),
                        ],
                      ),
                    ),
                  if((filterCategoryCondition || fertilizerCategoryCondition) && MediaQuery.of(context).size.width > 1200)
                    Container(
                      margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: Row(
                        children: [
                          Expanded(
                              child: (fertilizerCategoryCondition || fertilizerCondition)
                                  ? buildFertilizerDetails(centralSelectorCondition: centralSelectorCondition) : Container()
                          ),
                          const SizedBox(width: 10,),
                          Expanded(
                              child: (filterCategoryCondition)
                                  ? buildFilterDetails(localFilterCondition: localFilterCondition) : Container()
                          ),
                        ],
                      ),
                    ),
                  if((filterCategoryCondition && fertilizerCategoryCondition) && MediaQuery.of(context).size.width < 1200)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      // height: ((centralSelectorCondition || localFilterCondition) && (fertilizerCategoryCondition && fertilizerCondition)) ? 360 : 235,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          (filterCategoryCondition)
                              ? buildFilterDetails(localFilterCondition: localFilterCondition) : Container(),
                          const SizedBox(height: 10,),
                          (fertilizerCategoryCondition || fertilizerCondition)
                              ? buildFertilizerDetails(centralSelectorCondition: centralSelectorCondition) : Container(),
                        ],
                      ),
                    ),
                  if(irrigationProvider.sampleConditions?.defaultData.conditionLibrary.isNotEmpty ?? false)
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: buildConditions()
                    ),
                  const SizedBox(height: 10,),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: buildAlarmDetails()
                  ),
                  const SizedBox(height: 20,),
                  Container(
                    margin: MediaQuery.of(context).size.width > 1200 ? const EdgeInsets.all(20) : const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: customBoxShadow
                    ),
                    child: CustomDataTable(
                      rowsPerPage: fertilizerCondition
                          ? irrigationProvider.sequenceData.length >= 4
                          ? 4 : irrigationProvider.sequenceData.length
                          : MediaQuery.of(context).size.width > 1200 ? irrigationProvider.sequenceData.length >= 10 ? 10 : irrigationProvider.sequenceData.length : irrigationProvider.sequenceData.length >= 4
                          ? 4 : irrigationProvider.sequenceData.length,
                      headerText: 'Irrigation Details',
                      icon: Icons.water,
                      columnSpacing: MediaQuery.of(context).size.width > 800
                          ? constraints.maxWidth * (fertilizerCondition ? 0.09 : 0.16)
                          : constraints.maxWidth * (fertilizerCondition ? 0.05 : 0.1),
                      columns: [
                        buildDataColumn(label: "S.No", widthRatio: fertilizerCondition ? constraints.maxWidth * 0.03: null),
                        buildDataColumn(label: "Sequence", widthRatio: fertilizerCondition ? constraints.maxWidth * 0.1 : null),
                        buildDataColumn(label: "Valves", widthRatio: fertilizerCondition ? constraints.maxWidth * 0.1 : constraints.maxWidth * 0.15,),
                        buildDataColumn(label: "Dur/Qty", widthRatio: fertilizerCondition ? constraints.maxWidth * 0.05 : null),
                        if(fertilizerCondition)
                          buildDataColumn(label: "Before fert", widthRatio: fertilizerCondition ? constraints.maxWidth * 0.05 : null),
                        if(fertilizerCondition)
                          buildDataColumn(label: "After fert", widthRatio: constraints.maxWidth * 0.05),
                        buildDataColumn(label: "Condition", widthRatio: fertilizerCondition ? constraints.maxWidth * 0.1 : constraints.maxWidth * 0.17),
                      ],
                      dataList: irrigationProvider.sequenceData,
                      cellBuilders: [
                            (data, index) => buildDataCell(dataItem: data['sNo'].toString(), widthRatio: constraints.maxWidth * 0.03),
                            (data, index) => buildDataCell(dataItem: '${data['seqName']}', widthRatio: constraints.maxWidth * 0.1,),
                            (data, index) => buildDataCell(dataItem: '${data['valve'].map((e) => e['name']).toList().join(', ')}', widthRatio: constraints.maxWidth * 0.1, showToolTip: true, isFixedSize: true),
                            (data, index) => buildDataCell(dataItem: data['method'] == "Time" ? data['timeValue'] : data['quantityValue'], widthRatio: constraints.maxWidth * 0.05),
                        if(fertilizerCondition)
                              (data, index) => buildDataCell(dataItem: data['preValue'], widthRatio: constraints.maxWidth * 0.05),
                        if(fertilizerCondition)
                              (data, index) => buildDataCell(dataItem: data['postValue'], widthRatio: constraints.maxWidth * 0.05),
                            (data, index) => buildDataCell(dataItem: data['levelCondition'], widthRatio: constraints.maxWidth * 0.1),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20,),
                  if(fertilizerCondition)
                    Container(
                      margin: MediaQuery.of(context).size.width > 1200 ? const EdgeInsets.all(20) : const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: customBoxShadow
                      ),
                      child: CustomDataTable(
                        rowsPerPage: irrigationProvider.sequenceData.length >= 4 ? 4 : irrigationProvider.sequenceData.length,
                        headerText: 'Fertigation Details',
                        icon: Icons.local_florist_outlined,
                        columnSpacing: MediaQuery.of(context).size.width > 800
                            ? constraints.maxWidth * ((applyLocalFert && applyCentralFert) ? 0.1 : 0.03)
                            : constraints.maxWidth * ((applyLocalFert && applyCentralFert) ? 0.05 : 0.05),
                        columns: [
                          buildDataColumn(label: "S.No",),
                          buildDataColumn(label: "Sequence",),
                          // buildDataColumn(label: "Valves", widthRatio: constraints.maxWidth * 0.1335),
                          if(applyCentralFert)
                            buildDataColumn(label: "Cen. fert. site"),
                          if(applyCentralFert)
                            buildDataColumn(label: "Cen. fert. Inj."),
                          if(applyCentralFert)
                            buildDataColumn(label: "Cen. fert. Dur/Qty."),
                          if(applyLocalFert)
                            buildDataColumn(label: "Loc. site"),
                          if(applyLocalFert)
                            buildDataColumn(label: "Loc. fert. Inj."),
                          if(applyLocalFert)
                            buildDataColumn(label: "Loc. fert. Dur/Qty."),
                          // buildDataColumn(label: "Recipe", widthRatio: constraints.maxWidth * 0.1),
                        ],
                        dataList: irrigationProvider.sequenceData,
                        cellBuilders: [
                              (data, index) => buildDataCell(dataItem: data['sNo'].toString(), widthRatio: 50),
                              (data, index) => buildDataCell(dataItem: '${data['seqName']}', widthRatio: fertilizerCondition ? constraints.maxWidth > 800 ?  180 : 100 : 300),
                          // (data) => buildDataCell(dataItem: '${data['valve'].map((e) => e['name']).toList().join(', ')}', widthRatio: constraints.maxWidth * 0.1335,),
                          if(applyCentralFert)
                                (data, index) => buildDataCell(
                                dataItem: data['centralDosing'].isEmpty ? 'Not Available' : "${data['centralDosing'][0]['name']}",
                                widthRatio: (MediaQuery.of(context).size.width > 800)
                                    ? (applyCentralFert && applyLocalFert) ? 150 : 290
                                    : MediaQuery.of(context).size.width < 800 ? 150 : 100,
                                isFixedSize: true,
                                showToolTip: true),
                          if(applyCentralFert)
                                (data, index) => buildDataCell(
                                dataItem: data['centralDosing'].isEmpty ? 'Not Available' : getItem(data['centralDosing'][0]['fertilizer'], 'name'),
                                color: Colors.black,
                                widthRatio: (MediaQuery.of(context).size.width > 800)
                                    ? (applyCentralFert && applyLocalFert) ? 150 : 290
                                    : MediaQuery.of(context).size.width < 800 ? 150 : 100,
                                isFixedSize: true,
                                showToolTip: true),
                          if(applyCentralFert)
                                (data, index) => buildDataCell(
                                dataItem: data['centralDosing'].isEmpty ? 'Not Available' : getItem(data['centralDosing'][0]['fertilizer'], 'method', check: true),
                                color: Colors.black,
                                widthRatio: (MediaQuery.of(context).size.width > 800)
                                    ? (applyCentralFert && applyLocalFert) ? 150 : 290
                                    : MediaQuery.of(context).size.width < 800 ? 150 : 100,
                                isFixedSize: true,
                                showToolTip: true),
                          if(applyLocalFert)
                                (data, index) => buildDataCell(
                                dataItem: data['localDosing'].isEmpty ? 'Not Available' : "${data['localDosing'].map((e) => e['name']).toList().join(', ')}",
                                widthRatio: (MediaQuery.of(context).size.width > 800)
                                    ? (applyCentralFert && applyLocalFert) ? 150 : 290
                                    : MediaQuery.of(context).size.width < 800 ? 150 : 100,
                                isFixedSize: true,
                                showToolTip: true),
                          if(applyLocalFert)
                                (data, index) => buildDataCell(
                                dataItem: data['localDosing'].isEmpty ? 'Not Available' : getItem(data['localDosing'][0]['fertilizer'], 'name'),
                                color: Colors.black,
                                widthRatio: (MediaQuery.of(context).size.width > 800)
                                    ? (applyCentralFert && applyLocalFert) ? 150 : 290
                                    : MediaQuery.of(context).size.width < 800 ? 150 : 100,
                                isFixedSize: true,
                                showToolTip: true),
                          if(applyLocalFert)
                                (data, index) => buildDataCell(
                                dataItem: data['localDosing'].isEmpty ? 'Not Available' : getItem(data['localDosing'][0]['fertilizer'], 'method', check: true),
                                color: Colors.black,
                                widthRatio: (MediaQuery.of(context).size.width > 800)
                                    ? (applyCentralFert && applyLocalFert) ? 150 : 290
                                    : MediaQuery.of(context).size.width < 800 ? 150 : 100,
                                isFixedSize: true,
                                showToolTip: true),
                          // (data) => buildDataCell(dataItem: data['levelCondition'], widthRatio: constraints.maxWidth * 0.1),
                        ],
                      ),
                    ),
                  SlidingSendButton(
                    onSend: (){
                      irrigationProvider.programLibraryData(widget.userId, widget.controllerId);
                      sendFunction();
                    },
                  ),
                  const SizedBox(height: 80,)
                ],
              ),
            ),
          );
        }
    );
  }

  void sendFunction() async{
    final mainProvider = Provider.of<IrrigationProgramProvider>(context, listen: false);
    Map<String, dynamic> dataToMqtt = {};
    dataToMqtt = mainProvider.dataToMqtt(widget.serialNumber == 0 ? mainProvider.serialNumberCreation : widget.serialNumber, widget.programType);
    var userData = {
      "defaultProgramName": mainProvider.defaultProgramName,
      "userId": widget.userId,
      "controllerId": widget.controllerId,
      "createUser": widget.userId,
      "serialNumber": widget.serialNumber == 0 ? mainProvider.serialNumberCreation : widget.serialNumber,
    };
    if(mainProvider.irrigationLine!.sequence.isNotEmpty) {
      // print(mainProvider.selectionModel.data!.toJson());
      var dataToSend = {
        "sequence": mainProvider.irrigationLine!.sequence,
        "schedule": mainProvider.sampleScheduleModel!.toJson(),
        "conditions": mainProvider.sampleConditions!.toJson(),
        "waterAndFert": mainProvider.sequenceData,
        "selection": mainProvider.selectionModel!.data.toJson(),
        "alarm": mainProvider.newAlarmList!.toJson(),
        "programName": mainProvider.programName,
        "priority": mainProvider.priority,
        "delayBetweenZones": mainProvider.programDetails!.delayBetweenZones,
        "adjustPercentage": mainProvider.programDetails!.adjustPercentage,
        "incompleteRestart": mainProvider.isCompletionEnabled ? "1" : "0",
        "controllerReadStatus": 0,
        "programType": mainProvider.selectedProgramType,
        "hardware": dataToMqtt
      };
      userData.addAll(dataToSend);
      // print(dataToMqtt);
      try {
        await validatePayloadSent(
            dialogContext: context,
            context: context,
            mqttPayloadProvider: mqttPayloadProvider,
            acknowledgedFunction: () {
              setState(() {
                userData['controllerReadStatus'] = "1";
              });
              // showSnackBar(message: "${mqttPayloadProvider.messageFromHw['Name']} from controller", context: context);
            },
            payload: dataToMqtt,
            payloadCode: "2500",
            deviceId: widget.deviceId
        );
        await Future.delayed(const Duration(milliseconds: 300), () async {
          // print("userData['controllerReadStatus'] ==> ${userData['controllerReadStatus']}");
          final createUserProgram = await HttpService().postRequest('createUserProgram', userData);
          final response = jsonDecode(createUserProgram.body);
          if(createUserProgram.statusCode == 200) {
            await irrigationProvider.programLibraryData(widget.userId, widget.controllerId);
            ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(message: response['message']));
            if(widget.toDashboard) {
              Navigator.of(context).pop();
            } else {
              // Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ProgramSchedule(customerID: widget.userId, controllerID: widget.controllerId, siteName: "", imeiNumber: widget.deviceId, userId: widget.userId,))
              );
            }
          }
        });
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(message: 'Failed to update because of $error'));
        print("Error: $error");
      }
      // print(mainProvider.selectionModel.data!.localFertilizerSet!.map((e) => e.toJson()));
    }
    else {
      showAdaptiveDialog<Future>(
        context: context,
        builder: (BuildContext context) {
          return CustomAlertDialog(
            title: 'Warning',
            content: "Select valves to be sequence for Irrigation Program",
            actions: [
              TextButton(child: const Text("OK"), onPressed: () => Navigator.of(context).pop(),),
            ],
          );
        },
      );
    }
  }

  String getItem(List data, String item, {bool check = false}) {
    List resultList = [];
    var result = '';
    // data['localDosing'].isEmpty ? '' : (data['localDosing'][0]['fertilizer'].map((fertilizer) => fertilizer['onOff'] == true ? fertilizer['name'] : '').where((e) => e != '').toList().join(', '))
    for (var element in data) {
      if(element['onOff'] == true) {
        resultList.add(check ? ((element[item] == "Time" || element[item] == "Pro.time") ? element['timeValue'] : element['quantityValue']) : element[item]);
        result = resultList.join(', ');
        print("result ==> $result");
      }
    }
    return result == "" ? "Not selected" : result;
  }

  Widget buildGraph() {
    double getMaxFlowRate(List<ChartData> dataList) {
      if(dataList.isNotEmpty) {
        return dataList.map((data) => data.flowRate).reduce((a, b) => a > b ? a : b);
      } else {
        return 0.0;
      }
    }

    bool isSingleMethod = chartDataList != null && chartDataList!.isNotEmpty && chartDataList!.every((e) => e.method == chartDataList!.first.method);
    double maxFlowRate = getMaxFlowRate(chartDataList ?? []);
    return chartDataList != null ?
    Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Irrigation & fert", style: TextStyle(color: Color(0xff9291A5), fontSize: 16)),
            ),
            Row(
              children: [
                Row(children: [
                  Container(width: 10, height: 10, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xff15C0E6))),
                  const SizedBox(width: 10,),
                  const Text("Water only", style: TextStyle(color: Color(0xff9291A5), fontSize: 14))
                ],),
                const SizedBox(width: 30,),
                Row(children: [
                  Container(width: 10, height: 10, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xff10E196))),
                  const SizedBox(width: 10,),
                  const Text("Water & Fert", style: TextStyle(color: Color(0xff9291A5), fontSize: 14))
                ],)
              ],
            )
          ],
        ),
        const Divider(color: Color(0xffE5E5EF), indent: 10, endIndent: 10,),
        Expanded(
          child: SfCartesianChart(
            enableAxisAnimation: true,
            plotAreaBackgroundColor: Colors.transparent,
            borderColor: Colors.transparent,
            borderWidth: 0,
            plotAreaBorderWidth: 0,
            enableSideBySideSeriesPlacement: false,
            onTooltipRender: (TooltipArgs args) {
              String sequence = args.pointIndex != null && args.pointIndex! < chartDataList!.length
                  ? chartDataList![args.pointIndex!.toInt()].valves
                  : '';
              double? preValue = args.pointIndex != null && args.pointIndex! < chartDataList!.length
                  ? (chartDataList![args.pointIndex!.toInt()].preValueHigh.toDouble() - chartDataList![args.pointIndex!.toInt()].preValueLow.toDouble())
                  : null;
              double? postValue = args.pointIndex != null && args.pointIndex! < chartDataList!.length
                  ? (chartDataList![args.pointIndex!.toInt()].postValueHigh.toDouble() - chartDataList![args.pointIndex!.toInt()].postValueLow.toDouble())
                  : null;
              double? waterValue = args.pointIndex != null && args.pointIndex! < chartDataList!.length
                  ? (chartDataList![args.pointIndex!.toInt()].waterValueHigh.toDouble() - chartDataList![args.pointIndex!.toInt()].waterValueLow.toDouble())
                  : null;
              args.text = 'Sequence: $sequence, \nPre value: $preValue, \nPost value: $postValue, \nWater value: $waterValue';
            },
            tooltipBehavior: TooltipBehavior(
              enable: true,
              animationDuration: 300,
              canShowMarker: true,
              textStyle: const TextStyle(color: Colors.white),
              tooltipPosition: TooltipPosition.pointer,
              borderWidth: 2,
              color: Colors.black,
            ),
            primaryXAxis: CategoryAxis(
              isVisible: true,
              rangePadding: ChartRangePadding.round,
              labelPlacement: LabelPlacement.onTicks,
              minimum: -0.5,
              maximum: chartDataList!.length.toDouble() - 0.5,
              visibleMinimum: -0.5,
              visibleMaximum: chartDataList!.length < 6 ? chartDataList!.length.toDouble() - 0.5 : 6,
            ),
            primaryYAxis: NumericAxis(
              isVisible: true,
              minimum: 0,
              labelFormat: '{value}',
              axisLabelFormatter: (AxisLabelRenderDetails details) {
                if (isSingleMethod && chartDataList!.first.method == 1) {
                  num quantity = details.value;
                  if (quantity == 0) {
                    return ChartAxisLabel('0m', const TextStyle(color: Colors.black));
                  }

                  double timeInSeconds = quantity / maxFlowRate;
                  double timeInMinutes = timeInSeconds / 60;
                  return ChartAxisLabel('${timeInMinutes.toStringAsFixed(1)}m', const TextStyle(color: Colors.black));
                } else if (isSingleMethod) {
                  return ChartAxisLabel('${details.value}L', const TextStyle(color: Colors.black));
                } else {
                  return ChartAxisLabel('${details.value}L', const TextStyle(color: Colors.black));
                }
              },
            ),
            axes: isSingleMethod
                ? []
                : [
              NumericAxis(
                name: 'timeAxis',
                opposedPosition: true,
                minimum: 0,
                labelFormat: '{value}m',
                axisLabelFormatter: (AxisLabelRenderDetails details) {
                  num quantity = details.value;
                  print("AxisLabelRenderDetails ==> value: ${details.value}, text: ${details.text}");
                  if (quantity == 0) {
                    return ChartAxisLabel('0m', const TextStyle(color: Colors.black));
                  }

                  double timeInSeconds = quantity / maxFlowRate;
                  double timeInMinutes = timeInSeconds / 60;

                  return ChartAxisLabel('${timeInMinutes.toStringAsFixed(1)}m', const TextStyle(color: Colors.black));
                },
              )
            ],
            zoomPanBehavior: ZoomPanBehavior(
              enablePanning: true,
            ),
            series: <CartesianSeries>[
              RangeColumnSeries<ChartData, String>(
                borderRadius: BorderRadius.zero,
                dataSource: chartDataList ?? [],
                width: chartDataList!.length <= 3 ? 0.2 : 0.4,
                color: const Color(0xff15C0E6),
                pointColorMapper: (ChartData data, _) {
                  if (data.postValueHigh == 0 || data.preValueHigh == 0) {
                    return const Color(0xff10E196);
                  } else {
                    return const Color(0xff15C0E6);
                  }
                },
                xValueMapper: (ChartData data, _) => "${data.sequenceName}",
                highValueMapper: (ChartData data, _) => data.preValueHigh,
                lowValueMapper: (ChartData data, _) => data.preValueLow,
              ),
              RangeColumnSeries<ChartData, String>(
                borderRadius: BorderRadius.zero,
                dataSource: chartDataList ?? [],
                width: chartDataList!.length <= 3 ? 0.2 : 0.4,
                color: const Color(0xff10E196),
                pointColorMapper: (ChartData data, _) {
                  if (data.postValueHigh == 0 || data.preValueHigh == 0) {
                    return const Color(0xff15C0E6);
                  } else {
                    return Color(0xff10E196);
                  }
                },
                xValueMapper: (ChartData data, _) => "${data.sequenceName}",
                highValueMapper: (ChartData data, _) => data.waterValueHigh,
                lowValueMapper: (ChartData data, _) => data.waterValueLow,
              ),
              RangeColumnSeries<ChartData, String>(
                borderRadius: BorderRadius.zero,
                dataSource: chartDataList ?? [],
                width: chartDataList!.length <= 3 ? 0.2 : 0.4,
                color: const Color(0xff15C0E6),
                xValueMapper: (ChartData data, _) => "${data.sequenceName}",
                highValueMapper: (ChartData data, _) => data.postValueHigh,
                lowValueMapper: (ChartData data, _) => data.postValueLow,
              ),
            ],
          ),
        ),
      ],
    ) :
    Container();
  }

  Widget buildAlarmDetails(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text("Alarm details", style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),),
        ),
        Wrap(
          children: [
            buildItemsCard(
                context: context,
                title: "Enabled alarms",
                child: buildIndividualRow(irrigationProvider.newAlarmList!.alarmList)
            ),
          ],
        ),
      ],
    );
  }

  Widget buildGeneralDetails() {
    return buildCategory(
      categoryTitle: "General details",
      title1: "Irrigation pump",
      // itemList1: "",
      itemList1: irrigationProvider.isPumpStationMode ? "Auto pump selection is enabled" : irrigationProvider.selectionModel?.data.irrigationPump,
      title2: "Head units",
      // itemList2: "",
      itemList2: irrigationProvider.selectionModel?.data.headUnits,
      showRow: true,
      show4thWidget: false,
      title3: "Main valve",
      // itemList3: "",
      itemList3: irrigationProvider.selectionModel?.data.mainValve,
      title4: "",
      itemList4: [],
    );
  }

  Widget buildNoSchedule() {
    return buildCategory(
        categoryTitle: "General details",
        title1: "Irrigation pump",
        itemList1: irrigationProvider.isPumpStationMode ? "Auto pump selection is enabled" : irrigationProvider.selectionModel!.data.irrigationPump,
        title2: "Head units",
        itemList2: irrigationProvider.selectionModel!.data.headUnits,
        showRow: true,
        show4thWidget: true,
        title3: "Main valve",
        itemList3: irrigationProvider.selectionModel!.data.mainValve,
        title4: "Schedule type",
        itemList4: irrigationProvider.sampleScheduleModel!.selected,
        showWidget2: irrigationProvider.sampleScheduleModel!.selected == irrigationProvider.scheduleTypes[3],
        showRow2: irrigationProvider.sampleScheduleModel!.selected == irrigationProvider.scheduleTypes[3],
        show2ndWidget: irrigationProvider.sampleScheduleModel!.selected == irrigationProvider.scheduleTypes[3],
        title5: "Start time",
        title6: "Cycle Interval",
        title7: "Cycles",
        itemList5: irrigationProvider.sampleScheduleModel!.dayCountSchedule.schedule["onTime"],
        itemList6: irrigationProvider.sampleScheduleModel!.dayCountSchedule.schedule["interval"],
        itemList7: irrigationProvider.sampleScheduleModel!.dayCountSchedule.schedule["shouldLimitCycles"]
            ? irrigationProvider.sampleScheduleModel!.dayCountSchedule.schedule["noOfCycles"] : "No cycle limitations"
    );
  }

  Widget buildFertilizerDetails({required bool centralSelectorCondition}) {
    return buildCategory(
        categoryTitle: "Fertigation details",
        title1: MediaQuery.of(context).size.width > 800 ? "Central fertilizer site" : "Cent. fert site",
        title2: centralSelectorCondition ? "Cent. fert selector" : "Local fert Site",
        itemList1: irrigationProvider.selectionModel!.data.centralFertilizerSite,
        itemList2: centralSelectorCondition ? irrigationProvider.selectionModel!.data.selectorForCentral : irrigationProvider.selectionModel!.data.localFertilizerSite,
        showRow: centralSelectorCondition,
        show4thWidget: true,
        show2ndWidget: irrigationProvider.selectionModel!.data.localFertilizerSite!.isNotEmpty,
        title3: "Local fertilizer site",
        title4: "Local fertilizer selector",
        itemList3: irrigationProvider.selectionModel!.data.localFertilizerSite,
        itemList4: irrigationProvider.selectionModel!.data.selectorForLocal
    );
  }

  Widget buildConditions(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text("Condition details", style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),),
        ),
        Row(
          children: [
            Expanded(
              child: buildItemsCard(context:context, title: "Start by condition",
                  child: Text('${(irrigationProvider.sampleConditions!.condition[0].value['name'] != null)
                      ? irrigationProvider.sampleConditions!.condition[0].value['name']
                      : 'Not selected'}', style: TextStyle(color: irrigationProvider.sampleConditions!.condition[0].value['name'] != null ? null : Colors.red),)),
            ),
            Expanded(
              child: buildItemsCard(context:context, title: "Stop by condition", child: Text('${(irrigationProvider.sampleConditions!.condition[1].value['name'] != null)
                  ? irrigationProvider.sampleConditions!.condition[1].value['name']
                  : 'Not selected'}', style: TextStyle(color: irrigationProvider.sampleConditions!.condition[1].value['name'] != null ? null : Colors.red))),
            ),
            Expanded(
              child: buildItemsCard(context:context, title: "Enable by condition", child: Text('${(irrigationProvider.sampleConditions!.condition[2].value['name'] != null)
                  ? irrigationProvider.sampleConditions!.condition[2].value['name']
                  : 'Not selected'}', style: TextStyle(color: irrigationProvider.sampleConditions!.condition[2].value['name'] != null ? null : Colors.red))),
            ),
            Expanded(
              child: buildItemsCard(context:context, title: "Disable by condition", child: Text('${(irrigationProvider.sampleConditions!.condition[3].value['name'] != null)
                  ? irrigationProvider.sampleConditions!.condition[3].value['name']
                  : 'Not selected'}', style: TextStyle(color: irrigationProvider.sampleConditions!.condition[3].value['name'] != null ? null : Colors.red))),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildFilterDetails({required bool localFilterCondition}) {
    return buildCategory(
        categoryTitle: "Filter details",
        title1: "Central filter site",
        title2: "Central filters",
        itemList1: irrigationProvider.selectionModel!.data.centralFilterSite,
        itemList2: irrigationProvider.selectionModel!.data.centralFilter,
        showRow: localFilterCondition,
        show4thWidget: true,
        show2ndWidget: true,
        title3: "Local filter site",
        title4: "Local filters",
        itemList3: irrigationProvider.selectionModel!.data.localFilterSite,
        itemList4: irrigationProvider.selectionModel!.data.localFilter
    );
  }

  Widget buildScheduleDetails({scheduleTypeCondition}) {
    final condition = irrigationProvider.sampleScheduleModel!.selected == irrigationProvider.scheduleTypes[1];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text("Schedule details", style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),),
        ),
        Row(
          children: [
            Expanded(
              child: buildItemsCard(context:context, title: "Schedule type", child: Text(irrigationProvider.sampleScheduleModel!.selected)),
            ),
            Expanded(
              child: buildItemsCard(context:context, title: "Start date", child: _buildScheduleDetailsItem(scheduleTypeCondition, "startDate")
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: buildItemsCard(
                  context: context,
                  title: condition ? "Number of days" : "Run days",
                  child: _buildScheduleDetailsItem(scheduleTypeCondition, condition ? "noOfDays" : "runDays", string: true)
              ),
            ),
            if(!condition)
              Expanded(
                child: buildItemsCard(
                    context: context,
                    title: "Skip days",
                    child: _buildScheduleDetailsItem(scheduleTypeCondition, "skipDays", string: true)
                ),
              ),
            Expanded(
              child: scheduleTypeCondition.schedule['isForceToEndDate'] ? buildItemsCard(
                  context: context,
                  title: "End date",
                  child: _buildScheduleDetailsItem(scheduleTypeCondition, "endDate")
              ) : Container(),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildCategory({
    required String categoryTitle, required String title1,
    required String title2, required itemList1, required itemList2,
    required showRow, required show4thWidget, required String title3,
    required String title4, required itemList3, required itemList4, bool show2ndWidget = true, String? title5,
    String? title6, itemList5, itemList6, String? title7, itemList7, bool showRow2 = false, bool showWidget2 = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(categoryTitle, style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),),
        ),
        buildItemRow(title1: title1, title2: title2, itemList1: itemList1, itemList2: itemList2, showWidget: show2ndWidget),
        if(showRow)
          buildItemRow(title1: title3, title2: title4, itemList1: itemList3, itemList2: itemList4, showWidget: show4thWidget),
        if(showRow2)
          buildItemRow(title1: title5 ?? "", title2: title6 ?? "", itemList1: itemList5, itemList2: itemList6, title3: title7 ?? "", itemList3: itemList7, showWidget: show4thWidget, showWidget2: showWidget2),
      ],
    );
  }

  Widget buildItemRow({
    required String title1,
    required String title2,
    required itemList1,
    required itemList2,
    String? title3,
    itemList3,
    bool showWidget = true, bool showWidget2 = false}){
    return Row(
      children: [
        Expanded(
          child: buildItemsCard(
              context: context,
              title: title1,
              child: buildIndividualRow(itemList1)
          ),
        ),
        Expanded(
            child: showWidget
                ? buildItemsCard(
                context: context,
                title: title2,
                child: buildIndividualRow(itemList2)
            ) : Container()
        ),
        if(showWidget2)
          Expanded(
              child: buildItemsCard(
                  context: context,
                  title: title3 ?? "",
                  child: buildIndividualRow(itemList3)
              )
          ),
      ],
    );
  }

  Widget buildRtcDetails({required rtcList, required BoxConstraints constraints, required allowStopMethodCondition, required defaultOffTime, required defaultMaxTime}){
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
        margin: MediaQuery.of(context).size.width > 1200 ? const EdgeInsets.only(right: 20) : const EdgeInsets.symmetric(horizontal: 20),
        // padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: customBoxShadow
        ),
        child: CustomDataTable(
          rowsPerPage: rtcList.values.toList().length <= 3 ? rtcList.values.toList().length : 3,
          headerText: 'Schedule Details',
          icon: Icons.water,
          columnSpacing: screenWidth > 800 ? 0 : 20,
          dataRowMaxHeight: 45,
          columns: [
            buildDataColumn(label: "RTC No", widthRatio: screenWidth > 1200 ? constraints.maxWidth * 0.04 : null),
            buildDataColumn(label: "Start time", widthRatio: screenWidth > 1200 ? constraints.maxWidth * 0.04 : null),
            buildDataColumn(label: "Cycle Interval", widthRatio: screenWidth > 1200 ? constraints.maxWidth * 0.04 : null),
            buildDataColumn(label: "No. of cycles", widthRatio: screenWidth > 1200 ? constraints.maxWidth * 0.04 : null),
            if(allowStopMethodCondition || defaultOffTime)
              buildDataColumn(label: "Stop time", widthRatio: screenWidth > 1200 ? constraints.maxWidth * 0.04 : null),
            if(allowStopMethodCondition || defaultMaxTime)
              buildDataColumn(label: "Max run time", widthRatio: screenWidth > 1200 ? constraints.maxWidth * 0.04 : null),
          ],
          dataList: rtcList.values.toList(),
          cellBuilders: [
                (data, index) => buildDataCell(dataItem: "RTC ${index+1}", widthRatio: screenWidth > 1200 ? constraints.maxWidth * 0.04 : null),
                (data, index) => buildDataCell(dataItem: data["onTime"], widthRatio: screenWidth > 1200 ? constraints.maxWidth * 0.04 : null,),
                (data, index) => buildDataCell(dataItem: data["interval"], widthRatio: screenWidth > 1200 ? constraints.maxWidth * 0.04 : null,),
                (data, index) => buildDataCell(dataItem: data["noOfCycles"], widthRatio: screenWidth > 1200 ? constraints.maxWidth * 0.04 : null),
            if(allowStopMethodCondition || defaultOffTime)
                  (data, index) => buildDataCell(dataItem: data["offTime"], widthRatio: screenWidth > 1200 ? constraints.maxWidth * 0.04 : null,),
            if(allowStopMethodCondition || defaultMaxTime)
                  (data, index) => buildDataCell(dataItem: data["maxTime"], widthRatio: screenWidth > 1200 ? constraints.maxWidth * 0.04 : null),
          ],
        )
    );
  }
}

Widget buildIndividualRow(item) {
  ScrollController scrollController = ScrollController();
  if(item is! String && item.isNotEmpty) {
    // print(item.runtimeType);
    if(item is List<NameData>) {
      if(item.any((element) => element.selected == true)){
        return SizedBox(
          height: 20,
          child: Scrollbar(
            controller: scrollController,
            child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: item.length,
              itemBuilder: (BuildContext context, int index) {
                if (item[index].selected == true) {
                  return Row(
                    children: [
                      const SizedBox(width: 10),
                      Text(item[index].name ?? ""),
                      const SizedBox(width: 10),
                      if(item.where((element) => element.selected == true).map((e) => e.toJson()).toList().length > 1)
                        VerticalDivider(color: Theme.of(context).primaryColorDark,),
                    ],
                  );
                }
                return Container();
              },
            ),
          ),
        );
      } else {
        return const Text("Not Selected", style: TextStyle(color: Colors.red));
      }
    } else {
      // return Container();
      if(item.any((element) => element.value == true)){
        return SizedBox(
          height: 20,
          child: Scrollbar(
            controller: scrollController,
            child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: item.length,
              itemBuilder: (BuildContext context, int index) {
                if (item[index].value == true) {
                  return Row(
                    children: [
                      const SizedBox(width: 10),
                      Text(item[index].name ?? ""),
                      const SizedBox(width: 10),
                      if(item.where((element) => element.value == true).map((e) => e.toJson()).toList().length > 1)
                        VerticalDivider(color: Theme.of(context).primaryColorDark,),
                    ],
                  );
                }
                return Container();
              },
            ),
          ),
        );
      } else {
        return const Text("Not Selected", style: TextStyle(color: Colors.red));
      }
    }
  } else {
    return Text(item.toString() != "[]" ? item.toString() : "Not available", style: TextStyle(color: item.toString() != "[]" ? Colors.black :Colors.grey));
  }
}

Widget buildItemsCard({required BuildContext context, required String title, required Widget child, margin, padding}){
  return Container(
    margin: margin ?? const EdgeInsets.all(10),
    padding: padding ?? const EdgeInsets.all(10),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: customBoxShadow
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // CircleAvatar(
            //   radius: 15,
            //   backgroundColor: cardColor,
            //   child: Text(
            //     (title.split(" ").first[0]+title.split(" ").last[0]).toUpperCase(),
            //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Theme.of(context).primaryColor),
            //   ),
            // ),
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: linearGradientLeading
              ),
              child: Center(
                child: Text(
                  (title.split(" ").first[0]+title.split(" ").last[0]).toUpperCase(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                ),
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width > 1200 ? 20 : 10,),
            Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w300, overflow: TextOverflow.ellipsis),))
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: child,
        )
      ],
    ),
  );
}

List<BoxShadow> customBoxShadow = [
  BoxShadow(
      offset: const Offset(0, 45),
      blurRadius: 112,
      color: Colors.black.withOpacity(0.06)
  ),
  BoxShadow(
      offset: const Offset(0, 22.78),
      blurRadius: 48.83,
      color: Colors.black.withOpacity(0.0405)
  ),
  BoxShadow(
      offset: const Offset(0, 9),
      blurRadius: 18.2,
      color: Colors.black.withOpacity(0.03)
  ),
  BoxShadow(
      offset: const Offset(0, 1.97),
      blurRadius: 6.47,
      color: Colors.black.withOpacity(0.0195)
  ),
];

DataCell buildDataCell({required dataItem, double? widthRatio, bool showToolTip = false, Color color = Colors.black, Widget? child, bool isFixedSize = false}) {
  return DataCell(
    child ?? SizedBox(
      width: isFixedSize ? widthRatio : null,
      child: showToolTip ?
      Tooltip(
        message: dataItem,
        child: Text(dataItem, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.w500, color: color)),
      )
          : Text(dataItem, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.w500, color: color)),
    ),
  );
}

DataColumn buildDataColumn({required label, double? widthRatio, bool isFixedSize = false}) {
  return DataColumn(
      label: SizedBox(
          width: isFixedSize ? widthRatio : null,
          child: Text(label, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white),))
  );
}

dynamic dateFormatConversion(item) {
  return dateFormat.format(DateTime.parse(item));
}

Widget _buildScheduleDetailsItem(scheduleType, item, {string = false}) {
  return Text(
      string
          ? '${scheduleType.schedule[item]}'
          : "${dateFormatConversion(DateTime.parse(scheduleType.schedule[item]).isBefore(DateTime.now()) ? DateTime.now().toString() : scheduleType.schedule[item])}");
}

class SlidingSendButton extends StatefulWidget {
  final Function onSend;

  const SlidingSendButton({Key? key, required this.onSend}) : super(key: key);

  @override
  _SlidingSendButtonState createState() => _SlidingSendButtonState();
}

class _SlidingSendButtonState extends State<SlidingSendButton> {
  double _dragPosition = 0.0;
  final double _maxDragDistance = 200.0;
  IconData icon = Icons.send;
  bool isSent = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {
          // Update the drag position within bounds
          if (!isSent) {
            _dragPosition += details.delta.dx;
            _dragPosition = _dragPosition.clamp(0.0, _maxDragDistance);
          }
        });
      },
      onHorizontalDragEnd: (details) {
        if (_dragPosition == _maxDragDistance) {
          widget.onSend(); // Trigger the send action
          setState(() {
            isSent = true;
            icon = Icons.done; // Change icon to 'done'
          });
          Future.delayed(Duration(seconds: 1), () {
            setState(() {
              // Reset after a delay
              // isSent = false;
              // _dragPosition = 0.0;
              // icon = Icons.send;
            });
          });
        } else {
          // Reset position if not fully dragged
          setState(() {
            // _dragPosition = 0.0;
          });
        }
      },
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          // Background track
          Container(
            width: _maxDragDistance + 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          // "Slide to Send" text
          Positioned(
            left: isSent ? 100 : 70,
            child: Text(
              isSent ? "Sent!" : "-- Slide to Send -->",
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Sliding button with animation
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            left: _dragPosition,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isSent ? Colors.green : Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}