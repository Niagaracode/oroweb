
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../state_management/config_maker_provider.dart';


class StartPageConfigMaker extends StatefulWidget {
  const StartPageConfigMaker({super.key});
  @override
  State<StartPageConfigMaker> createState() => _StartPageConfigMakerState();
}

class _StartPageConfigMakerState extends State<StartPageConfigMaker> {
  bool isHovered = false;
  bool isHovered1 = false;
  @override
  Widget build(BuildContext context) {
    var configPvd = Provider.of<ConfigMakerProvider>(context, listen: true);

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0xFFF3F3F3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ElevatedButton(
          //     onPressed: (){
          //       MqttWebClient myMqtt = MqttWebClient();
          //       print(myMqtt.init());
          //     },
          //     child: Text('connect')
          // ),
          // ElevatedButton(
          //     onPressed: (){
          //       print(mqttPvd.isConnect);
          //     },
          //     child: Text('check')
          // ),
          // Icon(Icons.circle,color: mqttPvd.isConnect == true ? Colors.green : Colors.red,),
          MouseRegion(
            onEnter: (_) {
              setState(() {
                isHovered = true;
              });
            },
            onExit: (_) {
              setState(() {
                isHovered = false;
              });
            },
            child: InkWell(
              onTap: (){
                configPvd.clearConfig();
                configPvd.fetchAll(configPvd.serverData,true);
                configPvd.editSelectedTab(1);
              },
              child: Container(
                width: 250,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: isHovered == false ? Colors.white : Colors.blueGrey,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: 100,
                        height: 100,
                        child: Image.asset('assets/images/newConfig.png')
                    ),
                    Text('New Config',style: TextStyle(fontSize: 20,color: isHovered == false ? Colors.black : Colors.white,),),
                  ],
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

  List<String> returnTitleAndImage(int index){
    print('index : $index');
    if(index == 0){
      return ['Get Data', 'assets/images/get data.png'];
    }else{
      return ['Start Config', 'assets/images/start_config.png'];
    }
  }

  String returnDeviceName(String title){
    if(title == '2'){
      return 'ORO Smart RTU';
    }else if(title == '3'){
      return 'ORO RTU';
    }else if(title == '5'){
      return 'ORO Switch';
    }else if(title == '7'){
      return 'ORO Sense';
    }else{
      return '-';
    }
  }
}
