import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../state_management/config_maker_provider.dart';

class TextFormFieldForAddBatch extends StatefulWidget {
  String purpose;
  TextFormFieldForAddBatch({super.key,required this.purpose});

  @override
  State<TextFormFieldForAddBatch> createState() => _TextFormFieldForAddBatchState();
}

class _TextFormFieldForAddBatchState extends State<TextFormFieldForAddBatch> {
  FocusNode myFocus = FocusNode();
  late TextEditingController myController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    var configPvd = Provider.of<ConfigMakerProvider>(context, listen: true);
    return  Container(
      width: 50,
      height: 40,
      child: TextFormField(
        focusNode: myFocus,
        controller: myController,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        ],
        onFieldSubmitted: (value){
          if(value == ''){
            myController.text = '1';
          }
        },
        maxLength: 2,
        onChanged: (value){
          if(value == '0'){
            myController.text = '1';
          }
          switch (widget.purpose){
            case ('addBatchCentralDosing/site') : {
              var total = configPvd.totalCentralDosing - int.parse(myController.text == '' ? '0' : myController.text);
              int value = 0;
              if(total < 0){
                value = int.parse(myController.text) + total;
                myController.text = value.toString();
              }
              print('text : ${myController.text}');
              configPvd.centralDosingFunctionality(['addBatchCentralDosing/site',int.parse(myController.text)]);
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
    );
  }
}