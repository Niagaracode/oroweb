
import 'package:flutter/material.dart';

import '../../../Models/Customer/Dashboard/DashboardNode.dart';
import '../../../state_management/MqttPayloadProvider.dart';
import '../CustomerDashboard.dart';
import 'PumpLineCentral.dart';

class DisplayAllLine extends StatefulWidget {
  const DisplayAllLine({Key? key, required this.currentMaster, required this.provider, required this.userId, required this.customerId}) : super(key: key);
  final MasterData currentMaster;
  final MqttPayloadProvider provider;
  final int userId, customerId;

  @override
  State<DisplayAllLine> createState() => _DisplayAllLineState();
}

class _DisplayAllLineState extends State<DisplayAllLine> {

  @override
  Widget build(BuildContext context) {


    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.grey,
            width: 0.5,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ScrollConfiguration(
              behavior: const ScrollBehavior(),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.only(top: 9, left: 5, right: 5),
                  child: widget.provider.irrigationPump.isNotEmpty? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.provider.sourcePump.isNotEmpty? Padding(
                        padding: EdgeInsets.only(top:  widget.provider.centralFertilizer.isNotEmpty ||  widget.provider.localFertilizer.isNotEmpty? 38.4:0),
                        child: DisplaySourcePump(deviceId: widget.currentMaster.deviceId, currentLineId: 'all', spList: widget.provider.sourcePump, userId: widget.userId, controllerId: widget.currentMaster.controllerId, customerId: widget.customerId,),
                      ):
                      const SizedBox(),

                      widget.provider.irrigationPump.isNotEmpty? Padding(
                        padding: EdgeInsets.only(top: widget.provider.centralFertilizer.isNotEmpty || widget.provider.localFertilizer.isNotEmpty? 38.4:0),
                        child: InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Level List'),
                                  content: widget.provider.payloadIrrLine[0].level.isNotEmpty?Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: widget.provider.payloadIrrLine[0].level.map((levelItem) {
                                      return ListTile(
                                        title: Text(levelItem.swName),
                                        trailing: Column(
                                          children: [
                                            Text('Percent: ${levelItem.levelPercent}%'),
                                            Text('Value: ${levelItem.value}',)
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ):
                                  const Text('No level available'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(); // Close the dialog
                                      },
                                      child: const Text('Close'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: SizedBox(
                            width: 52.50,
                            height: 70,
                            child: Stack(
                              children: [
                                widget.provider.sourcePump.isNotEmpty
                                    ? Image.asset('assets/images/dp_sump_src.png')
                                    : Image.asset('assets/images/dp_sump.png'),
                              ],
                            ),
                          ),
                        ),
                      ):
                      const SizedBox(),

                      widget.provider.irrigationPump.isNotEmpty? Padding(
                        padding: EdgeInsets.only(top: widget.provider.centralFertilizer.isNotEmpty || widget.provider.localFertilizer.isNotEmpty? 38.4:0),
                        child: DisplayIrrigationPump(currentLineId: 'all', deviceId: widget.currentMaster.deviceId, ipList: widget.provider.irrigationPump, userId: widget.customerId, controllerId: widget.currentMaster.controllerId,),
                      ):
                      const SizedBox(),

                      widget.provider.centralFilter.isEmpty && widget.provider.centralFertilizer.isEmpty &&
                          widget.provider.localFilter.isEmpty && widget.provider.localFertilizer.isEmpty ? SizedBox(
                        width: 4.5,
                        height: 100,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 7),
                              child: VerticalDivider(width: 0, color: Colors.grey.shade300,),
                            ),
                            const SizedBox(width: 4.5,),
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: VerticalDivider(width: 0, color: Colors.grey.shade300,),
                            ),
                          ],
                        ),
                      ):
                      const SizedBox(),

                      widget.provider.centralFilter.isNotEmpty? Padding(
                        padding: EdgeInsets.only(top: widget.provider.centralFertilizer.isNotEmpty || widget.provider.localFertilizer.isNotEmpty? 38.4:0),
                        child: DisplayFilter(currentLineId: 'all', filtersSites: widget.provider.centralFilter,),
                      ):
                      const SizedBox(),

                      (widget.provider.localFertilizer.isEmpty && widget.provider.centralFertilizer.isEmpty) &&
                          (widget.provider.centralFilter.isNotEmpty || widget.provider.localFilter.isNotEmpty) ? SizedBox(
                        width: 4.5,
                        height: 120,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 7),
                              child: VerticalDivider(width: 0, color: Colors.grey.shade300,),
                            ),
                            const SizedBox(width: 4.5,),
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: VerticalDivider(width: 0, color: Colors.grey.shade300,),
                            ),
                          ],
                        ),
                      ):
                      const SizedBox(),

                      /*for(int i=0; i<widget.provider.payload2408.length; i++)
                        widget.provider.payload2408.isNotEmpty?  Padding(
                          padding: EdgeInsets.only(top: widget.provider.centralFertilizer.isNotEmpty || widget.provider.localFertilizer.isNotEmpty? 38.4:0),
                          child: DisplaySensor(payload2408: widget.provider.payload2408, index: i,),
                        ) : const SizedBox(),*/

                      widget.provider.centralFertilizer.isNotEmpty? const DisplayCentralFertilizer(currentLineId: 'all',):
                      const SizedBox(),

                      //local
                      widget.provider.irrigationPump.isNotEmpty? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              (widget.provider.centralFertilizer.isNotEmpty || widget.provider.centralFilter.isNotEmpty) && widget.provider.localFertilizer.isNotEmpty? SizedBox(
                                width: 4.5,
                                height: 150,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 42),
                                      child: VerticalDivider(width: 0, color: Colors.grey.shade300,),
                                    ),
                                    const SizedBox(width: 4.5,),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 45),
                                      child: VerticalDivider(width: 0, color: Colors.grey.shade300,),
                                    ),
                                  ],
                                ),
                              ):
                              const SizedBox(),

                              widget.provider.localFertilizer.isEmpty && widget.provider.localFilter.isNotEmpty? SizedBox(
                                width: 4.5,
                                height: 150,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 42),
                                      child: VerticalDivider(width: 0, color: Colors.grey.shade300,),
                                    ),
                                    const SizedBox(width: 4.5,),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 45),
                                      child: VerticalDivider(width: 0, color: Colors.grey.shade300,),
                                    ),
                                  ],
                                ),
                              ):
                              const SizedBox(),

                              widget.provider.localFilter.isNotEmpty? Padding(
                                padding: EdgeInsets.only(top: widget.provider.localFilter.isNotEmpty?38.4:0),
                                child:  LocalFilter(currentLineId: 'all', filtersSites: widget.provider.localFilter,),
                              ):
                              const SizedBox(),

                              widget.provider.localFertilizer.isEmpty && widget.provider.localFilter.isNotEmpty? SizedBox(
                                width: 4.5,
                                height: 150,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 45),
                                      child: VerticalDivider(width: 0, color: Colors.grey.shade300,),
                                    ),
                                    const SizedBox(width: 4.5,),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 42),
                                      child: VerticalDivider(width: 0, color: Colors.grey.shade300,),
                                    ),
                                  ],
                                ),
                              ):
                              const SizedBox(),

                              widget.provider.localFertilizer.isNotEmpty? const DisplayLocalFertilizer(currentLineId: 'all',):
                              const SizedBox(),
                            ],
                          ),
                        ],
                      ):
                      const SizedBox(height: 20)
                    ],
                  ):
                  const SizedBox(height: 20),
                ),
              ),
            ),

            Divider(height: 0, color: Colors.grey.shade300),
            Container(height: 4, color: Colors.white24),
            Divider(height: 0, color: Colors.grey.shade300),

            DisplayIrrigationLine(irrigationLine: widget.currentMaster.irrigationLine[0], currentLineId: 'all', currentMaster: widget.currentMaster, rWidth: 0, customerId: widget.customerId,)
          ],
        ),
      ),
    );
  }

}
