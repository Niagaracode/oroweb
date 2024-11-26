import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../state_management/config_maker_provider.dart';

class TextFieldForConfig extends StatefulWidget {
  String initialValue;
  int index;
  ConfigMakerProvider config;
  final String purpose;
  TextFieldForConfig({super.key,required this.index,required this.initialValue,required this.config, required this.purpose});

  @override
  State<TextFieldForConfig> createState() => _TextFieldForConfigState();
}

class _TextFieldForConfigState extends State<TextFieldForConfig> {
  FocusNode myFocus = FocusNode();
  late TextEditingController myController;
  bool focus = false;
  bool isEditing = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myController = TextEditingController();
    myController.text = widget.initialValue;
    myFocus.addListener(() {
      if(myFocus.hasFocus == false){
        toggleEditing();
        setState(() {
          focus = false;
        });
        if(myController.text == ''){
          switch (widget.purpose){
            case ('centralFiltrationFunctionality') : {
              widget.config.centralFiltrationFunctionality(['editFilters',widget.index,'1']);
              widget.config.centralFiltrationFunctionality(['editFilterSelection',widget.index]);
              break;
            }
            case ('localFiltrationFunctionality') : {
              widget.config.localFiltrationFunctionality(['editFilters',widget.index,'1']);
              widget.config.localFiltrationFunctionality(['editFilterSelection',widget.index]);
              break;
            }
            case ('irrigationLinesFunctionality/valve') : {
              widget.config.irrigationLinesFunctionality(['editValve',widget.index,'1']);
              widget.config.irrigationLinesFunctionality(['editValveConnection',widget.index]);
              break;
            }
          }

          myController.text = '1';
        }else{
          switch (widget.purpose){
            case ('centralFiltrationFunctionality') : {
              widget.config.centralFiltrationFunctionality(['editFilterSelection',widget.index]);
              break;
            }
            case ('localFiltrationFunctionality') : {
              widget.config.localFiltrationFunctionality(['editFilterSelection',widget.index]);
              break;
            }
            case ('irrigationLinesFunctionality/valve') : {
              widget.config.irrigationLinesFunctionality(['editValveConnection',widget.index]);
              break;
            }

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
        width: 80,
        child: TextFormField(
          focusNode: myFocus,
          controller: myController,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          ],
          onFieldSubmitted: (value){
            if(value == ''){
              myController.text = '1';
              switch (widget.purpose){
                case ('centralFiltrationFunctionality') : {
                  configPvd.centralFiltrationFunctionality(['editFilters',widget.index,'1']);
                  break;
                }
                case ('irrigationLinesFunctionality/valve') : {
                  configPvd.irrigationLinesFunctionality(['editValve',widget.index,'1']);
                  break;
                }
              }

            }
          },
          maxLength: 2,
          onChanged: (value){
            if(value == '0'){
              myController.text = '1';
            }
            switch (widget.purpose){
              case ('centralFiltrationFunctionality') : {
                var total = configPvd.totalFilter + int.parse(configPvd.centralFiltrationUpdated[widget.index]['filter'] == '' ? '0' : configPvd.centralFiltrationUpdated[widget.index]['filter']);
                total = total - int.parse(myController.text == '' ? '0' : myController.text);
                if(total < 0){
                  setState(() {
                    myController.text = (int.parse(myController.text) + total).toString();
                  });
                }
                configPvd.centralFiltrationFunctionality(['editFilter',widget.index,myController.text]);
                break;
              }
              case ('irrigationLinesFunctionality/valve') : {
                var total = configPvd.totalValve + int.parse(configPvd.irrigationLines[widget.index]['valve'] == '' ? '0' : configPvd.irrigationLines[widget.index]['valve']);
                total = total - int.parse(myController.text == '' ? '0' : myController.text);
                if(total < 0){
                  setState(() {
                    myController.text = (int.parse(myController.text) + total).toString();
                  });
                }
                configPvd.irrigationLinesFunctionality(['editValve',widget.index,myController.text]);
                print(myController.text);
                break;
              }
              case ('localFiltrationFunctionality') : {
                var total = configPvd.totalFilter + int.parse(configPvd.localFiltrationUpdated[widget.index]['filter'] == '' ? '0' : configPvd.localFiltrationUpdated[widget.index]['filter']);
                total = total - int.parse(myController.text == '' ? '0' : myController.text);
                if(total < 0){
                  setState(() {
                    myController.text = (int.parse(myController.text) + total).toString();
                  });
                }
                print('first');
                configPvd.localFiltrationFunctionality(['editFilter',widget.index,myController.text]);
                break;
              }
            }
          },
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              counterText: '',
              border: OutlineInputBorder(
                  borderSide: BorderSide.none
              )
          ),
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
