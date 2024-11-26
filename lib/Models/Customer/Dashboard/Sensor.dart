class Sensor {
  int sNo;
  String id;
  String name;
  String location;

  Sensor({required this.sNo, required this.id, required this.name, required this.location});

  factory Sensor.fromJson(Map<String, dynamic> json) {
    return Sensor(
      sNo: json['sNo'],
      id: json['id'],
      name: json['name'],
      location: json['location'],
    );
  }
}