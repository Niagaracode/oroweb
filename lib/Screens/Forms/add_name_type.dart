import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/name_type.dart';
import '../../constants/http_service.dart';
import '../../constants/theme.dart';

class AddNameType extends StatefulWidget {
  const AddNameType({Key? key}) : super(key: key);

  @override
  State<AddNameType> createState() => _AddNameTypeState();
}

class _AddNameTypeState extends State<AddNameType> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController nameCtl = TextEditingController();
  TextEditingController nameTypeCtl = TextEditingController();
  TextEditingController nameDisCtl = TextEditingController();

  List<NameType> nameTypeList = <NameType>[];
  bool editNameType = false;
  bool editActive = false;
  int sldNameTypeID = 0;

  @override
  void initState() {
    super.initState();
    getNameTypeList();
  }

  Future<void> getNameTypeList() async
  {
    Map<String, Object> body = {};
    final response = await HttpService().postRequest("getNameType", body);
    if (response.statusCode == 200)
    {
      nameTypeList.clear();
      var data = jsonDecode(response.body);
      final cntList = data["data"] as List;
      print(cntList);
      for (int i=0; i < cntList.length; i++) {
        nameTypeList.add(NameType.fromJson(cntList[i]));
      }
      setState(() {
        nameTypeList;
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
            child: Column(
              children: [
                SizedBox(
                  height: 60,
                  child: ListTile(
                    title: Text('Name Types', style: myTheme.textTheme.titleLarge),
                    subtitle: Text('Name types with Description', style: myTheme.textTheme.titleSmall),
                    trailing: Wrap(
                      spacing: 12, // space between two icons
                      children: <Widget>[
                        IconButton(
                            tooltip: 'Edit and hide Name Type',
                            onPressed: (){
                              setState(() {
                                editNameType = !editNameType;
                                editActive = false;
                              });
                              nameCtl.clear();
                              nameTypeCtl.clear();
                              nameDisCtl.clear();
                            }, icon: editNameType ? Icon(Icons.done_all, color: myTheme.primaryColor,) : Icon(Icons.edit_note_outlined, color: myTheme.primaryColor,)),
                        IconButton(
                          icon: Icon(Icons.add_circle_outline, color: myTheme.primaryColor,),
                          tooltip: 'Add new Name type',
                          onPressed: () {
                            setState(() async {
                              await showDialog<void>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    content: showAddAndEditForm(context),
                                  ));
                            });
                          },
                        ), // icon-2
                      ],
                    ),
                  ),
                ),
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GridView.builder(
                        itemCount: nameTypeList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsetsDirectional.all(5.0),
                            decoration: BoxDecoration(
                              color: nameTypeList[index].active=='1'? myTheme.primaryColor.withOpacity(0.2) : Colors.red.shade100,
                              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                            ),
                            child: ListTile(
                              leading: Icon(Icons.list_alt, color: myTheme.primaryColor,),
                              title: Text(nameTypeList[index].name,),
                              subtitle: Text(nameTypeList[index].nameDescription,),
                              trailing: editNameType ? Wrap(
                                spacing: 12, // space between two icons
                                children: <Widget>[
                                  IconButton(onPressed: ()
                                  async {
                                    nameCtl.text = nameTypeList[index].name;
                                    nameTypeCtl.text = nameTypeList[index].nameType.toString();
                                    nameDisCtl.text = nameTypeList[index].nameDescription;
                                    sldNameTypeID = nameTypeList[index].nameTypeId;

                                    setState(() {
                                      editActive = true;
                                    });

                                    await showDialog<void>(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          content: showAddAndEditForm(context),
                                        ));

                                  }, icon: Icon(Icons.edit_outlined, color: myTheme.primaryColor,),),
                                  IconButton(onPressed: () async {
                                    final prefs = await SharedPreferences.getInstance();
                                    String userID = (prefs.getString('userId') ?? "");

                                    Map<String, Object> body = {
                                      'nameTypeId': nameTypeList[index].nameTypeId.toString(),
                                      'modifyUser': userID,
                                    };

                                    final Response response;
                                    if(nameTypeList[index].active=='1'){
                                      response = await HttpService().putRequest("inactiveNameType", body);
                                    }else{
                                      response = await HttpService().putRequest("activeNameType", body);
                                    }

                                    if(response.statusCode == 200)
                                    {
                                      var data = jsonDecode(response.body);
                                      if(data["code"]==200)
                                      {
                                        _showSnackBar(data["message"]);
                                        getNameTypeList();
                                      }
                                      else{
                                        _showSnackBar(data["message"]);
                                      }
                                    }else{
                                      _showSnackBar(response.body);
                                    }

                                  }, icon: nameTypeList[index].active=='1'? Icon(Icons.check_circle_outlined, color: Colors.green,):Icon(Icons.unpublished_outlined, color: Colors.red,)),
                                ],
                              ): null,
                            ),
                          );
                        },
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: mediaQuery.size.width > 1200 ? 4 : 3,
                          childAspectRatio: editNameType ? mediaQuery.size.width / 350 : mediaQuery.size.width / 300,
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget showAddAndEditForm(BuildContext dialogContext)
  {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 60,
            child: ListTile(
              title: Text("Add Name Type", style: myTheme.textTheme.titleLarge),
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
                        controller: nameCtl,
                        validator: (value){
                          if(value==null ||value.isEmpty){
                            return 'Please fill out this field';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          border: OutlineInputBorder(),
                          labelText: 'Name',
                          icon: Icon(Icons.contactless_outlined),
                        ),
                      ),
                      const SizedBox(height: 13,),
                      TextFormField(
                        controller: nameTypeCtl,
                        validator: (value){
                          if(value==null ||value.isEmpty){
                            return 'Please fill out this field';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          border: OutlineInputBorder(),
                          labelText: 'Name Type',
                          icon: Icon(Icons.contactless_outlined),
                        ),
                      ),
                      const SizedBox(height: 13,),
                      TextFormField(
                        controller: nameDisCtl,
                        validator: (value){
                          if(value==null ||value.isEmpty){
                            return 'Please fill out this field';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          border: OutlineInputBorder(),
                          labelText: 'Name Description',
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
          SizedBox(
            height: 60,
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
                          print(sldNameTypeID);
                          Map<String, dynamic> body = {
                            "nameTypeId": sldNameTypeID.toString(),
                            'name': nameCtl.text,
                            'nameType': nameTypeCtl.text,
                            'nameDescription': nameDisCtl.text,
                            'modifyUser': userID,
                          };
                          response = await HttpService().putRequest("updateNameType", body);
                        }
                        else{
                          Map<String, Object> body = {
                            'name': nameCtl.text,
                            'nameType': nameTypeCtl.text,
                            'nameDescription': nameDisCtl.text,
                            'createUser': userID,
                          };
                          response = await HttpService().postRequest("createNameType", body);
                        }

                        if(response.statusCode == 200)
                        {
                          var data = jsonDecode(response.body);
                          if(data["code"]==200)
                          {
                            nameCtl.clear();
                            nameTypeCtl.clear();
                            nameDisCtl.clear();
                            _showSnackBar(data["message"]);
                            getNameTypeList();
                            Navigator.pop(dialogContext);
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
