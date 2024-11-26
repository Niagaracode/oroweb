import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state_management/GlobalFertLimitProvider.dart';


class TextFieldForGlobalFert extends StatefulWidget {
  final String initialValue;
  final int index;
  final String purpose;
  const TextFieldForGlobalFert({super.key,
    required this.purpose,
    required this.initialValue,
    required this.index
  });

  @override
  State<TextFieldForGlobalFert> createState() => _TextFieldForGlobalFertState();
}

class _TextFieldForGlobalFertState extends State<TextFieldForGlobalFert> {
  TextEditingController myController = TextEditingController();
  FocusNode myFocus = FocusNode();
  bool isEditing = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('value : ${widget.initialValue}    ${myController.text}');
    myController.text = widget.initialValue;
    myFocus.addListener(() {
      if(myFocus.hasFocus == false){
        toggleEditing();
      }
    });
  }
  void toggleEditing() {
    setState(() {
      isEditing = !isEditing;
      if (isEditing) {
        myController.text = widget.initialValue;
        myFocus.requestFocus();
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    var gfertpvd = Provider.of<GlobalFertLimitProvider>(context, listen: true);
    return GestureDetector(
      onTap: toggleEditing,
      child: isEditing
          ? SizedBox(
        width: 90,
        child: TextFormField(
          style: const TextStyle(fontSize: 12),
          controller: myController,
          autofocus: true,
          focusNode: myFocus,
          maxLength: 7,
          onChanged: (value){
            var split = widget.purpose.split('/');
            print('split : $split');
            if(split[0] == 'central_local'){
              gfertpvd.editGfert(split[0], int.parse(split[1]), int.parse(split[2]), split[3], value);
            }else if(split[0] == 'quantity'){
              gfertpvd.editGfert(split[0], int.parse(split[1]), int.parse(split[2]), split[3], value);
            }
          },
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
              counterText: '',
              border: OutlineInputBorder(
                  borderSide: BorderSide.none
              )
          ),
        ),
      )
          : Container(
          margin: const EdgeInsets.all(2),
          width: 90,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
          height: double.infinity,
          child: Center(child: Text(widget.initialValue,style: const TextStyle(fontSize: 12,fontWeight: FontWeight.w600),))
      ),
    );
  }
}
