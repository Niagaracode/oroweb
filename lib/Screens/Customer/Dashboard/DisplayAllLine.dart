
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
    int mainLineDvcList = 0;
    if(widget.provider.centralFilter.isNotEmpty){
      for (var site in widget.provider.centralFilter) {
        if (site['PrsIn']!='-') {
          mainLineDvcList = mainLineDvcList+1;
        }
        if (site['PrsOut']!='-') {
          mainLineDvcList = mainLineDvcList+1;
        }

        int filterLength = site['FilterStatus'].length;
        mainLineDvcList = mainLineDvcList+filterLength;
      }
    }
    mainLineDvcList = mainLineDvcList + (widget.provider.sourcePump.length + widget.provider.irrigationPump.length+1);

    final levelList = widget.provider.payloadIrrLine
        .expand((lvl) => lvl.level)
        .where((level) => level != null)
        .toList();

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

            ((widget.provider.centralFertilizer.isEmpty && widget.provider.localFertilizer.isEmpty && mainLineDvcList < 7) ||
                (widget.provider.centralFertilizer.isEmpty && widget.provider.localFertilizer.isEmpty && widget.currentMaster.irrigationLine[0].valve.length < 25))
                ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                widget.provider.sourcePump.isNotEmpty? Padding(
                  padding: const EdgeInsets.only(top:  11),
                  child: DisplaySourcePump(deviceId: widget.currentMaster.deviceId, currentLineId: 'all', spList: widget.provider.sourcePump, userId: widget.userId, controllerId: widget.currentMaster.controllerId, customerId: widget.customerId,),
                ):
                const SizedBox(),

                widget.provider.sourcePump.isNotEmpty && widget.provider.irrigationPump.isEmpty? Padding(
                  padding: const EdgeInsets.only(top: 11),
                  child: SizedBox(
                    width: levelList.length*75,
                    child: Row(
                      children: levelList.map((levelItem){
                        return Container(
                          color: Colors.transparent,
                          width: 75,
                          height: 100,
                          child: Column(
                            children: [
                              const SizedBox(height: 3.5,),
                              Divider(height: 0, color: Colors.grey.shade300),
                              Container(height: 5, color: Colors.white24),
                              Divider(height: 0, color: Colors.grey.shade300),
                              const SizedBox(
                                width: 10,
                                height: 7,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    VerticalDivider(width: 0),
                                    SizedBox(width: 4),
                                    VerticalDivider(width: 0),
                                  ],
                                ),
                              ),

                              SizedBox(
                                width: 60,
                                height: 55,
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 55,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey.shade300),
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.grey.shade50,
                                      ),
                                    ),
                                    FractionallySizedBox(
                                      heightFactor: double.parse('0.${levelItem.levelPercent}'),
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(5)),
                                          color: _getFillColor(0.10),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 5,
                                      left: 0,
                                      right: 0,
                                      child: Text(
                                        getUnitByParameter(
                                          context,
                                          'Level Sensor',
                                          levelItem.value,
                                        ) ?? '',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 25,
                                      left: 0,
                                      right: 0,
                                      child: Text(
                                        '${levelItem.levelPercent}%',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Text(
                                (levelItem.swName.isNotEmpty ?? false)
                                    ? levelItem.swName
                                    : levelItem.name ?? 'No Name',
                                style: const TextStyle(fontSize: 10, color: Colors.black54),
                              )
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  /*child: InkWell(
                    onTap: levelList.length>1?() {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Level List'),
                            content: levelList.isNotEmpty
                                ? SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: levelList.map((levelItem) {
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
                    }:null,
                    child: SizedBox(
                      width: 52.50,
                      height: 100,
                      child: Stack(
                        children: [
                          Image.asset('assets/images/dp_sump_src.png'),

                          levelList.length==1? Positioned(
                            top: 12,
                            left: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.yellow,
                                borderRadius: const BorderRadius.all(Radius.circular(2)),
                                border: Border.all(color: Colors.grey, width: .50),
                              ),
                              width: 52,
                              height: 30,
                              child: Center(
                                child: Column(
                                  children: [
                                    const Text(
                                      "Level",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      getUnitByParameter(
                                        context,
                                        'Level Sensor',
                                        levelList[0].value,
                                      ) ??
                                          '',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ):
                          const SizedBox(),

                          levelList.length==1? Positioned(
                            top: 43,
                            left: 12,
                            child: Center(
                              child: Text(
                                '${levelList[0].levelPercent}%',
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ):
                          const SizedBox(),

                          levelList.length==1? Positioned(
                            top: 64,
                            left: 5,
                            child: Center(
                              child: Text(
                                levelList[0].swName ?? levelList[0].name,
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ):
                          const SizedBox(),
                        ],
                      ),
                    ),
                  ),*/
                ):
                const SizedBox(),

                widget.provider.irrigationPump.isNotEmpty? Padding(
                  padding: const EdgeInsets.only(top: 11),
                  child: InkWell(
                    onTap: levelList.length>1?() {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Level List'),
                            content: levelList.isNotEmpty
                                ? SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: levelList.map((levelItem) {
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
                    }:null,
                    child: SizedBox(
                      width: 52.50,
                      height: 100,
                      child: Stack(
                        children: [
                          widget.provider.sourcePump.isNotEmpty
                              ? Image.asset('assets/images/dp_sump_src.png')
                              : Image.asset('assets/images/dp_sump.png'),

                          levelList.length==1? Positioned(
                            top: 12,
                            left: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.yellow,
                                borderRadius: const BorderRadius.all(Radius.circular(2)),
                                border: Border.all(color: Colors.grey, width: .50),
                              ),
                              width: 52,
                              height: 30,
                              child: Center(
                                child: Column(
                                  children: [
                                    const Text(
                                      "Level",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      getUnitByParameter(
                                        context,
                                        'Level Sensor',
                                        levelList[0].value,
                                      ) ??
                                          '',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ):
                          const SizedBox(),

                          levelList.length==1? Positioned(
                            top: 43,
                            left: 12,
                            child: Center(
                              child: Text(
                                '${levelList[0].levelPercent}%',
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ):
                          const SizedBox(),

                          levelList.length==1? Positioned(
                            top: 64,
                            left: 5,
                            child: Center(
                              child: Text(
                                levelList[0].swName ?? levelList[0].name,
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ):
                          const SizedBox(),
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
                      DisplayIrrigationLine(irrigationLine: widget.currentMaster.irrigationLine[0], currentLineId: 'all', currentMaster: widget.currentMaster, rWidth: mainLineDvcList*70, customerId: widget.customerId,),
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
                              onTap: levelList.length>1?() {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Level List'),
                                      content: levelList.isNotEmpty
                                          ? SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: levelList.map((levelItem) {
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
                              }:null,
                              child: SizedBox(
                                width: 52.50,
                                height: 100,
                                child: Stack(
                                  children: [
                                    widget.provider.sourcePump.isNotEmpty
                                        ? Image.asset('assets/images/dp_sump_src.png')
                                        : Image.asset('assets/images/dp_sump.png'),

                                    levelList.length==1? Positioned(
                                      top: 12,
                                      left: 0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.yellow,
                                          borderRadius: const BorderRadius.all(Radius.circular(2)),
                                          border: Border.all(color: Colors.grey, width: .50),
                                        ),
                                        width: 52,
                                        height: 30,
                                        child: Center(
                                          child: Column(
                                            children: [
                                              const Text(
                                                "Level",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Text(
                                                getUnitByParameter(
                                                  context,
                                                  'Level Sensor',
                                                  levelList[0].value,
                                                ) ??
                                                    '',
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ):
                                    const SizedBox(),

                                    levelList.length==1? Positioned(
                                      top: 43,
                                      left: 12,
                                      child: Center(
                                        child: Text(
                                          '${levelList[0].levelPercent}%',
                                          style: const TextStyle(
                                            color: Colors.black87,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ):
                                    const SizedBox(),

                                    levelList.length==1? Positioned(
                                      top: 64,
                                      left: 5,
                                      child: Center(
                                        child: Text(
                                          levelList[0].swName ?? levelList[0].name,
                                          style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ):
                                    const SizedBox(),
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

  Color _getFillColor(double percentage) {
    if (percentage >= 0.8) {
      return Colors.green.shade400;
    } else if (percentage >= 0.5) {
      return Colors.yellow.shade400;
    } else {
      return Colors.red.shade400;
    }
  }

}
