import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/http_service.dart';

class AccountManagement extends StatefulWidget {
  const AccountManagement({Key? key, required this.userID, required this.callback}) : super(key: key);
  final int userID;
  final void Function(String) callback;

  @override
  State<AccountManagement> createState() => _AccountManagementState();
}

class _AccountManagementState extends State<AccountManagement> {
  String countryCode = '', mobileNo = '', userName = '', emailId = '', password = '';
  final TextEditingController controllerMblNo = TextEditingController();
  final TextEditingController controllerUsrName = TextEditingController();
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerPwd = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserAccountDetails();
  }

  Future<void> getUserAccountDetails() async {

    Map<String, Object> body = {'userId': widget.userID};
    final response = await HttpService().postRequest("getUser", body);
    if (response.statusCode == 200)
    {
      var data = jsonDecode(response.body);
      final cntList = data["data"] as List;
      print(response.body);

      countryCode = cntList[0]['countryCode']!;
      controllerMblNo.text = cntList[0]['mobileNumber']!;
      controllerUsrName.text = cntList[0]['userName']!;
      controllerEmail.text = cntList[0]['email']!;
      controllerPwd.text = cntList[0]['password']!;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userType', cntList[0]["userType"].toString());
      await prefs.setString('userName', cntList[0]["userName"].toString());
      await prefs.setString('userId', cntList[0]["userId"].toString());
      await prefs.setString('countryCode', cntList[0]["countryCode"].toString());
      await prefs.setString('mobileNumber', cntList[0]["mobileNumber"].toString());
      await prefs.setString('password', cntList[0]["password"].toString());
      await prefs.setString('email', cntList[0]["email"].toString());

      setState(() {
        countryCode;
      });
    }

  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings'),
      ),
      backgroundColor: Colors.teal.shade50,
      body: SingleChildScrollView(
        child: Center(
          child: screenWidth>600? buildWideLayout(screenWidth): buildNarrowLayout(screenWidth),
        ),
      ),

    );
  }

  Widget buildNarrowLayout(screenWidth)
  {
    return Column(
      children: [
        const SizedBox(height: 10,),
        SizedBox(
          width: screenWidth-40,
          height: 325,
          child: returnForm(),
        ),
        SizedBox(
          width: MediaQuery.sizeOf(context).width-40,
          height: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 15,),
              Text('When Mobile Number and Email update', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
              SizedBox(height: 8,),
              Text("OTP (One-Time Password) is crucial when changing your "
                  "mobile number or email associated with the account."
                , style: TextStyle(fontWeight: FontWeight.normal),
              ),
              Text("When you initiate such changes, the app often sends"
                  " an OTP to your current registered mobile number or email address."
                  " You need to enter this OTP to confirm and complete the update."
                , style: TextStyle(fontWeight: FontWeight.normal),
              ),
              SizedBox(height: 20,),
              Text('Password requirement', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
              SizedBox(height: 8,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('1.'),
                      SizedBox(width: 5,),
                      Text('at least 6 characters password', style: TextStyle(fontWeight: FontWeight.normal),),
                    ],
                  ),
                  SizedBox(width: 8,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('2.'),
                      SizedBox(width: 5,),
                      Text('at least one uppercase letter', style: TextStyle(fontWeight: FontWeight.normal),),
                    ],
                  ),
                  SizedBox(width: 8,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('3.'),
                      SizedBox(width: 5,),
                      Text('at least one number', style: TextStyle(fontWeight: FontWeight.normal),),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget buildWideLayout(screenWidth) {
    return Column(
      children: [
        const SizedBox(height: 20,),
        SizedBox(
          width: 400,
          height: 325,
          child: returnForm(),
        ),
        SizedBox(
          width: MediaQuery.sizeOf(context).width-200,
          height: 200,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 15,),
              Text('When Mobile Number and Email update', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
              SizedBox(height: 8,),
              Text("OTP (One-Time Password) is crucial when changing your "
                  "mobile number or email associated with the account."
                , style: TextStyle(fontWeight: FontWeight.normal),
              ),
              Text("When you initiate such changes, the app often sends"
                  " an OTP to your current registered mobile number or email address."
                  " You need to enter this OTP to confirm and complete the update."
                , style: TextStyle(fontWeight: FontWeight.normal),
              ),
              SizedBox(height: 20,),
              Text('Password requirement', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
              SizedBox(height: 8,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('1.'),
                  SizedBox(width: 5,),
                  Text('at least 6 characters password', style: TextStyle(fontWeight: FontWeight.normal),),

                  SizedBox(width: 10,),

                  Text('2.'),
                  SizedBox(width: 5,),
                  Text('at least one uppercase letter', style: TextStyle(fontWeight: FontWeight.normal),),

                  SizedBox(width: 10,),

                  Text('3.'),
                  SizedBox(width: 5,),
                  Text('at least one number', style: TextStyle(fontWeight: FontWeight.normal),),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget returnForm() {
    return Card(
      surfaceTintColor: Colors.white,
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number) {
                //print(number.phoneNumber);
              },
              selectorConfig: const SelectorConfig(
                selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                setSelectorButtonAsPrefixIcon: true,
                leadingPadding: 10,
                useEmoji: false,
              ),
              ignoreBlank: false,
              inputDecoration: InputDecoration(
                labelText: 'Mobile Number',
                /* border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0), // Border radius
                              ),*/
              ),
              autoValidateMode: AutovalidateMode.disabled,
              selectorTextStyle: const TextStyle(color: Colors.black),
              initialValue: PhoneNumber(isoCode: 'IN'),
              textFieldController: controllerMblNo,
              formatInput: false,
              keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
              onSaved: (PhoneNumber number) {
                //print('On Saved: $number');
              },
            ),
            Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: controllerUsrName,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      /*border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0), // Border radius
                                    ),*/
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        //_name = value;
                      });
                    },
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: controllerPwd,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      /*border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0), // Border radius
                                    ),*/
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        //_name = value;
                      });
                    },
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: controllerEmail,
                    decoration: InputDecoration(
                      labelText: 'Email Id',
                      /*border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0), // Border radius
                                    ),*/
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email id';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        //_name = value;
                      });
                    },
                  ),
                  const SizedBox(height: 15),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      MaterialButton(
                        color: Colors.redAccent,
                        textColor: Colors.white,
                        child: const Text('CANCEL'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(width: 20,),
                      MaterialButton(
                        color: Colors.green,
                        textColor: Colors.white,
                        child: const Text('SAVE CHANGES'),
                        onPressed: () async {
                          try {
                            if (formKey.currentState!.validate()) {
                              final body = {"userId": widget.userID, "userName": controllerUsrName.text, "countryCode": countryCode, "mobileNumber": controllerMblNo.text,
                                "emailAddress": controllerEmail.text,"password": controllerPwd.text,"modifyUser": widget.userID,};
                              print(body);
                              final response = await HttpService().putRequest("updateUserDetails", body);
                              if (response.statusCode == 200) {
                                final jsonResponse = json.decode(response.body);
                                widget.callback(jsonResponse['message']);
                              }
                            }
                          } catch (e) {
                            print('Error: $e');
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
