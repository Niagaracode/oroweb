import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:oro_irrigation_new/constants/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/language.dart';
import '../constants/http_service.dart';

class MyPreference extends StatefulWidget {
  const MyPreference({Key? key, required this.userID}) : super(key: key);
  final int userID;

  @override
  State<MyPreference> createState() => _MyPreferenceState();
}

class _MyPreferenceState extends State<MyPreference>
{
  final List<LanguageList> languageList = <LanguageList>[];
  String _mySelection = 'English';

  // ImagePicker picker = ImagePicker();
  // XFile? image;

  String countryCode = '', mobileNo = '', userName = '', emailId = '', password = '';
  final TextEditingController _controllerMblNo = TextEditingController();
  final TextEditingController _controllerUsrName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPwd = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getUserInfo();
    getLanguage();
  }

  Future<void> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    countryCode = prefs.getString('countryCode')!;
    mobileNo = prefs.getString('mobileNumber')!;
    userName = prefs.getString('userName')!;
    emailId = prefs.getString('email')!;
    password = prefs.getString('password')!;

    _controllerMblNo.text = mobileNo;
    _controllerUsrName.text = userName;
    _controllerEmail.text = emailId;
    _controllerPwd.text = password;

  }

  // _getFromGallery() async {
  //   image = await picker.pickImage(source: ImageSource.gallery);
  // }

  Future<void> getLanguage() async
  {
    final response = await HttpService().postRequest("getLanguageByActive", {"active": '1'});
    if (response.statusCode == 200)
    {
      languageList.clear();
      var data = jsonDecode(response.body);
      if(data["code"]==200)
      {
        final cntList = data["data"] as List;
        for (int i=0; i < cntList.length; i++) {
          languageList.add(LanguageList.fromJson(cntList[i]));
        }
      }
      setState(() {
        languageList;
      });
    }
    else{
      //_showSnackBar(response.body);
    }
  }

  @override
  Widget build(BuildContext context)
  {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Container(
        color: Colors.blueGrey.shade50,
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.blueGrey.shade50,
                child: Row(
                  children: [
                    Flexible(
                      flex :1,
                      fit: FlexFit.loose,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            SizedBox(
                              height: height-80,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Container(
                                      height: 50,
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10.0),
                                            topRight: Radius.circular(10.0),
                                          )
                                      ),
                                      child: const ListTile(
                                        title: Text("Account Settings", style: TextStyle(fontSize: 20, color: Colors.black),),
                                        trailing: Icon(Icons.more_horiz, color: Colors.blue,),
                                      ),
                                    ),
                                    SizedBox(height: 2,child: Container(color: Colors.grey.shade200,)),
                                    Container(
                                      height: 380,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10.0),
                                          bottomRight: Radius.circular(10.0),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Flexible(
                                            flex :1,
                                            child: Padding(
                                              padding: const EdgeInsets.all(10.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [

                                                  Stack(
                                                    children: [
                                                      const Center(
                                                        child: CircleAvatar(
                                                          radius: 60.0,
                                                          //backgroundImage: image == null? AssetImage('assets/your_image.png') : File(image!.path),
                                                        ),
                                                      ),
                                                      // Positioned button in the bottom-right corner
                                                      Positioned(
                                                        bottom: 10.0,
                                                        right: 50.0,
                                                        child: GestureDetector(
                                                          onTap: () async {
                                                            print('Button tapped!');
                                                            //_getFromGallery();
                                                          },
                                                          child: const CircleAvatar(
                                                            radius: 20.0,
                                                            backgroundColor: Colors.blue,
                                                            child: Icon(
                                                              Icons.add,
                                                              color: Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            flex :2,
                                            child: Column(
                                              children: [
                                                const SizedBox(height: 20),
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
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(10.0), // Border radius
                                                    ),
                                                  ),
                                                  autoValidateMode: AutovalidateMode.disabled,
                                                  selectorTextStyle: const TextStyle(color: Colors.black),
                                                  initialValue: PhoneNumber(isoCode: 'IN'),
                                                  textFieldController: _controllerMblNo,
                                                  formatInput: false,
                                                  keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                                                  onSaved: (PhoneNumber number) {
                                                    //print('On Saved: $number');
                                                  },
                                                ),
                                                Form(
                                                  key: _formKey,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      const SizedBox(height: 20),
                                                      TextFormField(
                                                        controller: _controllerUsrName,
                                                        decoration: InputDecoration(
                                                          labelText: 'Name',
                                                          border: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(10.0), // Border radius
                                                          ),
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
                                                      const SizedBox(height: 20),
                                                      TextFormField(
                                                        controller: _controllerPwd,
                                                        decoration: InputDecoration(
                                                          labelText: 'Password',
                                                          border: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(10.0), // Border radius
                                                          ),
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
                                                      const SizedBox(height: 20),
                                                      TextFormField(
                                                        controller: _controllerEmail,
                                                        decoration: InputDecoration(
                                                          labelText: 'Email Id',
                                                          border: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(10.0), // Border radius
                                                          ),
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
                                                      const SizedBox(height: 20),
                                                      Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          MaterialButton(
                                                            color: Colors.grey,
                                                            textColor: Colors.white,
                                                            child: const Text('CANCEL'),
                                                            onPressed: () {

                                                            },
                                                          ),
                                                          const SizedBox(width: 20,),
                                                          MaterialButton(
                                                            color: Colors.blue,
                                                            textColor: Colors.white,
                                                            child: const Text('SAVE CHANGES'),
                                                            onPressed: () async {
                                                              try {
                                                                if (_formKey.currentState!.validate()) {
                                                                  final body = {"userId": widget.userID, "userName": _controllerUsrName.text, "countryCode": countryCode, "mobileNumber": _controllerMblNo.text,
                                                                    "emailAddress": _controllerEmail.text,"password": _controllerPwd.text,"modifyUser": widget.userID,};
                                                                  print(body);
                                                                  final response = await HttpService().putRequest("updateUserDetails", body);
                                                                  if (response.statusCode == 200) {
                                                                    final jsonResponse = json.decode(response.body);
                                                                    _showSnackBar(jsonResponse['message']);
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
                                          Flexible(
                                            flex :2,
                                            child: Padding(
                                              padding: const EdgeInsets.all(10.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade50,
                                                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                                                ),
                                                padding: const EdgeInsets.all(10),
                                                child: const Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text('When Mobile Number and Email update', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                                                    SizedBox(height: 10,),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 5,
                                                          child: Text("OTP (One-Time Password) is crucial when changing your "
                                                              "mobile number or email associated with the account"
                                                            , style: TextStyle(fontWeight: FontWeight.normal),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 15,),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 5,
                                                          child: Text("When you initiate such changes, the app often sends"
                                                              " an OTP to your current registered mobile number or email address."
                                                              " You need to enter this OTP to confirm and complete the update"
                                                            , style: TextStyle(fontWeight: FontWeight.normal),
                                                          ),
                                                        ),
                                                      ],
                                                    ),

                                                    SizedBox(height: 20,),
                                                    Text('Password requirement', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                                                    SizedBox(height: 10,),
                                                    Row(
                                                      children: [
                                                        Text('1.'),
                                                        SizedBox(width: 10,),
                                                        Text('at least 6 characters password', style: TextStyle(fontWeight: FontWeight.normal),),
                                                      ],
                                                    ),
                                                    SizedBox(height: 10,),
                                                    Row(
                                                      children: [
                                                        Text('2.'),
                                                        SizedBox(width: 10,),
                                                        Text('at least one uppercase letter', style: TextStyle(fontWeight: FontWeight.normal),),
                                                      ],
                                                    ),
                                                    SizedBox(height: 10,),
                                                    Row(
                                                      children: [
                                                        Text('3.'),
                                                        SizedBox(width: 10,),
                                                        Text('at least one number', style: TextStyle(fontWeight: FontWeight.normal),),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10,child: Container(color: Colors.grey.shade200,)),
                                    Container(
                                      height: 170,
                                      decoration: const BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Container(
                                                  height: 44,
                                                  decoration: const BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.only(
                                                      topRight: Radius.circular(10),
                                                      topLeft: Radius.circular(10),
                                                    ),
                                                  ),
                                                  child: const ListTile(
                                                    title: Text('Other Settings', style: TextStyle(fontSize: 20, color: Colors.black),),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    decoration: const BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.only(
                                                        bottomLeft: Radius.circular(10),
                                                        bottomRight: Radius.circular(10),
                                                      ),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Flexible(
                                                          flex :1,
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(15.0),
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                ListTile(
                                                                  title: const Text('Language'),
                                                                  leading: Icon(Icons.language, color: myTheme.primaryColor,),
                                                                  trailing: DropdownButton(
                                                                    items: languageList.map((item) {
                                                                      return DropdownMenuItem(
                                                                        value: item.languageName,
                                                                        child: Text(item.languageName),
                                                                      );
                                                                    }).toList(),
                                                                    onChanged: (newVal) {
                                                                      setState(() {
                                                                        _mySelection = newVal!;
                                                                      });
                                                                    },
                                                                    value: _mySelection,
                                                                  ),
                                                                ),
                                                                ListTile(
                                                                  title: const Text('Theme(Light/Dark)'),
                                                                  leading: Icon(Icons.color_lens_outlined,  color: myTheme.primaryColor,),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Flexible(
                                                          flex :1,
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(10.0),
                                                            child: Container(
                                                              decoration: const BoxDecoration(
                                                                color: Colors.white,
                                                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                                              ),
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  SwitchListTile(
                                                                    tileColor: Colors.red,
                                                                    secondary: Icon(Icons.notifications_none, color: myTheme.primaryColor,),
                                                                    title:  const Text('Push Notification'),
                                                                    value: true,
                                                                    onChanged:(bool? value) { },
                                                                  ),
                                                                  SwitchListTile(
                                                                    tileColor: Colors.red,
                                                                    secondary: Icon(Icons.volume_up_outlined, color: myTheme.primaryColor,),
                                                                    title:  const Text('Sound'),
                                                                    value: true,
                                                                    onChanged:(bool? value) { },
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
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
              ),
            ),
          ],
        ),
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
