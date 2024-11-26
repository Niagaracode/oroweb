import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:oro_irrigation_new/constants/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/http_service.dart';


TextEditingController _mobileNoController = TextEditingController();
TextEditingController _passwordController = TextEditingController();
bool _isObscure = true;
bool isValid = false;
bool visibleLoading = false;
bool _validate = false;

String strTitle = 'ORO DRIP IRRIGATION';
String strSubTitle = 'Drip irrigation is a type of watering system used in agriculture, gardening, and landscaping to efficiently deliver water directly to the roots of plants.';
String strOtpText = 'We will send you an OPT(One Time password) to the entered customer mobile number';
String strLoginRequiredText = 'Login Required for Controller Buyers Please sign in if you have purchased our Pump or Drip irrigation controller to unlock exclusive features.';

class LoginForm extends StatefulWidget
{
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}


class _LoginFormState extends State<LoginForm> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: screenWidth > 600 ? buildWideLayout(screenWidth) : buildNarrowLayout(screenWidth),
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

  Widget buildWideLayout(double screenWidth) {
    return Row(
      children: [
        Expanded(
          flex:2,
          child: Container(
              width: double.infinity, height: double.infinity,
              color: myTheme.primaryColor,
              child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: SvgPicture.asset('assets/SVGPicture/login_left_picture.svg'),
              )
          ),
        ),
        Expanded(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Expanded(
                      child: Container(
                        color: Colors.white,
                        child: Row(
                          children: [
                            Expanded(flex: 3, child: Container()),
                            const Image(image: AssetImage('assets/images/login_top_corner.png')),
                          ],
                        ),
                      )
                  ),
                  Expanded(
                      flex:5,
                      child:
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, right: 40),
                            child: Column(
                              children: [
                                SvgPicture.asset('assets/SVGPicture/oro_logo.svg', fit: BoxFit.cover),
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
                                  child: Text(strSubTitle, style: myTheme.textTheme.titleSmall,),
                                ),
                                const SizedBox(height: 15,),
                                SizedBox(height: 50,
                                  child: InternationalPhoneNumberInput(
                                    inputDecoration: InputDecoration(
                                      border: const OutlineInputBorder(),
                                      icon: const Icon(Icons.phone_outlined),
                                      labelText: 'Phone Number',
                                      suffixIcon: IconButton(icon: const Icon(Icons.clear, color: Colors.red,),
                                          onPressed: () {
                                            _mobileNoController.clear();
                                          }),
                                    ),
                                    onInputChanged: (PhoneNumber number) {
                                      //print(number);
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
                                    textFieldController: _mobileNoController,
                                    formatInput: false,
                                    keyboardType:
                                    const TextInputType.numberWithOptions(signed: true, decimal: true),
                                    onSaved: (PhoneNumber number) {
                                      //print('On Saved: $number');
                                    },
                                  ),
                                ),
                                const SizedBox(height: 15,),
                                TextField(
                                  controller: _passwordController,
                                  obscureText: _isObscure,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                    border: const OutlineInputBorder(),
                                    icon: const Icon(Icons.lock_outline),
                                    labelText: 'Password',
                                    suffixIcon: IconButton(icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
                                        onPressed: () {
                                          setState(() {
                                            _isObscure = !_isObscure;
                                          });
                                        }),
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                SizedBox(
                                    height: 30,
                                    width: screenWidth,
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 2, left: 40),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text("Forgot Password ?", style: myTheme.textTheme.bodyMedium),
                                        ],
                                      ),
                                    )
                                ),
                                const SizedBox(height: 15,),
                                SizedBox(
                                  width: 150.0,
                                  height: 40.0,
                                  child: MaterialButton(
                                    color: myTheme.primaryColor,
                                    textColor: Colors.white,
                                    child: const Text('CONTINUE'),
                                    onPressed: () async {
                                      setState(() {
                                        _mobileNoController.text.isEmpty ||_passwordController.text.isEmpty ? _showSnackBar('Value Can\'t Be Empty') :
                                        _mobileNoController.text.length < 6 || _passwordController.text.length < 5 ? _showSnackBar('Invalid Mobile number or Password') : _validate = true;
                                      });
                                      if(_validate)
                                      {

                                        String uniqueID;
                                        try {
                                          DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                                          WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
                                          uniqueID = webBrowserInfo.userAgent ?? 'Unknown';
                                        } catch (e) {
                                          uniqueID = "Failed to get unique ID: $e";
                                        }

                                        Map<String, Object> body = {
                                          'mobileNumber': _mobileNoController.text,
                                          'password': _passwordController.text,
                                        };
                                        final response = await HttpService().postRequest("userSignIn", body);
                                        //print(response.body);
                                        if(response.statusCode == 200)
                                        {
                                          var data = jsonDecode(response.body);
                                          if(data["code"]==200)
                                          {
                                            _mobileNoController.clear();
                                            _passwordController.clear();

                                            final customerData = data["data"];
                                            final customerInfo = customerData["user"];

                                            final prefs = await SharedPreferences.getInstance();
                                            await prefs.setString('userType', customerInfo["userType"].toString());
                                            await prefs.setString('userName', customerInfo["userName"].toString());
                                            await prefs.setString('userId', customerInfo["userId"].toString());
                                            await prefs.setString('countryCode', customerInfo["countryCode"].toString());
                                            await prefs.setString('mobileNumber', customerInfo["mobileNumber"].toString());
                                            await prefs.setString('password', customerInfo["password"].toString());
                                            await prefs.setString('email', customerInfo["email"].toString());

                                            /*if(customerInfo["userType"]=='1'){
                                              await prefs.setString('LoginType', 'Admin');
                                            }else if(customerInfo["userType"]=='2'){
                                              await prefs.setString('LoginType', 'Dealer');
                                            }else{
                                              await prefs.setString('LoginType', 'Customer');
                                            }*/

                                            if (mounted){
                                              Navigator.pushReplacementNamed(context, '/dashboard');
                                            }
                                          }
                                          else{
                                            _showSnackBar(data["message"]);
                                          }
                                        }
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(height: 15,),
                                RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(text: 'or Login with ', style: myTheme.textTheme.titleSmall),
                                      TextSpan(text: 'OTP', style: myTheme.textTheme.bodyMedium),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                  ),
                ],
              ),
            )
        ),
      ],
    );
  }




  Widget buildNarrowLayout(double screenWidth) {
    final PageController pageController = PageController(initialPage: 0);
    return Scaffold(
      body: PageView(
        controller: pageController,
        children: [
          Container(
            color: myTheme.primaryColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16,),
                SizedBox(
                  height: 50,
                  width: screenWidth,
                  child: SvgPicture.asset('assets/SVGPicture/oro_logo.svg', fit: BoxFit.fitHeight),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Flexible(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: SvgPicture.asset('assets/SVGPicture/login_left_picture.svg', fit: BoxFit.fitWidth, width: 500,),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(child: Text(strTitle, style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 20, color: Colors.white,))),
                              const SizedBox(height: 5,),
                              Text(strSubTitle,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.normal,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16,),
                SizedBox(
                  height: 55,
                  width: screenWidth,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 15),
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 5, right: 3, left: 3),
                          child: Image.asset('assets/images/company_logo.png'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Powered by', style: TextStyle(color: Colors.white, fontSize: 13)),
                          Text('Niagara Automation', style: TextStyle(color: Colors.white, fontSize: 10)),
                        ],
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    flex: 1,
                    child: SvgPicture.asset('assets/SVGPicture/login_top_pic.svg', width: screenWidth, fit: BoxFit.fitWidth,),
                  ),
                  Flexible(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8, right: 8),
                                child: Text(strLoginRequiredText,
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 35),
                              SizedBox(height: 50,
                                child: InternationalPhoneNumberInput(
                                  inputDecoration: InputDecoration(
                                    border: const OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white), // Change the border color here
                                    ),
                                    icon: const Icon(Icons.phone_outlined),
                                    labelText: 'Phone Number',
                                    suffixIcon: IconButton(icon: const Icon(Icons.clear, color: Colors.red,),
                                        onPressed: () {
                                          _mobileNoController.clear();
                                        }),
                                  ),
                                  onInputChanged: (PhoneNumber number) {
                                    //print(number);
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
                                  textFieldController: _mobileNoController,
                                  formatInput: false,
                                  keyboardType:
                                  const TextInputType.numberWithOptions(signed: true, decimal: true),
                                  onSaved: (PhoneNumber number) {
                                    //print('On Saved: $number');
                                  },
                                ),
                              ),
                              const SizedBox(height: 15,),
                              TextField(
                                controller: _passwordController,
                                obscureText: _isObscure,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                  border: const OutlineInputBorder(),
                                  icon: const Icon(Icons.lock_outline),
                                  labelText: 'Password',
                                  suffixIcon: IconButton(icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
                                      onPressed: () {
                                        setState(() {
                                          _isObscure = !_isObscure;
                                        });
                                      }),
                                ),
                              ),
                              const SizedBox(height: 15),
                              SizedBox(
                                  height: 30,
                                  width: screenWidth,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 2, left: 40),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text("Forgot Password ?", style: myTheme.textTheme.bodyMedium),
                                      ],
                                    ),
                                  )
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: screenWidth,
                                height: 45.0,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 40),
                                  child: MaterialButton(
                                    color: myTheme.primaryColor,
                                    textColor: Colors.white,
                                    child: const Text('CONTINUE', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
                                    onPressed: () async {
                                      setState(() {
                                        _mobileNoController.text.isEmpty ||_passwordController.text.isEmpty ? _showSnackBar('Value Can\'t Be Empty') :
                                        _mobileNoController.text.length < 6 || _passwordController.text.length < 5 ? _showSnackBar('Invalid Mobile number or Password') : _validate = true;
                                      });
                                      if(_validate)
                                      {

                                        Map<String, Object> body = {
                                          'mobileNumber': _mobileNoController.text,
                                          'password': _passwordController.text,
                                        };
                                        final response = await HttpService().postRequest("userSignIn", body);
                                        //print(response.body);
                                        if(response.statusCode == 200)
                                        {
                                          var data = jsonDecode(response.body);
                                          if(data["code"]==200)
                                          {
                                            _mobileNoController.clear();
                                            _passwordController.clear();

                                            final customerData = data["data"];
                                            final customerInfo = customerData["user"];

                                            List<dynamic> siteData = data['data']['site'];
                                            List<String> siteList = siteData.map((site) => json.encode(site)).toList();

                                            final prefs = await SharedPreferences.getInstance();
                                            await prefs.setString('userType', customerInfo["userType"].toString());
                                            await prefs.setString('userName', customerInfo["userName"].toString());
                                            await prefs.setString('userId', customerInfo["userId"].toString());
                                            await prefs.setString('countryCode', customerInfo["countryCode"].toString());
                                            await prefs.setString('mobileNumber', customerInfo["mobileNumber"].toString());
                                            await prefs.setString('password', customerInfo["password"].toString());
                                            await prefs.setString('email', customerInfo["email"].toString());
                                            //await prefs.setStringList('site', siteList);

                                            if (mounted){
                                              Navigator.pushReplacementNamed(context, '/dashboard');
                                            }
                                          }
                                          else{
                                            _showSnackBar(data["message"]);
                                          }
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(text: 'or Login with ', style: myTheme.textTheme.titleSmall),
                                    TextSpan(text: 'OTP', style: myTheme.textTheme.bodyMedium,),
                                  ],
                                ),
                              ),
                            ],
                          ),
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
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(width: 16.0),
          IconButton(onPressed: (){
            pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.bounceInOut,
            );
          }, icon: const Icon(Icons.forward_sharp, color: Colors.white)),
        ],
      ),
    );
  }


}


