class PumpLogMDL {
  String? logDate;
  String? motor1;
  String? motor2;
  String? motor3;

  PumpLogMDL({this.logDate, this.motor1, this.motor2, this.motor3});

  PumpLogMDL.fromJson(Map<String, dynamic> json) {
    logDate = json['logDate'];
    motor1 = json['motor1'];
    motor2 = json['motor2'];
    motor3 = json['motor3'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['logDate'] = logDate;
    data['motor1'] = motor1;
    data['motor2'] = motor2;
    data['motor3'] = motor3;
    return data;
  }
}