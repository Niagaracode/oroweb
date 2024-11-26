import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/global_settings.dart';
import '../../Models/setting_category.dart';
import '../../constants/http_service.dart';
import '../../constants/snack_bar.dart';
import '../../constants/theme.dart';

class AddSettingCategory extends StatefulWidget {
  const AddSettingCategory({Key? key}) : super(key: key);

  @override
  State<AddSettingCategory> createState() => _AddSettingCategoryState();
}

class _AddSettingCategoryState extends State<AddSettingCategory> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController settingNameCtl = TextEditingController();
  TextEditingController settingsDisCtl = TextEditingController();
  TextEditingController settingsTypeCtl = TextEditingController();

  List<SettingCategory> settingCategoryList = <SettingCategory>[];
  bool editStCat = false;
  bool editActive = false;
  int sldStCatID = 0;

  final TextEditingController dropdownSettingsList = TextEditingController();
  late List<DropdownMenuEntry<GlobalSettings>> ddValues;
  List<GlobalSettings> activeSettingsMenuList = <GlobalSettings>[];
  bool showDdError = false;
  int sldSettingID = 0;

  @override
  void initState() {
    super.initState();
    ddValues =  <DropdownMenuEntry<GlobalSettings>>[];
    getSettingCategoryByActiveList();
    getSettingCategoryList();
  }

  Future<void> getSettingCategoryList() async
  {
    Map<String, Object> body = {};
    final response = await HttpService().postRequest("getSettingCategory", body);
    if (response.statusCode == 200)
    {
      settingCategoryList.clear();
      var data = jsonDecode(response.body);
      final cntList = data["data"] as List;

      for (int i=0; i < cntList.length; i++) {
        settingCategoryList.add(SettingCategory.fromJson(cntList[i]));
      }
      setState(() {
        settingCategoryList;
      });
    }
    else{
      _showSnackBar(response.body);
    }
  }

  Future<void> getSettingCategoryByActiveList() async
  {
    Map<String, Object> body = {
      "active" : "1",
    };
    final response = await HttpService().postRequest("getSettingMenuByActive", body);
    if (response.statusCode == 200)
    {
      activeSettingsMenuList.clear();
      var data = jsonDecode(response.body);
      final cntList = data["data"] as List;

      for (int i=0; i < cntList.length; i++) {
        activeSettingsMenuList.add(GlobalSettings.fromJson(cntList[i]));
      }

      ddValues =  <DropdownMenuEntry<GlobalSettings>>[];
      for (final GlobalSettings index in activeSettingsMenuList) {
        ddValues.add(DropdownMenuEntry<GlobalSettings>(value: index, label: index.menuName));
      }
      setState(() {
        ddValues;
      });
    }
    else{
      if (context.mounted){
        GlobalSnackBar.show(context, response.body, response.statusCode);
      }
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
                      title: Text('Settings Category', style: myTheme.textTheme.titleLarge),
                      subtitle: Text('Settings Category with Description', style: myTheme.textTheme.titleSmall),
                      trailing: IconButton(onPressed: ()
                      {
                        setState(() {
                          editStCat = !editStCat;
                          editActive = false;
                        });
                        settingNameCtl.clear();
                        settingsDisCtl.clear();
                        settingsTypeCtl.clear();
                      }, icon: editStCat ? Icon(Icons.done_all, color: myTheme.primaryColor,) : Icon(Icons.edit_note_outlined, color: myTheme.primaryColor,)),
                    ),
                  ),
                  Expanded(
                      child: GridView.builder(
                        itemCount: settingCategoryList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsetsDirectional.all(5.0),
                            decoration: BoxDecoration(
                              color: settingCategoryList[index].active=='1'? myTheme.primaryColor.withOpacity(0.2) : Colors.red.shade100,
                              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                            ),
                            child: ListTile(
                              title: Text(settingCategoryList[index].settingName,),
                              subtitle: Text(settingCategoryList[index].settingDescription,),
                              trailing: editStCat ? Wrap(
                                spacing: 12, // space between two icons
                                children: <Widget>[
                                  IconButton(onPressed: ()
                                  {
                                    dropdownSettingsList.text = settingCategoryList[index].menuName;
                                    settingNameCtl.text = settingCategoryList[index].settingName;
                                    settingsDisCtl.text = settingCategoryList[index].settingDescription;
                                    settingsTypeCtl.text = settingCategoryList[index].settingType;
                                    sldStCatID = settingCategoryList[index].settingId;
                                    sldSettingID  = settingCategoryList[index].menuId;

                                    setState(() {
                                      editActive = true;
                                    });

                                  }, icon: Icon(Icons.edit_outlined, color: myTheme.primaryColor,),),
                                  IconButton(onPressed: () async {
                                    final prefs = await SharedPreferences.getInstance();
                                    String userID = (prefs.getString('userId') ?? "");

                                    Map<String, Object> body = {
                                      'settingId': settingCategoryList[index].settingId.toString(),
                                      'modifyUser': userID,
                                    };

                                    final Response response;
                                    if(settingCategoryList[index].active=='1'){
                                      response = await HttpService().putRequest("inactiveSettingCategory", body);
                                    }else{
                                      response = await HttpService().putRequest("activeSettingCategory", body);
                                    }

                                    if(response.statusCode == 200)
                                    {
                                      var data = jsonDecode(response.body);
                                      if(data["code"]==200)
                                      {
                                        _showSnackBar(data["message"]);
                                        getSettingCategoryList();
                                      }
                                      else{
                                        _showSnackBar(data["message"]);
                                      }
                                    }else{
                                      _showSnackBar(response.body);
                                    }

                                  }, icon: settingCategoryList[index].active=='1'? Icon(Icons.check_circle_outlined, color: Colors.green,):Icon(Icons.unpublished_outlined, color: Colors.red,)),
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
                      title: Text("Add Settings Category", style: myTheme.textTheme.titleLarge),
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
                              DropdownMenu<GlobalSettings>(
                                controller: dropdownSettingsList,
                                errorText: showDdError ? 'Select Settings category Type' : null,
                                hintText: 'Settings Category',
                                width: MediaQuery.sizeOf(context).width/3.6,
                                //label: const Text('Category'),
                                dropdownMenuEntries: ddValues,
                                inputDecorationTheme: const InputDecorationTheme(
                                  filled: false,
                                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                  border: OutlineInputBorder(),
                                ),
                                onSelected: (GlobalSettings? icon) {
                                  setState(() {
                                    sldSettingID = icon!.menuId;
                                    showDdError = false;
                                  });
                                },
                              ),
                              const SizedBox(height: 10,),
                              TextFormField(
                                controller: settingNameCtl,
                                validator: (value){
                                  if(value==null ||value.isEmpty){
                                    return 'Please fill out this field';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                  border: OutlineInputBorder(),
                                  labelText: 'Settings Category Name',
                                ),
                              ),
                              const SizedBox(height: 13,),
                              TextFormField(
                                controller: settingsTypeCtl,
                                validator: (value){
                                  if(value==null ||value.isEmpty){
                                    return 'Please fill out this field';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                  border: OutlineInputBorder(),
                                  labelText: 'Type',
                                ),
                              ),
                              const SizedBox(height: 13,),
                              TextFormField(
                                controller: settingsDisCtl,
                                validator: (value){
                                  if(value==null ||value.isEmpty){
                                    return 'Please fill out this field';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                  border: OutlineInputBorder(),
                                  labelText: 'Settings Category Description',
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
                              if (_formKey.currentState!.validate() && sldSettingID!=0) {
                                _formKey.currentState!.save();

                                final prefs = await SharedPreferences.getInstance();
                                String userID = (prefs.getString('userId') ?? "");
                                final Response response;

                                if(editActive){
                                  Map<String, Object> body = {
                                    "menuId": sldSettingID,
                                    "settingId": sldStCatID.toString(),
                                    'settingName': settingNameCtl.text,
                                    'settingDescription': settingsDisCtl.text,
                                    'settingType': settingsTypeCtl.text,
                                    'modifyUser': userID,
                                  };
                                  print(body);
                                  response = await HttpService().putRequest("updateSettingCategory", body);
                                }
                                else{
                                  Map<String, Object> body = {
                                    "menuId": sldSettingID,
                                    'settingName': settingNameCtl.text,
                                    'settingDescription': settingsDisCtl.text,
                                    'settingType': settingsTypeCtl.text,
                                    'createUser': userID,
                                  };
                                  print(body);
                                  response = await HttpService().postRequest("createSettingCategory", body);
                                }

                                if(response.statusCode == 200)
                                {
                                  var data = jsonDecode(response.body);
                                  if(data["code"]==200)
                                  {
                                    dropdownSettingsList.clear();
                                    settingNameCtl.clear();
                                    settingsDisCtl.clear();
                                    settingsTypeCtl.clear();

                                    _showSnackBar(data["message"]);
                                    getSettingCategoryList();
                                  }
                                  else{
                                    _showSnackBar(data["message"]);
                                  }
                                }
                              }
                              else{
                                if(sldSettingID==0){
                                  setState(() {
                                    showDdError = true;
                                  });
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
