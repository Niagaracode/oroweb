import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:oro_irrigation_new/Screens/Customer/ConfigDashboard/pumpView.dart';


class CentralDosingView extends StatefulWidget {
  final dynamic centralDosing;
  final dynamic referenceList;
  Map<dynamic,dynamic> names;
  CentralDosingView({super.key,required this.centralDosing,required this.referenceList,required this.names});

  @override
  State<CentralDosingView> createState() => _CentralDosingViewState();
}

class _CentralDosingViewState extends State<CentralDosingView> {
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
                                  for(var i = 0;i < widget.centralDosing.length;i++)
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
                                                      widget.centralDosing[i]['visible'] = !widget.centralDosing[i]['visible'];
                                                    });
                                                  },
                                                  icon: Icon(widget.centralDosing[i]['visible'] ? Icons.remove_circle : Icons.add_circle_outlined,color: widget.centralDosing[i]['visible'] ? Colors.green : Colors.blue,)
                                              ),
                                              Text('${widget.names['${widget.centralDosing[i]['sNo']}']?['name']}',style: const TextStyle(color: Colors.black,fontSize: 10,fontWeight: FontWeight.normal),overflow: TextOverflow.ellipsis,),
                                            ],
                                          ),
                                          if(widget.centralDosing[i]['visible'])
                                            if(widget.centralDosing[i]['pressureSwitch'].isNotEmpty)
                                              objectContainer(data: '${widget.names['${widget.centralDosing[i]['pressureSwitch']['sNo']}']['name']}',margin: 0),
                                          if(widget.centralDosing[i]['visible'])
                                            Padding(
                                              padding: const EdgeInsets.only(left:  20),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  IconButton(
                                                      onPressed: (){
                                                        setState(() {
                                                          widget.centralDosing[i]['injectorVisible'] = !widget.centralDosing[i]['injectorVisible'];
                                                        });
                                                      },
                                                      icon: Icon(widget.centralDosing[i]['injectorVisible'] ? Icons.remove_circle : Icons.add_circle_outlined,color: widget.centralDosing[i]['injectorVisible'] ? Colors.green : Colors.blue,)
                                                  ),
                                                  const Text('Channel',style: TextStyle(color: Colors.black,fontSize: 10,fontWeight: FontWeight.normal),overflow: TextOverflow.ellipsis,),
                                                ],
                                              ),
                                            ),
                                          if(widget.centralDosing[i]['visible'])
                                            if(widget.centralDosing[i]['injectorVisible'])
                                              for(var channel in widget.centralDosing[i]['injector'])
                                                Column(
                                                  children: [
                                                    objectContainer(data: '${widget.names['${channel['sNo']}']['name']}',margin: 15),
                                                    if(channel['dosingMeter'].isNotEmpty)
                                                      objectContainer(data: '${widget.names['${channel['dosingMeter']['sNo']}']['name']}',subCategory: true,margin: 20),
                                                    if(channel['levelSensor'].isNotEmpty)
                                                      objectContainer(data: '${widget.names['${channel['levelSensor']['sNo']}']['name']}',subCategory: true,margin: 20),
                                                  ],
                                                ),
                                          if(widget.centralDosing[i]['visible'])
                                            Padding(
                                              padding: const EdgeInsets.only(left:  20),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  IconButton(
                                                      onPressed: (){
                                                        setState(() {
                                                          widget.centralDosing[i]['boosterVisible'] = !widget.centralDosing[i]['boosterVisible'];
                                                        });
                                                      },
                                                      icon: Icon(widget.centralDosing[i]['boosterVisible'] ? Icons.remove_circle : Icons.add_circle_outlined,color: widget.centralDosing[i]['boosterVisible'] ? Colors.green : Colors.blue,)
                                                  ),
                                                  const Text('Booster',style: TextStyle(color: Colors.black,fontSize: 10,fontWeight: FontWeight.normal),overflow: TextOverflow.ellipsis,),
                                                ],
                                              ),
                                            ),
                                          if(widget.centralDosing[i]['visible'])
                                            if(widget.centralDosing[i]['boosterVisible'])
                                              for(var booster in widget.centralDosing[i]['boosterConnection'])
                                                objectContainer(data: '${widget.names['${booster['sNo']}']['name']}',margin: 15),
                                          if(widget.centralDosing[i]['visible'])
                                            Padding(
                                              padding: const EdgeInsets.only(left:  20),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  IconButton(
                                                      onPressed: (){
                                                        setState(() {
                                                          widget.centralDosing[i]['phVisible'] = !widget.centralDosing[i]['phVisible'];
                                                        });
                                                      },
                                                      icon: Icon(widget.centralDosing[i]['phVisible'] ? Icons.remove_circle : Icons.add_circle_outlined,color: widget.centralDosing[i]['phVisible'] ? Colors.green : Colors.blue,)
                                                  ),
                                                  const Text('PH Sensor',style: TextStyle(color: Colors.black,fontSize: 10,fontWeight: FontWeight.normal),overflow: TextOverflow.ellipsis,),
                                                ],
                                              ),
                                            ),
                                          if(widget.centralDosing[i]['visible'])
                                            if(widget.centralDosing[i]['phVisible'])
                                              for(var ph in widget.centralDosing[i]['phConnection'])
                                                objectContainer(data: '${widget.names['${ph['sNo']}']['name']}',margin: 15),
                                          if(widget.centralDosing[i]['visible'])
                                            Padding(
                                              padding: const EdgeInsets.only(left:  20),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  IconButton(
                                                      onPressed: (){
                                                        setState(() {
                                                          widget.centralDosing[i]['ecVisible'] = !widget.centralDosing[i]['ecVisible'];
                                                        });
                                                      },
                                                      icon: Icon(widget.centralDosing[i]['ecVisible'] ? Icons.remove_circle : Icons.add_circle_outlined,color: widget.centralDosing[i]['ecVisible'] ? Colors.green : Colors.blue,)
                                                  ),
                                                  const Text('EC Sensor',style: TextStyle(color: Colors.black,fontSize: 10,fontWeight: FontWeight.normal),overflow: TextOverflow.ellipsis,),
                                                ],
                                              ),
                                            ),
                                          if(widget.centralDosing[i]['visible'])
                                            if(widget.centralDosing[i]['ecVisible'])
                                              for(var ec in widget.centralDosing[i]['ecConnection'])
                                                objectContainer(data: '${widget.names['${ec['sNo']}']['name']}',margin: 15)


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
                                      for(var i = 0;i < widget.centralDosing.length;i++)
                                        Container(
                                          margin: const EdgeInsets.only(bottom: 1),
                                          decoration: const BoxDecoration(
                                              color: Colors.white
                                          ),
                                          width: 150*7,
                                          child: Column(
                                            children: [
                                              const SizedBox(height: 40,),

                                              if(widget.centralDosing[i]['visible'])
                                                if(widget.centralDosing[i]['pressureSwitch'].isNotEmpty)
                                                  rowWidget(nameData: widget.names, objectData: widget.centralDosing[i]['pressureSwitch'], referenceList: widget.referenceList),
                                              if(widget.centralDosing[i]['visible'])
                                                const SizedBox(height: 40,),
                                              if(widget.centralDosing[i]['visible'])
                                                if(widget.centralDosing[i]['injectorVisible'])
                                                  for(var channel in widget.centralDosing[i]['injector'])
                                                    Column(
                                                      children: [
                                                        rowWidget(nameData: widget.names, objectData: channel, referenceList: widget.referenceList),
                                                        if(channel['dosingMeter'].isNotEmpty)
                                                          rowWidget(nameData: widget.names, objectData: channel['dosingMeter'], referenceList: widget.referenceList,subCategory : true),
                                                        if(channel['levelSensor'].isNotEmpty)
                                                          rowWidget(nameData: widget.names, objectData: channel['levelSensor'], referenceList: widget.referenceList,subCategory : true),
                                                      ],
                                                    ),
                                              if(widget.centralDosing[i]['visible'])
                                                const SizedBox(height: 40,),
                                              if(widget.centralDosing[i]['visible'])
                                                if(widget.centralDosing[i]['boosterVisible'])
                                                  for(var booster in widget.centralDosing[i]['boosterConnection'])
                                                    rowWidget(nameData: widget.names, objectData: booster, referenceList: widget.referenceList),
                                              if(widget.centralDosing[i]['visible'])
                                                const SizedBox(height: 40,),
                                              if(widget.centralDosing[i]['visible'])
                                                if(widget.centralDosing[i]['phVisible'])
                                                  for(var ph in widget.centralDosing[i]['phConnection'])
                                                    rowWidget(nameData: widget.names, objectData: ph, referenceList: widget.referenceList),
                                              if(widget.centralDosing[i]['visible'])
                                                const SizedBox(height: 40,),
                                              if(widget.centralDosing[i]['visible'])
                                                if(widget.centralDosing[i]['ecVisible'])
                                                  for(var ec in widget.centralDosing[i]['ecConnection'])
                                                    rowWidget(nameData: widget.names, objectData: ec, referenceList: widget.referenceList)

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


