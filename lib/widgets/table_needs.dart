import 'package:flutter/material.dart';
Widget expandedTableCell_Text(String first,String second,[String? column,TextStyle? mystyle]){
  return  Expanded(
    child: Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
          color: Colors.indigo.shade50,
          border: Border(
            top: BorderSide(width: 1),
            bottom: BorderSide(width: 1),
            right: BorderSide(width: 1),
            left: BorderSide(width: column != null ? 1 : 0),
          )
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('${first}',style: mystyle == null ? TextStyle(color: Colors.black87) : mystyle,),
          if(second != '')
            Text('${second}',style: mystyle == null ? TextStyle(color: Colors.black87) : mystyle,),
        ],
      ),
    ),
  );
}
Widget fixedTableCell_Text(String first,String second,double myWidth,[TextStyle? mystyle,bool? left]){
  return  Container(
    width: myWidth,
    height: 50,
    decoration: BoxDecoration(
        color: Colors.indigo.shade50,
        border: Border(
          top: BorderSide(width: 1),
          bottom: BorderSide(width: 1),
          right: BorderSide(width: 1),
          left: BorderSide(width: left != null ? 1 : 0),
        )
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('${first}',style: mystyle == null ? TextStyle(color: Colors.black87) : mystyle,),
        if(second != '')
          Text('${second}',style: mystyle == null ? TextStyle(color: Colors.black87) : mystyle,),
      ],
    ),
  );
}


Widget expandedCustomCell(Widget mywidget,[String? row ,Color? colors,height]){
  return  Expanded(
    child: Container(
      decoration: BoxDecoration(
          border: Border(
            left: BorderSide(width: row != null ? 1 : 0),
            right: BorderSide(width: 1),
          )
      ),     width: double.infinity,
      height: height == null ? 40 : height,
      child: Center(child: mywidget),
    ),
  );
}
Widget expandedForAlarmType(Widget mywidget,[String? row,bool? last ]){
  return  Expanded(
    child: Container(
      decoration: BoxDecoration(
          border: Border(
              left: BorderSide(width: row != null ? 1 : 0),
              right: BorderSide(width: 1),
              bottom: BorderSide(width: last == true ? 0 : 1)
          )
      ),     width: double.infinity,
      height: 40 ,
      child: Center(child: mywidget),
    ),
  );
}

Widget expandedNestedCustomCell(List<Widget> listOfWidget){
  print('came');
  return Expanded(
    child: Container(
      width: double.infinity,
      height: listOfWidget.length * 40,
      child: Column(
        children: [
          ...listOfWidget
        ],
      ),
    ),
  );
}



Widget fixedSizeCustomCell(Widget mywidget,double myWidth,double height,bool border, [Color? colors]){
  return  Container(
    width : myWidth,
    height: height,
    child: Center(child: mywidget),
    decoration: BoxDecoration(
        color: colors,
        border: Border(left: BorderSide(width: border == true ? 1 : 0))
    ),
  );
}



Widget myTable(List<Widget> listOfHeading,Widget tableRows){
  return LayoutBuilder(builder: (BuildContext context,BoxConstraints constrainst){
    var width = constrainst.maxWidth;
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              ...listOfHeading,
            ],
          ),
          tableRows
        ],
      ),
    );
  });
}

Widget returnMyListTile(String heading,Widget mywidget){
  return Container(
    margin: EdgeInsets.only(bottom: 8),
    height: 70,
    padding: EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(width: 0.5),
    ),
    child: Center(
      child: ListTile(
        focusColor: Colors.white,
        selectedColor: Colors.white,
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(10.0)
          ),
          child: Center(
            child: Icon(Icons.people),
          ),
        ),
        contentPadding: EdgeInsets.all(0),
        title: Text(heading,style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
        trailing: Container(
            width: 150,
            child: Center(
                child: mywidget)),
      ),
    ),
  );
}

Widget fixedContainer(Widget myWidget){
  return Container(
    width: 150,
    child: myWidget,
  );
}