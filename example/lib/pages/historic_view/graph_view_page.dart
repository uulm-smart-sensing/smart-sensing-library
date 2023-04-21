import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'sensor_data.dart';

/// Widget for displaying Graph in Historic View
class GraphView extends StatelessWidget {
  //variable that determines how many data points are needed
  final int lineData;
  const GraphView({super.key, required this.lineData});

  @override
  Widget build(BuildContext context) => LineChart(
        LineChartData(
          lineTouchData: lineTouchData,
          gridData: gridData,
          titlesData: titleData,
          borderData: borderData,
          lineBarsData: chartData(lineData),
          minX: getMinTimeStamp(testData),
          maxX: getMaxTimeStamp(testData),
          minY: 0,
          maxY: getMaxUnit(testData) + 1,
        ),
      );
}

/// determines whether there will be 3 or 1 linechart depending on the parameter
List<LineChartBarData> chartData(int quantity) {
  if (quantity != 3) {
    return [lineChartBarDataX];
  }
  return [lineChartBarDataX, lineChartBarDataY, lineChartBarDataZ];
}

FlGridData get gridData => FlGridData(show: false);

/// changes border attribute for the graph
FlBorderData get borderData => FlBorderData(
      show: true,
      border: Border.all(
        color: Colors.white,
        width: 1,
      ),
    );

/// handles the touch event from the graph
LineTouchData get lineTouchData => LineTouchData(
      handleBuiltInTouches: true,
      getTouchLineStart: (data, index) => 0,
      touchTooltipData: LineTouchTooltipData(
        fitInsideHorizontally: true,
        fitInsideVertically: true,
        maxContentWidth: 100,
        tooltipBgColor: Colors.black.withOpacity(0.8),
        getTooltipItems: (touchedSpots) => touchedSpots.map((touchedSpot) {
          var textStyle = TextStyle(
            color: touchedSpot.bar.gradient?.colors[0] ?? touchedSpot.bar.color,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          );
          var date = DateTime.fromMillisecondsSinceEpoch(touchedSpot.x.toInt());
          return LineTooltipItem(
            "${'${DateFormat('HH:mm').format(date)} Uhr'}\n"
            "${touchedSpot.y.toStringAsFixed(2)}",
            textStyle,
          );
        }).toList(),
      ),
    );

/// handles the data from Graph
LineChartBarData get lineChartBarDataX => LineChartBarData(
      color: Colors.red,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      barWidth: 3,
      isCurved: true,
      spots: testData.map((data) => FlSpot(data.timestamp, data.x)).toList(),
    );

LineChartBarData get lineChartBarDataY => LineChartBarData(
      color: Colors.green,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      barWidth: 3,
      isCurved: true,
      spots: testData.map((data) => FlSpot(data.timestamp, data.y!)).toList(),
    );

LineChartBarData get lineChartBarDataZ => LineChartBarData(
      color: Colors.blue,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      barWidth: 3,
      isCurved: true,
      spots: testData.map((data) => FlSpot(data.timestamp, data.z!)).toList(),
    );

/// handles the titles
FlTitlesData get titleData => FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(sideTitles: bottomTitles),
      leftTitles: AxisTitles(sideTitles: leftTitles),
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );

SideTitles get bottomTitles => SideTitles(
      showTitles: true,
      reservedSize: 30,
      getTitlesWidget: bottomTitleWidgets,
      interval: (getMaxTimeStamp(testData) - getMinTimeStamp(testData)) / 2,
    );

Widget bottomTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 12,
  );
  Widget text;
  var date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
  text = Text('${DateFormat('HH:mm').format(date)}\n Uhr', style: style);

  return SideTitleWidget(
    axisSide: meta.axisSide,
    space: 4,
    child: text,
  );
}

SideTitles get leftTitles => SideTitles(
      showTitles: true,
      reservedSize: 40,
      getTitlesWidget: leftTitleWidgets,
      interval: getMaxUnit(testData) / 2.5,
    );

Widget leftTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );
  var newValue = value.round();
  return SideTitleWidget(
    axisSide: meta.axisSide,
    space: 4,
    child: Text('$newValue', style: style),
  );
}
