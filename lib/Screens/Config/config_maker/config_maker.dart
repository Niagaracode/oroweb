// import 'dart:html';
import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../constants/MQTTManager.dart';
import '../../../constants/http_service.dart';
import '../../../state_management/MqttPayloadProvider.dart';
import '../../../state_management/config_maker_provider.dart';
import 'config_web.dart';

class ConfigMakerScreen extends StatefulWidget {
  const ConfigMakerScreen({super.key, required this.userID, required this.customerID, required this.controllerId, required this.imeiNumber});
  final int userID, customerID, controllerId;
  final String imeiNumber;

  @override
  State<ConfigMakerScreen> createState() => _ConfigMakerScreenState();
}

class _ConfigMakerScreenState extends State<ConfigMakerScreen> with SingleTickerProviderStateMixin{
  int selectedTab = 0;
  // late TabController controller;

  @override
  void initState() {
    print('ConfigMakerScreen is called');
    super.initState();
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        var configPvd = Provider.of<ConfigMakerProvider>(context,listen: false);
        configPvd.clearConfig();
        getConfigData(configPvd);
        MqttPayloadProvider payloadProvider = Provider.of<MqttPayloadProvider>(context,listen: false);
        MQTTManager().initializeMQTTClient(state: payloadProvider);
        MQTTManager().connect();
      });

    }

    // controller = TabController(length: 12, vsync: this, initialIndex: 0);
    // controller.addListener(_handleTabSelection);
  }
  Future<void> getConfigData(ConfigMakerProvider configPvd)  async {
    HttpService service = HttpService();
    try{
      print('config : ${{'userId' : widget.customerID, 'controllerId' : widget.controllerId}}');
      var response = await service.postRequest('getUserConfigMakerTesting', {'userId' : widget.customerID, 'controllerId' : widget.controllerId});
      var jsonData = jsonDecode(response.body);
      print("isnewConfig  :::::::::::::::::::::::::::::: ${jsonData['data']['configMaker']?['isNewConfig']}");
      configPvd.fetchAll(jsonData['data'],jsonData['data']['configMaker']?['sourcePump'] == null ? true : null);
    }catch(e){
      print(e.toString());
    }
  }
  @override
  void dispose() {
    // Dispose of your TabController and other resources here
    // controller.dispose();

    super.dispose();
  }


  void _handleTabSelection() {
    var configPvd = Provider.of<ConfigMakerProvider>(context, listen: false);
    // setState(() {
    //   selectedTab = controller.index; // Store the selected tab index
    // });
    configPvd.editInitialIndex(selectedTab);
    if(selectedTab != 5){
      // configPvd.editLoadIL(false);
    }
  }
  @override
  Widget build(BuildContext context) {
    var configPvd = Provider.of<ConfigMakerProvider>(context, listen: true);
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      if(constraints.maxWidth < 1000){
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: (MediaQuery.of(context).orientation == Orientation.portrait || kIsWeb) ? null : 30,
            title: const Text('Config Maker'),

          ),
          body: Container(
            child: const Text('in complete'),
          ),
          // body: DefaultTabController(
          //     length: configPvd.tabs.length,
          //     child: Column(
          //       children: [
          //         Container(
          //           width: double.infinity,
          //           //color: Color(0XFFF3F3F3),
          //           child: TabBar(
          //               controller: controller,
          //               indicatorColor: myTheme.primaryColor,
          //               labelStyle: TextStyle(fontWeight: FontWeight.bold),
          //               unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
          //               isScrollable: true,
          //               tabs: [
          //                 for(var i = 0;i < configPvd.tabs.length;i++)
          //                   Tab(
          //                     text: '${configPvd.tabs[i][0]} ${configPvd.tabs[i][1]}',
          //                   ),
          //               ]
          //           ),
          //         ),
          //         Expanded(
          //           child: TabBarView(
          //             controller: controller,
          //             children: [
          //               const StartPageConfigMaker(),
          //               const SourcePumpTable(),
          //               const IrrigationPumpTable(),
          //               const CentralDosingTable(),
          //               const CentralFiltrationTable(),
          //               const IrrigationLineTable(),
          //               const LocalDosingTable(),
          //               const LocalFiltrationTable(),
          //               const WeatherStationConfig(),
          //               MappingOfOutputsTable(configPvd: configPvd,),
          //               MappingOfInputsTable(configPvd: configPvd),
          //               //FinishPageConfigMaker(customerId: widget.customerID, controllerId: widget.siteID, userId: widget.userID, imeiNo: widget.imeiNumber,),
          //             ],
          //           ),
          //         )
          //       ],
          //     )
          // ),
        );
      }else{
        return  ConfigMakerForWeb(userID: widget.userID, customerID: widget.customerID, siteId: widget.controllerId, imeiNo: widget.imeiNumber,);
      }
    },);
  }
}

