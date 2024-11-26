class DashBoardValve {
  int sNo;
  String id;
  String name;
  String location;
  bool isOn;

  DashBoardValve({required this.sNo, required this.id, required this.name, required this.location, required this.isOn});

  factory DashBoardValve.fromJson(Map<String, dynamic> json) {
    return DashBoardValve(
      sNo: json['sNo'],
      id: json['id'],
      name: json['name'],
      location: json['location'],
      isOn: json['isOn'],
    );
  }
}