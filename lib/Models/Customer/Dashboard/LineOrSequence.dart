import 'DashBoardValve.dart';
import 'Sensor.dart';

class LineOrSequence {
  dynamic sNo;
  String id;
  String name, location, time, flow, type;
  List<DashBoardValve> valves;
  List<Sensor> sensor;
  bool selected;


  LineOrSequence({required this.sNo, required this.id, required this.name, required this.location,required this.time,
    required this.flow, required this.type,  required this.valves, required this.sensor, required this.selected});

  factory LineOrSequence.fromJson(Map<String, dynamic> json) {
    var valveList = json['valve'] as List;
    var sensors = json['sensor'] as List;

    List<DashBoardValve> valves = valveList.map((valveJson) => DashBoardValve.fromJson(valveJson)).toList();
    List<Sensor> sensor = sensors.map((valveJson) => Sensor.fromJson(valveJson)).toList();


    return LineOrSequence(
      sNo: json['sNo'],
      id: json['id'],
      name: json['name'],
      location: json['location'],
      time: json['time'],
      flow: json['flow'],
      type: json['type'],
      valves: valves,
      sensor: sensor,
      selected: json['selected'],
    );
  }
}