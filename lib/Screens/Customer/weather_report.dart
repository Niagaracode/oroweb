import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../Models/weatherreport_model.dart';
import '../../constants/http_service.dart';

enum Segment { Hourly, Weekly, Monthly }

class WeatherReportbar extends StatefulWidget {
  WeatherReportbar({
    super.key,
    required this.titletype,
    required this.titlekeyvalue,
    required this.userId,
    required this.controllerId,
    required this.Sno,
    required this.index,
  });
  String titletype;
  String titlekeyvalue;
  final userId, controllerId,Sno,index;

  @override
  State<WeatherReportbar> createState() => _WeatherReportbarState();
}

class _WeatherReportbarState extends State<WeatherReportbar> {
  String title = 'bar chart';
  DateTime startDate = DateTime.now();
  DateTime? endDate = DateTime.now();
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  WeatherModelReport _weatherModelReport = WeatherModelReport();
  List tempData = [];
  List timeData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        fetchData();
      });
    }
  }

  Future<void> fetchData() async {
    Map<String, Object> body = {
      "userId": widget.userId,
      "controllerId": widget.controllerId,
      "fromDate": dateFormat.format(startDate),
      "toDate": dateFormat.format(startDate)
    };
    print('body:$body');
    final response =
    await HttpService().postRequest("getUserWeatherReport", body);
    if (response.statusCode == 200) {

      var jsondata = jsonDecode(response.body);
      if (jsondata['code'] == 200) {
        setState(() {
          _weatherModelReport = WeatherModelReport.fromJson(jsondata);
          timeData = graphvalueassign(jsondata, 'time');
          tempData = graphvalueassign(jsondata, widget.titlekeyvalue);
        });
      }
      if (jsondata['code'] == 404) {
        setState(() {
          timeData = [];
          tempData = [];
        });
      }

    } else {
      // Globalsc (response.body);
    }
  }

  List<String> graphvalueassign(Map<String, dynamic> json, String key) {
    List<String> keyvalue = [
      "hour1",
      "hour1",
      "hour2",
      "hour3",
      "hour4",
      "hour5",
      "hour6",
      "hour7",
      "hour8",
      "hour9",
      "hour10",
      "hour11",
      "hour12",
      "hour13",
      "hour14",
      "hour15",
      "hour16",
      "hour17",
      "hour18",
      "hour19",
      "hour20",
      "hour21",
      "hour22",
      "hour23",
      "hour24",
    ];
    List<String> value = [];
    for (var i = 1; i < json['data'][0]!.length; i++) {
      if (i <= keyvalue.length) {
        if (json['data'][0]['${keyvalue[i]}'].isNotEmpty) {
          String time = json['data'][0]['${keyvalue[i]}'][widget.index][key];
          value.add(time);
        } else {
          if (key == 'time') {
            var ival = (i - 1).toString().padLeft(2, '0');
            value.add('$ival:00:00');
          } else {
            value.add('0');
          }
        }
      }
    }
    return value;
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != startDate) {
      setState(() {
        startDate = picked;
        endDate = null;
        fetchData();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.titletype} Report')),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            width: 300,
            child: ListTile(
              title: Text("Date: ${dateFormat.format(startDate)}"),
              trailing: Icon(Icons.calendar_today),
              onTap: () => _selectStartDate(context),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ScrollableChart(
              titletype: widget.titletype,
              titlekeyvalue: widget.titlekeyvalue,
              tempData: tempData,
              timeData: timeData, Sno: widget.Sno,
            ),
          ),
        ],
      ),
    );
  }
}

class ScrollableChart extends StatefulWidget {
  ScrollableChart(
      {super.key,
        required this.titletype,
        required this.titlekeyvalue,
        required this.tempData,
        required this.timeData,
        required this.Sno,});
  Segment selectedSegment = Segment.Hourly;
  String titletype;
  String titlekeyvalue;
  List tempData;
  List timeData;
  int Sno;
  @override
  State<ScrollableChart> createState() => _ScrollableChartState();
}

class _ScrollableChartState extends State<ScrollableChart> {

  WeatherModelReport _weatherModelReport = WeatherModelReport();

  // @override
  // void initState() {
  //     fetchData();
  // }
  String titleunits(String title){

    if(title == 'SoilMoisture1') {
      return 'CB';
    } else if (title == 'SoilMoisture2') {
      return 'CB';
    } else if (title == 'SoilMoisture3') {
      return 'CB';
    } else if (title == 'SoilMoisture4') {
      return 'CB';
    } else if (title == 'SoilTemperature') {
      return '°C';

    } else if (title == 'Temperature') {
      return '°C';

    } else if (title == 'AtmospherePressure') {
      return 'kPa';

    } else if (title == 'Humidity') {
      return '%';

    } else if (title == 'LeafWetness') {
      return '%';

    } else if (title == 'Co2') {
      return 'ppm';

    } else if (title == 'LDR') {
      return 'Lu';

    } else if (title == 'Lux') {
      return 'Lu';

    } else if (title == 'WindDirection') {
      return '';

    } else if (title == 'Rainfall') {
      return 'mm';

    } else if (title == 'WindSpeed') {
      return 'km/h';

    } else {
      return '';
    }
  }


  @override
  Widget build(BuildContext context) {
    String titletypeunits = titleunits(widget.titletype);
    if (widget.timeData.isEmpty) {
      return const Center(
          child: Text('User weather report not found'));
    } else {
      List<SalesData> chartData = [];
      List<String> charList = widget.titletype.split('');
      for (int index = 0; index < widget.tempData.length; index++) {
        chartData
            .add(SalesData(widget.timeData[index], double.parse(widget.tempData[index])));
      }
      //String replacedValue = '${part[1]} $index';?
      String yaxixname = 'Hours';


      chartData = [];
      for (int index = 0; index < 24; index++) {
        String replacedValue = '${index + 1}';
        chartData.add(SalesData(replacedValue, double.parse(widget.tempData[index])));
      }
      // chartData = chartData.sublist(0, 30);
      yaxixname = 'Hours';
      // }

      // }
      return Column(
        children: [
          Expanded(
            child: Center(
              child: widget.selectedSegment == Segment.Hourly
                  ? SfCartesianChart(
                backgroundColor: Colors.grey[200],
                // Background color
                enableSideBySideSeriesPlacement: true,
                borderColor: Colors.blue,
                // Border color
                borderWidth: 1.5,
                // Border width
                plotAreaBackgroundColor: Colors.white,
                plotAreaBorderColor: Colors.grey[400],
                plotAreaBorderWidth: 0.5,

                onMarkerRender: (MarkerRenderArgs markerRenderArgs) {
                  markerRenderArgs.color = Colors.red;
                  markerRenderArgs.borderWidth = 2;
                },
                palette: const <Color>[
                  Colors.blue,
                  Colors.green,
                  Colors.orange,
                ],
                // Add your chart properties and data here
                zoomPanBehavior: ZoomPanBehavior(
                  enablePinching: true,
                  enablePanning: true,
                  enableDoubleTapZooming: true,
                ),
                // Axis names

                primaryXAxis: CategoryAxis(
                    title: AxisTitle(text: yaxixname),
                    autoScrollingMode: AutoScrollingMode.start),
                primaryYAxis:
                NumericAxis(title: AxisTitle(text: "${widget.titletype} ($titletypeunits) values")),
                series: <ChartSeries>[
                  LineSeries<SalesData, String>(
                    dataSource: chartData,
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                    xValueMapper: (SalesData sales, _) => '${sales.year}-Hrs',
                    yValueMapper: (SalesData sales, _) => sales.sales,
                    name: 'name',
                    yAxisName: 'Sales',
                    xAxisName: 'Year',
                    isVisibleInLegend: true,
                    legendItemText: 'graph',
                    markerSettings: const MarkerSettings(
                      isVisible: true,
                      color: Colors.blue,
                      height: 10,
                      width: 10,
                      shape: DataMarkerType.circle,
                    ),
                  ),
                ],
                tooltipBehavior: TooltipBehavior(
                  enable: true,
                  header: widget.titletype,
                  duration: 0.5,
                ),
              )
                  : SfCartesianChart(
                  backgroundColor: Colors.grey[200],
                  enableSideBySideSeriesPlacement: true,
                  borderColor: Colors.blue,
                  // Border color
                  borderWidth: 1.5,
                  // Border width
                  plotAreaBackgroundColor: Colors.white,
                  plotAreaBorderColor: Colors.grey[400],
                  plotAreaBorderWidth: 0.5,
                  primaryXAxis: CategoryAxis(
                      title: AxisTitle(text: yaxixname),
                      autoScrollingMode: AutoScrollingMode.start),
                  primaryYAxis:
                  NumericAxis(title: AxisTitle(text: "${widget.titletype} ($titletypeunits) values")),
                  // primaryXAxis: CategoryAxis(),
                  // primaryYAxis: NumericAxis(minimum: 0, maximum: 40, interval: 10),
                  tooltipBehavior: TooltipBehavior(
                    enable: true,
                    header: widget.titletype,
                    duration: 1.0,
                  ),
                  series: <ChartSeries>[
                    ColumnSeries<SalesData, String>(
                        width: 0.2,
                        dataSource: chartData,
                        xValueMapper: (SalesData sales, _) => sales.year,
                        yValueMapper: (SalesData sales, _) => sales.sales,
                        name: widget.titletype,
                        color: Color.fromRGBO(8, 142, 255, 1))
                  ]),
            ),
          ),
        ],
      );
    }
  }

}

class SalesData {
  final String year;
  final double sales;

  SalesData(this.year, this.sales);
}
