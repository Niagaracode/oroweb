import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/country_list.dart';
import '../../Models/state_list.dart';
import '../../constants/http_service.dart';
import '../../constants/snack_bar.dart';
import '../../constants/theme.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key, required this.callback, required this.subUsrAccount, required this.customerId, required this.from,}) : super(key: key);
  final void Function(String) callback;
  final bool subUsrAccount;
  final int customerId;
  final String from;

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {

  String userID = '0';
  String userType = '0';
  String userMobileNo = '0';

  final _formKey = GlobalKey<FormState>();

  // Form fields values
  String? name;
  String? email;
  String? country;
  String? state;
  String? city;
  String? address;
  final TextEditingController _cusMobileNoController = TextEditingController();

  List<CountryListMDL> countryList = <CountryListMDL>[];
  int sldCountryID = 0;
  bool showConError = false;

  List<StateListMDL> stateList = <StateListMDL>[];
  int sldStateID = 0;
  bool showStateError = false;

  String dialCode = '91';

  //
  List<String> _countries = [];
  List<String> _states = [];

  String message = "No message yet";
  void updateMessage(String newMessage) {
    setState(() {
      message = newMessage;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
    getCountryList();
  }

  Future<void> getUserInfo() async
  {
    final prefs = await SharedPreferences.getInstance();
    userID = (prefs.getString('userId') ?? "");
    userType = (prefs.getString('userType') ?? "");
    userMobileNo = (prefs.getString('mobileNumber') ?? "");
  }

  Future<void> getCountryList() async {
    Map<String, Object> body = {};
    final response = await HttpService().postRequest("getCountry", body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      final cntList = data["data"] as List;

      setState(() {
        _countries = cntList
            .map((country) => country['countryName'] as String)
            .toList();
        countryList = List<CountryListMDL>.from(
          cntList.map((countryData) => CountryListMDL.fromJson(countryData)),
        );
      });
    } else {
      // Handle error
    }
  }

  Future<void> getStateList(String countryId) async {
    Map<String, Object> body = {
      "countryId": countryId,
    };

    final response = await HttpService().postRequest("getState", body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      final cntList = data["data"] as List;

      state = null;
      setState(() {
        _states = cntList
            .map((state) => state['stateName'] as String)
            .toList();
        stateList = List<StateListMDL>.from(
          cntList.map((stateData) => StateListMDL.fromJson(stateData)),
        );
      });
    } else {
      // Handle error
    }
  }

  int? getCountryIdByName(String countryName) {
    final country = countryList.firstWhere(
          (country) => country.countryName.toLowerCase() == countryName.toLowerCase(),
    );
    return country.countryId;
  }

  int? getStateIdByName(String stateName) {
    final state = stateList.firstWhere(
          (sate) => sate.stateName.toLowerCase() == stateName.toLowerCase(),
    );
    return state.stateId;
  }

  @override
  Widget build(BuildContext context)
  {
    return Column(
      children: [
        _buildHeader(),
        const Divider(height: 0),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildFormContent(),
              ],
            ),
          ),
        ),
        _buildFooter(),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 2,right: 2, top: 2),
      child: ListTile(
        title: Text(widget.from=='Admin'? "Dealer Account Form" : widget.from=='Dealer'? "Customer Account Form": "Sub User Account Form", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: const Text("Please fill out all the details correctly.", style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
      ),
    );
  }


  Widget _buildFormContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // name Field
            TextFormField(
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                labelText: 'Full Name',
                icon: Icon(Icons.text_fields, color: myTheme.primaryColor,),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return widget.from=='Admin'? "Please enter your dealer name" : widget.from=='Dealer'? "Please enter your customer name": "Please enter your sub user name";
                }
                return null;
              },
              onSaved: (value) => name = value,
              inputFormatters: [
                CapitalizeFirstLetterFormatter(),
              ],
            ),
            const SizedBox(height: 15),

            // mobile Field
            InternationalPhoneNumberInput(
              validator: (value){
                if(value==null ||value.isEmpty){
                  return widget.from=='Admin'? "Please enter your dealer mobile number" : widget.from=='Dealer'? "Please enter your customer mobile number": "Please enter your sub user mobile number";
                }
                return null;
              },
              inputDecoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                icon:  Icon(Icons.phone_outlined, color: myTheme.primaryColor,),
                labelText: 'Mobile Number',
              ),
              onInputChanged: (PhoneNumber number) {
              },
              selectorConfig: const SelectorConfig(
                selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                setSelectorButtonAsPrefixIcon: true,
                leadingPadding: 10,
                useEmoji: true,
              ),
              ignoreBlank: false,
              autoValidateMode: AutovalidateMode.disabled,
              selectorTextStyle: myTheme.textTheme.titleMedium,
              initialValue: PhoneNumber(isoCode: 'IN'),
              textFieldController: _cusMobileNoController,
              formatInput: false,
              keyboardType:
              const TextInputType.numberWithOptions(signed: true, decimal: true),
              onSaved: (PhoneNumber number) {
                dialCode = number.dialCode.toString();
              },
            ),
            const SizedBox(height: 15),

            // Email Field
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Email Address',
                icon: Icon(Icons.email_outlined, color: myTheme.primaryColor,),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return widget.from=='Admin'? "Please enter your dealer email" : widget.from=='Dealer'? "Please enter your customer email": "Please enter your sub user email";
                }
                if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
              onSaved: (value) => email = value,
            ),
            const SizedBox(height: 15),

            // Country Dropdown
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Country',
                icon: Icon(CupertinoIcons.globe, color: myTheme.primaryColor,),
              ),
              value: country,
              items: _countries.map((countryItem) {
                return DropdownMenuItem(
                  value: countryItem,
                  child: Text(countryItem),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  country = value;
                  state = null;
                  _states.clear();
                  sldCountryID = getCountryIdByName(value.toString())!;
                });
                getStateList(sldCountryID.toString());
              },
              validator: (value) {
                if (value == null) {
                  return widget.from=='Admin'? "Please select your dealer country" : widget.from=='Dealer'? "Please select your customer country": "Please select your sub user country";
                }
                return null;
              },
              onSaved: (value) => country = value,
            ),
            const SizedBox(height: 20),

            // State Dropdown
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'State',
                icon: Icon(CupertinoIcons.placemark, color: myTheme.primaryColor,),
              ),
              value: state,
              items: _states.map((stateItem) {
                return DropdownMenuItem(
                  value: stateItem,
                  child: Text(stateItem),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  state = value;
                  sldStateID = getStateIdByName(value.toString())!;
                });
              },
              validator: (value) {
                if (value == null) {
                  return widget.from=='Admin'? "Please select your dealer state" : widget.from=='Dealer'? "Please select your customer state": "Please select your sub user state";
                }
                return null;
              },
              onSaved: (value) => state = value,
            ),
            const SizedBox(height: 20),

            // city Field
            TextFormField(
              decoration: InputDecoration(
                labelText: 'City',
                icon: Icon(Icons.location_city, color: myTheme.primaryColor,),
              ),
              keyboardType: TextInputType.name,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return widget.from=='Admin'? "Please enter your dealer city" : widget.from=='Dealer'? "Please enter your customer city": "Please enter your sub user city";
                }
                return null;
              },
              onSaved: (value) => city = value,
              inputFormatters: [
                CapitalizeFirstLetterFormatter(),
              ],
            ),
            const SizedBox(height: 15),

            // Address Field
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Address',
                icon: Icon(Icons.linear_scale, color: myTheme.primaryColor,),
              ),
              keyboardType: TextInputType.streetAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return widget.from=='Admin'? "Please enter your dealer address" : widget.from=='Dealer'? "Please enter your customer address": "Please enter your sub user address";
                }
                return null;
              },
              onSaved: (value) => address = value,
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return SizedBox(
      height: 48,
      child: Column(
        children: [
          ListTile(
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                MaterialButton(
                  onPressed:() {
                    Navigator.pop(context);
                  },
                  textColor: Colors.white,
                  color: Colors.redAccent,
                  child: const Text('Cancel',style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 10),
                MaterialButton(
                  onPressed:() async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      String cusType = widget.from=='Admin'? '2':'3';
                      Map<String, Object> body = {
                        'userName': name.toString(),
                        'countryCode': dialCode.contains('+')?dialCode.replaceAll('+', ''):dialCode,
                        'mobileNumber': _cusMobileNoController.text,
                        'userType': cusType,
                        'macAddress': '1234567890',
                        'deviceToken': '12346789abcdefghijklmnopqrstuvwxyz987654321',
                        'mobCctv': '987654321zyxwvutsrqponmlkjihgfedcba123456789',
                        'createUser': widget.customerId,
                        'address1': address.toString(),
                        'address2': '-',
                        'address3': '-',
                        'city': city.toString(),
                        'postalCode': '-',
                        'country': sldCountryID.toString(),
                        'state': sldStateID.toString(),
                        'email': email.toString(),
                        'mainUserId': userID,
                      };

                      final response = widget.subUsrAccount? await HttpService().postRequest("createUserAccountWithMainUser", body):
                      await HttpService().postRequest("createUser", body);
                      if(response.statusCode == 200)
                      {
                        var data = jsonDecode(response.body);
                        if(data["code"]==200)
                        {
                          widget.callback('reloadCustomer');
                          if(mounted){
                            Navigator.pop(context);
                          }
                        }
                        else{
                          if(data["code"]==409){
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Sub user'),
                                content: const Text('The mobile number already registered. Are you sure! You want add this customer?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () async {
                                      Map<String, Object> body = {
                                        'countryCode': dialCode,
                                        'mobileNumber': _cusMobileNoController.text,
                                        'modifyUser': userID,
                                        'mainUserId': widget.customerId,
                                      };
                                      final response = await HttpService().putRequest("updateMainUserDetail", body);
                                      if(response.statusCode == 200)
                                      {
                                        var data = jsonDecode(response.body);
                                        if(data["code"]==200)
                                        {
                                          widget.callback('reloadCustomer');
                                          if(mounted){
                                            Navigator.of(ctx).pop();
                                            Navigator.pop(context);
                                          }
                                        }
                                        else{
                                          Navigator.of(ctx).pop();
                                          _showAlertDialog('Warning', data["message"]);
                                        }
                                      }

                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      child: const Text("Add"),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(ctx).pop();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      child: const Text("Cancel"),
                                    ),
                                  ),
                                ],
                              ),
                            );

                          }else{
                            _showAlertDialog('Warning', data["message"]);
                          }
                        }
                      }
                    }
                  },
                  textColor: Colors.white,
                  color: myTheme.primaryColor,
                  child: const Text('Create Account',style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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

class CapitalizeFirstLetterFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    if (newValue.text.isNotEmpty) {
      return TextEditingValue(
        text: newValue.text[0].toUpperCase() + newValue.text.substring(1),
        selection: newValue.selection,
      );
    }
    return newValue;
  }
}
