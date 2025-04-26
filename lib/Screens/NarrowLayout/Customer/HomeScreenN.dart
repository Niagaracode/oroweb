import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:oro_irrigation_new/constants/theme.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

import '../../../Models/Customer/Dashboard/DashboardNode.dart';
import '../../../Models/language.dart';
import '../../../constants/http_service.dart';
import '../../../widgets/Customer/ControllerWidget.dart';
import '../../NodeList.dart';

class HomeScreenN extends StatefulWidget {
  const HomeScreenN({Key? key, required this.userId}) : super(key: key);
  final int userId;

  @override
  State<HomeScreenN> createState() => _HomeScreenNState();
}

class _HomeScreenNState extends State<HomeScreenN> {

  final ScrollController listViewController = ScrollController();
  final List<LanguageList> languageList = <LanguageList>[];
  List<DashboardModel> siteListFinal = [];
  int siteIndex = 0;
  bool loadingSite = true;
  bool visibleLoading = false;

  @override
  void initState() {
    super.initState();
    getCustomerSite(widget.userId);
  }

  Future<void> getCustomerSite(userId) async
  {
    Map<String, Object> body = {"userId" : userId ?? 0};
    final response = await HttpService().postRequest("getUserDeviceListForCustomer", body);
    if (response.statusCode == 200)
    {
      siteListFinal.clear();
      var data = jsonDecode(response.body);
      if(data["code"]==200)
      {
        final cntList = data["data"] as List;
        try {
          siteListFinal = cntList.map((json) => DashboardModel.fromJson(json)).toList();
          setState((){
            loadingSite = false;
          });
          //subscribeAndUpdateSite();
        } catch (e, stackTrace) {
          print('Error: $e');
          print('stackTrace: $stackTrace');
          //indicatorViewHide();
        }
      }
    }
    else{
      //_showSnackBar(response.body);
    }
  }



  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return loadingSite? buildLoadingIndicator(loadingSite, screenSize.width): Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      drawer: Drawer(
        shape: const RoundedRectangleBorder(),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              width: screenSize.width,
              height: 100,
              color: myTheme.primaryColorDark,
              child: const Image(image: AssetImage("assets/images/oro_logo_white.png")),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      endDrawer: Drawer(
        width: 340,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5))),
        child: CustomerNodeList(siteData: siteListFinal[siteIndex]),
      ),
      body: SnappingSheet(
        lockOverflowDrag: true,
        snappingPositions: const [
          SnappingPosition.factor(
            positionFactor: 0.0,
            snappingCurve: Curves.easeOutExpo,
            snappingDuration: Duration(seconds: 1),
            grabbingContentOffset: GrabbingContentOffset.top,
          ),
          SnappingPosition.factor(
            snappingCurve: Curves.elasticOut,
            snappingDuration: Duration(milliseconds: 1750),
            positionFactor: 0.2,
          ),
          SnappingPosition.factor(
            grabbingContentOffset: GrabbingContentOffset.bottom,
            snappingCurve: Curves.easeInExpo,
            snappingDuration: Duration(seconds: 1),
            positionFactor: 0.7,
          ),
        ],
        grabbing: GrabbingWidget(siteData: siteListFinal[siteIndex]),
        grabbingHeight: MediaQuery.sizeOf(context).height-57,
        sheetAbove: null,
        /*sheetBelow: SnappingSheetContent(
          draggable: true,
          childScrollController: listViewController,
          child: Container(
            width: 200,
            height: 100,
            color: Colors.red,
          ),
        ),*/
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: MasterController(name: siteListFinal[siteIndex].groupName, category: siteListFinal[siteIndex].groupName, refreshOnPress: () {
                  print('ControllerWidget clicked');
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildLoadingIndicator(bool isVisible, double width)
{
  return Visibility(
    visible: isVisible,
    child: Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: width / 2 - 25),
      child: const LoadingIndicator(
        indicatorType: Indicator.ballPulse,
      ),
    ),
  );
}

class GrabbingWidget extends StatelessWidget {
  const GrabbingWidget({super.key, required this.siteData});
  final DashboardModel siteData;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(blurRadius: 25, color: Colors.black.withOpacity(0.2)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20),
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: myTheme.primaryColorDark,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          Container(
            color: Colors.white,
            height: screenSize.height - 95,
            width: screenSize.width,
            margin: const EdgeInsets.all(15).copyWith(top: 0, bottom: 10),
            child: Column(
              children: [
              ],
            ),
          )
        ],
      ),
    );
  }
}
