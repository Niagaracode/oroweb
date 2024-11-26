import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/global_settings.dart';
import '../../constants/http_service.dart';
import '../../constants/theme.dart';

class AddGlobalSettings extends StatefulWidget {
  const AddGlobalSettings({Key? key}) : super(key: key);

  @override
  State<AddGlobalSettings> createState() => _AddGlobalSettingsState();
}

class _AddGlobalSettingsState extends State<AddGlobalSettings> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController glRefNameCtl = TextEditingController();
  TextEditingController refIDCtl = TextEditingController();

  List<GlobalSettings> globalSettingsList = <GlobalSettings>[];
  bool editGS = false;
  bool editActive = false;
  int sldGStID = 0;

  @override
  void initState() {
    super.initState();
    getGlobalSettingsList();
  }

  Future<void> getGlobalSettingsList() async
  {
    Map<String, Object> body = {};
    final response = await HttpService().postRequest("getSettingMenu", body);
    if (response.statusCode == 200)
    {
      globalSettingsList.clear();
      var data = jsonDecode(response.body);
      final cntList = data["data"] as List;

      for (int i=0; i < cntList.length; i++) {
        globalSettingsList.add(GlobalSettings.fromJson(cntList[i]));
      }
      setState(() {
        globalSettingsList;
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
                      title: Text('Global setting Types', style: myTheme.textTheme.titleLarge),
                      subtitle: Text('Global setting types with id', style: myTheme.textTheme.titleSmall),
                      trailing: IconButton(onPressed: ()
                      {
                        setState(() {
                          editGS = !editGS;
                          editActive = false;
                        });
                        glRefNameCtl.clear();
                        refIDCtl.clear();
                      }, icon: editGS ? Icon(Icons.done_all, color: myTheme.primaryColor,) : Icon(Icons.edit_note_outlined, color: myTheme.primaryColor,)),
                    ),
                  ),
                  Expanded(
                      child: GridView.builder(
                        itemCount: globalSettingsList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsetsDirectional.all(5.0),
                            decoration: BoxDecoration(
                              color: globalSettingsList[index].active=='1'? myTheme.primaryColor.withOpacity(0.2) : Colors.red.shade100,
                              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                            ),
                            child: ListTile(
                              title: Text(globalSettingsList[index].menuName,),
                              subtitle: Text(globalSettingsList[index].referenceId.toString(),),
                              trailing: editGS ? Wrap(
                                spacing: 12, // space between two icons
                                children: <Widget>[
                                  IconButton(onPressed: ()
                                  {
                                    glRefNameCtl.text = globalSettingsList[index].menuName;
                                    refIDCtl.text = globalSettingsList[index].referenceId.toString();
                                    sldGStID = globalSettingsList[index].menuId;

                                    setState(() {
                                      editActive = true;
                                    });

                                  }, icon: Icon(Icons.edit_outlined, color: myTheme.primaryColor,),),
                                  IconButton(onPressed: () async {
                                    final prefs = await SharedPreferences.getInstance();
                                    String userID = (prefs.getString('userId') ?? "");

                                    Map<String, Object> body = {
                                      'menuId': globalSettingsList[index].menuId.toString(),
                                      'modifyUser': userID,
                                    };

                                    final Response response;
                                    if(globalSettingsList[index].active=='1'){
                                      response = await HttpService().putRequest("inactiveSettingMenu", body);
                                    }else{
                                      response = await HttpService().putRequest("activeSettingMenu", body);
                                    }

                                    if(response.statusCode == 200)
                                    {
                                      var data = jsonDecode(response.body);
                                      if(data["code"]==200)
                                      {
                                        _showSnackBar(data["message"]);
                                        getGlobalSettingsList();
                                      }
                                      else{
                                        _showSnackBar(data["message"]);
                                      }
                                    }else{
                                      _showSnackBar(response.body);
                                    }

                                  }, icon: globalSettingsList[index].active=='1'? Icon(Icons.check_circle_outlined, color: Colors.green,):Icon(Icons.unpublished_outlined, color: Colors.red,)),
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
                      title: Text("Add Global setting Type", style: myTheme.textTheme.titleLarge),
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
                                controller: glRefNameCtl,
                                validator: (value){
                                  if(value==null ||value.isEmpty){
                                    return 'Please fill out this field';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                  border: OutlineInputBorder(),
                                  labelText: 'Global setting Type',
                                  icon: Icon(Icons.contactless_outlined),
                                ),
                              ),
                              const SizedBox(height: 13,),
                              TextFormField(
                                controller: refIDCtl,
                                validator: (value){
                                  if(value==null ||value.isEmpty){
                                    return 'Please fill out this field';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                  border: OutlineInputBorder(),
                                  labelText: 'Global setting id',
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
                                  Map<String, Object> body = {
                                    "menuId": sldGStID.toString(),
                                    'menuName': glRefNameCtl.text,
                                    'referenceId': refIDCtl.text,
                                    'modifyUser': userID,
                                  };
                                  response = await HttpService().putRequest("updateSettingMenu", body);
                                }
                                else{
                                  Map<String, Object> body = {
                                    'menuName': glRefNameCtl.text,
                                    'referenceId': refIDCtl.text,
                                    'createUser': userID,
                                  };
                                  response = await HttpService().postRequest("createSettingMenu", body);
                                }

                                if(response.statusCode == 200)
                                {
                                  var data = jsonDecode(response.body);
                                  if(data["code"]==200)
                                  {
                                    glRefNameCtl.clear();
                                    refIDCtl.clear();
                                    _showSnackBar(data["message"]);
                                    getGlobalSettingsList();
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
