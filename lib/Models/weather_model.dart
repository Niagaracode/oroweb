

import 'dart:convert';

WeatherModel weatherModelFromJson(String str) => WeatherModel.fromJson(json.decode(str));

String weatherModelToJson(WeatherModel data) => json.encode(data.toJson());

class WeatherModel {
  List<Datum>? data;

  WeatherModel({
    this.data,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) => WeatherModel(
    data: json["5100"] == null ? [] : List<Datum>.from(json["5100"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "5100": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  List<Weatherdata>? WeatherSensorlist;

  Datum({
    this.WeatherSensorlist,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    WeatherSensorlist: json["5101"] == null ? [] : List<Weatherdata>.from(json["5101"]!.map((x) => Weatherdata.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "5101": WeatherSensorlist == null ? [] : List<dynamic>.from(WeatherSensorlist!.map((x) => x.toJson())),
  };
}

class Weatherdata {
  int? sNo;
  String? date;
  String? time;
  String? soilMoisture1;
  String? soilMoisture2;
  String? soilMoisture3;
  String? soilMoisture4;
  String? soilTemperature;
  String? humidity;
  String? temperature;
  String? atmospherePressure;
  String? co2;
  String? ldr;
  String? lux;
  String? windDirection;
  String? windSpeed;
  String? rainfall;
  String? leafWetness;
  String? soilMoisture1Err;
  String? soilMoisture2Err;
  String? soilMoisture3Err;
  String? soilMoisture4Err;
  String? soilTemperatureErr;
  String? humidityErr;
  String? temperatureErr;
  String? atmospherePressureErr;
  String? co2Err;
  String? ldrErr;
  String? luxErr;
  String? windDirectionErr;
  String? windSpeedErr;
  String? rainfallErr;
  String? leafWetnessErr;
  List<String> sensorlist;
  List<String> sensorlisthw;
  String? irrigationLine;
  String? irrigationLineName;
  String? deviceName;

  Weatherdata({
    this.sNo,
    this.date,
    this.time,
    this.soilMoisture1,
    this.soilMoisture2,
    this.soilMoisture3,
    this.soilMoisture4,
    this.soilTemperature,
    this.humidity,
    this.temperature,
    this.atmospherePressure,
    this.co2,
    this.ldr,
    this.lux,
    this.windDirection,
    this.windSpeed,
    this.rainfall,
    this.leafWetness,
    this.soilMoisture1Err,
    this.soilMoisture2Err,
    this.soilMoisture3Err,
    this.soilMoisture4Err,
    this.soilTemperatureErr,
    this.humidityErr,
    this.temperatureErr,
    this.atmospherePressureErr,
    this.co2Err,
    this.ldrErr,
    this.luxErr,
    this.windDirectionErr,
    this.windSpeedErr,
    this.rainfallErr,
    this.leafWetnessErr,
    required this.sensorlist,
    required this.sensorlisthw,
    this.irrigationLine,
    this.irrigationLineName,
    this.deviceName,

  });

  factory Weatherdata.fromJson(Map<String, dynamic> json) => Weatherdata(
    sNo: json["sNo"],
    date: json["date"],
    time: json["time"],
    soilMoisture1: '${json["1- Value"]}',
    soilMoisture2: '${json["2- Value"]}',
    soilMoisture3: '${json["3- Value"]}',
    soilMoisture4: '${json["4- Value"]}',
    soilTemperature: double.parse(json["5- Value"]) > 60 ?  '60 °C' : '${json["5- Value"]}',
    humidity: '${json["6- Value"]}',
    temperature: double.parse(json["7- Value"]) > 60 ?  '60 °C' : '${json["7- Value"]}',
    atmospherePressure: '${json["8- Value"]}',
    co2: '${json["9- Value"]}',
    ldr: '${json["10- Value"]}',
    lux: '${json["11- Value"]}',
    windDirection: '${json["12- Value"]}',
    windSpeed: '${json["13- Value"]}',
    rainfall: '${json["14- Value"]}',
    leafWetness: '${json["15- Value"]}',
    soilMoisture1Err: json["1- Errorstatus"],
    soilMoisture2Err: json["2- Errorstatus"],
    soilMoisture3Err: json["3- Errorstatus"],
    soilMoisture4Err: json["4- Errorstatus"],
    soilTemperatureErr: json["5- Errorstatus"],
    humidityErr: json["6- Errorstatus"],
    temperatureErr: json["7- Errorstatus"],
    atmospherePressureErr: json["8- Errorstatus"],
    co2Err: json["9- Errorstatus"],
    ldrErr: json["10- Errorstatus"],
    luxErr: json["11- Errorstatus"],
    windDirectionErr: json["12- Errorstatus"],
    windSpeedErr: json["13- Errorstatus"],
    rainfallErr: json["14- Errorstatus"],
    leafWetnessErr: json["15- Errorstatus"],
    sensorlist: _buildsensorlist(json),
    sensorlisthw: _buildsensorhwlist(json),
    irrigationLine: json["IrrigationLine"],
    irrigationLineName: json["irrigationLineName"],
    deviceName: json["deviceName"],
  );

  Map<String, dynamic> toJson() => {
    "sNo": sNo,
    "date": date,
    "time": time,
    "SoilMoisture1": soilMoisture1,
    "SoilMoisture2": soilMoisture2,
    "SoilMoisture3": soilMoisture3,
    "SoilMoisture4": soilMoisture4,
    "SoilTemperature": soilTemperature,
    "Humidity": humidity,
    "Temperature": temperature,
    "AtmospherePressure": atmospherePressure,
    "Co2": co2,
    "LDR": ldr,
    "Lux": lux,
    "WindDirection": windDirection,
    "WindSpeed": windSpeed,
    "Rainfall": rainfall,
    "LeafWetness": leafWetness,
    "SoilMoisture1Err": soilMoisture1Err,
    "SoilMoisture2Err": soilMoisture2Err,
    "SoilMoisture3Err": soilMoisture3Err,
    "SoilMoisture4Err": soilMoisture4Err,
    "SoilTemperatureErr": soilTemperatureErr,
    "HumidityErr": humidityErr,
    "TemperatureErr": temperatureErr,
    "AtmospherePressureErr": atmospherePressureErr,
    "Co2Err": co2Err,
    "LDRErr": ldrErr,
    "LuxErr": luxErr,
    "WindDirectionErr": windDirectionErr,
    "WindSpeedErr": windSpeedErr,
    "RainfallErr": rainfallErr,
    "LeafWetnessErr": leafWetnessErr,
    "IrrigationLine": irrigationLine,
    "IrrigationLineName": irrigationLine,
    "DeviceName": irrigationLine,

  };

  static List<String> _buildsensorlist(Map<String, dynamic> json)
  {
    print('_buildsensorlist');
    List<String> sensorlist = [];

    if(json["1- Value"] != '-')
    {
      sensorlist.add('SoilMoisture1');
    }
    if(json["2- Value"] != '-')
    {
      sensorlist.add('SoilMoisture2');
    }
    if(json["3- Value"] != '-')
    {
      sensorlist.add('SoilMoisture3');
    }
    if(json["4- Value"] != '-')
    {
      sensorlist.add('SoilMoisture4');
    }
    if(json["5- Value"] != '-')
    {
      sensorlist.add('SoilTemperature');
    }
    if(json["6- Value"] != '-')
    {
      sensorlist.add('Humidity');
    }
    if(json["7- Value"] != '-')
    {
      sensorlist.add('Temperature');
    }
    if(json["8- Value"] != '-')
    {
      sensorlist.add('AtmospherePressure');
    }
    if(json["9- Value"] != '-')
    {
      sensorlist.add('Co2');
    }
    if(json["10- Value"] != '-')
    {
      sensorlist.add('LDR');
    }
    if(json["11- Value"] != '-')
    {
      sensorlist.add('Lux');
    }
    if(json["12- Value"] != '-')
    {
      sensorlist.add('WindDirection');
    }
    if(json["13- Value"] != '-')
    {
      sensorlist.add('WindSpeed');
    }
    if(json["14- Value"] != '-')
    {
      sensorlist.add('Rainfall');
    }
    if(json["15- Value"] != '-')
    {
      sensorlist.add('LeafWetness');
    }
    return sensorlist;
  }
  static List<String> _buildsensorhwlist(Map<String, dynamic> json)
  {
    print('_buildsensorlist');
    List<String> sensorlist = [];

    if(json["1- Value"] != '-')
    {
      sensorlist.add('1- Value');
    }
    if(json["2- Value"] != '-')
    {
      sensorlist.add('2- Value');
    }
    if(json["3- Value"] != '-')
    {
      sensorlist.add('3- Value');
    }
    if(json["4- Value"] != '-')
    {
      sensorlist.add('4- Value');
    }
    if(json["5- Value"] != '-')
    {
      sensorlist.add('5- Value');
    }
    if(json["6- Value"] != '-')
    {
      sensorlist.add('6- Value');
    }
    if(json["7- Value"] != '-')
    {
      sensorlist.add('7- Value');
    }
    if(json["8- Value"] != '-')
    {
      sensorlist.add('8- Value');
    }
    if(json["9- Value"] != '-')
    {
      sensorlist.add('9- Value');
    }
    if(json["10- Value"] != '-')
    {
      sensorlist.add('10- Value');
    }
    if(json["11- Value"] != '-')
    {
      sensorlist.add('11- Value');
    }
    if(json["12- Value"] != '-')
    {
      sensorlist.add('12- Value');
    }
    if(json["13- Value"] != '-')
    {
      sensorlist.add('13- Value');
    }
    if(json["14- Value"] != '-')
    {
      sensorlist.add('14- Value');
    }
    if(json["15- Value"] != '-')
    {
      sensorlist.add('15- Value');
    }
    return sensorlist;
  }
  static String degreeToDirection(String degreestr) {
    String cleanedString = degreestr.replaceAll('º', '').trim();
    double degree = double.parse(cleanedString);
    if ((degree >= 337.5 && degree <= 360) || (degree >= 0.1 && degree < 22.5)) {
      return 'North';
    } else if (degree >= 22.5 && degree < 67.5) {
      return 'NorthEast';
    } else if (degree >= 67.5 && degree < 112.5) {
      return 'East';
    } else if (degree >= 112.5 && degree < 157.5) {
      return 'SouthEast';
    } else if (degree >= 157.5 && degree < 202.5) {
      return 'South';
    } else if (degree >= 202.5 && degree < 247.5) {
      return 'SouthWest';
    } else if (degree >= 247.5 && degree < 292.5) {
      return 'West';
    } else if (degree >= 292.5 && degree < 337.5) {
      return 'NorthWest';
    } else {
      return degreestr;
    }
  }
}
