import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/interface_type.dart';
import '../../constants/http_service.dart';
import '../../constants/theme.dart';

class AddInterfaceType extends StatefulWidget {
  const AddInterfaceType({Key? key}) : super(key: key);

  @override
  State<AddInterfaceType> createState() => _AddInterfaceTypeState();
}

class _AddInterfaceTypeState extends State<AddInterfaceType> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController interfaceTypeCtl = TextEditingController();
  TextEditingController interfaceDisCtl = TextEditingController();

  List<InterfaceType> interfaceTypeList = <InterfaceType>[];
  bool editInfType = false;
  bool editActive = false;
  int sldInfTypeID = 0;

  @override
  void initState() {
    super.initState();
    getInterfaceTypeListTypeList();
  }

  Future<void> getInterfaceTypeListTypeList() async
  {
    Map<String, Object> body = {};
    final response = await HttpService().postRequest("getInterfaceType", body);
    if (response.statusCode == 200)
    {
      interfaceTypeList.clear();
      var data = jsonDecode(response.body);
      final cntList = data["data"] as List;

      for (int i=0; i < cntList.length; i++) {
        interfaceTypeList.add(InterfaceType.fromJson(cntList[i]));
      }
      setState(() {
        interfaceTypeList;
      });
    }
    else{
      _showSnackBar(response.body);
    }
  }

  @override
  Widget build(BuildContext context)
  {
    final mediaQuery = MediaQuery.of(context);
    //final Color color = Colors.primaries[contactList.length % Colors.primaries.length];
    return Container(
      color:  Colors.blueGrey.shade50,
      child: Row(
        children: [
          Flexible(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.all(10.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                  Container(
                    height: 60,
                    color: Colors.white,
                    child: ListTile(
                      title: Text('Interface Types', style: myTheme.textTheme.titleLarge),
                      subtitle: Text('Interface types with Description', style: myTheme.textTheme.titleSmall),
                      trailing: IconButton(onPressed: ()
                      {
                        setState(() {
                          editInfType = !editInfType;
                          editActive = false;
                        });
                        interfaceTypeCtl.clear();
                        interfaceDisCtl.clear();
                      }, icon: editInfType ? Icon(Icons.done_all, color: myTheme.primaryColor,) : Icon(Icons.edit_note_outlined, color: myTheme.primaryColor,)),
                    ),
                  ),
                  Expanded(
                      child: GridView.builder(
                        itemCount: interfaceTypeList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsetsDirectional.all(5.0),
                            decoration: BoxDecoration(
                              color: interfaceTypeList[index].active=='1'? myTheme.primaryColor.withOpacity(0.2) : Colors.red.shade100,
                              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                            ),
                            child: ListTile(
                              title: Text(interfaceTypeList[index].interface,),
                              subtitle: Text(interfaceTypeList[index].interfaceDescription,),
                              trailing: editInfType ? Wrap(
                                spacing: 12, // space between two icons
                                children: <Widget>[
                                  IconButton(onPressed: ()
                                  {
                                    interfaceTypeCtl.text = interfaceTypeList[index].interface;
                                    interfaceDisCtl.text = interfaceTypeList[index].interfaceDescription;
                                    sldInfTypeID = interfaceTypeList[index].interfaceTypeId;

                                    setState(() {
                                      editActive = true;
                                    });

                                  }, icon: Icon(Icons.edit_outlined, color: myTheme.primaryColor,),),
                                  IconButton(onPressed: () async {
                                    final prefs = await SharedPreferences.getInstance();
                                    String userID = (prefs.getString('userId') ?? "");

                                    Map<String, Object> body = {
                                      'interfaceTypeId': interfaceTypeList[index].interfaceTypeId.toString(),
                                      'modifyUser': userID,
                                    };

                                    final Response response;
                                    if(interfaceTypeList[index].active=='1'){
                                      response = await HttpService().putRequest("inactiveInterfaceType", body);
                                    }else{
                                      response = await HttpService().putRequest("activeInterfaceType", body);
                                    }

                                    if(response.statusCode == 200)
                                    {
                                      var data = jsonDecode(response.body);
                                      if(data["code"]==200)
                                      {
                                        _showSnackBar(data["message"]);
                                        getInterfaceTypeListTypeList();
                                      }
                                      else{
                                        _showSnackBar(data["message"]);
                                      }
                                    }else{
                                      _showSnackBar(response.body);
                                    }

                                  }, icon: interfaceTypeList[index].active=='1'? Icon(Icons.check_circle_outlined, color: Colors.green,):Icon(Icons.unpublished_outlined, color: Colors.red,)),
                                ],
                              ): null,
                            ),
                          );
                        },
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: mediaQuery.size.width > 1200 ? 2 : 1,
                          childAspectRatio: mediaQuery.size.width / 250,
                        ),
                      )),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.all(10.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                  Container(
                    height: 60,
                    color: Colors.white,
                    child: ListTile(
                      title: Text("Add Interface Type", style: myTheme.textTheme.titleLarge),
                      subtitle: Text("Please fill out all details correctly.", style: myTheme.textTheme.titleSmall),
                    ),
                  ),
                  Stack(
                    clipBehavior: Clip.none,
                    children: <Widget>[
                      Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const SizedBox(height: 10,),
                              TextFormField(
                                controller: interfaceTypeCtl,
                                validator: (value){
                                  if(value==null ||value.isEmpty){
                                    return 'Please fill out this field';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                  border: OutlineInputBorder(),
                                  labelText: 'Interface Type',
                                  icon: Icon(Icons.contactless_outlined),
                                ),
                              ),
                              const SizedBox(height: 13,),
                              TextFormField(
                                controller: interfaceDisCtl,
                                validator: (value){
                                  if(value==null ||value.isEmpty){
                                    return 'Please fill out this field';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                  border: OutlineInputBorder(),
                                  labelText: 'Interface Description',
                                  icon: Icon(Icons.content_paste_go),
                                ),
                              ),
                              const SizedBox(height: 20,),
                            ],
                          ),
                        ),
                      ),

                    ],
                  ),
                  Container(
                    height: 60,
                    color: Colors.white,
                    child: ListTile(
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            child: editActive ? const Text('Save'): const Text('Submit'),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();

                                final prefs = await SharedPreferences.getInstance();
                                String userID = (prefs.getString('userId') ?? "");
                                final Response response;

                                if(editActive){
                                  print(sldInfTypeID);
                                  Map<String, Object> body = {
                                    "interfaceTypeId": sldInfTypeID.toString(),
                                    'interface': interfaceTypeCtl.text,
                                    'interfaceDescription': interfaceDisCtl.text,
                                    'modifyUser': userID,
                                  };
                                  response = await HttpService().putRequest("updateInterfaceType", body);
                                }
                                else{
                                  Map<String, Object> body = {
                                    'interface': interfaceTypeCtl.text,
                                    'interfaceDescription': interfaceDisCtl.text,
                                    'createUser': userID,
                                  };
                                  response = await HttpService().postRequest("createInterfaceType", body);
                                }

                                if(response.statusCode == 200)
                                {
                                  var data = jsonDecode(response.body);
                                  if(data["code"]==200)
                                  {
                                    interfaceTypeCtl.clear();
                                    interfaceDisCtl.clear();
                                    _showSnackBar(data["message"]);
                                    getInterfaceTypeListTypeList();
                                  }
                                  else{
                                    _showSnackBar(data["message"]);
                                  }
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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
