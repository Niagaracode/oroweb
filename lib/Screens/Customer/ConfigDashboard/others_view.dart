import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:oro_irrigation_new/Screens/Customer/ConfigDashboard/pumpView.dart';


class OthersView extends StatefulWidget {
  final dynamic others;
  final dynamic referenceList;
  Map<dynamic,dynamic> names;
  OthersView({super.key,required this.others,required this.referenceList,required this.names});

  @override
  State<OthersView> createState() => _OthersViewState();
}

class _OthersViewState extends State<OthersView> {
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
                                  for(var i = 0;i < widget.others.length;i++)
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
                                                      widget.others[i]['visible'] = !widget.others[i]['visible'];
                                                    });
                                                  },
                                                  icon: Icon(widget.others[i]['visible'] ? Icons.remove_circle : Icons.add_circle_outlined,color: widget.others[i]['visible'] ? Colors.green : Colors.blue,)
                                              ),
                                              Text('${widget.others[i]['name']}',style: const TextStyle(color: Colors.black,fontSize: 10,fontWeight: FontWeight.normal),overflow: TextOverflow.ellipsis,),
                                            ],
                                          ),
                                          if(widget.others[i]['visible'])
                                            for(var object in widget.others[i]['connection'])
                                                objectContainer(data: '${widget.names?['${object['sNo']}']?['name']}',margin: 0),



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
                                      for(var i = 0;i < widget.others.length;i++)
                                        Container(
                                          margin: const EdgeInsets.only(bottom: 1),
                                          decoration: const BoxDecoration(
                                              color: Colors.white
                                          ),
                                          width: 150*7,
                                          child: Column(
                                            children: [
                                                const SizedBox(height: 40,),
                                              if(widget.others[i]['visible'])
                                                for(var object in widget.others[i]['connection'])
                                                  rowWidget(nameData: widget.names, objectData: object, referenceList: widget.referenceList),

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
