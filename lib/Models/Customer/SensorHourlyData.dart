
class AllMySensor {
  final String name;
  final Map<String, List<SensorHourlyData>> data;

  AllMySensor({required this.name, required this.data});

  factory AllMySensor.fromJson(Map<String, dynamic> json) {
    Map<String, List<SensorHourlyData>> dataMap = {};
    json['data'].forEach((key, value) {
      dataMap[key] = (value as List).map((item) => SensorHourlyData.fromJson(item)).toList();
    });

    return AllMySensor(
      name: json['name'],
      data: dataMap,
    );
  }
}


class SensorHourlyData {
  final String? name;
  final String id;
  final double value;
  final String hour;


  SensorHourlyData({required this.id, required this.value, required this.hour, required this.name,});

  factory SensorHourlyData.fromJson(Map<String, dynamic> json) {

    String snrName = '';
    if (json['Valve'] == null || json['Valve'].toString().isEmpty) {
      snrName = '${json['Name'] ?? json['Id']}';
    } else {
      snrName = '${json['Name'] ?? json['Id']}(${json['Valve']})';
    }

    return SensorHourlyData(
      name: snrName,
      id: json['Id'],
      value: double.tryParse(json['Value']) ?? 0.0,
      hour: json['hour'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'Id': id,
      'Value': value,
      'hour': hour,
    };
  }
}
