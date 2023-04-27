import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'sensor_view_data.dart';

/// Widget for displaying Graph in Historic View
class GraphView extends LineChart {
  /// Variable that determines how many data points are needed
  final int lineDataCount;
  final List<SensorViewData> lineData;

  GraphView({super.key, required this.lineDataCount, required this.lineData})
      : super(
          LineChartData(
            lineTouchData: lineTouchData,
            gridData: gridData,
            titlesData: titleData,
            borderData: borderData,
            lineBarsData: chartData(lineDataCount),
            minX: getMinTimeStamp(lineData),
            maxX: getMaxTimeStamp(lineData),
            minY: 0,
            maxY: getMaxUnit(lineData) + 1,
          ),
        );
}

/// Determines whether there will be 3 or 1 linechart depending on the parameter
List<LineChartBarData> chartData(int quantity) {
  if (quantity != 3) {
    return [lineChartBarDataX];
  }
  return [lineChartBarDataX, lineChartBarDataY, lineChartBarDataZ];
}

FlGridData get gridData => FlGridData(show: false);

/// Changes border attribute for the graph
FlBorderData get borderData => FlBorderData(
      border: Border.all(
        color: Colors.white,
        width: 1,
      ),
    );

/// Handles the touch event from the graph
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
            "${'${DateFormat('HH:mm').format(date)} '}\n"
            "${touchedSpot.y.toStringAsFixed(2)}",
            textStyle,
          );
        }).toList(),
      ),
    );

/// Handles the data from Graph
LineChartBarData _getLineChartBarData(Color color, List<FlSpot> spots) =>
    LineChartBarData(
      color: color,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      barWidth: 3,
      isCurved: true,
      spots: spots,
    );

LineChartBarData get lineChartBarDataX => _getLineChartBarData(
      Colors.red,
      testData.map((data) => FlSpot(data.timestamp, data.x)).toList(),
    );

LineChartBarData get lineChartBarDataY => _getLineChartBarData(
      Colors.green,
      testData.map((data) => FlSpot(data.timestamp, data.y!)).toList(),
    );

LineChartBarData get lineChartBarDataZ => _getLineChartBarData(
      Colors.blue,
      testData.map((data) => FlSpot(data.timestamp, data.z!)).toList(),
    );

/// Handles the titles
FlTitlesData get titleData => FlTitlesData(
      bottomTitles: AxisTitles(sideTitles: bottomTitles),
      leftTitles: AxisTitles(sideTitles: leftTitles),
      rightTitles: AxisTitles(sideTitles: SideTitles()),
      topTitles: AxisTitles(sideTitles: SideTitles()),
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
  text = Text('${DateFormat('HH:mm').format(date)}\n ', style: style);

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
