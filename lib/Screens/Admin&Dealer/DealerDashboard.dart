import 'dart:convert';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:oro_irrigation_new/Screens/Admin&Dealer/sevicerequestdealer.dart';

import '../../Models/DataResponse.dart';
import '../../Models/Dealer/CustomerAlarmList.dart';
import '../../Models/StockModel.dart';
import '../../Models/UserModel.dart';
import '../../constants/MyFunction.dart';
import '../../constants/http_service.dart';
import '../../constants/theme.dart';
import '../Customer/CustomerScreenController.dart';
import '../Forms/create_account.dart';
import '../Forms/device_list.dart';
import '../UserChat/user_chat.dart';
import 'MySalesBarChart.dart';

enum Calendar {all, year}
typedef CallbackFunction = void Function(String result);

class DealerDashboard extends StatefulWidget {
  const DealerDashboard({Key? key, required this.userName, required this.countryCode, required this.mobileNo, required this.userId, required this.emailId, required this.fromLogin, required this.userType}) : super(key: key);
  final String userName, countryCode, mobileNo, emailId;
  final int userId, userType;
  final bool fromLogin;

  @override
  State<DealerDashboard> createState() => _DealerDashboardState();
}

class _DealerDashboardState extends State<DealerDashboard> {

  Calendar calendarView = Calendar.all;
  List<StockModel> myStockList = <StockModel>[];
  List<UserModel> myCustomerList = <UserModel>[];
  List<UserModel> filteredCustomerList = [];
  late SalesDataModel mySalesData;

  bool gettingSR = false;
  bool gettingCL = false;
  int totalSales = 0;
  bool searched = false;
  TextEditingController txtFldSearch = TextEditingController();


  @override
  void initState() {
    super.initState();
    searched=false;
    gettingSR = true;
    gettingCL = true;
    mySalesData = SalesDataModel(graph: {}, total: []);
    getMySalesData('All');
    getMyStock();
    getMyCustomer();

  }

  void callbackFunction(String message)
  {
    Future.delayed(const Duration(milliseconds: 500), () {
      getMyCustomer();
    });
  }

  Future<void> getMySalesData(filterBy) async {
    Map<String, Object> body = {
      "userId": widget.userId,
      "userType": 2,
      "type": filterBy,
      "year": 2024,
    };

    try {
      final response = await HttpService().postRequest("getProductSalesReport", body);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data is Map<String, dynamic> && data["code"] == 200) {
          try {
            mySalesData = SalesDataModel.fromJson(data);
            totalSales = mySalesData.total?.fold<int>(0, (sum, item) => sum + item.totalProduct) ?? 0;

            if (mounted) {
              setState(() => gettingSR = false);
            }
          } catch (e) {
            print('Error parsing data response: $e');
          }
        } else {
          print('Unexpected response code: ${data["code"]}');
          if (mounted) {
            setState(() => gettingSR = false);
          }
        }
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        if (mounted) {
          setState(() => gettingSR = false);
        }
      }
    } catch (e) {
      print('Network or parsing error: $e');
      if (mounted) {
        setState(() => gettingSR = false);
      }
    }
  }

  Future<void> getMyStock() async {
    Map<String, dynamic> body = {
      "fromUserId": null,
      "toUserId": widget.userId,
    };

    try {
      final response = await HttpService().postRequest("getProductStock", body);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data["code"] == 200) {
          final cntList = data["data"];
          if (cntList is List) {
            myStockList = cntList.map((item) => StockModel.fromJson(item)).toList();
            if (mounted) {
              setState(() {});
            }
          } else {
            print("Unexpected data format: 'data' is not a List");
          }
        } else {
          print("Unexpected response code: ${data["code"]}");
        }
      } else {
        print('Failed response: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Network or parsing error: $e');
    }
  }

  Future<void> getMyCustomer() async {
    Map<String, Object> body = {"userType": 2, "userId": widget.userId};
    try {
      final response = await HttpService().postRequest("getUserList", body);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data["code"] == 200) {
          final cntList = data["data"] as List;
          myCustomerList = cntList.map((item) => UserModel.fromJson(item)).toList();
          filteredCustomerList = List.from(myCustomerList);
          setState(() {
            gettingCL = false;
          });
        } else {
          // Handle the case where the code is not 200
          setState(() {
            gettingCL = false;
          });
        }
      } else {
        // Handle non-200 response status (e.g., show a Snackbar or error message)
        //_showSnackBar(response.body);
        setState(() {
          gettingCL = false;
        });
      }
    } catch (e) {
      // Catch any errors (network, decoding, etc.)
      print('Error fetching customer data: $e');
      setState(() {
        gettingCL = false;
      });
    }
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: myTheme.primaryColor.withOpacity(0.01),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Dashboard'),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.userName, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  Text('+${widget.countryCode} ${widget.mobileNo}', style: const TextStyle(fontWeight: FontWeight.normal,color: Colors.white)),
                ],
              ),
              const SizedBox(width: 05),
              const CircleAvatar(
                radius: 23,
                backgroundImage: AssetImage("assets/images/user_thumbnail.png"),
              ),
            ],),
          const SizedBox(width: 10)
        ],
        //scrolledUnderElevation: 5.0,
        //shadowColor: Theme.of(context).colorScheme.shadow,
      ),
      body: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Card(
                      elevation: 5,
                      surfaceTintColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0), // Adjust the radius as needed
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            title: const Text(
                              "Analytics Overview",
                              style: TextStyle(fontSize: 20, color: Colors.black),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SegmentedButton<Calendar>(
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStateProperty.all(myTheme.primaryColor.withOpacity(0.1)),
                                    iconColor: WidgetStateProperty.all(myTheme.primaryColor),
                                  ),
                                  segments: const <ButtonSegment<Calendar>>[
                                    ButtonSegment<Calendar>(
                                      value: Calendar.all,
                                      label: SizedBox(
                                        width: 45,
                                        child: Text('All', textAlign: TextAlign.center),
                                      ),
                                      icon: Icon(Icons.calendar_view_day),
                                    ),
                                    ButtonSegment<Calendar>(
                                      value: Calendar.year,
                                      label: SizedBox(
                                        width: 45,
                                        child: Text('Year', textAlign: TextAlign.center),
                                      ),
                                      icon: Icon(Icons.calendar_view_month),
                                    ),
                                  ],
                                  selected: <Calendar>{calendarView},
                                  onSelectionChanged: (Set<Calendar> newSelection) {
                                    setState(() {
                                      calendarView = newSelection.first;
                                      String sldName = calendarView.name[0].toUpperCase() + calendarView.name.substring(1);
                                      getMySalesData(sldName);
                                    });
                                  },
                                ),
                                const SizedBox(width: 16,),
                                Text.rich(
                                  TextSpan(
                                    text: 'Total Sales: ', // Regular text
                                    style: const TextStyle(fontSize: 15),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '$totalSales',
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: gettingSR?const Center(child: SizedBox(width:40,child: LoadingIndicator(indicatorType: Indicator.ballPulse))):
                            MySalesBarChart(graph: mySalesData.graph,),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Wrap(
                              spacing: 5,
                              runSpacing: 5,
                              alignment: WrapAlignment.start,
                              runAlignment: WrapAlignment.spaceBetween,
                              children: List.generate(
                                mySalesData.total!.length, (index) => Chip(
                                avatar: CircleAvatar(backgroundColor: mySalesData.total![index].color),
                                elevation: 3,
                                shape: const LinearBorder(),
                                label: Text('${index+1} - ${mySalesData.total![index].categoryName}',
                                  style: const TextStyle(fontSize: 11),
                                ),
                                visualDensity: VisualDensity.compact,
                              ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: myStockList.isEmpty
                        ? 200
                        : (150 + myStockList.length * 40.0).clamp(150.0, 325.0), // Minimum 100, maximum 325
                    child: Card(
                      elevation: 5,
                      surfaceTintColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0), // Adjust the radius as needed
                      ),
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
                            child: ListTile(

                              title: RichText(
                                text: TextSpan(
                                  text: 'Product Stock : ', // Regular text
                                  style: const TextStyle(fontSize: 20, color: Colors.black), // Default style
                                  children: [
                                    TextSpan(
                                      text: myStockList.length < 10
                                          ? '(${myStockList.length.toString().padLeft(2, '0')})'
                                          : '(${myStockList.length.toString()})',
                                      style: const TextStyle(fontSize: 17, color: Colors.black54),
                                    ),
                                  ],
                                ),
                              ),
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
                              child: myStockList.isNotEmpty
                                  ? Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: DataTable2(
                                  columnSpacing: 12,
                                  horizontalMargin: 12,
                                  minWidth: 600,
                                  border: TableBorder.all(color: Colors.teal.shade100),
                                  headingRowHeight: 40,
                                  dataRowHeight: 40,
                                  headingRowColor: WidgetStateProperty.all<Color>(primaryColorDark.withOpacity(0.1)),
                                  columns: const [
                                    DataColumn2(
                                      label: Text(
                                        'S.No',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      fixedWidth: 50,
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Category',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Model',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    DataColumn2(
                                      label: Text(
                                        'IMEI',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      size: ColumnSize.L,
                                    ),
                                    DataColumn2(
                                      label: Center(
                                        child: Text(
                                          'M.Date',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      fixedWidth: 125,
                                    ),
                                    DataColumn2(
                                      label: Center(
                                        child: Text(
                                          'Warranty',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      fixedWidth: 100,
                                    ),
                                  ],
                                  rows: List<DataRow>.generate(
                                    myStockList.length,
                                        (index) => DataRow(
                                      cells: [
                                        DataCell(Text('${index + 1}')),
                                        DataCell(
                                          Row(
                                            children: [Text(myStockList[index].categoryName)],
                                          ),
                                        ),
                                        DataCell(Text(myStockList[index].model)),
                                        DataCell(Text(myStockList[index].imeiNo)),
                                        DataCell(Center(child: Text(myStockList[index].dtOfMnf))),
                                        DataCell(Center(child: Text('${myStockList[index].warranty}'))),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                                  : const Center(
                                child: Text(
                                  'SOLD OUT',
                                  style: TextStyle(fontSize: 20),
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
            SizedBox(
              width: 330,
              height: MediaQuery.sizeOf(context).height,
              child: Card(
                elevation: 5,
                surfaceTintColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0), // Adjust the radius as needed
                ),
                child: gettingCL?
                const Center(child: SizedBox(width:40,child: LoadingIndicator(indicatorType: Indicator.ballPulse))):
                Column(
                  children: [
                    searched?ListTile(
                      title: TextField(
                        controller: txtFldSearch,
                        decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.clear, color: Colors.red,),
                              onPressed: () {
                                searched = false;
                                filteredCustomerList = myCustomerList;
                                txtFldSearch.clear();
                                setState(() {
                                });
                              },
                            ),
                            hintText: 'Search by name',
                            border: InputBorder.none),
                        onChanged: (value) {
                          setState(() {
                            filteredCustomerList = myCustomerList.where((customer) {
                              return customer.userName.toLowerCase().contains(value.toLowerCase());
                            }).toList();
                          });
                        },
                      ),
                    ):
                    ListTile(
                      title: RichText(
                        text: TextSpan(
                          text: 'My Customers : ', // Regular text
                          style: const TextStyle(fontSize: 17, color: Colors.black), // Default style
                          children: [
                            TextSpan(
                              text: '(${myCustomerList.length})',
                              style: const TextStyle(fontSize: 15, color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          myCustomerList.length>15?IconButton(tooltip: 'Search Customer', icon: const Icon(Icons.search), color: myTheme.primaryColor, onPressed: () async
                          {
                            setState(() {
                              searched=true;
                            });
                          }):
                          const SizedBox(),
                          IconButton(tooltip: 'Create Customer account', icon: const Icon(Icons.person_add_outlined), color: myTheme.primaryColor, onPressed: () async
                          {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) {
                                return FractionallySizedBox(
                                  heightFactor: 0.84,
                                  widthFactor: 0.75,
                                  child: Container(
                                    // padding: EdgeInsets.all(16.0),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
                                    ),
                                    child: CreateAccount(callback: callbackFunction, subUsrAccount: false, customerId: widget.userId, from: 'Dealer',),
                                  ),
                                );
                              },
                            );
                          }),
                        ],
                      ),
                    ),
                    const Divider(height: 0),
                    Expanded(
                      child: filteredCustomerList.isNotEmpty? ListView.separated(
                        itemCount: filteredCustomerList.length,
                        itemBuilder: (context, index) {
                          final customer = filteredCustomerList[index];
                          return ListTile(
                            leading: const CircleAvatar(
                              backgroundImage: AssetImage("assets/images/user_thumbnail.png"),
                              backgroundColor: Colors.transparent,
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  tooltip: 'chart',
                                  onPressed: (){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UserChatScreen(userId: customer.userId, dealerId: customer.userId, userName: customer.userName,),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.question_answer_rounded),
                                ),
                                (customer.criticalAlarmCount + customer.serviceRequestCount)>0? BadgeButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return  Column(
                                          children: [
                                            Container(
                                              width: MediaQuery.sizeOf(context).width,
                                              color: Colors.teal.shade100,
                                              height: 30,
                                              child: Center(child: Text(customer.userName)),
                                            ),
                                            customer.serviceRequestCount>0?SizedBox(
                                              width: MediaQuery.sizeOf(context).width,
                                              height: (customer.serviceRequestCount*45)+45,
                                              child: ServiceRequestsTable(userId: customer.userId),
                                            ):
                                            const SizedBox(),
                                            customer.criticalAlarmCount>0?SizedBox(
                                              width: MediaQuery.sizeOf(context).width,
                                              height: customer.criticalAlarmCount*45+40,
                                              child: DisplayCriticalAlarm(userId: customer.userId,),
                                            ):
                                            const SizedBox(),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: Icons.hail,
                                  badgeNumber: customer.criticalAlarmCount + customer.serviceRequestCount,
                                ):
                                const SizedBox(),
                                IconButton(
                                  tooltip: 'View and Add new product',
                                  onPressed: (){
                                    showModalBottomSheet(
                                      context: context,
                                      elevation: 10,
                                      isScrollControlled: true,
                                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5))),
                                      builder: (BuildContext context) {
                                        return DeviceList(customerID: customer.userId, userName: customer.userName, userID: widget.userId, userType: widget.fromLogin?2:1, productStockList: myStockList, callback: callbackFunction, customerType: 'Customer',);
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.playlist_add),
                                ),
                              ],
                            ),
                            title: Text(customer.userName, style: const TextStyle(fontSize: 13,fontWeight: FontWeight.bold)),
                            subtitle: Text('+${customer.countryCode} ${customer.mobileNumber}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
                            onTap:() {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CustomerScreenController(
                                    customerId: customer.userId,
                                    customerName: customer.userName,
                                    mobileNo: '+${customer.countryCode}-${customer.mobileNumber}',
                                    comingFrom: 'AdminORDealer',
                                    emailId: customer.emailId,
                                    userId: widget.userId,),
                                ),
                              );
                            },
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Divider(
                            color: Colors.black26,
                            thickness: 0.3,
                            indent: 16,
                            endIndent: 0,
                            height: 0,
                          );
                        },
                      ):
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Customers not found.', style: TextStyle(fontSize: 17, fontWeight: FontWeight.normal)),
                              const SizedBox(height: 5),
                              !searched? const Text('Add your customer using top of the customer adding button.', style: TextStyle(fontWeight: FontWeight.normal)):
                              const SizedBox(),
                              !searched?const Icon(Icons.person_add_outlined):const SizedBox(),
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
    );
  }
}

class BadgeButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final int badgeNumber;

  const BadgeButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.badgeNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          tooltip: 'My alarm and Service request',
          onPressed: onPressed,
          icon: Icon(icon,),
        ),
        if (badgeNumber > 0)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                badgeNumber.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}

class DisplayCriticalAlarm extends StatefulWidget{
  const DisplayCriticalAlarm({super.key, required this.userId});
  final int userId;

  @override
  State<DisplayCriticalAlarm> createState() => _DisplayCriticalAlarmState();
}

class _DisplayCriticalAlarmState extends State<DisplayCriticalAlarm> {

  List<CriticalAlarmFinal> alarms = [];

  @override
  void initState() {
    super.initState();
    getCriticalAlarmList();
  }


  Future<void> getCriticalAlarmList() async {
    Map<String, Object> body = {"userId": widget.userId};
    final response = await HttpService().postRequest("getUserCriticalAlarmForDealer", body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data["code"] == 200) {
        List<AlarmGroupData> alarmGroupDataList = List<AlarmGroupData>.from(data['data'].map((item) => AlarmGroupData.fromJson(item)));
        alarms.clear();
        for (var group in alarmGroupDataList) {
          for (var master in group.master) {
            for (var alarm in master.criticalAlarm) {
              String msg = getAlarmMessage(alarm.alarmType);
              alarms.add(CriticalAlarmFinal(
                fmName: group.groupName,
                dvcName: master.deviceName,
                location: alarm.location,
                message: msg,
              ));
            }
          }
        }

        setState(() {
          // Trigger UI update after data processing
        });
      }
    } else {
      //_showSnackBar(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DataTable2(
      columnSpacing: 12,
      horizontalMargin: 12,
      minWidth: 600,
      dataRowHeight: 45.0,
      headingRowHeight: 40.0,
      headingRowColor: WidgetStateProperty.all<Color>(Colors.yellow.shade50),
      columns:  const [
        DataColumn2(
          label: Text('Farm', style: TextStyle(fontSize: 13),),
          size: ColumnSize.M,
        ),
        DataColumn2(
          label: Text('Device', style: TextStyle(fontSize: 13),),
          size: ColumnSize.M,
        ),
        DataColumn2(
          label: Text('Location', style: TextStyle(fontSize: 13)),
          size: ColumnSize.S,
        ),
        DataColumn2(
          label: Text('Alarm Message', style: TextStyle(fontSize: 13)),
          size: ColumnSize.L,
        ),
      ],
      rows: List<DataRow>.generate(alarms.length, (index) {
        return DataRow(cells: [
          DataCell(Text(alarms[index].fmName, style: const TextStyle(fontSize: 13,fontWeight: FontWeight.normal),)),
          DataCell(Text(alarms[index].dvcName, style: const TextStyle(fontSize: 13,fontWeight: FontWeight.normal),)),
          DataCell(Text(alarms[index].location, style: const TextStyle(fontSize: 13,fontWeight: FontWeight.normal),)),
          DataCell(Text(alarms[index].message, style: const TextStyle(fontSize: 13,fontWeight: FontWeight.normal),)),
        ]);
      }),
    );
  }
}