import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:oro_irrigation_new/Screens/Customer/Logs/pump_list.dart';

import '../../../../../constants/http_service.dart';
import '../IrrigationLog/list_of_log_config.dart';
import '../IrrigationLog/standalone_log.dart';

class IrrigationAndPumpLog extends StatefulWidget {
  final int userId, controllerId;
  const IrrigationAndPumpLog({super.key, required this.userId, required this.controllerId});

  @override
  State<IrrigationAndPumpLog> createState() => _IrrigationAndPumpLogState();
}

class _IrrigationAndPumpLogState extends State<IrrigationAndPumpLog> with TickerProviderStateMixin{
  late TabController tabController;
  List pumpList = [];
  String message = '';

  @override
  void initState() {
    // TODO: implement initState
    tabController = TabController(length: 3, vsync: this);
    getUserNodePumpList();
    super.initState();
  }

  Future<void> getUserNodePumpList() async{
    Map<String, dynamic> userData = {
      "userId": widget.userId,
      "controllerId": widget.controllerId
    };

    final result = await HttpService().postRequest('getUserNodePumpList', userData);
    setState(() {
      if(result.statusCode == 200 && jsonDecode(result.body)['data'] != null) {
        pumpList = jsonDecode(result.body)['data'];
      } else {
        message = jsonDecode(result.body)['message'];
      }
    });
    // print(result.body);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: DefaultTabController(
              length: tabController.length,
              child: Column(
                children: [
                  TabBar(
                      tabs: [
                        Tab(text: "Irrigation Log",),
                        Tab(text: "Standalone Log",),
                        if(pumpList.isNotEmpty)
                          Tab(text: "Pump Log",)
                        else
                          Container()
                      ]
                  ),
                  Expanded(
                      child: TabBarView(
                          children: [
                            ListOfLogConfig(userId: widget.userId, controllerId: widget.controllerId,),
                            StandaloneLog(userId: widget.userId, controllerId: widget.controllerId,),
                            if(pumpList.isNotEmpty)
                              PumpList(pumpList: pumpList, userId: widget.userId, controllerId: widget.controllerId,)
                            else
                              Container()
                          ]
                      )
                  )
                ],
              )
          )
      ),
    );
  }
}
