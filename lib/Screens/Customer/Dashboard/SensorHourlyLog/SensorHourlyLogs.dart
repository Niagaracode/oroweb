import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../../Models/Customer/SensorHourlyData.dart';
import '../../../../constants/MyFunction.dart';
import '../../../../constants/http_service.dart';

class SensorHourlyLogs extends StatefulWidget {
  const SensorHourlyLogs({Key? key, required this.userId, required this.controllerId}) : super(key: key);
  final int userId, controllerId;

  @override
  State<SensorHourlyLogs> createState() => _SensorHourlyLogsState();
}

class _SensorHourlyLogsState extends State<SensorHourlyLogs> {
  DateTime selectedDate = DateTime.now();
  List<AllMySensor> sensors = [];
  List<bool> selectedSegments = [true, false];

  @override
  void initState() {
    super.initState();
    getSensorHourlyLogs(widget.userId, widget.controllerId, selectedDate);
  }


  Future<void> getSensorHourlyLogs(userId, controllerId, selectedDate) async {
    String date = DateFormat('yyyy-MM-dd').format(selectedDate);
    Map<String, Object> body = {
      "userId": userId,
      "controllerId": controllerId,
      "fromDate": date,
      "toDate": date
    };

    final response = await HttpService().postRequest("getUserSensorHourlyLog", body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data["code"] == 200) {
        try {
          sensors = (data['data'] as List).map((item) {
            final Map<String, List<SensorHourlyData>> sensorData = {};
            item['data'].forEach((hour, values) {
              sensorData[hour] = (values as List)
                  .map((sensorItem) => SensorHourlyData.fromJson({
                ...sensorItem,
                'hour': hour,
              })).toList();
            });
            return AllMySensor(name: item['name'], data: sensorData);
          }).toList();

          setState(() {
          });
        } catch (e) {
          print('Error: $e');
        }
      }
    }
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        getSensorHourlyLogs(widget.userId, widget.controllerId, selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: sensors.isNotEmpty?DefaultTabController(
        length: sensors.length,
        child: Scaffold(
          appBar: AppBar(
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(45),
              child: Row(
                children: [
                  Expanded(
                    child: TabBar(
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Colors.teal,
                      isScrollable: true,
                      tabs: sensors.map((sensor) => Tab(text: sensor.name)).toList(),
                    ),
                  ),
                  ToggleButtons(
                    isSelected: selectedSegments,
                    onPressed: (int index) {
                      setState(() {
                        for (int i = 0; i < selectedSegments.length; i++) {
                          selectedSegments[i] = i == index;
                        }
                      });
                    },
                    borderRadius: BorderRadius.circular(5.0),
                    constraints: const BoxConstraints(minHeight: 30, minWidth: 60),
                    selectedColor: Colors.white,
                    borderColor: Colors.white.withOpacity(0.3),
                    selectedBorderColor: Colors.white.withOpacity(0.3),
                    fillColor: Colors.teal,
                    color: Colors.grey,
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Icon(Icons.auto_graph_outlined),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Icon(Icons.list_alt),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10,),
                ],
              ),
            ),
            title: const Text('Sensor Data Charts'),
            actions: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    "${selectedDate.toLocal()}".split(' ')[0],
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ),
            ],
          ),
          body: TabBarView(
            children: sensors.map((sensor) {
              return selectedSegments[1]? buildDataTable(sensor.data, sensor.name):buildLineChart(sensor.data, sensor.name);
            }).toList(),
          ),
        ),
      ):
      Scaffold(appBar:AppBar(title: const Text('Sensor Data Charts'),), body: const Center(child: Text('Sensor Hourly log not found'),)),
    );
  }

  Row buildLineChart(Map<String, List<SensorHourlyData>> sensorData, String snrName) {
    final Set<String> allHours = {};
    sensorData.values.expand((hourlyData) => hourlyData).forEach((data) {
      allHours.add(data.hour);
    });

    final List<String> sortedHours = allHours.toList()..sort();
    final Map<String, List<SensorHourlyData>> groupedByName = {};

    sensorData.values.expand((hourlyData) => hourlyData).forEach((data) {
      final sensorName = data.name ?? "Unnamed Sensor";
      groupedByName.putIfAbsent(sensorName, () => []).add(data);
    });

    final List<Color> sensorColors = [Colors.blue, Colors.red, Colors.green, Colors.orange];

    final List<LineSeries<SensorHourlyData, String>> series = [];
    int colorIndex = 0;

    groupedByName.forEach((sensorName, sensorValues) {
      final color = sensorColors[colorIndex % sensorColors.length];
      colorIndex++;

      final dataPoints = sortedHours.map((hour) {
        final data = sensorValues.firstWhere((d) => d.hour == hour,
          orElse: () => SensorHourlyData(id: '', value: 0.0, hour: hour, name: sensorName,),
        );
        return data;
      }).toList();


      series.add(LineSeries<SensorHourlyData, String>(
        name: sensorName,
        dataSource: dataPoints,
        xValueMapper: (SensorHourlyData data, _) => data.hour,
        yValueMapper: (SensorHourlyData data, _) {

          if(snrName=='EC Sensor' || snrName=='PH Sensor'){
            return data.value;
          }else{
            String? result = getUnitByParameter(context, snrName, data.value.toString());
            String? numericString = result?.replaceAll(RegExp(r'[^\d.]+'), '');
            double? value = double.tryParse(numericString!);
            return value ?? 0.0;
          }

        },
        color: color,
        dataLabelSettings: const DataLabelSettings(isVisible: true),
        dataLabelMapper: (SensorHourlyData data, _) {

          if(snrName=='EC Sensor' || snrName=='PH Sensor'){
            return data.value.toString();
          }else{
            String? result = getUnitByParameter(context, snrName, data.value.toString());
            String? numericString = result?.replaceAll(RegExp(r'[^\d.]+'), '');
            return '$numericString';
          }

        },
        markerSettings: const MarkerSettings(isVisible: true),
        dashArray: [4, 4],
        width: 1.5,
        emptyPointSettings: EmptyPointSettings(
          mode: EmptyPointMode.gap,
        ),
      ));
    });

    return Row(
      children: [
        Expanded(
          child: SfCartesianChart(
            primaryXAxis: CategoryAxis(
              title: AxisTitle(text: 'Hours'),
              majorGridLines: const MajorGridLines(width: 0),
              axisLine: const AxisLine(width: 0),
            ),
            primaryYAxis: NumericAxis(
              title: AxisTitle(text: getSensorUnit(snrName, context)),
            ),
            legend: const Legend(isVisible: true, position: LegendPosition.right),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: series,
          ),
        ),
      ],
    );
  }


  Widget buildDataTable(Map<String, List<SensorHourlyData>> sensorData, String snrName) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SensorDataTable(sensorData: sensorData, snrName: snrName,),
    );
  }

}


class SensorDataTable extends StatelessWidget {
  final Map<String, List<SensorHourlyData>> sensorData;
  final String snrName;

  const SensorDataTable({Key? key, required this.sensorData, required this.snrName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sensorNames = <String>{};
    for (var hourlyData in sensorData.values) {
      for (var sensor in hourlyData) {
        sensorNames.add(sensor.name ?? 'Unnamed');
      }
    }

    final List<DataColumn> columns = [
      const DataColumn(label: Text('Sensor Name')),
      ...sensorData.keys.map((hour) => DataColumn(label: Text(hour))).toList(),
    ];

    final sensorValues = <String, List<String>>{};
    for (var hour in sensorData.keys) {
      for (var sensor in sensorData[hour]!) {
        sensorValues.putIfAbsent(sensor.name ?? 'Unnamed', () => List.filled(sensorData.keys.length, ''));
        final index = sensorData.keys.toList().indexOf(hour);
        sensorValues[sensor.name ?? 'Unnamed']![index] = sensor.value.toString();
      }
    }

    final List<DataRow> rows = sensorValues.entries.map((entry) {
      final List<DataCell> cells = [DataCell(Text(entry.key))];

      cells.addAll(entry.value.map((value) {
        String? result = getUnitByParameter(context, snrName, value.toString());
        String? numericString = result?.replaceAll(RegExp(r'[^\d.]+'), '');
        return DataCell(Text(numericString!));
      }));

      return DataRow(cells: cells);
    }).toList();

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 35,
          height: MediaQuery.sizeOf(context).height,
          child: Center(
            child: RotatedBox(
              quarterTurns: 3,
              child: Text(getSensorUnit(snrName, context),
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
        const VerticalDivider(width: 0,),
        DataTable(
          columns: columns,
          rows: rows,
        ),
      ],
    );
  }

}