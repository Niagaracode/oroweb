import 'dart:convert';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../Models/DataResponse.dart';
import '../../Models/StockModel.dart';
import '../../Models/UserModel.dart';
import '../../constants/http_service.dart';
import '../../constants/theme.dart';
import '../Forms/add_product.dart';
import '../Forms/create_account.dart';
import '../Forms/device_list.dart';
import 'BaseScreenController.dart';
import 'MySalesBarChart.dart';

enum Calendar {all, year}
typedef CallbackFunction = void Function(String result);

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key, required this.userName, required this.countryCode, required this.mobileNo, required this.userId}) : super(key: key);
  final String userName, countryCode, mobileNo;
  final int userId;

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {

  Calendar calendarView = Calendar.all;
  List<StockModel> myStockList = <StockModel>[];
  List<UserModel> myDealerList = <UserModel>[];
  late SalesDataModel mySalesData;

  int totalSales = 0;
  bool gettingSR = false;
  bool gettingCL = false;

  @override
  void initState() {
    super.initState();
    gettingSR = true;
    gettingCL = true;
    mySalesData = SalesDataModel(graph: {}, total: []);
    getMySalesData("All");
    getMyStock();
    getMyDealer();
  }

  void callbackFunction(String message)
  {
    if(message=='reloadStock'){
      Navigator.pop(context);
      Future.delayed(const Duration(milliseconds: 500), () {
        getMyStock();
      });
    }else{
      Future.delayed(const Duration(milliseconds: 500), () {
        getMyDealer();
      });
    }
  }

  Future<void> getMySalesData(filterBy) async {
    Map<String, Object> body = {
      "userId": widget.userId,
      "userType": 1,
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

  Future<void> getMyDealer() async {
    Map<String, Object> body = {
      "userType": 1,
      "userId": widget.userId,
    };

    try {
      final response = await HttpService().postRequest("getUserList", body);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data["code"] == 200) {
          final cntList = data["data"];

          if (cntList is List) {
            myDealerList = cntList.map((item) => UserModel.fromJson(item)).toList();
          } else {
            print("Unexpected data format: 'data' is not a List");
          }
        } else {
          print("Unexpected response code: ${data["code"]}");
        }
      } else {
        print("Failed response: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Network or parsing error: $e");
    } finally {
      if (mounted) {
        setState(() => gettingCL = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  Text(widget.userName, style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white)),
                  Text('+${widget.countryCode} ${widget.mobileNo}',
                      style: const TextStyle(
                          fontWeight: FontWeight.normal, color: Colors.white)),
                ],
              ),
              const SizedBox(width: 05),
              const CircleAvatar(
                radius: 23,
                backgroundImage: AssetImage("assets/images/user_thumbnail.png"),
              ),
            ],),
          const SizedBox(width: 10),
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
                  SizedBox(
                    height: 350,
                    child: Card(
                      elevation: 5,
                      surfaceTintColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            5.0),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            title: const Text(
                              "Analytics Overview",
                              style: TextStyle(
                                  fontSize: 20, color: Colors.black),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SegmentedButton<Calendar>(
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStateProperty
                                        .all(
                                        myTheme.primaryColor.withOpacity(
                                            0.1)),
                                    iconColor: WidgetStateProperty.all(
                                        myTheme.primaryColor),
                                  ),
                                  segments: const <ButtonSegment<Calendar>>[
                                    ButtonSegment<Calendar>(
                                      value: Calendar.all,
                                      label: SizedBox(
                                        width: 45,
                                        child: Text('All',
                                            textAlign: TextAlign.center),
                                      ),
                                      icon: Icon(Icons.calendar_view_day),
                                    ),
                                    ButtonSegment<Calendar>(
                                      value: Calendar.year,
                                      label: SizedBox(
                                        width: 45,
                                        child: Text('Year',
                                            textAlign: TextAlign.center),
                                      ),
                                      icon: Icon(Icons.calendar_view_month),
                                    ),
                                  ],
                                  selected: <Calendar>{calendarView},
                                  onSelectionChanged: (
                                      Set<Calendar> newSelection) {
                                    setState(() {
                                      calendarView = newSelection.first;
                                      String sldName = calendarView.name[0]
                                          .toUpperCase() +
                                          calendarView.name.substring(1);
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
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: gettingSR ? const Center(child: SizedBox(
                                width: 40,
                                child: LoadingIndicator(
                                    indicatorType: Indicator.ballPulse))) :
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
                                mySalesData.total!.length, (index) =>
                                  Chip(
                                    avatar: CircleAvatar(
                                        backgroundColor: mySalesData
                                            .total![index].color),
                                    elevation: 3,
                                    shape: const LinearBorder(),
                                    label: Text(
                                      '${index + 1} - ${mySalesData
                                          .total![index].categoryName}',
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
                  Expanded(
                    child: Card(
                      elevation: 5,
                      surfaceTintColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            5.0), // Adjust the radius as needed
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
                              title: Text(
                                'Product Stock(${myStockList.length})',
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.black),),
                              trailing: TextButton.icon(
                                onPressed: () {
                                  {
                                    AlertDialog alert = AlertDialog(
                                      title: const Text("Stock Entry Form"),
                                      elevation: 10,
                                      content: SizedBox(
                                          width: 640,
                                          height: 300,
                                          child: AddProduct(callback: callbackFunction)
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("Cancel"),
                                        ),
                                      ],
                                    );

                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return alert;
                                      },
                                    );
                                  }
                                },
                                icon: const Icon(Icons.add),
                                label: const Text("New stock"),
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
                              child: myStockList.isNotEmpty ? Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: DataTable2(
                                    columnSpacing: 12,
                                    horizontalMargin: 12,
                                    minWidth: 600,
                                    border: TableBorder.all(
                                        color: Colors.teal.shade100),
                                    headingRowHeight: 40,
                                    dataRowHeight: 40,
                                    headingRowColor: WidgetStateProperty.all<
                                        Color>(
                                        primaryColorDark.withOpacity(0.1)),
                                    columns: const [
                                      DataColumn2(
                                          label: Center(child: Text('S.No',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),)),
                                          fixedWidth: 50
                                      ),
                                      DataColumn(
                                        label: Text('Category',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),),
                                      ),
                                      DataColumn(
                                        label: Text('Model', style: TextStyle(
                                            fontWeight: FontWeight.bold),),
                                      ),
                                      DataColumn2(
                                        label: Center(child: Text('IMEI',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),)),
                                        size: ColumnSize.L,
                                      ),
                                      DataColumn2(
                                        label: Center(child: Text('M.Date',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),)),
                                        fixedWidth: 150,
                                      ),
                                      DataColumn2(
                                        label: Center(child: Text('Warranty',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),)),
                                        fixedWidth: 100,
                                      ),
                                      DataColumn2(
                                        label: Center(child: Text('Action',
                                          style: TextStyle(fontWeight: FontWeight.bold),)),
                                        fixedWidth: 75,
                                      ),
                                    ],
                                    rows: List<DataRow>.generate(
                                        myStockList.length, (index) =>
                                        DataRow(cells: [
                                          DataCell(Center(
                                              child: Text('${index + 1}'))),
                                          DataCell(Text(myStockList[index]
                                              .categoryName)),
                                          DataCell(Text(
                                              myStockList[index].model)),
                                          DataCell(Center(child: Text(
                                              myStockList[index].imeiNo))),
                                          DataCell(Center(child: Text(
                                              myStockList[index]
                                                  .dtOfMnf))),
                                          DataCell(Center(child: Text(
                                              '${myStockList[index]
                                                  .warranty}'))),
                                          DataCell(Center(child: IconButton(icon:const Icon(Icons.remove_circle_outline, color: Colors.redAccent,),tooltip: 'remove from stock', onPressed: (){

                                          },))),
                                        ]))),
                              ) :
                              const Center(child: Text(
                                'SOLD OUT', style: TextStyle(fontSize: 20),)),
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
              width: 300,
              height: MediaQuery.sizeOf(context).height,
              child: Card(
                elevation: 5,
                surfaceTintColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      5.0), // Adjust the radius as needed
                ),
                child: gettingCL ?
                const Center(child: SizedBox(width: 40,
                    child: LoadingIndicator(
                        indicatorType: Indicator.ballPulse))) :
                Column(
                  children: [
                    ListTile(
                      title: const Text('My Dealer',
                          style: TextStyle(fontSize: 17)),
                      trailing: IconButton(
                          tooltip: 'Create Dealer account',
                          icon: const Icon(Icons.person_add_outlined),
                          color: myTheme.primaryColor,
                          onPressed: () async
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
                                    child: CreateAccount(callback: callbackFunction, subUsrAccount: false, customerId: widget.userId, from: 'Admin',),
                                  ),
                                );
                              },
                            );
                          }),
                    ),
                    const Divider(height: 0),
                    Expanded(
                      child: myDealerList.isNotEmpty ? ListView.separated(
                        itemCount: myDealerList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: const CircleAvatar(
                              backgroundImage: AssetImage(
                                  "assets/images/user_thumbnail.png"),
                              backgroundColor: Colors.transparent,
                            ),
                            title: Text(
                                myDealerList[index].userName,
                                style: const TextStyle(fontSize: 13,
                                    fontWeight: FontWeight.bold)),
                            subtitle: Text('+${myDealerList[index]
                                .countryCode} ${myDealerList[index]
                                .mobileNumber}',
                                style: const TextStyle(fontSize: 12,
                                    fontWeight: FontWeight.normal)),
                            onTap: () {
                              Navigator.push(context,
                                MaterialPageRoute(
                                    builder: (context) =>  BaseScreenController(
                                      userName: myDealerList[index]
                                          .userName,
                                      countryCode: myDealerList[index]
                                          .countryCode,
                                      mobileNo: myDealerList[index]
                                          .mobileNumber,
                                      fromLogin: false,
                                      userId: myDealerList[index]
                                          .userId,
                                      emailId: myDealerList[index]
                                          .emailId,
                                      userType: 2,
                                    )),
                              );
                            },
                            trailing: IconButton(
                              tooltip: 'View and Add new product',
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  elevation: 10,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5))),
                                  builder: (BuildContext context) {
                                    return DeviceList(
                                      customerID: myDealerList[index]
                                          .userId,
                                      userName: myDealerList[index]
                                          .userName,
                                      userID: widget.userId,
                                      userType: 1,
                                      productStockList: myStockList,
                                      callback: callbackFunction,
                                      customerType: 'Dealer',);
                                  },
                                );
                              },
                              icon: const Icon(Icons.playlist_add),),
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
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(25.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment
                                .center,
                            children: [
                              Text('Customers not found.',
                                  style: TextStyle(fontSize: 17,
                                      fontWeight: FontWeight.normal)),
                              SizedBox(height: 5),
                              Text(
                                  'Add your customer using top of the customer adding button.',
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal)),
                              Icon(Icons.person_add_outlined),
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