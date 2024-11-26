import 'dart:math';

import 'package:flutter/material.dart';
class ConnectedCircles extends StatelessWidget {
  final List<dynamic> list;
  const ConnectedCircles({super.key,required this.list});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/irrigation_image.jpg')
          )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Container(
          //   width: 300,
          //   height: 300,
          //   child: Column(
          //     children: [
          //       ListTile(
          //         leading: Icon(Icons.square,color: Colors.teal,),
          //         title: Text('ORO PUMP'),
          //       ),
          //       ListTile(
          //         leading: Icon(Icons.square,color: Colors.teal,),
          //         title: Text('ORO PUMP'),
          //       ),
          //       ListTile(
          //         leading: Icon(Icons.square,color: Colors.teal,),
          //         title: Text('ORO PUMP'),
          //       ),
          //       ListTile(
          //         leading: Icon(Icons.square,color: Colors.teal,),
          //         title: Text('ORO PUMP'),
          //       ),
          //       ListTile(
          //         leading: Icon(Icons.square,color: Colors.teal,),
          //         title: Text('ORO PUMP'),
          //       ),
          //       ListTile(
          //         leading: Icon(Icons.square,color: Colors.teal,),
          //         title: Text('ORO PUMP'),
          //       ),
          //
          //     ],
          //   ),
          // ),
          SizedBox(
            width: 300,
            height: 300,
            child: CustomPaint(
              painter: CirclesPainter(myList: list),
            ),
          ),
        ],
      ),
    );
  }
}

class CirclesPainter extends CustomPainter {
  final List<dynamic> myList;
  CirclesPainter({required this.myList});
  @override
  // var list = ['RTU PLUS(5)','ORO RTU(5)', 'ORO SMART(2)','SMART PLUS(2)', 'ORO SWITCH(4)', 'ORO WEATHER(2)', 'ORO EXTEND(2)', 'ORO SENSE(2)','ORO PUMP(2)','PUMP PLUS(2)'];
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    const double mainCircleRadius = 50.0;
    const double connectedCircleRadius = 50.0;
    const double lineOffset = 10.0; // Adjust this value to control the line offset
    final int numberOfCircles = myList.length;

    // Draw the surrounding circles with names
    final connectedCirclePaint = Paint()..color = Colors.orange.shade100;
    const textStyle = TextStyle(color: Colors.black, fontSize: 14.0);
    for (int i = 0; i < numberOfCircles; i++) {
      final angle = (i * 2 * pi) / numberOfCircles;
      final x = centerX + cos(angle) * (mainCircleRadius + connectedCircleRadius * 2);
      final y = centerY + sin(angle) * (mainCircleRadius + connectedCircleRadius * 2);

      // Draw surrounding circle
      if(i == 0){
        canvas.drawCircle(Offset(x, y), connectedCircleRadius, connectedCirclePaint);

      }else if(i == 1){
        canvas.drawCircle(Offset(x, y), connectedCircleRadius, Paint()..color = Colors.teal.shade100);
      }else if(i == 2){
        canvas.drawCircle(Offset(x, y), connectedCircleRadius, Paint()..color = Colors.brown.shade100);
      }else if(i == 3){
        canvas.drawCircle(Offset(x, y), connectedCircleRadius, Paint()..color = Colors.yellow.shade100);
      }else if(i == 4){
        canvas.drawCircle(Offset(x, y), connectedCircleRadius, Paint()..color = Colors.blue.shade100);
      }else if(i == 5){
        canvas.drawCircle(Offset(x, y), connectedCircleRadius, Paint()..color = Colors.cyan.shade100);
      }else if(i == 6){
        canvas.drawCircle(Offset(x, y), connectedCircleRadius, Paint()..color = Colors.green.shade100);
      }else{
        canvas.drawCircle(Offset(x, y), connectedCircleRadius, Paint()..color = Colors.red.shade100);

      }

      // Display name for the surrounding circles
      final text = '${myList[i]['name']}(${myList[i]['count']})';
      // final text = '${myList[i]['count']}';
      final textPainter = TextPainter(
        text: TextSpan(text: text, style: const TextStyle(fontSize: 12)),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x - textPainter.width / 2, y - textPainter.height / 2));
    }

    // Draw lines connecting the circles
    for (int i = 0; i < numberOfCircles; i++) {
      final angle = (i * 2 * pi) / numberOfCircles;
      final x = centerX + cos(angle) * (mainCircleRadius + connectedCircleRadius * 2.5);
      final y = centerY + sin(angle) * (mainCircleRadius + connectedCircleRadius * 2.5);

      // Calculate the end point of the line
      final endX = centerX + cos(angle) * (mainCircleRadius - lineOffset);
      final endY = centerY + sin(angle) * (mainCircleRadius - lineOffset);

    }

    // Draw the central circle with a name
    final mainCirclePaint = Paint()..color = Colors.green.shade100;
    canvas.drawCircle(Offset(centerX, centerY), mainCircleRadius, mainCirclePaint);

    const centerText = 'ORO GEM';
    final centerTextPainter = TextPainter(
      text: const TextSpan(text: centerText, style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold)),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    centerTextPainter.layout();
    centerTextPainter.paint(canvas, Offset(centerX - centerTextPainter.width / 2, centerY - centerTextPainter.height / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}