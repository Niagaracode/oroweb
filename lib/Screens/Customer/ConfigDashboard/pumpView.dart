import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';


class PumpView extends StatefulWidget {
  final dynamic sourcePump;
  final referenceList;
  Map<dynamic,dynamic> names;
  PumpView({super.key, required this.sourcePump, required this.referenceList, required this.names});

  @override
  State<PumpView> createState() => _PumpViewState();
}

class _PumpViewState extends State<PumpView> {
  late LinkedScrollControllerGroup _scrollable1;
  late ScrollController _verticalScroll1;
  late ScrollController _verticalScroll2;
  late LinkedScrollControllerGroup _scrollable2;
  late ScrollController _horizontalScroll1;
  late ScrollController _horizontalScroll2;

  @override
  void initState() {
    // TODO: implement initState
    _scrollable1 = LinkedScrollControllerGroup();
    _verticalScroll1 = _scrollable1.addAndGet();
    _verticalScroll2 = _scrollable1.addAndGet();
    _scrollable2 = LinkedScrollControllerGroup();
    _horizontalScroll1 = _scrollable2.addAndGet();
    _horizontalScroll2 = _scrollable2.addAndGet();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xfff3f3f3),
      padding: const EdgeInsets.all(8.0),
      child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        return Center(
          child: SizedBox(
            width: constraints.maxWidth,
            child: Row(
              children: [
                Column(
                  children: [
                    //Todo : first column
                    headerConfigView(data: 'Object'),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _verticalScroll1,
                        child: Container(
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  for(var i = 0;i < widget.sourcePump.length;i++)
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 1),
                                      decoration: const BoxDecoration(
                                          color: Colors.white
                                      ),
                                      width: 150,
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              IconButton(
                                                  onPressed: (){
                                                    setState(() {
                                                      widget.sourcePump[i]['visible'] = !widget.sourcePump[i]['visible'];
                                                    });
                                                  },
                                                  icon: Icon(widget.sourcePump[i]['visible'] ? Icons.remove_circle : Icons.add_circle_outlined,color: widget.sourcePump[i]['visible'] ? Colors.green : Colors.blue,)
                                              ),
                                              Text('SP ${i+1}',style: const TextStyle(color: Colors.black,fontSize: 10,fontWeight: FontWeight.normal),overflow: TextOverflow.ellipsis,),
                                            ],
                                          ),
                                          if(widget.sourcePump[i]['visible'])
                                            Column(
                                              children: [
                                                objectContainer(data: '${widget.names['${widget.sourcePump[i]['sNo']}']['name']}'),
                                                if(widget.sourcePump[i]['levelSensor'].isNotEmpty)
                                                  objectContainer(data: '${widget.names['${widget.sourcePump[i]['levelSensor']['sNo']}']['name']}'),
                                                if(widget.sourcePump[i]['pressureSensor'].isNotEmpty)
                                                  objectContainer(data: '${widget.names['${widget.sourcePump[i]['pressureSensor']['sNo']}']['name']}'),
                                                if(widget.sourcePump[i]['TopTankHigh'].isNotEmpty)
                                                  objectContainer(data: '${widget.names['${widget.sourcePump[i]['TopTankHigh']['sNo']}']['name']}'),
                                                if(widget.sourcePump[i]['TopTankLow'].isNotEmpty)
                                                  objectContainer(data: '${widget.names['${widget.sourcePump[i]['TopTankLow']['sNo']}']['name']}'),
                                                if(widget.sourcePump[i]['SumpTankHigh'].isNotEmpty)
                                                  objectContainer(data: '${widget.names['${widget.sourcePump[i]['SumpTankHigh']['sNo']}']['name']}'),
                                                if(widget.sourcePump[i]['SumpTankLow'].isNotEmpty)
                                                  objectContainer(data: '${widget.names['${widget.sourcePump[i]['SumpTankLow']['sNo']}']['name']}'),
                                              ],
                                            )
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      width: constraints.maxWidth - 150,
                      height: 50,
                      child: SingleChildScrollView(
                        controller: _horizontalScroll1,
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            headerConfigView(data: 'ID'),
                            headerConfigView(data: 'LOCATION'),
                            headerConfigView(data: 'RTU'),
                            headerConfigView(data: 'REF NO'),
                            headerConfigView(data: 'MAC ADDRESS'),
                            headerConfigView(data: 'OUTPUT'),
                            headerConfigView(data: 'INPUT'),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        width: constraints.maxWidth - 150,
                        child: Scrollbar(
                          thumbVisibility: true,
                          controller: _horizontalScroll2,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            controller: _horizontalScroll2,
                            child: Container(
                              child: Scrollbar(
                                thumbVisibility: true,
                                controller: _verticalScroll2,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  controller: _verticalScroll2,
                                  child: Column(
                                    children: [
                                      for(var i = 0;i < widget.sourcePump.length;i++)
                                        Container(
                                          margin: const EdgeInsets.only(bottom: 1),
                                          decoration: const BoxDecoration(
                                              color: Colors.white
                                          ),
                                          width: 150*7,
                                          child: Column(
                                            children: [
                                              const SizedBox(height: 40,),
                                              if(widget.sourcePump[i]['visible'])
                                                Column(
                                                  children: [
                                                    rowWidget(nameData: widget.names, objectData: widget.sourcePump[i], referenceList: widget.referenceList),
                                                    if(widget.sourcePump[i]['levelSensor'].isNotEmpty)
                                                      rowWidget(nameData: widget.names, objectData: widget.sourcePump[i]['levelSensor'], referenceList: widget.referenceList),
                                                    if(widget.sourcePump[i]['pressureSensor'].isNotEmpty)
                                                      rowWidget(nameData: widget.names, objectData: widget.sourcePump[i]['pressureSensor'], referenceList: widget.referenceList),
                                                    if(widget.sourcePump[i]['TopTankHigh'].isNotEmpty)
                                                      rowWidget(nameData: widget.names, objectData: widget.sourcePump[i]['TopTankHigh'], referenceList: widget.referenceList),
                                                    if(widget.sourcePump[i]['TopTankLow'].isNotEmpty)
                                                      rowWidget(nameData: widget.names, objectData: widget.sourcePump[i]['TopTankLow'], referenceList: widget.referenceList),
                                                    if(widget.sourcePump[i]['SumpTankHigh'].isNotEmpty)
                                                      rowWidget(nameData: widget.names, objectData: widget.sourcePump[i]['SumpTankHigh'], referenceList: widget.referenceList),
                                                    if(widget.sourcePump[i]['SumpTankLow'].isNotEmpty)
                                                      rowWidget(nameData: widget.names, objectData: widget.sourcePump[i]['SumpTankLow'], referenceList: widget.referenceList),
                                                    if(widget.sourcePump[i]['waterMeter'].isNotEmpty)
                                                      rowWidget(nameData: widget.names, objectData: widget.sourcePump[i]['waterMeter'], referenceList: widget.referenceList),
                                                  ],
                                                )
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

String getMacAddress({
  required referenceList,
  required String rtu,
  required String rfNo,
}){
  var mac = '-';
  switch(rtu){
    case('ORO Smart'):
      var index = referenceList['12'].indexWhere((element) => element["referenceNumber"].toString() == rfNo);
      mac = referenceList['12'][index]['deviceId'];
    case('O-Smart-Plus'):
      var index = referenceList['7'].indexWhere((element) => element["referenceNumber"].toString() == rfNo);
      mac = referenceList['7'][index]['deviceId'];
    case('ORO Sense'):
      var index = referenceList['10'].indexWhere((element) => element["referenceNumber"].toString() == rfNo);
      mac = referenceList['10'][index]['deviceId'];
    case('ORO RTU'):
      var index = referenceList['13'].indexWhere((element) => element["referenceNumber"].toString() == rfNo);
      mac = referenceList['13'][index]['deviceId'];
    case('O-RTU-Plus'):
      var index = referenceList['8'].indexWhere((element) => element["referenceNumber"].toString() == rfNo);
      mac = referenceList['8'][index]['deviceId'];
    case('ORO Pump'):
      var index = referenceList['3'].indexWhere((element) => element["referenceNumber"].toString() == rfNo);
      mac = referenceList['3'][index]['deviceId'];
    case('O-Pump-Plus'):
      var index = referenceList['4'].indexWhere((element) => element["referenceNumber"].toString() == rfNo);
      mac = referenceList['4'][index]['deviceId'];
    case('ORO Level'):
      var index = referenceList['6'].indexWhere((element) => element["referenceNumber"].toString() == rfNo);
      mac = referenceList['6'][index]['deviceId'];
    default:
      mac ='-';

  }
  return mac;
}
Widget objectContainer({
  required String? data,
  bool? subCategory,
  double? margin,
}){
  return Container(
      width: 150 - (margin ?? 0),
      color: subCategory == null ? const Color(0xff1C7C8A) : const Color(0xff2999A9),
      height: 30,
      margin: EdgeInsets.only(bottom: 1,left: margin ?? 0.0),
      padding: const EdgeInsets.only(left: 10),
      child: Center(child: Text('$data',style: const TextStyle(fontWeight: FontWeight.normal,fontSize: 12,color: Colors.white),overflow: TextOverflow.ellipsis,))
  );
}

Widget headerConfigView({
  required String data
}){
  return Container(
    decoration: const BoxDecoration(
      color: Color(0xff96CED5),
    ),
    padding: const EdgeInsets.only(left: 8),
    width: 150,
    height: 50,
    alignment: Alignment.center,
    child: Center(child: Text(data,style: const TextStyle(color: Color(0xff30555A),fontSize: 13),)),
  );
}

Widget rowWidget({
  required nameData,
  required objectData,
  required referenceList,
  bool? subCategory,
}){
  return Row(
    children: [
      objectContainer(data: '${nameData['${objectData['sNo']}']['id']}',subCategory: subCategory),
      objectContainer(data: '${nameData['${objectData['sNo']}']['location']}',subCategory: subCategory),
      objectContainer(data: '${objectData['rtu']}',subCategory: subCategory),
      objectContainer(data: '${objectData['rfNo']}',subCategory: subCategory),
      objectContainer(data:  getMacAddress(referenceList: referenceList, rtu: '${objectData['rtu']}', rfNo: '${objectData['rfNo']}'),subCategory: subCategory),
      objectContainer(data: '${objectData['output'] ?? '-'}',subCategory: subCategory),
      objectContainer(data: '${objectData['input'] ?? '-'}',subCategory: subCategory),
    ],
  );
}

