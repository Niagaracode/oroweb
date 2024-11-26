import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/product_type.dart';
import '../../constants/http_service.dart';
import '../../constants/theme.dart';

class AddProductType extends StatefulWidget {
  const AddProductType({Key? key}) : super(key: key);

  @override
  State<AddProductType> createState() => _AddProductTypeState();
}

class _AddProductTypeState extends State<AddProductType> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController productTypeCtl = TextEditingController();
  TextEditingController productDisCtl = TextEditingController();

  List<ProductType> productTypeList = <ProductType>[];
  bool editPrdType = false;
  bool editActive = false;
  int sldPrdTypeID = 0;

  bool visibleLoading = false;

  @override
  void initState() {
    super.initState();
    getProductTypeList();
  }

  Future<void> getProductTypeList() async
  {
    indicatorViewShow();
    await Future.delayed(const Duration(milliseconds: 500));
    Map<String, Object> body = {};
    final response = await HttpService().postRequest("getProductType", body);
    if (response.statusCode == 200)
    {
      productTypeList.clear();
      var data = jsonDecode(response.body);
      final cntList = data["data"] as List;

      for (int i=0; i < cntList.length; i++) {
        productTypeList.add(ProductType.fromJson(cntList[i]));
      }
      setState(() {
        productTypeList;
        indicatorViewHide();
      });
    }
    else{
      _showSnackBar(response.body);
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

  @override
  Widget build(BuildContext context)
  {
    final mediaQuery = MediaQuery.of(context);
    //final Color color = Colors.primaries[contactList.length % Colors.primaries.length];
    return visibleLoading? Visibility(
      visible: visibleLoading,
      child: Container(
        padding: EdgeInsets.fromLTRB(mediaQuery.size.width/2 - 50, 0, mediaQuery.size.width/2 - 50, 0),
        child: const LoadingIndicator(
          indicatorType: Indicator.ballPulseRise,
        ),
      ),
    ) : Container(
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
                    title: Text('Product Types', style: myTheme.textTheme.titleLarge),
                    subtitle: Text('Product types with Description', style: myTheme.textTheme.titleSmall),
                    trailing: Wrap(
                      spacing: 12, // space between two icons
                      children: <Widget>[
                        IconButton(
                            tooltip: 'Edit and hide Product Type',
                            onPressed: ()
                            {
                              setState(() {
                                editPrdType = !editPrdType;
                                editActive = false;
                              });
                              productTypeCtl.clear();
                              productDisCtl.clear();
                            }, icon: editPrdType ? Icon(Icons.done_all, color: myTheme.primaryColor,) : Icon(Icons.edit_note_outlined, color: myTheme.primaryColor,)), // icon-1
                        IconButton(
                          icon: Icon(Icons.add_circle_outline, color: myTheme.primaryColor,),
                          tooltip: 'Add new Product type',
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
                        itemCount: productTypeList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsetsDirectional.all(5.0),
                            decoration: BoxDecoration(
                              color: productTypeList[index].active=='1'? myTheme.primaryColor.withOpacity(0.2) : Colors.red.shade100,
                              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                            ),
                            child: ListTile(
                              leading: Icon(Icons.print_disabled_outlined, color: myTheme.primaryColor,),
                              title: Text(productTypeList[index].product,),
                              subtitle: Text(productTypeList[index].productDescription, style: myTheme.textTheme.titleSmall,),
                              trailing: editPrdType ? Wrap(
                                spacing: 12, // space between two icons
                                children: <Widget>[
                                  IconButton(onPressed: ()
                                  async {
                                    productTypeCtl.text = productTypeList[index].product;
                                    productDisCtl.text = productTypeList[index].productDescription;
                                    sldPrdTypeID = productTypeList[index].productTypeId;

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
                                      'productTypeId': productTypeList[index].productTypeId.toString(),
                                      'modifyUser': userID,
                                    };

                                    final Response response;
                                    if(productTypeList[index].active=='1'){
                                      response = await HttpService().putRequest("inactiveProductType", body);
                                    }else{
                                      response = await HttpService().putRequest("activeProductType", body);
                                    }

                                    if(response.statusCode == 200)
                                    {
                                      var data = jsonDecode(response.body);
                                      if(data["code"]==200)
                                      {
                                        _showSnackBar(data["message"]);
                                        getProductTypeList();
                                      }
                                      else{
                                        _showSnackBar(data["message"]);
                                      }
                                    }else{
                                      _showSnackBar(response.body);
                                    }

                                  }, icon: productTypeList[index].active=='1'? Icon(Icons.check_circle_outlined, color: Colors.green,):Icon(Icons.unpublished_outlined, color: Colors.red,)),
                                ],
                              ): null,
                            ),
                          );
                        },
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: mediaQuery.size.width > 1200 ? 4 : 3,
                          childAspectRatio: editPrdType ? mediaQuery.size.width / 350 : mediaQuery.size.width / 300,
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
              title: Text("Add Product Type", style: myTheme.textTheme.titleLarge),
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
                        controller: productTypeCtl,
                        validator: (value){
                          if(value==null ||value.isEmpty){
                            return 'Please fill out this field';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          border: OutlineInputBorder(),
                          labelText: 'Product Type',
                          icon: Icon(Icons.contactless_outlined),
                        ),
                      ),
                      const SizedBox(height: 13,),
                      TextFormField(
                        controller: productDisCtl,
                        validator: (value){
                          if(value==null ||value.isEmpty){
                            return 'Please fill out this field';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          border: OutlineInputBorder(),
                          labelText: 'Product Description',
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
                          print(sldPrdTypeID);
                          Map<String, Object> body = {
                            "productTypeId": sldPrdTypeID.toString(),
                            'product': productTypeCtl.text,
                            'productDescription': productDisCtl.text,
                            'modifyUser': userID,
                          };
                          response = await HttpService().putRequest("updateProductType", body);
                        }
                        else{
                          Map<String, Object> body = {
                            'product': productTypeCtl.text,
                            'productDescription': productDisCtl.text,
                            'createUser': userID,
                          };
                          response = await HttpService().postRequest("createProductType", body);
                        }

                        if(response.statusCode == 200)
                        {
                          var data = jsonDecode(response.body);
                          if(data["code"]==200)
                          {
                            productTypeCtl.clear();
                            productDisCtl.clear();
                            _showSnackBar(data["message"]);
                            getProductTypeList();
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
