import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../Models/DataResponse.dart';

class MySalesBarChart extends StatefulWidget {
  const MySalesBarChart({Key? key, required this.graph}) : super(key: key);
  final Map<String, List<Category>>? graph;

  @override
  MySalesChartState createState() => MySalesChartState();
}

class MySalesChartState extends State<MySalesBarChart> {
  int? selectedSeriesIndex;

  @override
  void didUpdateWidget(MySalesBarChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.graph != widget.graph) {
      selectedSeriesIndex = null; // Reset to show all series
    }
  }

  @override
  Widget build(BuildContext context) {
    List<BarSeries<Category, String>> seriesList = [];

    widget.graph?.forEach((month, categories) {
      seriesList.add(
        BarSeries<Category, String>(
          dataSource: categories,
          xValueMapper: (Category category, int index) => (index + 1).toString(),
          yValueMapper: (Category category, _) => category.totalProduct,
          pointColorMapper: (Category category, _) => category.color,
          name: month,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
          isVisible: selectedSeriesIndex == null || selectedSeriesIndex == seriesList.length,
        ),
      );
    });

    return SfCartesianChart(
      primaryYAxis: NumericAxis(),
      primaryXAxis: CategoryAxis(),
      enableAxisAnimation: true,
      legend: const Legend(
        isVisible: true,
        toggleSeriesVisibility: false,
      ),
      series: seriesList,
      tooltipBehavior: TooltipBehavior(enable: false),
      isTransposed: true,
      onLegendTapped: (LegendTapArgs args) {
        setState(() {
          selectedSeriesIndex = selectedSeriesIndex == args.seriesIndex ? null : args.seriesIndex;
        });
      },
    );
  }
}