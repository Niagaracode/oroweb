import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:oro_irrigation_new/Screens/Customer/ConfigDashboard/pumpView.dart';


class CentralFiltrationView extends StatefulWidget {
  final dynamic centralFiltration;
  final dynamic referenceList;
  Map<dynamic,dynamic> names;
  CentralFiltrationView({super.key,required this.centralFiltration,required this.referenceList,required this.names});

  @override
  State<CentralFiltrationView> createState() => _CentralFiltrationViewState();
}

class _CentralFiltrationViewState extends State<CentralFiltrationView> {
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
                                  for(var i = 0;i < widget.centralFiltration.length;i++)
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
                                                      widget.centralFiltration[i]['visible'] = !widget.centralFiltration[i]['visible'];
                                                    });
                                                  },
                                                  icon: Icon(widget.centralFiltration[i]['visible'] ? Icons.remove_circle : Icons.add_circle_outlined,color: widget.centralFiltration[i]['visible'] ? Colors.green : Colors.blue,)
                                              ),
                                              Text('${widget.names['${widget.centralFiltration[i]['sNo']}']?['name']}',style: const TextStyle(color: Colors.black,fontSize: 10,fontWeight: FontWeight.normal),overflow: TextOverflow.ellipsis,),
                                            ],
                                          ),
                                          for(var key in ['pressureSwitch','pressureIn','pressureOut','diffPressureSensor'])
                                            if(widget.centralFiltration[i]['visible'])
                                              if(widget.centralFiltration[i][key].isNotEmpty)
                                                objectContainer(data: '${widget.names['${widget.centralFiltration[i][key]['sNo']}']['name']}',margin: 0),

                                          if(widget.centralFiltration[i]['visible'])
                                            Padding(
                                              padding: const EdgeInsets.only(left:  20),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  IconButton(
                                                      onPressed: (){
                                                        setState(() {
                                                          widget.centralFiltration[i]['filterVisible'] = !widget.centralFiltration[i]['filterVisible'];
                                                        });
                                                      },
                                                      icon: Icon(widget.centralFiltration[i]['filterVisible'] ? Icons.remove_circle : Icons.add_circle_outlined,color: widget.centralFiltration[i]['filterVisible'] ? Colors.green : Colors.blue,)
                                                  ),
                                                  const Text('Filter',style: TextStyle(color: Colors.black,fontSize: 10,fontWeight: FontWeight.normal),overflow: TextOverflow.ellipsis,),
                                                ],
                                              ),
                                            ),
                                          if(widget.centralFiltration[i]['visible'])
                                            if(widget.centralFiltration[i]['filterVisible'])
                                              for(var channel in widget.centralFiltration[i]['filterConnection'])
                                                objectContainer(data: '${widget.names['${channel['sNo']}']['name']}',margin: 15),


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
                                      for(var i = 0;i < widget.centralFiltration.length;i++)
                                        Container(
                                          margin: const EdgeInsets.only(bottom: 1),
                                          decoration: const BoxDecoration(
                                              color: Colors.white
                                          ),
                                          width: 150*7,
                                          child: Column(
                                            children: [
                                              const SizedBox(height: 40,),
                                              for(var key in ['pressureSwitch','pressureIn','pressureOut','diffPressureSensor'])
                                                if(widget.centralFiltration[i]['visible'])
                                                  if(widget.centralFiltration[i][key].isNotEmpty)
                                                    rowWidget(nameData: widget.names, objectData: widget.centralFiltration[i][key], referenceList: widget.referenceList),

                                              if(widget.centralFiltration[i]['visible'])
                                                const SizedBox(height: 40,),
                                              if(widget.centralFiltration[i]['visible'])
                                                if(widget.centralFiltration[i]['filterVisible'])
                                                  for(var filter in widget.centralFiltration[i]['filterConnection'])
                                                    rowWidget(nameData: widget.names, objectData: filter, referenceList: widget.referenceList),

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
