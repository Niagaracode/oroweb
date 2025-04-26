import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oro_irrigation_new/Screens/Customer/IrrigationProgram/preview_screen.dart';
import 'package:oro_irrigation_new/Screens/Customer/IrrigationProgram/schedule_screen.dart';

import '../../constants/http_service.dart';
import '../../constants/theme.dart';


class CopyConfigDataScreen extends StatefulWidget {
  final int userId;
  final int controllerId;
  final int createUser;
  final dynamic capacity;
  const CopyConfigDataScreen({super.key, this.capacity, required this.userId, required this.controllerId, required this.createUser});

  @override
  State<CopyConfigDataScreen> createState() => _CopyConfigDataScreenState();
}

class _CopyConfigDataScreenState extends State<CopyConfigDataScreen> {
  List<dynamic> dealerList = [];
  List<dynamic> customerList = [];
  List<dynamic> masterList = [];
  int selectedDealer = 0;
  int selectedCustomer = 0;
  int selectedMaster = -1;

  @override
  void initState() {
    // TODO: implement initState
    getDealerList();
    super.initState();
  }

  void getDealerList()async{
    print(' called...............');
    try{
      HttpService service = HttpService();
      var response = await service.postRequest(
          'getDealerListForCopy',
          {

          });
      var jsonData = response.body;
      var myData = jsonDecode(jsonData);
      print('getDealerListForCopy myData => $myData');
      if(myData['code'] == 200){
        setState(() {
          dealerList = myData['data'];
        });
        if(dealerList.isNotEmpty){
          getCustomerList(userId: dealerList[0]['userId']);
        }

      }
    }catch(e){
      log(e.toString());
    }
  }
  void getCustomerList({required int userId})async{
    try{
      HttpService service = HttpService();
      var response = await service.postRequest(
          'getCustomerListForCopy',
          {
            "userId" : userId,
          });
      var jsonData = response.body;
      var myData = jsonDecode(jsonData);

      print('getCustomerListForCopy myData => $myData');
      if(myData['code'] == 200){
        setState(() {
          customerList = myData['data'];
        });
        if(customerList.isNotEmpty){
          getMasterList(userId: customerList[selectedCustomer]['userId']);
        }
      }
    }catch(e){
      log(e.toString());
    }
  }

  void getMasterList({required int userId})async{
    try{
      HttpService service = HttpService();
      var response = await service.postRequest(
          'getCustomerMasterDeviceForCopy',
          {
            "userId" : userId,
          });
      var jsonData = response.body;
      var myData = jsonDecode(jsonData);
      print('getCustomerMasterDeviceForCopy myData => $myData');
      if(myData['code'] == 200){
        setState(() {
          masterList = myData['data'];
        });
      }
    }catch(e){
      log(e.toString());
    }
  }


  void createrProductLimitAndConfigMaker({
    required int fromUserId,
    required int fromControllerId,
  })async{
    try{
      HttpService service = HttpService();
      var response = await service.postRequest(
          'createUserProductLimitAndConfigMakerFromCopy',
          {
            "fromUserId" : fromUserId,
            "fromControllerId" : fromControllerId,
            "userId" : widget.userId,
            "controllerId" : widget.controllerId,
            "createUser" : widget.createUser,
          });
      var jsonData = response.body;
      var myData = jsonDecode(jsonData);
      print('createUserProductLimitAndConfigMakerFromCopy myData => $myData');
    }catch(e){
      log(e.toString());
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Copy Config Data'),
      ),
      // body: SingleChildScrollView(
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       for(var i = 0;i < dealerList.length;i++)
      //         Container(
      //           width: double.infinity,
      //           margin: const EdgeInsets.all(10),
      //           padding: const EdgeInsets.all(8),
      //           decoration: BoxDecoration(
      //             borderRadius: BorderRadius.circular(20),
      //             color: Colors.white,
      //             boxShadow: customBoxShadow
      //           ),
      //           child: Column(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               Container(
      //                 width: 500,
      //                 padding: const EdgeInsets.all(8),
      //                 // decoration: BoxDecoration(
      //                 //     borderRadius: BorderRadius.circular(20),
      //                 //     color: Colors.green.shade100,
      //                 //     boxShadow: customBoxShadow
      //                 // ),
      //                 child: ListTile(
      //                     title: Text('${dealerList[i]['userName']}'),
      //                   trailing: MaterialButton(
      //                     color: Colors.blueGrey,
      //                     onPressed: (){
      //                       getCustomerList(userId: dealerList[i]['userId']);
      //                       setState(() {
      //                         if(i != selectedDealer){
      //                           selectedDealer = i;
      //                           selectedCustomer = -1;
      //                           selectedMaster = -1;
      //                           customerList = [];
      //                           masterList = [];
      //                         }
      //                       });
      //                     },
      //                     child: const Text('View Customer',style: TextStyle(color: Colors.white)),
      //                   ),
      //                 ),
      //               ),
      //               if(selectedDealer == i)
      //                 for(var customer = 0;customer < customerList.length;customer++)
      //                   Column(
      //                     children: [
      //                       Container(
      //                         width: 500,
      //                       margin: const EdgeInsets.only(bottom: 10,left: 20),
      //                       padding: const EdgeInsets.all(8),
      //                       decoration: BoxDecoration(
      //                           // borderRadius: BorderRadius.circular(10),
      //                           color: const Color(0xffFFF7E5),
      //                           boxShadow: customBoxShadow
      //                       ),
      //                         child: ListTile(
      //                           title: Text('${customerList[customer]['userName']}'),
      //                           trailing: MaterialButton(
      //                             color: Colors.green,
      //                             onPressed: (){
      //                               setState(() {
      //                                 selectedCustomer = customer;
      //                                 masterList = [];
      //                               });
      //                               getMasterList(userId: customerList[customer]['userId']);
      //                             },
      //                             child: const Text('View Master',style: TextStyle(color: Colors.white),),
      //                           ),
      //                         ),
      //                       ),
      //                       if(selectedCustomer == customer)
      //                         for(var master = 0;master < masterList.length;master++)
      //                           if([1,2].contains(masterList[master]['categoryId']))
      //                             Container(
      //                               width: 500,
      //                             margin: const EdgeInsets.only(bottom: 10,left: 40),
      //                             padding: const EdgeInsets.all(8),
      //                             decoration: BoxDecoration(
      //                                 borderRadius: BorderRadius.circular(10),
      //                                 color: const Color(0xffE7D6FF),
      //                                 boxShadow: customBoxShadow
      //                             ),
      //                             child: ListTile(
      //                               title: Text('${masterList[master]['deviceName']}'),
      //                               trailing: MaterialButton(
      //                                 color: const Color(0xff1D808E),
      //                                 onPressed: (){
      //                                   setState(() {
      //                                     selectedMaster = master;
      //                                   });
      //                                   bool showSuccess = true;
      //                                   var selectedCapacity = {};
      //                                   for(var i in masterList[master]['nodeList']){
      //                                     if(selectedCapacity['${i['categoryId']}'] == null){
      //                                       selectedCapacity['${i['categoryId']}'] = 0;
      //                                     }
      //                                     selectedCapacity['${i['categoryId']}'] += 1;
      //                                   }
      //                                   print('selectedCapacity => $selectedCapacity');
      //                                   for(var nodeCapacityKey in widget.capacity.keys){
      //                                     if(selectedCapacity[nodeCapacityKey] == null){
      //                                       showSuccess = false;
      //                                       getDialog(title: 'Alert Message', content: 'Node Not Matching');
      //                                       break;
      //                                     }
      //                                   }
      //                                   for(var nodeCapacityKey in widget.capacity.keys){
      //                                     if(selectedCapacity[nodeCapacityKey] < widget.capacity[nodeCapacityKey]){
      //                                       showSuccess = false;
      //                                       getDialog(title: 'Alert Message', content: 'Some Node Count Not Matching');
      //                                       break;
      //                                     }
      //                                   }
      //                                   if(showSuccess){
      //                                     getDialog(
      //                                         title: 'Matching',
      //                                         content: 'All node are matched successfully',
      //                                       successFunction: (){
      //                                         createrProductLimitAndConfigMaker(fromUserId: customerList[customer]['userId'], fromControllerId: masterList[master]['controllerId']);
      //                                       }
      //                                     );
      //                                   }
      //                                 },
      //                                 child: const Text('Apply',style: TextStyle(color: Colors.white),),
      //                               ),
      //                             ),
      //                           ),
      //
      //                     ],
      //                   )
      //             ],
      //           ),
      //         )
      //     ],
      //   ),
      // ),
      body: Container(
        color: Colors.white,
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.all(8),
              width: 300,
              decoration: BoxDecoration(
                  // color: cardColor,
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        cardColor,
                        Colors.grey.shade100
                      ]
                  ),
                  borderRadius: BorderRadius.circular(10)
              ),
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for(var dealer = 0;dealer <dealerList.length;dealer++)
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 8,horizontal: 8),
                        padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 8),
                        child: ListTile(
                          onTap: (){
                            setState(() {
                              selectedDealer = dealer;
                              selectedCustomer = 0;
                              getCustomerList(userId: dealerList[dealer]['userId']);

                            });
                          },
                          contentPadding: EdgeInsets.zero,
                          leading: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                                color: selectedDealer == dealer ? Colors.black : primaryColorDark,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Center(
                              child: Text('${dealerList[dealer]['userName'][0] ?? ''}',style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),),
                            ),
                          ),
                          title: Text('${dealerList[dealer]['userName']}',style: TextStyle(fontWeight: FontWeight.bold,color: selectedDealer == dealer ? Colors.white : primaryColorDark),),
                          subtitle: Text('${dealerList[dealer]['mobileNumber']}',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: selectedDealer == dealer ? Colors.grey.shade200 : Colors.black),),
                        ),
                        decoration: BoxDecoration(
                            color: selectedDealer == dealer ? primaryColorDark :null,
                            borderRadius: BorderRadius.circular(10)
                        ),

                      )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height,
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          cardColor,
                          Colors.grey.shade100
                        ]
                    ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(height: 10,),
                      Container(
                        width: double.infinity,
                        height: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('List of Customers',style: TextStyle(color: primaryColorDark,fontWeight: FontWeight.bold,fontSize: 16),),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  for(var customer = 0;customer < customerList.length;customer++)
                                    Row(
                                      children: [
                                        SizedBox(width: 20,),
                                        InkWell(
                                          onTap: (){
                                            setState(() {
                                              selectedCustomer = customer;
                                            });
                                            getMasterList(userId: customerList[customer]['userId']);
                                          },
                                          child: Container(
                                            width: 150,
                                            height: 150,
                                            decoration: BoxDecoration(
                                              color: selectedCustomer == customer ? primaryColorDark : Colors.grey.shade300,
                                              borderRadius: BorderRadius.circular(10)
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Container(
                                                  width: 60,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                      color: Colors.black54,
                                                      borderRadius: BorderRadius.circular(30)
                                                  ),
                                                  child: Center(
                                                    child: Text('${customerList[customer]['userName'][0] ?? ''}',style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),),
                                                  ),
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Text('${customerList[customer]['userName']}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10,color: selectedCustomer == customer ? Colors.white : Colors.black),),
                                                    Text('${customerList[customer]['mobileNumber']}',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 10,color: selectedCustomer == customer ? Colors.white : Colors.black),),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 40,),
                      Text('List of Controllers',style: TextStyle(color: primaryColorDark,fontSize: 16,fontWeight: FontWeight.bold),),
                      SizedBox(height: 20,),
                      for(var master = 0;master < masterList.length;master++)
                        Container(
                          margin: EdgeInsets.only(bottom: 20,left: 20,right: 20),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: customBoxShadow
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 200,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 100,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(height: 10,),
                                          SizedBox(
                                            width: 50,
                                            height: 50,
                                            child: Image.asset('assets/images/oro_gem.png'),
                                          ),
                                          SizedBox(height: 10,),
                                          Text('${masterList[master]['deviceName']}'),
                                          SizedBox(height: 5,),
                                          Text('${masterList[master]['deviceId']}',style: TextStyle(fontWeight: FontWeight.w200,fontSize: 12),),

                                        ],
                                      ),
                                    ),
                                    MaterialButton(
                                      color: const Color(0xff1D808E),
                                      onPressed: (){
                                        setState(() {
                                          selectedMaster = master;
                                        });
                                        bool showSuccess = true;
                                        var selectedCapacity = {};
                                        for(var i in masterList[master]['nodeList']){
                                          if(selectedCapacity['${i['categoryId']}'] == null){
                                            selectedCapacity['${i['categoryId']}'] = 0;
                                          }
                                          selectedCapacity['${i['categoryId']}'] += 1;
                                        }
                                        print('selectedCapacity => $selectedCapacity');
                                        for(var nodeCapacityKey in widget.capacity.keys){
                                          if(selectedCapacity[nodeCapacityKey] == null){
                                            showSuccess = false;
                                            getDialog(title: 'Alert Message', content: 'Node Not Matching');
                                            break;
                                          }
                                        }
                                        if(showSuccess){
                                          for(var nodeCapacityKey in widget.capacity.keys){
                                            if(selectedCapacity[nodeCapacityKey] < widget.capacity[nodeCapacityKey]){
                                              showSuccess = false;
                                              getDialog(title: 'Alert Message', content: 'Some Node Count Not Matching');
                                              break;
                                            }
                                          }
                                        }
                                        if(showSuccess){
                                          getDialog(
                                              title: 'Matching',
                                              content: 'All node are matched successfully',
                                              successFunction: (){
                                                createrProductLimitAndConfigMaker(fromUserId: customerList[selectedCustomer]['userId'], fromControllerId: masterList[master]['controllerId']);
                                              }
                                          );
                                        }
                                      },
                                      child: const Text('Apply',style: TextStyle(color: Colors.white),),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 5,
                                child: VerticalDivider(
                                  width: 5,
                                  color: Colors.grey,
                                ),
                              ),
                              Expanded(
                                child: Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: [
                                    for(var node = 0;node < masterList[master]['nodeList'].length;node++)
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: Colors.grey.shade50,
                                          border: Border.all(width: 0.5)
                                        ),
                                        child: Column(
                                          children: [
                                            Text('${masterList[master]['nodeList'][node]['deviceName']}',style: TextStyle(fontWeight: FontWeight.bold)),
                                            SizedBox(height: 3,),
                                            Text('${masterList[master]['nodeList'][node]['deviceId']}',style: TextStyle(fontSize: 10,fontWeight: FontWeight.w200),),
                                          ],
                                        ),
                                      )
                                  ],
                                ),
                              )

                            ],
                          ),
                        )
                    ],
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
  void getDialog({
    required String title,
    required String content,
   void Function()? successFunction
  }){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          MaterialButton(
            color: Colors.green,
              onPressed: (){
                Navigator.pop(context);
                if(successFunction != null){
                  successFunction();
                }
              },
            child: const Text('Ok',style: TextStyle(color: Colors.white),),
          )
        ],
      );
    });
  }

}
