import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:oro_irrigation_new/constants/theme.dart';
import '../../Models/dd_config.dart';
import '../../constants/MQTTManager.dart';
import '../../constants/http_service.dart';

class DealerDefinitionInConfig extends StatefulWidget {
  const DealerDefinitionInConfig(
      {Key? key,
        required this.userId,
        required this.customerId,
        required this.controllerId,
        required this.imeiNo})
      : super(key: key);
  final int userId, customerId, controllerId;
  final String imeiNo;

  @override
  State<DealerDefinitionInConfig> createState() =>
      DealerDefinitionInConfigState();
}

class DealerDefinitionInConfigState extends State<DealerDefinitionInConfig> {
  DataModelDDConfig data =
  DataModelDDConfig(categories: [], dealerDefinition: {});
  bool visibleLoading = false;

  @override
  Widget build(BuildContext context) {
    // return wideLayout(data, context);
    if (MediaQuery.sizeOf(context).width <= 800) {
      return MyContainerWithTabs(
        data: data,
        userID: widget.userId,
        customerID: widget.customerId,
        controllerId: widget.controllerId,
      );
    } else {
      return wideLayout(data, context);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    indicatorViewShow();
    await Future.delayed(const Duration(milliseconds: 500));
    Map<String, Object> body = {
      "userId": widget.customerId,
      "controllerId": widget.controllerId
    };

    final response =
    await HttpService().postRequest("getUserDealerDefinition", body);
    final jsonData = json.decode(response.body);
    try {
      setState(() {
        data = DataModelDDConfig.fromJson(jsonData);
        indicatorViewHide();
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Widget wideLayout(DataModelDDConfig data, BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final ScrollController _scrollController = ScrollController();
    return visibleLoading
        ? Center(
      child: Visibility(
        visible: visibleLoading,
        child: Container(
          padding: EdgeInsets.fromLTRB(mediaQuery.size.width / 2 - 115, 0,
              mediaQuery.size.width / 2 - 115, 0),
          child: const LoadingIndicator(
            indicatorType: Indicator.ballPulse,
          ),
        ),
      ),
    )
        : Container(
      color: Colors.white,
      child: Column(
        children: [
          Expanded(
            child:  GestureDetector(
              onHorizontalDragUpdate: (details) {
                _scrollController.jumpTo(_scrollController.offset - details.primaryDelta! / 2);
              },
              child: Scrollbar(
                controller: _scrollController,
                trackVisibility: true,
                thumbVisibility: true,

                child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: data.categories.length,
                  itemBuilder: (context, index) {
                    final category = data.categories[index];
                    return buildCategoryContainer(category, data);
                  },
                ),
              ),
            ),
          ),
          Container(
            height: 50,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () async {
                    String strPayload = Mqttdata(data);
                    // print('strPayload:$strPayload');
                    String payLoadFinal = jsonEncode({
                      "500": [
                        {"501": strPayload},
                      ]
                    });
                    MQTTManager().publish(
                        payLoadFinal, 'AppToFirmware/${widget.imeiNo}');

                    Map<String, dynamic> dealerDefinitionJson = {};
                    data.dealerDefinition.forEach((key, value) {
                      dealerDefinitionJson[key] = value.map((item) => item.toJson()).toList();
                    });

                    Map<String, Object> body = {
                      "userId": widget.customerId,
                      "controllerId": widget.controllerId,
                      "dealerDefinition": dealerDefinitionJson,
                      "hardware": jsonDecode(payLoadFinal),
                      "createUser": widget.userId
                    };
                    final response = await HttpService()
                        .postRequest("createUserDealerDefinition", body);
                    if (response.statusCode == 200) {
                      var data = jsonDecode(response.body);
                      if (data["code"] == 200) {
                        _showSnackBar(data["message"]);
                      } else {
                        _showSnackBar(data["message"]);
                      }
                    }
                  },
                  label: const Text('Save'),
                  icon: const Icon(
                    Icons.save_as_outlined,
                  ),style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(
                  primaryColorDark,),foregroundColor: MaterialStateProperty.all<Color>(Colors.white)
                ),
                ),
                const SizedBox(
                  width: 20,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  String Mqttdata(DataModelDDConfig dmConfig) {
    String mqttFormatData = '';
    for (var i = 0; i < dmConfig.categories.length; i++) {
      int k = dmConfig.categories[i].categoryId;
      for (var j = 0; j < dmConfig.dealerDefinition['$k']!.length; j++) {
        mqttFormatData +=
        '${dmConfig.dealerDefinition['$k']![j].dealerDefinitionId},$k,${dmConfig.dealerDefinition['$k']![j].value.isNotEmpty ? dmConfig.dealerDefinition['$k']![j].value : '0'};';
      }
    }
    return mqttFormatData;
  }

  Widget buildCategoryContainer(Category category, DataModelDDConfig data) {
    if (data.categories.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Container(
      width: 350.0,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      margin: const EdgeInsets.only(left: 5, right: 5),
      child: Column(
        children: [
          buildFixedRow(category.categoryName),
          Expanded(
            child: buildDealerDefinitionList(category, data),
          ),
        ],
      ),
    );
  }

  Widget buildFixedRow(String categoryName) {
    return Container(
      height: 45.0,
      color: myTheme.primaryColor,
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Center(
            child:
            Text(categoryName, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget buildDealerDefinitionList(Category category, DataModelDDConfig data) {
    return ListView.builder(
      itemCount: data.dealerDefinition['${category.categoryId}']?.length ?? 0,
      itemBuilder: (context, index) {
        final definition =
        data.dealerDefinition['${category.categoryId}']?[index];
        return buildDealerDefinitionItem(definition, category);
      },
    );
  }

  Widget buildDealerDefinitionItem(
      DealerDefinition? definition, Category category) {
    final dropdownlist =
    StringToList().stringtolist('${definition?.dropdownValues}', ',');
    int iconcode = int.parse(definition?.iconCodePoint ?? "0xe123");
    String iconfontfamily = definition?.iconFontFamily ?? "MaterialIcons";

    if (definition?.widgetTypeId == 3) {
      return buildDropdownItem(
          definition, dropdownlist, iconcode, iconfontfamily);
    } else if (definition?.widgetTypeId == 1) {
      return buildTextFieldItem(definition, iconcode, iconfontfamily);
    } else {
      return buildSwitchItem(definition, iconcode, iconfontfamily);
    }
  }

  Widget buildDropdownItem(DealerDefinition? definition,
      List<String> dropdownlist, int iconcode, String iconfontfamily) {
    return Column(
      children: [
        ListTile(
          // leading: Icon(IconData(iconcode, fontFamily: iconfontfamily)),
          title: Text(
            '${definition?.parameter}',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
          ),
          subtitle: Text('${definition?.description}',
              style:
              const TextStyle(fontSize: 11, fontWeight: FontWeight.normal)),
          trailing: DropdownButton(
            items: dropdownlist.map((String items) {
              return DropdownMenuItem(
                value: items,
                child: Container(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(items)),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                definition?.value = value!;
              });
            },
            value: definition?.value == ''
                ? dropdownlist[0].toString()
                : dropdownlist.contains(definition?.value) ? definition?.value : dropdownlist[0].toString(),
          ),
        ),
      ],
    );
  }

  Widget buildTextFieldItem(
      DealerDefinition? definition, int iconcode, String iconfontfamily) {
    return Column(
      children: [
        ListTile(
          //leading: Icon(IconData(iconcode, fontFamily: iconfontfamily)),
          title: Text(
            '${definition?.parameter}',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
          ),
          subtitle: Text('${definition?.description}',
              style:
              const TextStyle(fontSize: 11, fontWeight: FontWeight.normal)),
          trailing: SizedBox(
            width: 50,
            child: CustomTextField(
              onChanged: (text) {
                setState(() {
                  definition?.value = text;
                });
              },
              initialValue: definition?.value ?? '0',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Warranty is required';
                } else {
                  setState(() {
                    definition?.value = value;
                  });
                }
                return null;
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSwitchItem(
      DealerDefinition? definition, int iconcode, String iconfontfamily) {

    int? rtcindex = data.dealerDefinition["1"]?.indexWhere((element) => element.dealerDefinitionId == 62);
    int? rtcmaxindex = data.dealerDefinition["1"]?.indexWhere((element) => element.dealerDefinitionId == 63);
    int? stopmethod = data.dealerDefinition["1"]?.indexWhere((element) => element.dealerDefinitionId == 64);

    if (definition?.dealerDefinitionId == 62 ||
        definition?.dealerDefinitionId == 63 ||
        definition?.dealerDefinitionId == 64) {
      if (definition?.dealerDefinitionId == 62){
        return Column(
          children: [
            ListTile(
              title: Text(
                '${definition?.parameter}',
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.normal),
              ),
              subtitle: Text('${definition?.description}',
                  style: const TextStyle(
                      fontSize: 11, fontWeight: FontWeight.normal)),
              trailing: MySwitch(
                value: definition?.value == '1',
                onChanged: ((value) {
                  setState(() {
                    definition?.value = !value ? '0' : '1';
                    if (value) {
                      data.dealerDefinition["1"]![rtcmaxindex!].value = '0';
                      data.dealerDefinition["1"]![stopmethod!].value = '0';
                    }
                  });
                }),
              ),
            ),
          ],
        );
      }
      else if (definition?.dealerDefinitionId == 63){
        return Column(
          children: [
            ListTile(
              title: Text(
                '${definition?.parameter}',
                style:
                const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
              ),
              subtitle: Text('${definition?.description}',
                  style: const TextStyle(
                      fontSize: 11, fontWeight: FontWeight.normal)),
              trailing: MySwitch(
                value: definition?.value == '1',
                onChanged: ((value) {
                  setState(() {
                    definition?.value = !value ? '0' : '1';
                    if (value) {
                      data.dealerDefinition["1"]![rtcindex!].value = '0';
                      data.dealerDefinition["1"]![stopmethod!].value = '0';
                    }
                  });
                }),
              ),
            ),
          ],
        );
      }
      else{
        return Column(
          children: [
            ListTile(
              title: Text(
                '${definition?.parameter}',
                style:
                const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
              ),
              subtitle: Text('${definition?.description}',
                  style: const TextStyle(
                      fontSize: 11, fontWeight: FontWeight.normal)),
              trailing: MySwitch(
                value: definition?.value == '1',
                onChanged: ((value) {
                  setState(() {
                    definition?.value = !value ? '0' : '1';
                    if (value) {
                      data.dealerDefinition["1"]![rtcindex!].value = '0';
                      data.dealerDefinition["1"]![rtcmaxindex!].value = '0';
                    }
                  });
                }),
              ),
            ),
          ],
        );
      }
    }else {
      return Column(
        children: [
          ListTile(
            //leading: Icon(IconData(iconcode, fontFamily: iconfontfamily)),

            title: Text(
              '${definition?.parameter}',
              style:
              const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
            subtitle: Text('${definition?.description}',
                style: const TextStyle(
                    fontSize: 11, fontWeight: FontWeight.normal)),
            trailing: MySwitch(
              value: definition?.value == '1',
              onChanged: ((value) {
                setState(() {
                  definition?.value = !value ? '0' : '1';
                });
              }),
            ),
          ),
        ],
      );
    }
  }

  void indicatorViewShow() {
    setState(() {
      visibleLoading = true;
    });
  }

  void indicatorViewHide() {
    setState(() {
      visibleLoading = false;
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

class MyContainerWithTabs extends StatefulWidget {
  const MyContainerWithTabs(
      {super.key,
        required this.data,
        required this.userID,
        required this.customerID,
        required this.controllerId});
  final DataModelDDConfig data;
  final int userID, customerID, controllerId;

  @override
  State<MyContainerWithTabs> createState() => _MyContainerWithTabsState();
}

class _MyContainerWithTabsState extends State<MyContainerWithTabs> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey.shade50,
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  DefaultTabController(
                    length: widget.data.categories.length, // Number of tabs
                    child: Column(
                      children: [
                        TabBar(
                          indicatorColor:
                          const Color.fromARGB(255, 175, 73, 73),
                          isScrollable: true,
                          tabs: [
                            for (var i = 0;
                            i < widget.data.categories.length;
                            i++)
                              Tab(
                                text: widget.data.categories[i].categoryName,
                              ),
                          ],
                          onTap: (value) {},
                        ),
                        const SizedBox(height: 10.0),
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height - 310,
                          child: TabBarView(
                            children: [
                              for (var i = 0;
                              i < widget.data.categories.length;
                              i++)
                                widget.data.categories[i].categoryName.isEmpty
                                    ? Container()
                                    : buildTab(widget.data.dealerDefinition[
                                '${widget.data.categories[i].categoryId}']),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 60,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () async {
                    String strPayload = Mqttdata(widget.data);
                     String payLoadFinal = jsonEncode({
                      "500": [
                        {"501": strPayload},
                      ]
                    });
                    final sendData = jsonEncode(widget.data.dealerDefinition);
                    Map<String, Object> body = {
                      "userId": widget.customerID,
                      "controllerId": widget.controllerId,
                      "dealerDefinition": sendData,
                      "hardware": jsonDecode(payLoadFinal),
                      "createUser": widget.userID
                    };
                    final response = await HttpService()
                        .postRequest("createUserDealerDefinition", body);
                    if (response.statusCode == 200) {
                      var data = jsonDecode(response.body);
                       if(data["code"] == 200) {
                        _showSnackBar(data["message"]);
                      } else {
                        _showSnackBar(data["message"]);
                      }
                    }
                  },
                  label: const Text('Save'),
                  icon: const Icon(
                    Icons.save_as_outlined,
                  ),style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(
                  primaryColorDark,),foregroundColor: MaterialStateProperty.all<Color>(Colors.white)
                ),

                ),

                const SizedBox(
                  width: 20,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTab(List<DealerDefinition>? Listofvalue) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: Listofvalue?.length ?? 0,
            itemBuilder: (context, index) {


              if (Listofvalue?[index].widgetTypeId == 3) {
                final dropdownlist = StringToList().stringtolist(
                  '${Listofvalue?[index].dropdownValues}',
                  ',',
                );

                return Column(
                  children: [
                    Container(
                      child: ListTile(
                        title: Text('${Listofvalue?[index].parameter}'),
                        subtitle: Text(
                          'Details: ${Listofvalue?[index].description}',
                          style: const TextStyle(fontSize: 11),
                        ),
                        // leading: Icon(IconData(iconcode, fontFamily: iconfontfamily)),
                        trailing: Container(
                          color: Colors.white,
                          width: 140,
                          child: DropdownButton(
                            items: dropdownlist.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Container(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Text(items)),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                Listofvalue?[index].value = value!;
                              });
                            },
                            value: Listofvalue?[index].value == ''
                                ? dropdownlist[0].toString()
                                : Listofvalue?[index].value,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else if (Listofvalue?[index].widgetTypeId == 1) {

                return Column(
                  children: [
                    Container(
                      child: ListTile(
                        title: Text('${Listofvalue?[index].parameter}'),
                        subtitle: Text(
                          'Details: ${Listofvalue?[index].description}',
                          style: const TextStyle(fontSize: 11),
                        ),
                        //leading: Icon(IconData(iconcode, fontFamily: iconfontfamily)),
                        trailing: SizedBox(
                            width: 50,
                            child: CustomTextField(
                              onChanged: (text) {
                                setState(() {
                                  Listofvalue?[index].value = text;
                                });
                              },
                              initialValue: Listofvalue?[index].value ?? '0',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Warranty is required';
                                } else {
                                  setState(() {
                                    Listofvalue?[index].value = value;
                                  });
                                }
                                return null;
                              },
                            )
                        ),
                      ),
                    ),
                    // const Padding(
                    //   padding: EdgeInsets.only(
                    //     left: 70,
                    //   ),
                    //   child: Divider(
                    //     height: 1.0,
                    //     color: Colors.grey,
                    //   ),
                    // ),
                  ],
                );
              } else {
                return Column(
                  children: [
                    Container(
                      child: ListTile(
                        title: Text('${Listofvalue?[index].parameter}'),
                        subtitle: Text(
                          'Details: ${Listofvalue?[index].description}',
                          style: const TextStyle(fontSize: 11),
                        ),
                        // leading: Icon(IconData(iconcode, fontFamily: iconfontfamily)),
                        trailing: MySwitch(
                          value: Listofvalue?[index].value == '1',
                          onChanged: ((value) {
                            setState(() {
                              Listofvalue?[index].value = !value ? '0' : '1';
                            });
                            // Listofvalue?[index].value = value;
                          }),
                        ),
                      ),
                    ),
                  ],
                );
              }

            },
          ),
        ),
      ],
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

class StringToList {
  List<String> stringtolist(
      String name,
      String split,
      ) {
    var f = name.split(split);
    return f;
  }
}
String Mqttdata(DataModelDDConfig dmConfig) {
  String mqttFormatData = '';
  for (var i = 0; i < dmConfig.categories.length; i++) {
    int k = dmConfig.categories[i].categoryId;
    for (var j = 0; j < dmConfig.dealerDefinition['$k']!.length; j++) {
      mqttFormatData +=
      '${dmConfig.dealerDefinition['$k']![j].dealerDefinitionId},$k,${dmConfig.dealerDefinition['$k']![j].value.isNotEmpty ? dmConfig.dealerDefinition['$k']![j].value : '0'};';
    }
  }
  return mqttFormatData;
}

class MySwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const MySwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  State<MySwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<MySwitch> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onChanged(!widget.value);
      },
      child: Switch(value: widget.value, onChanged: widget.onChanged),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? initialValue;

  final IconData? prefixIcon;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    this.controller,
    this.labelText,
    this.initialValue,
    this.prefixIcon,
    this.obscureText = false,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      onChanged: onChanged,
      initialValue: initialValue,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      ),
      validator: (text) {
        if (text == null || text.isEmpty) {
          return 'Please enter a username.';
        }
        return null;
      },
    );
  }
}