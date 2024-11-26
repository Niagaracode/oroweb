import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/unit_type.dart';
import '../../constants/http_service.dart';
import '../../constants/theme.dart';

class UnitCategory extends StatefulWidget {
  const UnitCategory({Key? key}) : super(key: key);

  @override
  State<UnitCategory> createState() => _UnitCategoryState();
}

class _UnitCategoryState extends State<UnitCategory> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController unitCatTypeCtl = TextEditingController();
  TextEditingController unitCatDisCtl = TextEditingController();

  List<UnitCategoryModel> unitCategoryList = <UnitCategoryModel>[];
  bool editCategoryType = false;
  bool editActive = false;
  int sldUnitCategoryID = 0;


  @override
  void initState() {
    super.initState();
    getUnitCategoryList();
  }

  Future<void> getUnitCategoryList() async
  {
    Map<String, Object> body = {};
    final response = await HttpService().postRequest("getUnitCategory", body);
    if (response.statusCode == 200)
    {
      unitCategoryList.clear();
      var data = jsonDecode(response.body);
      final cntList = data["data"] as List;
      for (int i=0; i < cntList.length; i++) {
        unitCategoryList.add(UnitCategoryModel.fromJson(cntList[i]));
      }
      setState(() {
        unitCategoryList;
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
                      title: Text('Unit Category', style: myTheme.textTheme.titleLarge),
                      subtitle: Text('Unit Category with Description', style: myTheme.textTheme.titleSmall),
                      trailing: IconButton(onPressed: ()
                      {
                        setState(() {
                          editCategoryType = !editCategoryType;
                          editActive = false;
                        });
                        unitCatTypeCtl.clear();
                        unitCatDisCtl.clear();
                      }, icon: editCategoryType ? Icon(Icons.done_all, color: myTheme.primaryColor,) : Icon(Icons.edit_note_outlined, color: myTheme.primaryColor,)),
                    ),
                  ),
                  Expanded(
                      child: GridView.builder(
                        itemCount: unitCategoryList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsetsDirectional.all(5.0),
                            decoration: BoxDecoration(
                              color: unitCategoryList[index].active=='1'? myTheme.primaryColor.withOpacity(0.2) : Colors.red.shade100,
                              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                            ),
                            child: ListTile(
                              title: Text(unitCategoryList[index].categoryName),
                              subtitle: Text(unitCategoryList[index].categoryDescription,),
                              trailing: editCategoryType ? Wrap(
                                spacing: 12, // space between two icons
                                children: <Widget>[
                                  IconButton(onPressed: ()
                                  {
                                    unitCatTypeCtl.text = unitCategoryList[index].categoryName;
                                    unitCatDisCtl.text = unitCategoryList[index].categoryDescription;
                                    sldUnitCategoryID = unitCategoryList[index].unitCategoryId;

                                    setState(() {
                                      editActive = true;
                                    });
                                  }, icon: Icon(Icons.edit_outlined, color: myTheme.primaryColor,),),
                                  IconButton(onPressed: () async {
                                    final prefs = await SharedPreferences.getInstance();
                                    String userID = (prefs.getString('userId') ?? "");

                                    Map<String, Object> body = {
                                      'unitCategoryId': unitCategoryList[index].unitCategoryId.toString(),
                                      'modifyUser': userID,
                                    };

                                    final Response response;
                                    if(unitCategoryList[index].active=='1'){
                                      response = await HttpService().putRequest("inactiveUnitCategory", body);
                                    }else{
                                      response = await HttpService().putRequest("activeUnitCategory", body);
                                    }

                                    if(response.statusCode == 200)
                                    {
                                      var data = jsonDecode(response.body);
                                      if(data["code"]==200)
                                      {
                                        _showSnackBar(data["message"]);
                                        getUnitCategoryList();
                                      }
                                      else{
                                        _showSnackBar(data["message"]);
                                      }
                                    }else{
                                      _showSnackBar(response.body);
                                    }

                                  }, icon: unitCategoryList[index].active=='1'? Icon(Icons.check_circle_outlined, color: Colors.green,):Icon(Icons.unpublished_outlined, color: Colors.red,)),
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
                      title: Text("Add Unit Category Type", style: myTheme.textTheme.titleLarge),
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
                                controller: unitCatTypeCtl,
                                validator: (value){
                                  if(value==null ||value.isEmpty){
                                    return 'Please fill out this field';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                  border: OutlineInputBorder(),
                                  labelText: 'Unit Category',
                                  icon: Icon(Icons.contactless_outlined),
                                ),
                              ),
                              const SizedBox(height: 13,),
                              TextFormField(
                                controller: unitCatDisCtl,
                                validator: (value){
                                  if(value==null ||value.isEmpty){
                                    return 'Please fill out this field';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                  border: OutlineInputBorder(),
                                  labelText: 'Category Description',
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
                                    "unitCategoryId": sldUnitCategoryID.toString(),
                                    'categoryName': unitCatTypeCtl.text,
                                    'categoryDescription': unitCatDisCtl.text,
                                    'modifyUser': userID,
                                  };
                                  response = await HttpService().putRequest("updateUnitCategory", body);
                                }
                                else{
                                  Map<String, Object> body = {
                                    'categoryName': unitCatTypeCtl.text,
                                    'categoryDescription': unitCatDisCtl.text,
                                    'createUser': userID,
                                  };
                                  response = await HttpService().postRequest("createUnitCategory", body);
                                }

                                if(response.statusCode == 200)
                                {
                                  var data = jsonDecode(response.body);
                                  if(data["code"]==200)
                                  {
                                    unitCatTypeCtl.clear();
                                    unitCatDisCtl.clear();
                                    _showSnackBar(data["message"]);
                                    getUnitCategoryList();
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
