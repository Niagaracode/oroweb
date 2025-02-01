import 'dart:convert';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:oro_irrigation_new/constants/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/product_model.dart';
import '../../constants/http_service.dart';

enum SampleItem { itemOne, itemTwo}

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key, required this.callback}) : super(key: key);
  final void Function(String) callback;

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {

  // Controllers
  final TextEditingController ddModelList = TextEditingController();
  final TextEditingController imeiController = TextEditingController();
  final TextEditingController ctrlPrdDis = TextEditingController();
  final TextEditingController ctrlWrM = TextEditingController();
  final TextEditingController ctrlDofM = TextEditingController();

  // Dropdown Data
  List<SimpleCategory> categoryList = [];
  List<DropdownMenuEntry<PrdModel>> modelEntries = [];
  SimpleCategory? selectedCategory;

  // State Variables
  int selectedCategoryId = 0;
  int selectedModelId = 0;
  bool isEditing = false;

  // Validation Flags
  bool showModelError = false;
  bool showWarrantyError = false;
  bool showDateError = false;

  // Product List
  List<Map<String, dynamic>> addedProductList = [];

  @override
  void initState() {
    super.initState();
    fetchCategoryList();
    imeiController.addListener(() {
      imeiController.value = imeiController.value.copyWith(
        text: imeiController.text.toUpperCase(),
        selection: TextSelection.collapsed(offset: imeiController.text.length),
      );
    });
    ctrlWrM.text = '12';
    ctrlDofM.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
  }


  @override
  void dispose() {
    ddModelList.dispose();
    imeiController.dispose();
    ctrlPrdDis.dispose();
    ctrlWrM.dispose();
    ctrlDofM.dispose();
    super.dispose();
  }

  // Fetch category list
  Future<void> fetchCategoryList() async {
    try {
      final response = await HttpService().postRequest("getCategoryByActive", {"active": "1"});
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final categories = data["data"] as List?;
        if (categories != null) {
          setState(() {
            categoryList = categories.map((item) => SimpleCategory(
              id: item["categoryId"],
              name: item["categoryName"],
            )).toList();
          });
        }
      } else {
        print("Failed to fetch categories: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching categories: $e");
    }
  }

  // Fetch models based on category
  Future<void> fetchModelsByCategory(int categoryId) async {
    try {
      final response = await HttpService().postRequest("getModelByCategoryId", {"categoryId": categoryId.toString()});
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        modelEntries.clear();
        final models = data["data"] as List?;
        if (models != null) {
          setState(() {
            modelEntries = models.map((item) {
              final model = PrdModel.fromJson(item);
              return DropdownMenuEntry<PrdModel>(
                value: model,
                label: model.modelName,
              );
            }).toList();
          });
        }
      } else {
        print("Failed to fetch models: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching models: $e");
    }
  }

  @override
  Widget build(BuildContext context)
  {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 5.0),
          child: Row(
            children: [
              SizedBox(
                width:200,
                height: 50,
                child: DropdownButtonFormField<SimpleCategory>(
                  value: selectedCategory,
                  hint: const Text("Select a category",),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    filled: true,
                    fillColor: Colors.teal.shade50,
                  ),
                  items: categoryList.map((category) {
                    return DropdownMenuItem<SimpleCategory>(
                      value: category,
                      child: Text(
                        category.name,
                      ),
                    );
                  }).toList(),
                  onChanged: (SimpleCategory? newValue) {
                    selectedCategoryId = newValue!.id;
                    ddModelList.clear();
                    selectedModelId = 0;
                    fetchModelsByCategory(selectedCategoryId);
                    setState(() {
                      selectedCategory = newValue;
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              DropdownMenu<PrdModel>(
                controller: ddModelList,
                errorText: showModelError ? 'Select model' : null,
                width: 205,
                label: const Text('Model'),
                dropdownMenuEntries: modelEntries,
                inputDecorationTheme: InputDecorationTheme(
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  border: const OutlineInputBorder(),
                  fillColor: Colors.teal.shade50,
                ),
                onSelected: (PrdModel? mdl) {
                  setState(() {
                    selectedModelId = mdl!.modelId;
                    ddModelList.clear();
                    ddModelList.text = mdl.modelName;
                  });
                },
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 200,
                child: TextFormField(
                  maxLength: 12,
                  controller: imeiController,
                  decoration: InputDecoration(
                    counterText: '',
                    labelText: 'Device ID',
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.teal.shade50,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please fill out this field';
                    }
                    return null;
                  },
                ),
              ),

            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 5.0),
          child: Row(
            children: [
              SizedBox(
                width: 175,
                child: TextFormField(
                  controller: ctrlWrM,
                  validator: (value){
                    if(value==null || value.isEmpty){
                      return 'Please fill out this field';
                    }
                    return null;
                  },
                  maxLength: 2,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    counterText: '',
                    filled: true,
                    fillColor: Colors.teal.shade50,
                    errorText: showWarrantyError ? 'Enter warranty months' : null,
                    labelText: 'warranty months',
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 125,
                child: TextFormField(
                  validator: (value){
                    if(value==null || value.isEmpty){
                      return 'Please fill out this field';
                    }
                    return null;
                  },
                  controller: ctrlDofM,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.teal.shade50,
                    errorText: showDateError? 'Select Date' : null,
                    labelText: 'Date',
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  ),
                  onTap: ()
                  async
                  {
                    DateTime? date = DateTime(1900);
                    FocusScope.of(context).requestFocus(FocusNode());
                    date = await showDatePicker(
                        context: context,
                        initialDate:DateTime.now(),
                        firstDate:DateTime(1900),
                        lastDate: DateTime(2100));

                    ctrlDofM.text =  DateFormat('dd-MM-yyyy').format(date!);
                  },

                ),
              ),
              const SizedBox(width: 20),
              SizedBox(
                width: 100,
                child: MaterialButton(
                  color: Colors.teal,
                  textColor: Colors.white,
                  height: 55,
                  child: const Row(
                    children: [
                      Icon(Icons.add),
                      SizedBox(width: 8,),
                      Text('ADD'),
                    ],
                  ),
                  onPressed: () async {
                    if (selectedCategoryId!=0 && selectedModelId!=0) {
                      if (isNotEmpty(imeiController.text.trim()) && isNotEmpty(ctrlDofM.text) && isNotEmpty(ctrlWrM.text)) {
                        if (!isIMEIAlreadyExists(imeiController.text.trim(), addedProductList)) {
                          Map<String, Object> body = {"deviceId" : imeiController.text.trim(),};
                          final response = await HttpService().postRequest("checkProduct", body);
                          if (response.statusCode == 200)
                          {
                            var data = jsonDecode(response.body);
                            if(data['code']==404) {
                              Map<String, dynamic> productMap = {
                                "categoryName": selectedCategory!.name,
                                "categoryId": selectedCategoryId.toString(),
                                "modelName": ddModelList.text,
                                "modelId": selectedModelId.toString(),
                                "deviceId": imeiController.text.trim(),
                                "productDescription": ctrlPrdDis.text,
                                'dateOfManufacturing': ctrlDofM.text,
                                'warrantyMonths': ctrlWrM.text,
                              };
                              setState(() {
                                addedProductList.add(productMap);
                              });
                            }else{
                              _showAlertDialog('Alert Message', 'The product id already exists!');
                            }
                          }
                          else{
                            //_showSnackBar(response.body);
                          }
                        } else {
                          _showAlertDialog('Error!', 'Device id already exists!');
                        }
                      }else{
                        _showAlertDialog('Error!', 'Empty filed not allowed!');
                      }

                    }
                    else{
                      if(selectedModelId==0){
                        setState(() {
                          showModelError = true;
                        });
                      }
                    }
                  },
                ),
              ),
              const SizedBox(width: 25),
              SizedBox(
                width: 170,
                child: MaterialButton(
                  color: Colors.green,
                  textColor: Colors.white,
                  height: 55,
                  child: const Row(
                    children: [
                      Icon(Icons.save_as_outlined),
                      SizedBox(width: 8,),
                      Text('SAVE TO STOCK'),
                    ],
                  ),
                  onPressed: () async {
                    if(addedProductList.isNotEmpty)
                    {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Confirmation'),
                            content: const Text('Are you sure! You want to save the product to Stock list?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  final prefs = await SharedPreferences.getInstance();
                                  String userID = (prefs.getString('userId') ?? "");
                                  Map<String, Object> body = {
                                    'products': addedProductList,
                                    'createUser': userID,
                                  };

                                  final Response response = await HttpService().postRequest("createProduct", body);
                                  if(response.statusCode == 200)
                                  {
                                    var data = jsonDecode(response.body);
                                    if(data["code"]==200)
                                    {
                                      imeiController.clear();
                                      ctrlPrdDis.clear();
                                      ctrlDofM.clear();
                                      ctrlWrM.clear();
                                      widget.callback('reloadStock');
                                    }
                                    else{
                                      _showAlertDialog('Error', '${data["message"]}\n${data["data"].toString()}');
                                    }
                                  }
                                },
                                child: const Text('Save'),
                              ),
                            ],
                          );
                        },
                      );

                    }else{
                      _showAlertDialog('Alert Message', 'Product Empty!');
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16,),
        Expanded(
          child: DataTable2(
            columnSpacing: 12,
            horizontalMargin: 12,
            minWidth: 600,
            dataRowHeight: 35.0,
            headingRowHeight: 25.0,
            headingRowColor: WidgetStateProperty.all<Color>(myTheme.primaryColor.withOpacity(0.1)),
            columns: const [
              DataColumn2(
                  label: Center(child: Text('S.No')),
                  fixedWidth: 32
              ),
              DataColumn2(
                  label: Text('Category'),
                  size: ColumnSize.M
              ),
              DataColumn2(
                  label: Text('Model Name'),
                  size: ColumnSize.M
              ),
              DataColumn2(
                label: Text('Device Id'),
                fixedWidth: 150,
              ),
              DataColumn2(
                label: Center(child: Text('M.Date')),
                fixedWidth: 75,
              ),
              DataColumn2(
                label: Center(child: Text('Warranty')),
                fixedWidth: 70,
              ),
              DataColumn2(
                label: Center(child: Text('Action')),
                fixedWidth: 45,
              ),
            ],
            rows: List<DataRow>.generate(addedProductList.length, (index) => DataRow(cells: [
              DataCell(Center(child: Text('${index + 1}',style: const TextStyle(fontSize: 10)))),
              DataCell(Text(addedProductList[index]['categoryName'],style: const TextStyle(fontSize: 10))),
              DataCell(Text(addedProductList[index]['modelName'],style: const TextStyle(fontSize: 10))),
              DataCell(Text('${addedProductList[index]['deviceId']}',style: const TextStyle(fontSize: 10))),
              DataCell(Center(child: Text(addedProductList[index]['dateOfManufacturing'],style: const TextStyle(fontSize: 10)))),
              DataCell(Center(child: Text('${addedProductList[index]['warrantyMonths']}',style: const TextStyle(fontSize: 10)))),
              DataCell(Center(child: IconButton(
                tooltip: 'Remove',
                icon: const Icon(Icons.delete_outline, color: Colors.red,), // Specify the icon
                onPressed: () {
                  setState(() {
                    addedProductList.removeAt(index);
                  });
                },
              ), )),
            ])),
          ),
        ),
      ],
    );
  }

  bool isNotEmpty(String text) {
    return text.isNotEmpty;
  }

  bool isIMEIAlreadyExists(String newIMEI, List<Map<String, dynamic>> productList) {
    for (var product in productList) {
      if (product['deviceId'] == newIMEI) {
        return true; // IMEI already exists
      }
    }
    return false; // IMEI does not exist
  }



  void _showAlertDialog(String title , String message)
  {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              child: const Text("okay"),
            ),
          ),
        ],
      ),
    );
  }

}

class SimpleCategory {
  final int id;
  final String name;

  SimpleCategory({required this.id, required this.name});
}
