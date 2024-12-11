
import 'package:flutter/material.dart';
import 'package:oro_irrigation_new/Screens/Customer/Logs/pump_log.dart';

import '../IrrigationProgram/irrigation_program_main.dart';
import 'hourly_data.dart';

class PumpList extends StatefulWidget {
  final int userId, controllerId;
  final List pumpList;
  const PumpList({super.key, required this.pumpList, required this.userId, required this.controllerId});

  @override
  State<PumpList> createState() => _PumpListState();
}

class _PumpListState extends State<PumpList> {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView.builder(
        itemCount: widget.pumpList.length,
          itemBuilder: (BuildContext context, int index) {
          final pumpItem = widget.pumpList[index];
            return Column(
              children: [
                Container(
                  // margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    // boxShadow: customBoxShadow
                  ),
                  child: ListTile(
                    title: Text('${pumpItem['deviceName']}'),
                    subtitle: Text('${pumpItem['deviceId']}'),
                    trailing: IntrinsicWidth(
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => HourlyData(userId: widget.userId, controllerId: widget.controllerId, nodeControllerId: pumpItem['controllerId'], showAppBar: true,)));
                              },
                              icon: Icon(Icons.power)
                          ),
                          IconButton(
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => NewPumpLogScreen(userId: widget.userId, controllerId: widget.controllerId, nodeControllerId: pumpItem['controllerId'], showAppBar: true)));
                              },
                              icon: Icon(Icons.auto_graph)
                          ),
                        ],
                      ),
                    ),
                    leading: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: linearGradientLeading,
                      ),
                      child: Center(child: Text('${index+1}', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),)),
                    ),
                  ),
                ),
                // SizedBox(height: 15,)
              ],
            );
          }
      ),
    );
  }
}
