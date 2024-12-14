
import 'package:flutter/material.dart';

import '../../../Models/Customer/Dashboard/DashboardNode.dart';
import '../../../constants/MyFunction.dart';
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            (widget.provider.centralFertilizer.isEmpty && widget.provider.localFertilizer.isEmpty &&
                (widget.provider.sourcePump.length + widget.provider.irrigationPump.length + widget.provider.centralFilter.length + widget.provider.localFilter.length) < 7)
                ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                widget.provider.sourcePump.isNotEmpty? Padding(
                  padding: const EdgeInsets.only(top:  11),
                  child: DisplaySourcePump(deviceId: widget.currentMaster.deviceId, currentLineId: 'all', spList: widget.provider.sourcePump, userId: widget.userId, controllerId: widget.currentMaster.controllerId, customerId: widget.customerId,),
                ):
                const SizedBox(),

                widget.provider.irrigationPump.isNotEmpty? Padding(
                  padding: const EdgeInsets.only(top: 11),
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          final levels = widget.provider.payloadIrrLine
                              .expand((record) => record.level)
                              .where((level) => level != null)
                              .toList();

                          return AlertDialog(
                            title: const Text('Level List'),
                            content: levels.isNotEmpty
                                ? SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: levels.map((levelItem) {
                                  return ListTile(
                                    leading: Image.asset(
                                      'assets/images/level_sensor.png',
                                      height: 30,
                                      width: 30,
                                    ),
                                    title: Text(
                                      (levelItem.swName.isNotEmpty ?? false)
                                          ? levelItem.swName
                                          : levelItem.name ?? 'No Name',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    trailing: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text.rich(
                                          TextSpan(
                                            text: 'Percent: ', // Regular text
                                            style: const TextStyle(fontSize: 12),
                                            children: [
                                              TextSpan(
                                                text: '${levelItem.levelPercent}%',
                                                style: const TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text.rich(
                                          TextSpan(
                                            text: 'Level: ', // Regular text
                                            style: const TextStyle(fontSize: 12),
                                            children: [
                                              TextSpan(
                                                text: getUnitByParameter(
                                                  context,
                                                  'Level Sensor',
                                                  levelItem.value,
                                                ) ??
                                                    '',
                                                style: const TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            )
                                : const Text('No levels available'), // Display if levels are empty
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
                      height: 100,
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
                  padding: const EdgeInsets.only(top: 11),
                  child: DisplayIrrigationPump(currentLineId: 'all', deviceId: widget.currentMaster.deviceId, ipList: widget.provider.irrigationPump, userId: widget.customerId, controllerId: widget.currentMaster.controllerId,),
                ):
                const SizedBox(),

                widget.provider.centralFilter.isNotEmpty? Padding(
                  padding: const EdgeInsets.only(top: 11),
                  child: DisplayFilter(currentLineId: 'all', filtersSites: widget.provider.centralFilter,),
                ):
                const SizedBox(),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 14,),
                      Divider(height: 0, color: Colors.grey.shade300),
                      Container(height: 5, color: Colors.white24),
                      Divider(height: 0, color: Colors.grey.shade300),
                      DisplayIrrigationLine(irrigationLine: widget.currentMaster.irrigationLine[0], currentLineId: 'all', currentMaster: widget.currentMaster, rWidth: (widget.provider.sourcePump.length + widget.provider.irrigationPump.length + widget.provider.centralFilter.length + widget.provider.localFilter.length+1)*70, customerId: widget.customerId,),
                    ],
                  ),
                ),
              ],
            )
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
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
                                    final levels = widget.provider.payloadIrrLine
                                        .expand((record) => record.level)
                                        .where((level) => level != null)
                                        .toList();

                                    return AlertDialog(
                                      title: const Text('Level List'),
                                      content: levels.isNotEmpty
                                          ? SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: levels.map((levelItem) {
                                            return ListTile(
                                              leading: Image.asset(
                                                'assets/images/level_sensor.png',
                                                height: 30,
                                                width: 30,
                                              ),
                                              title: Text(
                                                (levelItem.swName.isNotEmpty ?? false)
                                                    ? levelItem.swName
                                                    : levelItem.name ?? 'No Name',
                                                style: const TextStyle(fontSize: 14),
                                              ),
                                              trailing: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text.rich(
                                                    TextSpan(
                                                      text: 'Percent: ', // Regular text
                                                      style: const TextStyle(fontSize: 12),
                                                      children: [
                                                        TextSpan(
                                                          text: '${levelItem.levelPercent}%',
                                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Text.rich(
                                                    TextSpan(
                                                      text: 'Level: ', // Regular text
                                                      style: const TextStyle(fontSize: 12),
                                                      children: [
                                                        TextSpan(
                                                          text: getUnitByParameter(
                                                            context,
                                                            'Level Sensor',
                                                            levelItem.value,
                                                          ) ??
                                                              '',
                                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      )
                                          : const Text('No levels available'), // Display if levels are empty
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

                DisplayIrrigationLine(irrigationLine: widget.currentMaster.irrigationLine[0], currentLineId: 'all', currentMaster: widget.currentMaster, rWidth: 0, customerId: widget.customerId,),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
