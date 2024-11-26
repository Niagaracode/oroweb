import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../state_management/config_maker_provider.dart';

class TextFieldForFlexibleConfig extends StatefulWidget {
  String initialValue;
  final int index;
  final ConfigMakerProvider config;
  final String purpose;
  TextFieldForFlexibleConfig({super.key, required this.purpose, required this.initialValue, required this.index, required this.config});

  @override
  State<TextFieldForFlexibleConfig> createState() => _TextFieldForFlexibleConfigState();
}

class _TextFieldForFlexibleConfigState extends State<TextFieldForFlexibleConfig> {
  late TextEditingController myController;
  FocusNode myFocus = FocusNode();
  bool focus = false;
  bool isEditing = false;

  @override
  void initState() {
    // TODO: implement initState
    myController = TextEditingController();
    myController.text = widget.initialValue;
    myFocus.addListener(() {
      if(myFocus.hasFocus == false){
        toggleEditing();
        setState(() {
          focus = false;
        });
        switch (widget.purpose){
          case ('irrigationLinesFunctionality/OroSmartRtu'):{
            var total = widget.config.totalOroSmartRTU + int.parse(widget.config.irrigationLines[widget.index]['ORO_Smart_RTU'] == '' ? '0' : widget.config.irrigationLines[widget.index]['ORO_Smart_RTU']);
            total = total - int.parse(myController.text == '' ? '0' : myController.text);
            if(total < 0){
              setState(() {
                myController.text = (int.parse(myController.text) + total).toString();
              });
            }
            widget.config.irrigationLinesFunctionality(['editOroSmartRtu',widget.index,myController.text]);
            break;
          }
          case ('irrigationLinesFunctionality/OroSmartRtuPlus'):{
            var total = widget.config.totalOroSmartRtuPlus + int.parse(widget.config.irrigationLines[widget.index]['ORO_Smart_RTU_Plus'] == '' ? '0' : widget.config.irrigationLines[widget.index]['ORO_Smart_RTU_Plus']);
            total = total - int.parse(myController.text == '' ? '0' : myController.text);
            if(total < 0){
              setState(() {
                myController.text = (int.parse(myController.text) + total).toString();
              });
            }
            widget.config.irrigationLinesFunctionality(['editOroSmartRtuPlus',widget.index,myController.text]);
            break;
          }
          case ('irrigationLinesFunctionality/RTU'):{
            var total = widget.config.totalRTU + int.parse(widget.config.irrigationLines[widget.index]['RTU'] == '' ? '0' : widget.config.irrigationLines[widget.index]['RTU']);
            total = total - int.parse(myController.text == '' ? '0' : myController.text);
            if(total < 0){
              setState(() {
                myController.text = (int.parse(myController.text) + total).toString();
              });
            }
            widget.config.irrigationLinesFunctionality(['editRTU',widget.index,myController.text]);
            break;
          }
          case ('irrigationLinesFunctionality/RTU_Plus'):{
            var total = widget.config.totalRtuPlus + int.parse(widget.config.irrigationLines[widget.index]['RTU_Plus'] == '' ? '0' : widget.config.irrigationLines[widget.index]['RTU_Plus']);
            total = total - int.parse(myController.text == '' ? '0' : myController.text);
            if(total < 0){
              setState(() {
                myController.text = (int.parse(myController.text) + total).toString();
              });
            }
            widget.config.irrigationLinesFunctionality(['editRtuPlus',widget.index,myController.text]);
            break;
          }
          case ('irrigationLinesFunctionality/0roSwitch'):{
            var total = widget.config.totalOroSwitch + int.parse(widget.config.irrigationLines[widget.index]['ORO_switch'] == '' ? '0' : widget.config.irrigationLines[widget.index]['ORO_switch']);
            total = total - int.parse(myController.text == '' ? '0' : myController.text);
            if(total < 0){
              setState(() {
                myController.text = (int.parse(myController.text) + total).toString();
              });
            }
            widget.config.irrigationLinesFunctionality(['editOroSwitch',widget.index,myController.text]);
            break;
          }
          case ('irrigationLinesFunctionality/0roSense'):{
            var total = widget.config.totalOroSense + int.parse(widget.config.irrigationLines[widget.index]['ORO_sense'] == '' ? '0' : widget.config.irrigationLines[widget.index]['ORO_sense']);
            total = total - int.parse(myController.text == '' ? '0' : myController.text);
            if(total < 0){
              setState(() {
                myController.text = (int.parse(myController.text) + total).toString();
              });
            }
            widget.config.irrigationLinesFunctionality(['editOroSense',widget.index,myController.text]);
            break;
          }
          case ('irrigationLinesFunctionality/0roLevel'):{
            var total = widget.config.totalOroLevel + int.parse(widget.config.irrigationLines[widget.index]['ORO_level'] == '' ? '0' : widget.config.irrigationLines[widget.index]['ORO_level']);
            total = total - int.parse(myController.text == '' ? '0' : myController.text);
            if(total < 0){
              setState(() {
                myController.text = (int.parse(myController.text) + total).toString();
              });
            }
            widget.config.irrigationLinesFunctionality(['editOroLevel',widget.index,myController.text]);
            break;
          }
          case ('centralDosingFunctionality/editBoosterPump'):{
            widget.config.centralDosingFunctionality(['editBoosterPumpSelection',widget.index]);
            break;
          }
          case ('centralDosingFunctionality/editEcSensor'):{
            widget.config.centralDosingFunctionality(['editEcSelection',widget.index]);
            break;
          }
          case ('centralDosingFunctionality/editPhSensor'):{
            widget.config.centralDosingFunctionality(['editPhSelection',widget.index]);
            break;
          }
          case ('localDosingFunctionality/editBoosterPump'):{
            widget.config.localDosingFunctionality(['editBoosterPumpSelection',widget.index]);
            break;
          }
          case ('localDosingFunctionality/editEcSensor'):{
            widget.config.localDosingFunctionality(['editEcSelection',widget.index]);
            break;
          }
          case ('localDosingFunctionality/editPhSensor'):{
            widget.config.localDosingFunctionality(['editPhSelection',widget.index]);
            break;
          }
          case ('irrigationLinesFunctionality/mainValve'):{
            widget.config.irrigationLinesFunctionality(['editMainValveConnection',widget.index]);
            break;
          }
          case ('irrigationLinesFunctionality/moistureSensor'):{
            widget.config.irrigationLinesFunctionality(['editMoistureSensorConnection',widget.index]);
            break;
          }
          case ('irrigationLinesFunctionality/levelSensor'):{
            widget.config.irrigationLinesFunctionality(['editLevelSensorConnection',widget.index]);
            break;
          }
          case ('irrigationLinesFunctionality/fogger'):{
            widget.config.irrigationLinesFunctionality(['editFoggerConnection',widget.index]);
            break;
          }
          case ('irrigationLinesFunctionality/fan'):{
            widget.config.irrigationLinesFunctionality(['editFanConnection',widget.index]);
            break;
          }
          default:{

          }
        }

      }
      if(myFocus.hasFocus == true){
        setState(() {
          focus = true;
        });
      }
    });
  }
  void toggleEditing() {
    setState(() {
      isEditing = !isEditing;
      if (isEditing) {
        myFocus.requestFocus();
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    var configPvd = Provider.of<ConfigMakerProvider>(context, listen: true);
    if(focus == false){
      myController.text = widget.initialValue;
    }
    return GestureDetector(
      onTap: toggleEditing,
      child: isEditing
          ? Container(
        width: 60,
        child: TextFormField(
          decoration: InputDecoration(
              contentPadding : EdgeInsets.all(0),
              counterText: '',
              border: OutlineInputBorder(
                  borderSide: BorderSide.none
              )
          ),
          focusNode: myFocus,
          controller: myController,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          ],
          maxLength: 2,
          onChanged: (value){
            if(value == '0'){
              myController.text = '1';
            }
            switch(widget.purpose){
              case ('irrigationLinesFunctionality/mainValve'):{
                var total = configPvd.totalMainValve + int.parse(configPvd.irrigationLines[widget.index]['main_valve'] == '' ? '0' : configPvd.irrigationLines[widget.index]['main_valve']);
                total = total - int.parse(myController.text == '' ? '0' : myController.text);
                if(total < 0){
                  setState(() {
                    myController.text = (int.parse(myController.text) + total).toString();
                  });
                }
                configPvd.irrigationLinesFunctionality(['editMainValve',widget.index,myController.text]);
                break;
              }
              case ('irrigationLinesFunctionality/moistureSensor'):{
                var total = configPvd.totalMoistureSensor + int.parse(configPvd.irrigationLines[widget.index]['moistureSensor'] == '' ? '0' : configPvd.irrigationLines[widget.index]['moistureSensor']);
                total = total - int.parse(myController.text == '' ? '0' : myController.text);
                if(total < 0){
                  setState(() {
                    myController.text = (int.parse(myController.text) + total).toString();
                  });
                }
                configPvd.irrigationLinesFunctionality(['editMoistureSensor',widget.index,myController.text]);
                break;
              }
              case ('irrigationLinesFunctionality/levelSensor'):{
                var total = configPvd.totalLevelSensor + int.parse(configPvd.irrigationLines[widget.index]['levelSensor'] == '' ? '0' : configPvd.irrigationLines[widget.index]['levelSensor']);
                total = total - int.parse(myController.text == '' ? '0' : myController.text);
                if(total < 0){
                  setState(() {
                    myController.text = (int.parse(myController.text) + total).toString();
                  });
                }
                configPvd.irrigationLinesFunctionality(['editLevelSensor',widget.index,myController.text]);
                break;
              }
              case ('irrigationLinesFunctionality/fogger'):{
                var total = configPvd.totalFogger + int.parse(configPvd.irrigationLines[widget.index]['fogger'] == '' ? '0' : configPvd.irrigationLines[widget.index]['fogger']);
                total = total - int.parse(myController.text == '' ? '0' : myController.text);
                if(total < 0){
                  setState(() {
                    myController.text = (int.parse(myController.text) + total).toString();
                  });
                }
                configPvd.irrigationLinesFunctionality(['editFogger',widget.index,myController.text]);
                break;
              }
              case ('irrigationLinesFunctionality/fan'):{
                var total = configPvd.totalFan + int.parse(configPvd.irrigationLines[widget.index]['fan'] == '' ? '0' : configPvd.irrigationLines[widget.index]['fan']);
                total = total - int.parse(myController.text == '' ? '0' : myController.text);
                if(total < 0){
                  setState(() {
                    myController.text = (int.parse(myController.text) + total).toString();
                  });
                }
                configPvd.irrigationLinesFunctionality(['editFan',widget.index,myController.text]);
                break;
              }
              case ('centralDosingFunctionality/editBoosterPump'):{
                var total = configPvd.totalBooster + int.parse(configPvd.centralDosingUpdated[widget.index]['boosterPump'] == '' ? '0' : configPvd.centralDosingUpdated[widget.index]['boosterPump']);
                total = total - int.parse(myController.text == '' ? '0' : myController.text);
                if(total < 0){
                  setState(() {
                    myController.text = (int.parse(myController.text) + total).toString();
                  });
                }
                configPvd.centralDosingFunctionality(['editBoosterPump',widget.index,myController.text]);
                break;
              }
              case ('centralDosingFunctionality/editEcSensor'):{
                var total = configPvd.totalEcSensor + int.parse(configPvd.centralDosingUpdated[widget.index]['ec'] == '' ? '0' : configPvd.centralDosingUpdated[widget.index]['ec']);
                total = total - int.parse(myController.text == '' ? '0' : myController.text);
                if(total < 0){
                  setState(() {
                    myController.text = (int.parse(myController.text) + total).toString();
                  });
                }
                configPvd.centralDosingFunctionality(['editEcSensor',widget.index,myController.text]);
                break;
              }
              case ('centralDosingFunctionality/editPhSensor'):{
                var total = configPvd.totalPhSensor + int.parse(configPvd.centralDosingUpdated[widget.index]['ph'] == '' ? '0' : configPvd.centralDosingUpdated[widget.index]['ph']);
                total = total - int.parse(myController.text == '' ? '0' : myController.text);
                if(total < 0){
                  setState(() {
                    myController.text = (int.parse(myController.text) + total).toString();
                  });
                }
                configPvd.centralDosingFunctionality(['editPhSensor',widget.index,myController.text]);
                break;
              }
              case ('localDosingFunctionality/editBoosterPump'):{
                var total = configPvd.totalBooster + int.parse(configPvd.localDosingUpdated[widget.index]['boosterPump'] == '' ? '0' : configPvd.localDosingUpdated[widget.index]['boosterPump']);
                total = total - int.parse(myController.text == '' ? '0' : myController.text);
                if(total < 0){
                  setState(() {
                    myController.text = (int.parse(myController.text) + total).toString();
                  });
                }
                configPvd.localDosingFunctionality(['editBoosterPump',widget.index,myController.text]);
                break;
              }
              case ('localDosingFunctionality/editEcSensor'):{
                var total = configPvd.totalEcSensor + int.parse(configPvd.localDosingUpdated[widget.index]['ec'] == '' ? '0' : configPvd.localDosingUpdated[widget.index]['ec']);
                total = total - int.parse(myController.text == '' ? '0' : myController.text);
                if(total < 0){
                  setState(() {
                    myController.text = (int.parse(myController.text) + total).toString();
                  });
                }
                configPvd.localDosingFunctionality(['editEcSensor',widget.index,myController.text]);
                break;
              }
              case ('localDosingFunctionality/editPhSensor'):{
                var total = configPvd.totalPhSensor + int.parse(configPvd.localDosingUpdated[widget.index]['ph'] == '' ? '0' : configPvd.localDosingUpdated[widget.index]['ph']);
                total = total - int.parse(myController.text == '' ? '0' : myController.text);
                if(total < 0){
                  setState(() {
                    myController.text = (int.parse(myController.text) + total).toString();
                  });
                }
                configPvd.localDosingFunctionality(['editPhSensor',widget.index,myController.text]);
                break;
              }
            }
          },
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
        ),
      )
          : Container(
          margin: EdgeInsets.all(2),
          width: 90,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
          height: double.infinity,
          child: Center(child: Text(widget.initialValue,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),))
      ),
    );
  }
}