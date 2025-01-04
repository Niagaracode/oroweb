import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
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
  List<AllMySensor> sensors = [];
  List<bool> selectedSegments = [true, false];
  DateRange? selectedDateRange;
  bool visibleLoading = false;

  @override
  void initState() {
    super.initState();
    selectedDateRange = DateRange(
      DateTime.now().subtract(const Duration(days: 0)),
      DateTime.now(),
    );
    getSensorHourlyLogs(widget.userId, widget.controllerId);
  }


  Future<void> getSensorHourlyLogs(userId, controllerId) async {
    sensors.clear();
    indicatorViewShow();
    String sDate = '${selectedDateRange?.start.year}-${selectedDateRange?.start.month.toString().padLeft(2, '0')}-${selectedDateRange?.start.day.toString().padLeft(2, '0')}';
    String eDate = '${selectedDateRange?.end.year}-${selectedDateRange?.end.month.toString().padLeft(2, '0')}-${selectedDateRange?.end.day.toString().padLeft(2, '0')}';

    Map<String, Object> body = {
      "userId": userId,
      "controllerId": controllerId,
      "fromDate": sDate,
      "toDate": eDate
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
          indicatorViewHide();
        } catch (e) {
          print('Error: $e');
          indicatorViewHide();
        }
      }else{
        indicatorViewHide();
      }
    }
  }


  Widget datePickerBuilder(context, dynamic Function(DateRange?) onDateRangeChanged)
  {
    return DateRangePickerWidget(
      doubleMonth: false,
      maximumDateRangeLength: 10,
      quickDateRanges: [
        QuickDateRange(dateRange: null, label: "Remove date range"),
        QuickDateRange(
          label: 'Today',
          dateRange: DateRange(
            DateTime.now().subtract(const Duration(days: 0)),
            DateTime.now(),
          ),
        ),
        QuickDateRange(
          label: 'Last 3 days',
          dateRange: DateRange(
            DateTime.now().subtract(const Duration(days: 2)),
            DateTime.now(),
          ),
        ),
        QuickDateRange(
          label: 'Last 7 days',
          dateRange: DateRange(
            DateTime.now().subtract(const Duration(days: 6)),
            DateTime.now(),
          ),
        ),
        QuickDateRange(
          label: 'Last 10 days',
          dateRange: DateRange(
            DateTime.now().subtract(const Duration(days: 9)),
            DateTime.now(),
          ),
        ),
      ],
      minimumDateRangeLength: 2,
      initialDateRange: selectedDateRange,
      initialDisplayedDate:
      selectedDateRange?.start ?? DateTime.now(),
      onDateRangeChanged: onDateRangeChanged,
      height: 350,
      maxDate: DateTime.now(),
      theme: const CalendarTheme(
        selectedColor: Colors.teal,
        dayNameTextStyle: TextStyle(color: Colors.black45, fontSize: 10),
        inRangeColor: Color(0xFFD9EDFA),
        inRangeTextStyle: TextStyle(color: Colors.teal),
        selectedTextStyle: TextStyle(color: Colors.white),
        todayTextStyle: TextStyle(fontWeight: FontWeight.bold),
        defaultTextStyle: TextStyle(color: Colors.black, fontSize: 12),
        radius: 10,
        tileSize: 40,
        disabledTextStyle: TextStyle(color: Colors.grey),
        //quickDateRangeBackgroundColor: Color(0xFFFFF9F9),
        selectedQuickDateRangeColor: Colors.teal,
      ),
    );
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
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: TextButton(
                  isSemanticButton: true,
                  onPressed: () {
                    showDateRangePickerDialog(
                      context: context,
                      builder: datePickerBuilder,
                      offset: Offset(MediaQuery.sizeOf(context).width-525, 40),
                    ).then((value) {
                      if(value!=null){
                        selectedDateRange = value;
                        getSensorHourlyLogs(widget.userId, widget.controllerId);
                      }
                    },);
                  },
                  child: Text(
                    selectedDateRange != null &&
                        selectedDateRange?.start.day == selectedDateRange?.end.day
                        ? '${selectedDateRange?.start.day}-${selectedDateRange?.start.month}-${selectedDateRange?.start.year}'
                        : '${selectedDateRange?.start.day}-${selectedDateRange?.start.month}-${selectedDateRange?.start.year} to ${selectedDateRange?.end.day}-${selectedDateRange?.end.month}-${selectedDateRange?.end.year}',
                    style: const TextStyle(color: Colors.white),
                  ),
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
      Scaffold(
        appBar:AppBar(
          title: const Text('Sensor Data Charts'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: TextButton(
                isSemanticButton: true,
                onPressed: () {
                  showDateRangePickerDialog(
                    context: context,
                    builder: datePickerBuilder,
                    offset: Offset(MediaQuery.sizeOf(context).width-525, 40),
                  ).then((value) {
                    if(value!=null){
                      selectedDateRange = value;
                      getSensorHourlyLogs(widget.userId, widget.controllerId);
                    }
                  },);
                },
                child: Text(
                  selectedDateRange != null &&
                      selectedDateRange?.start.day == selectedDateRange?.end.day
                      ? '${selectedDateRange?.start.day}-${selectedDateRange?.start.month}-${selectedDateRange?.start.year}'
                      : '${selectedDateRange?.start.day}-${selectedDateRange?.start.month}-${selectedDateRange?.start.year} to ${selectedDateRange?.end.day}-${selectedDateRange?.end.month}-${selectedDateRange?.end.year}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        body: visibleLoading? Visibility(
          visible: visibleLoading,
          child: Container(
            height: double.infinity,
            color: Colors.transparent,
            padding: EdgeInsets.fromLTRB(MediaQuery.sizeOf(context).width/2 - 25, 0, MediaQuery.sizeOf(context).width/2 - 25, 0),
            child: const LoadingIndicator(
              indicatorType: Indicator.ballPulse,
            ),
          ),
        ):
        const Center(child: Text('Sensor Hourly log not found'),),
      ),
    );
  }

  Row buildLineChart(Map<String, List<SensorHourlyData>> sensorData, String snrName) {
    final Set<String> allHours = {};

    // Collect all unique hours from the sensor data
    sensorData.values.expand((hourlyData) => hourlyData).forEach((data) {
      allHours.add(data.hour);
    });

    // Sort the hours and remove duplicate dates, keeping the date only for the first occurrence
    final List<String> sortedHours = removeDuplicateDates(allHours.toList()..sort());

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
      //print(sensorValues);

      final dataPoints = sortedHours.map((hour) {
        //print(hour);
        final data = sensorValues.firstWhere(
              (d) => d.hour == hour,
          orElse: () => SensorHourlyData(id: '', value: 0.0, hour: hour, name: sensorName, sNo: 0),
        );
        //print(data.value);
        return data;
      }).toList();

      series.add(LineSeries<SensorHourlyData, String>(
        name: sensorName,
        dataSource: dataPoints,
        xValueMapper: (SensorHourlyData data, _) => data.hour,
        yValueMapper: (SensorHourlyData data, _) {
          if (snrName == 'EC Sensor' || snrName == 'PH Sensor') {
            return data.value;
          } else {
            String? result = getUnitByParameter(context, snrName, data.value.toString());
            String? numericString = result?.replaceAll(RegExp(r'[^\d.]+'), '');
            double? value = double.tryParse(numericString!);
            return value ?? 0.0;
          }
        },
        color: color,
        dataLabelSettings: const DataLabelSettings(isVisible: true),
        dataLabelMapper: (SensorHourlyData data, _) {
          if (snrName == 'EC Sensor' || snrName == 'PH Sensor') {
            return data.value.toString();
          } else {
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
              visibleMinimum: 0,
              visibleMaximum: 10, // Adjust based on initial view
              interval: 0.7,
            ),
            primaryYAxis: NumericAxis(
              title: AxisTitle(text: getSensorUnit(snrName, context)),
            ),
            legend: const Legend(isVisible: true, position: LegendPosition.right),
            tooltipBehavior: TooltipBehavior(enable: true),
            zoomPanBehavior: ZoomPanBehavior(
              enablePanning: true,
              enablePinching: true,
              enableDoubleTapZooming: true,
            ),
            series: series,
          ),
        ),
      ],
    );
  }

  List<String> removeDuplicateDates(List<String> hours) {
    String? previousDate;
    return hours.map((hour) {

      final parts = hour.split(' ');
      final currentDate = parts[0];
      /*List<String> partsD = currentDate.split('-'); // Split into year, month, and date
      String lastPart = "${partsD[2]}-${partsD[1]}";*/

      final time = parts[1];

      //return '${currentDate.split('-').last}-$time';
      return hour;
      /*final parts = hour.split(' '); // Split into date and time
      final currentDate = parts[0];
      final time = parts[1];
      //return time;
      if (currentDate == previousDate) {
        return time; // Return only time if date is duplicate
      } else {
        previousDate = currentDate;
        return hour; // Return full timestamp for the first occurrence
      }*/
    }).toList();
  }


  Widget buildDataTable(Map<String, List<SensorHourlyData>> sensorData, String snrName) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SensorDataTable(sensorData: sensorData, snrName: snrName,),
    );
  }

  void indicatorViewShow() {
    if(mounted){
      setState(() {
        visibleLoading = true;
      });
    }
  }

  void indicatorViewHide() {
    if(mounted){
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          visibleLoading = false;
        });
      });
    }
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