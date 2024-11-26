import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/prd_cat_model.dart';
import '../../constants/http_service.dart';
import '../../constants/theme.dart';

class ProductCategory extends StatefulWidget {
  const ProductCategory({Key? key}) : super(key: key);

  @override
  State<ProductCategory> createState() => _ProductCategoryState();
}

class _ProductCategoryState extends State<ProductCategory> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController catName = TextEditingController();
  TextEditingController catSMSFormat = TextEditingController();
  TextEditingController relayCountCtrl = TextEditingController();

  List<PrdCateModel> categoryList = <PrdCateModel>[];
  bool editCategory= false;
  bool editActive = false;
  int sldCatID = 0;

  @override
  void initState() {
    super.initState();
    getCategoryList();
  }

  Future<void> getCategoryList() async
  {
    Map<String, Object> body = {};
    final response = await HttpService().postRequest("getCategory", body);
    print(response);
    if (response.statusCode == 200)
    {
      categoryList.clear();
      var data = jsonDecode(response.body);
      final cntList = data["data"] as List;

      for (int i=0; i < cntList.length; i++) {
        categoryList.add(PrdCateModel.fromJson(cntList[i]));
      }
      setState(() {
        categoryList;
      });
    }
    else{
      _showSnackBar(response.body);
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
                      title: Text('Product Category List', style: myTheme.textTheme.titleLarge),
                      subtitle: Text('Product Category with this details', style: myTheme.textTheme.titleSmall),
                      trailing: Wrap(
                        spacing: 12, // space between two icons
                        children: <Widget>[
                          IconButton(
                              onPressed: ()
                              {
                                setState(() {
                                  editCategory = !editCategory;
                                  editActive = false;
                                });
                                catName.clear();
                                catSMSFormat.clear();
                                relayCountCtrl.clear();
                              }, icon: editCategory ? Icon(Icons.done_all, color: myTheme.primaryColor,) : Icon(Icons.edit_note_outlined, color: myTheme.primaryColor,)),
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
                        itemCount: categoryList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsetsDirectional.all(5.0),
                            decoration: BoxDecoration(
                              color: categoryList[index].active=='1'? myTheme.primaryColor.withOpacity(0.2) : Colors.red.shade100,
                              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                            ),
                            child: ListTile(
                              title: Text(categoryList[index].categoryName,),
                              subtitle: Text(categoryList[index].smsFormat,),
                              trailing: editCategory ? Wrap(
                                spacing: 12, // space between two icons
                                children: <Widget>[
                                  IconButton(onPressed: ()
                                  async {
                                    catName.text = categoryList[index].categoryName;
                                    catSMSFormat.text = categoryList[index].smsFormat;
                                    relayCountCtrl.text = '${categoryList[index].outputCount}';
                                    sldCatID = categoryList[index].categoryId;

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
                                      'categoryId': categoryList[index].categoryId.toString(),
                                      'modifyUser': userID,
                                    };

                                    final Response response;
                                    if(categoryList[index].active=='1'){
                                      response = await HttpService().putRequest("inactiveCategory", body);
                                    }else{
                                      response = await HttpService().putRequest("activeCategory", body);
                                    }

                                    if(response.statusCode == 200)
                                    {
                                      var data = jsonDecode(response.body);
                                      if(data["code"]==200)
                                      {
                                        _showSnackBar(data["message"]);
                                        getCategoryList();
                                        //Navigator.pop(context);
                                      }
                                      else{
                                        _showSnackBar(data["message"]);
                                      }
                                    }else{
                                      _showSnackBar(response.body);
                                    }

                                  }, icon: categoryList[index].active=='1'? Icon(Icons.check_circle_outlined, color: Colors.green,):Icon(Icons.unpublished_outlined, color: Colors.red,)),
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
              title: Text("Add Product Category", style: myTheme.textTheme.titleLarge),
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
                        controller: catName,
                        validator: (value){
                          if(value==null ||value.isEmpty){
                            return 'Please fill out this field';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          border: OutlineInputBorder(),
                          labelText: 'Category Name',
                          icon: Icon(Icons.contactless_outlined),
                        ),
                      ),
                      const SizedBox(height: 13,),
                      TextFormField(
                        controller: catSMSFormat,
                        validator: (value){
                          if(value==null ||value.isEmpty){
                            return 'Please fill out this field';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          border: OutlineInputBorder(),
                          labelText: 'SMS Format',
                          icon: Icon(Icons.content_paste_go),
                        ),
                      ),
                      const SizedBox(height: 13,),
                      TextFormField(
                        controller: relayCountCtrl,
                        validator: (value){
                          if(value==null ||value.isEmpty){
                            return 'Please fill out this field';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          border: OutlineInputBorder(),
                          labelText: 'Relay Count',
                          icon: Icon(Icons.numbers),
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
                          print(sldCatID);
                          Map<String, Object> body = {
                            "categoryId": sldCatID.toString(),
                            'categoryName': catName.text,
                            'smsFormat': catSMSFormat.text,
                            'relayCount': relayCountCtrl.text,
                            'modifyUser': userID,
                          };
                          response = await HttpService().putRequest("updateCategory", body);
                        }
                        else{
                          Map<String, Object> body = {
                            'categoryName': catName.text,
                            'smsFormat': catSMSFormat.text,
                            'relayCount': relayCountCtrl.text,
                            'createUser': userID,
                          };
                          response = await HttpService().postRequest("createCategory", body);
                        }

                        if(response.statusCode == 200)
                        {
                          var data = jsonDecode(response.body);
                          if(data["code"]==200)
                          {
                            catName.clear();
                            catSMSFormat.clear();
                            _showSnackBar(data["message"]);
                            getCategoryList();
                          }
                          else{
                            _showSnackBar(data["message"]);
                          }
                          Navigator.pop(dialogContext);
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
