import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:oro_irrigation_new/Models/widget_type.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Models/dd_category_model.dart';
import '../../Models/dd_model.dart';
import '../../constants/http_service.dart';
import '../../constants/theme.dart';

class DealerDefinitions extends StatefulWidget {
  const DealerDefinitions({Key? key}) : super(key: key);

  @override
  State<DealerDefinitions> createState() => _DealerDefinitionsState();
}

class _DealerDefinitionsState extends State<DealerDefinitions> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController dropdownCatList = TextEditingController();
  late List<DropdownMenuEntry<DDCategoryModel>> activeCatEntries;
  final TextEditingController ddParamType = TextEditingController();
  late List<DropdownMenuEntry<WidgetType>> activeWidgetType;
  TextEditingController ddParamCtl = TextEditingController();
  TextEditingController ddParamDisCtl = TextEditingController();
  TextEditingController ddParamValCtl = TextEditingController();
  TextEditingController icodePiCtl = TextEditingController();
  TextEditingController iffCtl = TextEditingController();
  List<DDCategoryModel> activeDDCategoryList = <DDCategoryModel>[];
  List<DDModel> ddList = <DDModel>[];
  List<WidgetType> activeWidgetList = <WidgetType>[];
  bool editCont = false;
  bool editActive = false;
  int sldDDfID = 0;
  int sldCatID = 0;
  int sldWidgetID = 0;
  bool showDdError = false;

  @override
  void initState() {
    super.initState();
    activeCatEntries = <DropdownMenuEntry<DDCategoryModel>>[];
    activeWidgetType = <DropdownMenuEntry<WidgetType>>[];
    getCategoryAndWidgetList();
    getDealerDefinitionList();
  }

  Future<void> getCategoryAndWidgetList() async {
    await getActiveList("getDealerDefinitionCategoryByActive", activeDDCategoryList, activeCatEntries);
    await getActiveList("getWidgetTypeByActive", activeWidgetList, activeWidgetType);
  }

  Future<void> getActiveList(String endpoint, List list, List<DropdownMenuEntry> entries) async {
    Map<String, Object> body = {"active": "1"};
    final response = await HttpService().postRequest(endpoint, body);
    if (response.statusCode == 200) {
      list.clear();
      var data = jsonDecode(response.body);
      final cntList = data["data"] as List;

      for (int i = 0; i < cntList.length; i++) {
        list.add(endpoint == "getDealerDefinitionCategoryByActive"
            ? DDCategoryModel.fromJson(cntList[i])
            : WidgetType.fromJson(cntList[i]));
      }

      entries.clear();
      for (final item in list) {
        entries.add(DropdownMenuEntry(value: item, label: item.getLabel()));
      }

      setState(() {
        list;
      });
    } else {
      _showSnackBar(response.body);
    }
  }

  Future<void> getDealerDefinitionList() async {
    Map<String, Object> body = {};
    final response = await HttpService().postRequest("getDealerDefinition", body);

    if (response.statusCode == 200) {
      ddList.clear();
      var data = jsonDecode(response.body);
      final cntList = data["data"] as List;
      print(response.body);

      for (int i = 0; i < cntList.length; i++) {
        ddList.add(DDModel.fromJson(cntList[i]));
      }
      setState(() {
        ddList;
      });
    } else {
      _showSnackBar(response.body);
    }
  }

  Widget buildGridViewItem(BuildContext context, int index)
  {
    return Row(
      children: [
        Container(
          width: 50,
          margin: const EdgeInsetsDirectional.only(top: 5, bottom: 5, start: 5),
          child: CircleAvatar(
            backgroundColor: myTheme.primaryColor.withOpacity(0.5),
            child:  Text(getInitials(string: ddList[index].categoryName, limitTo: 2), style: const TextStyle(fontWeight: FontWeight.bold),),
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsetsDirectional.only(top: 5, bottom: 5, end: 5),
            decoration: BoxDecoration(
              color: ddList[index].active=='1'? myTheme.primaryColor.withOpacity(0.2) : Colors.red.shade100,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: ListTile(
              //leading: Icon(IconData(int.parse(ddList[index].iconCodePoint), fontFamily: ddList[index].iconFontFamily), color: myTheme.primaryColor,),
              title: Text(ddList[index].parameter,),
              subtitle: Text(ddList[index].description, style: myTheme.textTheme.titleSmall,),
              trailing: editCont ? Wrap(
                spacing: 12, // space between two icons
                children: <Widget>[
                  IconButton(onPressed: ()
                  async {
                    ddParamCtl.text = ddList[index].parameter;
                    ddParamDisCtl.text = ddList[index].description;
                    ddParamValCtl.text = ddList[index].dropdownValues;
                    dropdownCatList.text = ddList[index].categoryName;
                    ddParamType.text = ddList[index].widget;
                    icodePiCtl.text = ddList[index].iconCodePoint;
                    iffCtl.text = ddList[index].iconFontFamily;
                    sldDDfID = ddList[index].dealerDefinitionId;
                    sldCatID  = ddList[index].categoryId;
                    sldWidgetID  = ddList[index].widgetTypeId;

                    setState(() {
                      editActive = true;
                    });

                    await showDialog<void>(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: buildForm(context),
                        ));

                  }, icon: Icon(Icons.edit_outlined, color: myTheme.primaryColor,),),
                  IconButton(onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    String userID = (prefs.getString('userId') ?? "");

                    Map<String, Object> body = {
                      'dealerDefinitionId': ddList[index].dealerDefinitionId.toString(),
                      'modifyUser': userID,
                    };

                    final Response response;
                    if(ddList[index].active=='1'){
                      response = await HttpService().putRequest("inactiveDealerDefinition", body);
                    }else{
                      response = await HttpService().putRequest("activeDealerDefinition", body);
                    }

                    if(response.statusCode == 200)
                    {
                      var data = jsonDecode(response.body);
                      if(data["code"]==200)
                      {
                        _showSnackBar(data["message"]);
                        getDealerDefinitionList();
                      }
                      else{
                        _showSnackBar(data["message"]);
                      }
                    }else{
                      _showSnackBar(response.body);
                    }
                  }, icon: ddList[index].active=='1'? Icon(Icons.check_circle_outlined, color: Colors.green,):Icon(Icons.unpublished_outlined, color: Colors.red,)),
                ],
              ): null,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildForm(BuildContext dialogContext)
  {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 60,
            child: ListTile(
              title: Text("Add Dealer Definition ", style: myTheme.textTheme.titleLarge),
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
                      DropdownMenu<DDCategoryModel>(
                        controller: dropdownCatList,
                        errorText: showDdError ? 'Select category' : null,
                        hintText: 'Category',
                        width: 273,
                        //label: const Text('Category'),
                        dropdownMenuEntries: activeCatEntries,
                        inputDecorationTheme: const InputDecorationTheme(
                          filled: false,
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          border: OutlineInputBorder(),
                        ),
                        onSelected: (DDCategoryModel? icon) {
                          setState(() {
                            sldCatID = icon!.categoryId;
                            showDdError = false;
                          });
                        },
                      ),
                      const SizedBox(height: 15,),
                      TextFormField(
                        controller: ddParamCtl,
                        validator: (value){
                          if(value==null ||value.isEmpty){
                            return 'Please fill out this field';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          border: OutlineInputBorder(),
                          labelText: 'Parameter',
                        ),
                      ),
                      const SizedBox(height: 15,),
                      TextFormField(
                        controller: ddParamDisCtl,
                        validator: (value){
                          if(value==null ||value.isEmpty){
                            return 'Please fill out this field';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          border: OutlineInputBorder(),
                          labelText: 'Parameter Description',
                        ),
                      ),
                      const SizedBox(height: 15,),
                      DropdownMenu<WidgetType>(
                        controller: ddParamType,
                        errorText: showDdError ? 'Select widget' : null,
                        hintText: 'Widget',
                        width: 273,
                        //label: const Text('Category'),
                        dropdownMenuEntries: activeWidgetType,
                        inputDecorationTheme: const InputDecorationTheme(
                          filled: false,
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          border: OutlineInputBorder(),
                        ),
                        onSelected: (WidgetType? icon) {
                          setState(() {
                            sldWidgetID = icon!.widgetTypeId;
                            showDdError = false;
                          });
                        },
                      ),
                      const SizedBox(height: 15,),
                      TextFormField(
                        controller: ddParamValCtl,
                        validator: (value){
                          if(value==null || value.isEmpty){
                            return 'Please fill out this field';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          border: OutlineInputBorder(),
                          labelText: 'Value',
                        ),
                      ),
                      const SizedBox(height: 15,),
                      TextFormField(
                        controller: icodePiCtl,
                        validator: (value){
                          if(value==null || value.isEmpty){
                            return 'Please fill out this field';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          border: OutlineInputBorder(),
                          labelText: 'Icon Code Point',
                        ),
                      ),
                      const SizedBox(height: 15,),
                      TextFormField(
                        controller: iffCtl,
                        validator: (value){
                          if(value==null || value.isEmpty){
                            return 'Please fill out this field';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          border: OutlineInputBorder(),
                          labelText: 'Icon Font Family',
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
                          //print(sldDDfID);
                          Map<String, Object> body = {
                            "dealerDefinitionId": sldDDfID.toString(),
                            "categoryId": sldCatID.toString(),
                            "widgetTypeId": sldWidgetID.toString(),
                            'parameter': ddParamCtl.text,
                            'description': ddParamDisCtl.text,
                            'dropdownValues': ddParamValCtl.text,
                            'iconCodePoint': icodePiCtl.text,
                            'iconFontFamily': iffCtl.text,
                            'modifyUser': userID,
                          };
                          response = await HttpService().putRequest("updateDealerDefinition", body);
                        }
                        else{
                          Map<String, Object> body = {
                            "categoryId": sldCatID.toString(),
                            "widgetTypeId": sldWidgetID.toString(),
                            'parameter': ddParamCtl.text,
                            'description': ddParamDisCtl.text,
                            'dropdownValues': ddParamValCtl.text,
                            'iconCodePoint': icodePiCtl.text,
                            'iconFontFamily': iffCtl.text,
                            'createUser': userID,
                          };
                          response = await HttpService().postRequest("createDealerDefinition", body);
                        }

                        if(response.statusCode == 200)
                        {
                          var data = jsonDecode(response.body);
                          if(data["code"]==200)
                          {
                            ddParamCtl.clear();
                            ddParamDisCtl.clear();
                            icodePiCtl.clear();
                            iffCtl.clear();
                            _showSnackBar(data["message"]);
                            getDealerDefinitionList();
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

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Container(
      color: Colors.blueGrey.shade50,
      child: Row(
        children: [
          Flexible(
            flex: 2,
            child: Column(
              children: [
                ListTile(
                  title: Text('Dealer Definition List', style: myTheme.textTheme.titleLarge),
                  subtitle: Text('Dealer Definition with that details', style: myTheme.textTheme.titleSmall),
                  trailing: Wrap(
                    spacing: 12,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            editCont = !editCont;
                            editActive = false;
                          });
                          ddParamCtl.clear();
                          ddParamDisCtl.clear();
                          ddParamValCtl.clear();
                        },
                        tooltip: 'Edit and hide dealer definition',
                        icon: editCont ? Icon(Icons.done_all, color: myTheme.primaryColor,) : Icon(Icons.edit_note_outlined, color: myTheme.primaryColor,),
                      ),
                      IconButton(
                        icon: Icon(Icons.add_circle_outline, color: myTheme.primaryColor,),
                        tooltip: 'Add new dealer definition menu',
                        onPressed: () => showFormDialog(context),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GridView.builder(
                      itemCount: ddList.length,
                      itemBuilder: (context, index) => buildGridViewItem(context, index),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: mediaQuery.size.width > 1200 ? 3 : 2,
                        childAspectRatio: mediaQuery.size.width / 250,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showFormDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        content: buildForm(context),
      ),
    );
  }

  String getInitials({required String string, required int limitTo}) {
    if (string.isEmpty) {
      return '';
    }
    var buffer = StringBuffer();
    var split = string.split(' ');

    if (split.length == 1) {
      return string.substring(0, 1);
    }
    for (var i = 0; i < (limitTo ?? split.length); i++) {
      buffer.write(split[i][0]);
    }
    return buffer.toString();
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
