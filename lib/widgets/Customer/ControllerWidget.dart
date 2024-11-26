import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../constants/theme.dart';
import '../../state_management/MqttPayloadProvider.dart';

typedef RefreshedPressedCallback = void Function();

class MasterController extends StatefulWidget {
  const MasterController({super.key, required this.name, required this.category, required this.refreshOnPress});
  final String name, category;
  final RefreshedPressedCallback refreshOnPress;

  @override
  State<MasterController> createState() => _MasterControllerState();
}

class _MasterControllerState extends State<MasterController>{


  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<MqttPayloadProvider>(context);

    final screenSize = MediaQuery.of(context).size;
    final double textSizeTitle1 = screenSize.width * 0.025;
    final double textSizeTitle2 = screenSize.width * 0.02;

    return Container(
      width: screenSize.width,
      height: 100,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          colors: [myTheme.primaryColor, myTheme.primaryColorDark],
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          const SizedBox(height: 3),
          Row(
            children: [
              SizedBox(
                height: 40,
                width: 40,
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Image.asset('assets/images/oro_gem.png'),
                ),
              ),
              Expanded(child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.name, style: TextStyle(color: Colors.white,fontSize: textSizeTitle1)),
                  Text('${widget.category} - Last sync : ${getCurrentDateTime()}', style: TextStyle(fontWeight: FontWeight.normal, fontSize: textSizeTitle2, color: Colors.white,),),
                ],
              ))
            ],
          ),
          const SizedBox(height: 3),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: myTheme.primaryColorDark
                ),
                width: 45,
                height: 45,
                child: IconButton(
                  tooltip: '${provider.wifiStrength} %',
                  icon: Icon(provider.wifiStrength == 0? Icons.wifi_off:
                  provider.wifiStrength >= 1 && provider.wifiStrength <= 20 ? Icons.network_wifi_1_bar_outlined:
                  provider.wifiStrength >= 21 && provider.wifiStrength <= 40 ? Icons.network_wifi_2_bar_outlined:
                  provider.wifiStrength >= 41 && provider.wifiStrength <= 60 ? Icons.network_wifi_3_bar_outlined:
                  provider.wifiStrength >= 61 && provider.wifiStrength <= 80 ? Icons.network_wifi_outlined:
                  Icons.wifi, color: Colors.white,),
                  onPressed: null,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: myTheme.primaryColorDark
                ),
                width: 45,
                height: 45,
                child: IconButton(
                  tooltip: 'refresh',
                  icon: const Icon(Icons.refresh, color: Colors.white,),
                  onPressed: widget.refreshOnPress,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: myTheme.primaryColorDark
                ),
                width: 45,
                height: 45,
                child: IconButton(tooltip:'View all Node details', onPressed: (){
                  //showNodeDetailsBottomSheet(context);
                }, icon: const Icon(Icons.grid_view, color: Colors.white)),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: myTheme.primaryColorDark
                ),
                width: 45,
                height: 45,
                child: IconButton(
                  tooltip: 'Manual Mode',
                  icon: const Icon(Icons.touch_app_outlined, color: Colors.white,),
                  onPressed: () async {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container();
                        /*return RunByManual(siteID: widget.siteData.siteId,
                                siteName: widget.siteData.siteName,
                                controllerID: widget.siteData.controllerId,
                                customerID: widget.customerID,
                                imeiNo: widget.siteData.deviceId,
                                programList: programList, callbackFunction: callbackFunction);*/
                      },
                    );
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: myTheme.primaryColorDark
                ),
                width: 45,
                height: 45,
                child: IconButton(
                  tooltip: 'Planning',
                  icon: const Icon(Icons.list_alt, color: Colors.white,),
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Container(),
                      ),
                    );
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  String getCurrentDateTime() {
    var nowDT = DateTime.now();
    return '${DateFormat('MMMM dd, yyyy').format(nowDT)}-${DateFormat('hh:mm:ss').format(nowDT)}';
  }
}