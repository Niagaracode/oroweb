import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/prd_cat_model.dart';
import '../../Models/product_model.dart';
import '../../constants/http_service.dart';
import '../../constants/snack_bar.dart';
import '../../constants/theme.dart';



class ProductModelForm extends StatefulWidget {
  const ProductModelForm({Key? key}) : super(key: key);

  @override
  State<ProductModelForm> createState() => _ProductModelFormState();
}

class _ProductModelFormState extends State<ProductModelForm> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController dropdownCatList = TextEditingController();
  late List<DropdownMenuEntry<PrdCateModel>> activeCatEntries;

  TextEditingController modelName = TextEditingController();
  TextEditingController modelDisc = TextEditingController();

  List<PrdCateModel> activeCategoryList = <PrdCateModel>[];
  List<PrdModel> modelList = <PrdModel>[];
  bool editModel= false;
  bool editActive = false;
  int sldModelID = 0;
  int sldCatID = 0;
  bool showDdError = false;

  @override
  void initState() {
    super.initState();
    activeCatEntries =  <DropdownMenuEntry<PrdCateModel>>[];
    getCategoryByActiveList();
    getModelList();
  }

  Future<void> getCategoryByActiveList() async
  {
    Map<String, Object> body = {
      "active" : "1",
    };
    final response = await HttpService().postRequest("getCategoryByActive", body);
    print(response);
    if (response.statusCode == 200)
    {
      activeCategoryList.clear();
      var data = jsonDecode(response.body);
      final cntList = data["data"] as List;

      for (int i=0; i < cntList.length; i++) {
        activeCategoryList.add(PrdCateModel.fromJson(cntList[i]));
      }

      activeCatEntries =  <DropdownMenuEntry<PrdCateModel>>[];
      for (final PrdCateModel index in activeCategoryList) {
        activeCatEntries.add(DropdownMenuEntry<PrdCateModel>(value: index, label: index.categoryName));
      }

      setState(() {
        activeCategoryList;
      });
    }
    else{
      if (context.mounted){
        GlobalSnackBar.show(context, response.body, response.statusCode);
      }
    }
  }

  Future<void> getModelList() async
  {
    Map<String, Object> body = {};
    final response = await HttpService().postRequest("getModel", body);
    if (response.statusCode == 200)
    {
      modelList.clear();
      var data = jsonDecode(response.body);
      final cntList = data["data"] as List;

      for (int i=0; i < cntList.length; i++) {
        modelList.add(PrdModel.fromJson(cntList[i]));
      }
      setState(() {
        modelList;
      });
    }
    else{
      if (context.mounted){
        GlobalSnackBar.show(context, response.body, response.statusCode);
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    final mediaQuery = MediaQuery.of(context);

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
                      title: Text('Model List', style: myTheme.textTheme.titleLarge),
                      subtitle: Text('Model List with this details', style: myTheme.textTheme.titleSmall),
                      trailing: Wrap(
                        spacing: 12, // space between two icons
                        children: <Widget>[
                          IconButton(onPressed: ()
                          {
                            setState(() {
                              editModel = !editModel;
                              editActive = false;
                            });
                            modelName.clear();
                            modelDisc.clear();
                          }, icon: editModel ? Icon(Icons.done_all, color: myTheme.primaryColor,) : Icon(Icons.edit_note_outlined, color: myTheme.primaryColor,)),
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
                      child: GridView.builder(
                        itemCount: modelList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsetsDirectional.all(5.0),
                            decoration: BoxDecoration(
                              color: modelList[index].active=='1'? myTheme.primaryColor.withOpacity(0.2) : Colors.red.shade100,
                              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                            ),
                            child: ListTile(
                              title: Text(modelList[index].modelName,),
                              subtitle: Text(modelList[index].modelDescription,),
                              trailing: editModel ? Wrap(
                                spacing: 12, // space between two icons
                                children: <Widget>[
                                  IconButton(onPressed: ()
                                  async {
                                    modelName.text = modelList[index].modelName;
                                    modelDisc.text = modelList[index].modelDescription;
                                    dropdownCatList.text = modelList[index].categoryName;

                                    sldModelID = modelList[index].modelId;
                                    sldCatID  = modelList[index].categoryId;

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
                                      'modelId': modelList[index].modelId.toString(),
                                      'modifyUser': userID,
                                    };

                                    final Response response;
                                    if(modelList[index].active=='1'){
                                      response = await HttpService().putRequest("inactiveModel", body);
                                    }else{
                                      response = await HttpService().putRequest("activeModel", body);
                                    }

                                    if(response.statusCode == 200)
                                    {
                                      var data = jsonDecode(response.body);
                                      if(data["code"]==200)
                                      {
                                        getModelList();
                                      }

                                      if (context.mounted){
                                        GlobalSnackBar.show(context, data["message"], response.statusCode);
                                      }

                                    }
                                    if (context.mounted){
                                      GlobalSnackBar.show(context, response.body, response.statusCode);
                                    }

                                  }, icon: modelList[index].active=='1'? Icon(Icons.check_circle_outlined, color: Colors.green,):Icon(Icons.unpublished_outlined, color: Colors.red,)),
                                ],
                              ): null,
                            ),
                          );
                        },
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: mediaQuery.size.width > 1200 ? 3 : 2,
                          childAspectRatio: mediaQuery.size.width > 1200 ? mediaQuery.size.width / 250 : mediaQuery.size.width / 150,
                        ),
                      )),
                ],
              ),
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
              title: Text("Add Product Model List", style: myTheme.textTheme.titleLarge),
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
                      DropdownMenu<PrdCateModel>(
                        controller: dropdownCatList,
                        errorText: showDdError ? 'Select category' : null,
                        hintText: 'Category',
                        width: MediaQuery.sizeOf(context).width/4.9,
                        //label: const Text('Category'),
                        dropdownMenuEntries: activeCatEntries,
                        inputDecorationTheme: const InputDecorationTheme(
                          filled: false,
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          border: OutlineInputBorder(),
                        ),
                        onSelected: (PrdCateModel? icon) {
                          setState(() {
                            sldCatID = icon!.categoryId;
                            showDdError = false;
                          });
                        },
                      ),
                      const SizedBox(height: 10,),
                      TextFormField(
                        controller: modelName,
                        validator: (value){
                          if(value==null ||value.isEmpty){
                            return 'Please fill out this field';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          border: OutlineInputBorder(),
                          labelText: 'Model Name',
                        ),
                      ),
                      const SizedBox(height: 13,),
                      TextFormField(
                        controller: modelDisc,
                        validator: (value){
                          if(value==null ||value.isEmpty){
                            return 'Please fill out this field';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          border: OutlineInputBorder(),
                          labelText: 'Model Description',
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
                      if (_formKey.currentState!.validate() && sldCatID!=0) {
                        _formKey.currentState!.save();

                        final prefs = await SharedPreferences.getInstance();
                        String userID = (prefs.getString('userId') ?? "");
                        final Response response;

                        if(editActive)
                        {
                          Map<String, Object> body = {
                            "categoryId": sldCatID.toString(),
                            "modelId": sldModelID.toString(),
                            'modelName': modelName.text,
                            'modelDescription': modelDisc.text,
                            'modifyUser': userID,
                          };
                          response = await HttpService().putRequest("updateModel", body);
                        }
                        else{
                          Map<String, Object> body = {
                            'categoryId': sldCatID.toString(),
                            'modelName': modelName.text,
                            'modelDescription': modelDisc.text,
                            'createUser': userID,
                          };
                          response = await HttpService().postRequest("createModel", body);
                        }

                        if(response.statusCode == 200)
                        {
                          var data = jsonDecode(response.body);
                          if(data["code"]==200)
                          {
                            modelName.clear();
                            modelDisc.clear();
                            dropdownCatList.clear();
                            showDdError = false;
                            sldCatID = 0;
                            getModelList();
                          }

                          if (context.mounted){
                            GlobalSnackBar.show(context, data["message"], response.statusCode);
                            Navigator.pop(dialogContext);
                          }
                        }
                      }
                      else{
                        if(sldCatID==0){
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
    );
  }

}
