import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:oro_irrigation_new/Screens/Customer/ConfigDashboard/pumpView.dart';

class IrrigationLinesView extends StatefulWidget {
  final dynamic irrigationLine;
  final dynamic referenceList;
  Map<dynamic,dynamic> names;
  IrrigationLinesView({super.key,required this.irrigationLine,required this.referenceList,required this.names});
  @override
  State<IrrigationLinesView> createState() => _IrrigationLinesViewState();
}

class _IrrigationLinesViewState extends State<IrrigationLinesView> {
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
                                  for(var i = 0;i < widget.irrigationLine.length;i++)
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
                                                      for(var line = 0;line < widget.irrigationLine.length;line++){
                                                        if(line != i){
                                                          widget.irrigationLine[line]['visible'] = false;
                                                        }
                                                      }
                                                      widget.irrigationLine[i]['visible'] = !widget.irrigationLine[i]['visible'];
                                                    });
                                                  },
                                                  icon: Icon(widget.irrigationLine[i]['visible'] ? Icons.remove_circle : Icons.add_circle_outlined,color: widget.irrigationLine[i]['visible'] ? Colors.green : Colors.blue,)
                                              ),
                                              Text('${widget.names['${widget.irrigationLine[i]['sNo']}']?['name']}',style: const TextStyle(color: Colors.black,fontSize: 10,fontWeight: FontWeight.normal),overflow: TextOverflow.ellipsis,),
                                            ],
                                          ),
                                          //Todo : applying first lineData
                                          if(widget.irrigationLine[i]['visible'])
                                            for(var object in ['valveConnection-valveVisible-Valve','main_valveConnection-mainValveVisible-Main Valve','moistureSensorConnection-moistureVisible-Moisture Sensor','levelSensorConnection-levelVisible-Level Sensor','foggerConnection-foggerVisible-Fogger','fanConnection-fanVisible-Fan'])
                                              if(widget.irrigationLine[i][object.split('-')[0]].isNotEmpty)
                                                Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(left:  20),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          IconButton(
                                                              onPressed: (){
                                                                setState(() {
                                                                  widget.irrigationLine[i][object.split('-')[1]] = !widget.irrigationLine[i][object.split('-')[1]];
                                                                });
                                                              },
                                                              icon: Icon(widget.irrigationLine[i][object.split('-')[1]] ? Icons.remove_circle : Icons.add_circle_outlined,color: widget.irrigationLine[i][object.split('-')[1]] ? Colors.green : Colors.blue,)
                                                          ),
                                                          Text('${object.split('-')[2]}',style: TextStyle(color: Colors.black,fontSize: 10,fontWeight: FontWeight.normal),overflow: TextOverflow.ellipsis,),
                                                        ],
                                                      ),
                                                    ),
                                                    if(widget.irrigationLine[i][object.split('-')[1]])
                                                      for(var obj in widget.irrigationLine[i][object.split('-')[0]])
                                                        objectContainer(data: '${widget.names['${obj['sNo']}']['name']}',margin: 15),
                                                  ],
                                                ),

                                          if(widget.irrigationLine[i]['visible'])
                                            for(var object in ['water_meter','pressureIn','pressureOut'])
                                              if(widget.irrigationLine[i][object].isNotEmpty)
                                                objectContainer(data: '${widget.names['${widget.irrigationLine[i][object]['sNo']}']['name']}',margin: 0),



                                          //Todo : applying first fertilizer
                                          if(widget.irrigationLine[i]['visible'])
                                            if(widget.irrigationLine[i]['ldPressureSwitch'] != null)
                                              if(widget.irrigationLine[i]['ldPressureSwitch'].isNotEmpty)
                                                objectContainer(data: '${widget.names['${widget.irrigationLine[i]['ldPressureSwitch']['sNo']}']['name']}',margin: 0),
                                          if(widget.irrigationLine[i]['visible'])
                                            if(widget.irrigationLine[i]['injectorVisible'] != null)
                                              Padding(
                                                padding: const EdgeInsets.only(left:  20),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    IconButton(
                                                        onPressed: (){
                                                          setState(() {
                                                            widget.irrigationLine[i]['injectorVisible'] = !widget.irrigationLine[i]['injectorVisible'];
                                                          });
                                                        },
                                                        icon: Icon(widget.irrigationLine[i]['injectorVisible'] ? Icons.remove_circle : Icons.add_circle_outlined,color: widget.irrigationLine[i]['injectorVisible'] ? Colors.green : Colors.blue,)
                                                    ),
                                                    const Text('Channel',style: TextStyle(color: Colors.black,fontSize: 10,fontWeight: FontWeight.normal),overflow: TextOverflow.ellipsis,),
                                                  ],
                                                ),
                                              ),
                                          if(widget.irrigationLine[i]['injectorVisible'] != null)
                                            Column(
                                              children: [
                                                if(widget.irrigationLine[i]['visible'])
                                                  if(widget.irrigationLine[i]['injectorVisible'])
                                                    for(var channel in widget.irrigationLine[i]['injector'])
                                                      Column(
                                                        children: [
                                                          objectContainer(data: '${widget.names['${channel['sNo']}']['name']}',margin: 15),
                                                          if(channel['dosingMeter'].isNotEmpty)
                                                            objectContainer(data: '${widget.names['${channel['dosingMeter']['sNo']}']['name']}',subCategory: true,margin: 20),
                                                          if(channel['levelSensor'].isNotEmpty)
                                                            objectContainer(data: '${widget.names['${channel['levelSensor']['sNo']}']['name']}',subCategory: true,margin: 20),
                                                        ],
                                                      ),
                                                if(widget.irrigationLine[i]['visible'])
                                                  Padding(
                                                    padding: const EdgeInsets.only(left:  20),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        IconButton(
                                                            onPressed: (){
                                                              setState(() {
                                                                widget.irrigationLine[i]['boosterVisible'] = !widget.irrigationLine[i]['boosterVisible'];
                                                              });
                                                            },
                                                            icon: Icon(widget.irrigationLine[i]['boosterVisible'] ? Icons.remove_circle : Icons.add_circle_outlined,color: widget.irrigationLine[i]['boosterVisible'] ? Colors.green : Colors.blue,)
                                                        ),
                                                        Text('Booster',style: TextStyle(color: Colors.black,fontSize: 10,fontWeight: FontWeight.normal),overflow: TextOverflow.ellipsis,),
                                                      ],
                                                    ),
                                                  ),
                                                if(widget.irrigationLine[i]['visible'])
                                                  if(widget.irrigationLine[i]['boosterVisible'])
                                                    for(var booster in widget.irrigationLine[i]['boosterConnection'])
                                                      objectContainer(data: '${widget.names['${booster['sNo']}']['name']}',margin: 15),
                                                if(widget.irrigationLine[i]['visible'])
                                                  Padding(
                                                    padding: const EdgeInsets.only(left:  20),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        IconButton(
                                                            onPressed: (){
                                                              setState(() {
                                                                widget.irrigationLine[i]['phVisible'] = !widget.irrigationLine[i]['phVisible'];
                                                              });
                                                            },
                                                            icon: Icon(widget.irrigationLine[i]['phVisible'] ? Icons.remove_circle : Icons.add_circle_outlined,color: widget.irrigationLine[i]['phVisible'] ? Colors.green : Colors.blue,)
                                                        ),
                                                        Text('PH Sensor',style: TextStyle(color: Colors.black,fontSize: 10,fontWeight: FontWeight.normal),overflow: TextOverflow.ellipsis,),
                                                      ],
                                                    ),
                                                  ),
                                                if(widget.irrigationLine[i]['visible'])
                                                  if(widget.irrigationLine[i]['phVisible'])
                                                    for(var ph in widget.irrigationLine[i]['phConnection'])
                                                      objectContainer(data: '${widget.names['${ph['sNo']}']['name']}',margin: 15),
                                                if(widget.irrigationLine[i]['visible'])
                                                  Padding(
                                                    padding: const EdgeInsets.only(left:  20),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        IconButton(
                                                            onPressed: (){
                                                              setState(() {
                                                                widget.irrigationLine[i]['ecVisible'] = !widget.irrigationLine[i]['ecVisible'];
                                                              });
                                                            },
                                                            icon: Icon(widget.irrigationLine[i]['ecVisible'] ? Icons.remove_circle : Icons.add_circle_outlined,color: widget.irrigationLine[i]['ecVisible'] ? Colors.green : Colors.blue,)
                                                        ),
                                                        Text('EC Sensor',style: TextStyle(color: Colors.black,fontSize: 10,fontWeight: FontWeight.normal),overflow: TextOverflow.ellipsis,),
                                                      ],
                                                    ),
                                                  ),
                                                if(widget.irrigationLine[i]['visible'])
                                                  if(widget.irrigationLine[i]['ecVisible'])
                                                    for(var ec in widget.irrigationLine[i]['ecConnection'])
                                                      objectContainer(data: '${widget.names['${ec['sNo']}']['name']}',margin: 15)
                                              ],
                                            ),

                                          //Todo : applying first filtration
                                          if(widget.irrigationLine[i]['filterVisible'] != null)
                                            Column(
                                              children: [
                                                for(var key in ['lfPressureSwitch','lfPressureIn','lfPressureOut','diffPressureSensor'])
                                                  if(widget.irrigationLine[i]['visible'])
                                                    if(widget.irrigationLine[i][key] != null && widget.irrigationLine[i][key].isNotEmpty)
                                                      objectContainer(data: '${widget.names['${widget.irrigationLine[i][key]['sNo']}']['name']}',margin: 0),

                                                if(widget.irrigationLine[i]['visible'])
                                                  if(widget.irrigationLine[i]['filterConnection'] != null)
                                                    Padding(
                                                      padding: const EdgeInsets.only(left:  20),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          IconButton(
                                                              onPressed: (){
                                                                setState(() {
                                                                  widget.irrigationLine[i]['filterVisible'] = !widget.irrigationLine[i]['filterVisible'];
                                                                });
                                                              },
                                                              icon: Icon(widget.irrigationLine[i]['filterVisible'] ? Icons.remove_circle : Icons.add_circle_outlined,color: widget.irrigationLine[i]['filterVisible'] ? Colors.green : Colors.blue,)
                                                          ),
                                                          const Text('Filter',style: TextStyle(color: Colors.black,fontSize: 10,fontWeight: FontWeight.normal),overflow: TextOverflow.ellipsis,),
                                                        ],
                                                      ),
                                                    ),
                                                if(widget.irrigationLine[i]['visible'])
                                                  if(widget.irrigationLine[i]['filterVisible'])
                                                    if(widget.irrigationLine[i]['filterConnection'] != null)
                                                      for(var channel in widget.irrigationLine[i]['filterConnection'])
                                                        objectContainer(data: '${widget.names['${channel['sNo']}']['name']}',margin: 15),
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
                                      for(var i = 0;i < widget.irrigationLine.length;i++)
                                        Container(
                                          margin: const EdgeInsets.only(bottom: 1),
                                          decoration: const BoxDecoration(
                                              color: Colors.white
                                          ),
                                          width: 150*7,
                                          child: Column(
                                            children: [
                                              const SizedBox(height: 40,),
                                              //Todo applying second lineData const SizedBox(height: 40,),
                                              if(widget.irrigationLine[i]['visible'])
                                                for(var object in ['valveConnection-valveVisible-Valve','main_valveConnection-mainValveVisible-Main Valve','moistureSensorConnection-moistureVisible-Moisture Sensor','levelSensorConnection-levelVisible-Level Sensor','foggerConnection-foggerVisible-Fogger','fanConnection-fanVisible-Fan'])
                                                  if(widget.irrigationLine[i][object.split('-')[0]].isNotEmpty)
                                                    if(widget.irrigationLine[i][object.split('-')[1]])
                                                      Column(
                                                        children: [
                                                          const SizedBox(height: 40,),
                                                          for(var obj in widget.irrigationLine[i][object.split('-')[0]])
                                                            rowWidget(nameData: widget.names, objectData: obj, referenceList: widget.referenceList),
                                                        ],
                                                      )
                                                    else
                                                      const SizedBox(height: 40,),
                                              if(widget.irrigationLine[i]['visible'])
                                                for(var object in ['water_meter','pressureIn','pressureOut'])
                                                  if(widget.irrigationLine[i][object].isNotEmpty)
                                                    rowWidget(nameData: widget.names, objectData: widget.irrigationLine[i][object], referenceList: widget.referenceList),



                                              //Todo : applying second fertilizer
                                              if(widget.irrigationLine[i]['visible'])
                                                if(widget.irrigationLine[i]?['pressureSwitch'] != null)
                                                  if(widget.irrigationLine[i]?['pressureSwitch'].isNotEmpty)
                                                    rowWidget(nameData: widget.names, objectData: widget.irrigationLine[i]['pressureSwitch'], referenceList: widget.referenceList),
                                              if(widget.irrigationLine[i]['injectorVisible'] != null)
                                                if(widget.irrigationLine[i]['visible'])
                                                  const SizedBox(height: 40,),
                                              if(widget.irrigationLine[i]['visible'])
                                                if(widget.irrigationLine[i]['injectorVisible'] != null)
                                                  if(widget.irrigationLine[i]['injectorVisible'])
                                                    for(var channel in widget.irrigationLine[i]['injector'])
                                                      Column(
                                                      children: [
                                                        rowWidget(nameData: widget.names, objectData: channel, referenceList: widget.referenceList),
                                                        if(channel['dosingMeter'].isNotEmpty)
                                                          rowWidget(nameData: widget.names, objectData: channel['dosingMeter'], referenceList: widget.referenceList,subCategory : true),
                                                        if(channel['levelSensor'].isNotEmpty)
                                                          rowWidget(nameData: widget.names, objectData: channel['levelSensor'], referenceList: widget.referenceList,subCategory : true),
                                                      ],
                                                    ),
                                              if(widget.irrigationLine[i]['injectorVisible'] != null)
                                                Column(
                                                  children: [
                                                    if(widget.irrigationLine[i]['visible'])
                                                      const SizedBox(height: 40,),
                                                    if(widget.irrigationLine[i]['visible'])
                                                      if(widget.irrigationLine[i]['boosterVisible'])
                                                        for(var booster in widget.irrigationLine[i]['boosterConnection'])
                                                          rowWidget(nameData: widget.names, objectData: booster, referenceList: widget.referenceList),
                                                    if(widget.irrigationLine[i]['visible'])
                                                      const SizedBox(height: 40,),
                                                    if(widget.irrigationLine[i]['visible'])
                                                      if(widget.irrigationLine[i]['phVisible'])
                                                        for(var ph in widget.irrigationLine[i]['phConnection'])
                                                          rowWidget(nameData: widget.names, objectData: ph, referenceList: widget.referenceList),
                                                    if(widget.irrigationLine[i]['visible'])
                                                      const SizedBox(height: 40,),
                                                    if(widget.irrigationLine[i]['visible'])
                                                      if(widget.irrigationLine[i]['ecVisible'])
                                                        for(var ec in widget.irrigationLine[i]['ecConnection'])
                                                          rowWidget(nameData: widget.names, objectData: ec, referenceList: widget.referenceList)
                                                  ],
                                                ),

                                              //Todo : applying second filtration
                                              if(widget.irrigationLine[i]['filterConnection'] != null)
                                                Column(
                                                  children: [
                                                    for(var key in ['lfPressureSwitch','lfPressureIn','lfPressureOut','diffPressureSensor'])
                                                      if(widget.irrigationLine[i]['visible'])
                                                        if(widget.irrigationLine[i][key].isNotEmpty)
                                                          rowWidget(nameData: widget.names, objectData: widget.irrigationLine[i][key], referenceList: widget.referenceList),

                                                    if(widget.irrigationLine[i]['visible'])
                                                      const SizedBox(height: 40,),
                                                    if(widget.irrigationLine[i]['visible'])
                                                      if(widget.irrigationLine[i]['filterVisible'])
                                                        for(var filter in widget.irrigationLine[i]['filterConnection'])
                                                          rowWidget(nameData: widget.names, objectData: filter, referenceList: widget.referenceList),
                                                  ],
                                                ),






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
