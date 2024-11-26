import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/global_settings.dart';
import '../../Models/unit_type.dart';
import '../../constants/http_service.dart';
import '../../constants/snack_bar.dart';
import '../../constants/theme.dart';

class AddUnitType extends StatefulWidget {
  const AddUnitType({Key? key}) : super(key: key);

  @override
  State<AddUnitType> createState() => _AddUnitTypeState();
}

class _AddUnitTypeState extends State<AddUnitType> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController unitTypeCtl = TextEditingController();
  TextEditingController unitNameCtl = TextEditingController();
  TextEditingController unitDisCtl = TextEditingController();

  List<UnitType> unitTypeList = <UnitType>[];
  bool editUnitType = false;
  bool editActive = false;
  int sldUnitTypeID = 0;

  final TextEditingController dropdownSettingsList = TextEditingController();
  late List<DropdownMenuEntry<DDCategoryList>> ddValues;
  List<DDCategoryList> activeSettingsMenuList = <DDCategoryList>[];
  bool showDdError = false;
  int sldUnitCategoryID = 0;

  @override
  void initState() {
    super.initState();
    ddValues =  <DropdownMenuEntry<DDCategoryList>>[];
    getUnitTypeList();
    getUnitCategoryByActiveList();
  }

  Future<void> getUnitTypeList() async
  {
    Map<String, Object> body = {};
    final response = await HttpService().postRequest("getUnitType", body);
    if (response.statusCode == 200)
    {
      unitTypeList.clear();
      var data = jsonDecode(response.body);
      final cntList = data["data"] as List;

      for (int i=0; i < cntList.length; i++) {
        unitTypeList.add(UnitType.fromJson(cntList[i]));
      }
      setState(() {
        unitTypeList;
      });
    }
    else{
      _showSnackBar(response.body);
    }
  }

  Future<void> getUnitCategoryByActiveList() async
  {
    Map<String, Object> body = {
      "active" : "1",
    };
    final response = await HttpService().postRequest("getUnitCategoryByActive", body);
    if (response.statusCode == 200)
    {
      activeSettingsMenuList.clear();
      var data = jsonDecode(response.body);
      final cntList = data["data"] as List;

      for (int i=0; i < cntList.length; i++) {
        activeSettingsMenuList.add(DDCategoryList.fromJson(cntList[i]));
      }

      ddValues =  <DropdownMenuEntry<DDCategoryList>>[];
      for (final DDCategoryList index in activeSettingsMenuList) {
        ddValues.add(DropdownMenuEntry<DDCategoryList>(value: index, label: index.categoryName));
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
                      title: Text('Unit Types', style: myTheme.textTheme.titleLarge),
                      subtitle: Text('Unit types with Description', style: myTheme.textTheme.titleSmall),
                      trailing: IconButton(onPressed: ()
                      {
                        setState(() {
                          editUnitType = !editUnitType;
                          editActive = false;
                        });
                        unitTypeCtl.clear();
                        unitNameCtl.clear();
                        unitDisCtl.clear();
                      }, icon: editUnitType ? Icon(Icons.done_all, color: myTheme.primaryColor,) : Icon(Icons.edit_note_outlined, color: myTheme.primaryColor,)),
                    ),
                  ),
                  Expanded(
                      child: GridView.builder(
                        itemCount: unitTypeList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsetsDirectional.all(5.0),
                            decoration: BoxDecoration(
                              color: unitTypeList[index].active=='1'? myTheme.primaryColor.withOpacity(0.2) : Colors.red.shade100,
                              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                            ),
                            child: ListTile(
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Category Name', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13),),
                                      Text('Unit Name', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13),),
                                      Text('Unit', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13),),
                                      Text('Unit Description', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13),)
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(unitTypeList[index].categoryName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),),
                                      Text(unitTypeList[index].unitName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),),
                                      Text(unitTypeList[index].unit, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),),
                                      Text(unitTypeList[index].unitDescription, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: editUnitType ? Wrap(
                                spacing: 12, // space between two icons
                                children: <Widget>[
                                  IconButton(onPressed: ()
                                  {
                                    unitTypeCtl.text = unitTypeList[index].unit;
                                    unitNameCtl.text = unitTypeList[index].unitName;
                                    unitDisCtl.text = unitTypeList[index].unitDescription;
                                    sldUnitTypeID = unitTypeList[index].unitTypeId;

                                    setState(() {
                                      editActive = true;
                                    });

                                  }, icon: Icon(Icons.edit_outlined, color: myTheme.primaryColor,),),
                                  IconButton(onPressed: () async {
                                    final prefs = await SharedPreferences.getInstance();
                                    String userID = (prefs.getString('userId') ?? "");

                                    Map<String, Object> body = {
                                      'unitTypeId': unitTypeList[index].unitTypeId.toString(),
                                      'modifyUser': userID,
                                    };

                                    final Response response;
                                    if(unitTypeList[index].active=='1'){
                                      response = await HttpService().putRequest("inactiveUnitType", body);
                                    }else{
                                      response = await HttpService().putRequest("activeUnitType", body);
                                    }

                                    if(response.statusCode == 200)
                                    {
                                      var data = jsonDecode(response.body);
                                      if(data["code"]==200)
                                      {
                                        _showSnackBar(data["message"]);
                                        getUnitTypeList();
                                      }
                                      else{
                                        _showSnackBar(data["message"]);
                                      }
                                    }else{
                                      _showSnackBar(response.body);
                                    }

                                  }, icon: unitTypeList[index].active=='1'? Icon(Icons.check_circle_outlined, color: Colors.green,):Icon(Icons.unpublished_outlined, color: Colors.red,)),
                                ],
                              ): null,
                            ),
                          );
                        },
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: mediaQuery.size.width > 1200 ? 2 : 1,
                          childAspectRatio: mediaQuery.size.width / 370,
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
                      title: Text("Add Unit Type", style: myTheme.textTheme.titleLarge),
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
                              DropdownMenu<DDCategoryList>(
                                controller: dropdownSettingsList,
                                errorText: showDdError ? 'Select category Name' : null,
                                hintText: 'Unit Category',
                                width: MediaQuery.sizeOf(context).width/3.6,
                                //label: const Text('Category'),
                                dropdownMenuEntries: ddValues,
                                inputDecorationTheme: const InputDecorationTheme(
                                  filled: false,
                                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                  border: OutlineInputBorder(),
                                ),
                                onSelected: (DDCategoryList? icon) {
                                  setState(() {
                                    sldUnitCategoryID = icon!.unitCategoryId;
                                    showDdError = false;
                                  });
                                },
                              ),
                              const SizedBox(height: 15,),
                              TextFormField(
                                controller: unitTypeCtl,
                                validator: (value){
                                  if(value==null ||value.isEmpty){
                                    return 'Please fill out this field';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                  border: OutlineInputBorder(),
                                  labelText: 'Unit Type',
                                ),
                              ),
                              const SizedBox(height: 10,),
                              TextFormField(
                                controller: unitNameCtl,
                                validator: (value){
                                  if(value==null ||value.isEmpty){
                                    return 'Please fill out this field';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                  border: OutlineInputBorder(),
                                  labelText: 'Unit Name',
                                ),
                              ),
                              const SizedBox(height: 13,),
                              TextFormField(
                                controller: unitDisCtl,
                                validator:(value){
                                  if(value==null ||value.isEmpty){
                                    return 'Please fill out this field';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                  border: OutlineInputBorder(),
                                  labelText: 'Unit Description',
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
                              if (_formKey.currentState!.validate() && sldUnitCategoryID!=0) {
                                _formKey.currentState!.save();

                                final prefs = await SharedPreferences.getInstance();
                                String userID = (prefs.getString('userId') ?? "");
                                final Response response;

                                if(editActive){
                                  Map<String, Object> body = {
                                    'unitTypeId': sldUnitTypeID,
                                    'unitCategoryId': sldUnitCategoryID,
                                    'unit': unitTypeCtl.text,
                                    'unitName': unitNameCtl.text,
                                    'unitDescription': unitDisCtl.text,
                                    'modifyUser': userID,
                                  };
                                  //print(body);

                                  response = await HttpService().putRequest("updateUnitType", body);
                                }
                                else{
                                  Map<String, Object> body = {
                                    'unitCategoryId': sldUnitCategoryID,
                                    'unit': unitTypeCtl.text,
                                    'unitName': unitNameCtl.text,
                                    'unitDescription': unitDisCtl.text,
                                    'createUser': userID,
                                  };
                                  print(body);
                                  response = await HttpService().postRequest("createUnitType", body);
                                }




                                if(response.statusCode == 200)
                                {
                                  var data = jsonDecode(response.body);
                                  if(data["code"]==200)
                                  {
                                    unitTypeCtl.clear();
                                    unitNameCtl.clear();
                                    unitDisCtl.clear();
                                    _showSnackBar(data["message"]);
                                    getUnitTypeList();
                                  }
                                  else{
                                    _showSnackBar(data["message"]);
                                  }
                                }
                              }
                              else{
                                GlobalSnackBar.show(context, 'Please select Unit category and try again later', 200);
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
