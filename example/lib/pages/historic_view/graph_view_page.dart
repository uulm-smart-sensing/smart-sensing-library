import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GraphView extends StatelessWidget {
  const GraphView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("Sensor settings"),
        ),
        body: AspectRatio(
          aspectRatio: 1.7,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 18,
              top: 40,
              bottom: 4,
            ),
            child: LineChart(
              chartData,
            ),
          ),
        ),
      );
}

LineChartData get chartData => LineChartData(
      lineTouchData: lineTouchData,
      gridData: gridData,
      titlesData: titleData,
      borderData: borderData,
      lineBarsData: lineBarsData,
      minX: xData.first.timestamp,
      maxX: xData.last.timestamp,
      minY: 0,
      maxY: 6,
    );

FlGridData get gridData => FlGridData(show: false);
FlBorderData get borderData => FlBorderData(
      show: true,
      border: Border.all(
        color: Colors.white,
        width: 1,
      ),
    );
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
List<LineChartBarData> get lineBarsData => [
      lineChartBarDataX,
      lineChartBarDataY,
      lineChartBarDataZ,
    ];
LineChartBarData get lineChartBarDataX => LineChartBarData(
      color: Colors.red,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      barWidth: 3,
      isCurved: true,
      spots: xData.map((data) => FlSpot(data.timestamp, data.unit)).toList(),
    );

LineChartBarData get lineChartBarDataY => LineChartBarData(
      color: Colors.green,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      barWidth: 3,
      isCurved: true,
      spots: yData.map((data) => FlSpot(data.timestamp, data.unit)).toList(),
    );

LineChartBarData get lineChartBarDataZ => LineChartBarData(
      color: Colors.blue,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      barWidth: 3,
      isCurved: true,
      spots: zData.map((data) => FlSpot(data.timestamp, data.unit)).toList(),
    );

FlTitlesData get titleData => FlTitlesData(
      show: true,
      bottomTitles:
          AxisTitles(sideTitles: bottomTitles, drawBehindEverything: true),
      leftTitles: AxisTitles(
        sideTitles: leftTitles,
      ),
      rightTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      topTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
    );

SideTitles get bottomTitles => SideTitles(
      showTitles: true,
      reservedSize: 30,
      getTitlesWidget: bottomTitleWidgets,
      interval: (xData.last.timestamp - xData.first.timestamp) / 4,
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
      reservedSize: 35,
      getTitlesWidget: leftTitleWidgets,
      interval: 1,
    );

Widget leftTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );
  Widget text;
  switch (value.toInt()) {
    case 1:
      text = const Text('1', style: style);
      break;
    case 3:
      text = const Text('3', style: style);
      break;
    case 5:
      text = const Text('5', style: style);
      break;
    default:
      text = const Text('');
      break;
  }

  return SideTitleWidget(
    axisSide: meta.axisSide,
    space: 4,
    child: text,
  );
}

final List<TestData> xData = [
  TestData(
    timestamp: DateTime(2023, 4, 17, 17, 30).millisecondsSinceEpoch.toDouble(),
    unit: 3,
  ),
  TestData(
    timestamp: DateTime(2023, 4, 17, 17, 31).millisecondsSinceEpoch.toDouble(),
    unit: 2,
  ),
  TestData(
    timestamp: DateTime(2023, 4, 17, 17, 32).millisecondsSinceEpoch.toDouble(),
    unit: 5,
  ),
  TestData(
    timestamp: DateTime(2023, 4, 17, 17, 33).millisecondsSinceEpoch.toDouble(),
    unit: 2.5,
  ),
  TestData(
    timestamp: DateTime(2023, 4, 17, 17, 34).millisecondsSinceEpoch.toDouble(),
    unit: 4,
  ),
];

final List<TestData> yData = [
  TestData(
    timestamp: DateTime(2023, 4, 17, 17, 30).millisecondsSinceEpoch.toDouble(),
    unit: 4,
  ),
  TestData(
    timestamp: DateTime(2023, 4, 17, 17, 31).millisecondsSinceEpoch.toDouble(),
    unit: 3,
  ),
  TestData(
    timestamp: DateTime(2023, 4, 17, 17, 32).millisecondsSinceEpoch.toDouble(),
    unit: 4.9,
  ),
  TestData(
    timestamp: DateTime(2023, 4, 17, 17, 33).millisecondsSinceEpoch.toDouble(),
    unit: 3,
  ),
  TestData(
    timestamp: DateTime(2023, 4, 17, 17, 34).millisecondsSinceEpoch.toDouble(),
    unit: 5,
  ),
];
final List<TestData> zData = [
  TestData(
    timestamp: DateTime(2023, 4, 17, 17, 30).millisecondsSinceEpoch.toDouble(),
    unit: 1,
  ),
  TestData(
    timestamp: DateTime(2023, 4, 17, 17, 31).millisecondsSinceEpoch.toDouble(),
    unit: 5,
  ),
  TestData(
    timestamp: DateTime(2023, 4, 17, 17, 32).millisecondsSinceEpoch.toDouble(),
    unit: 1,
  ),
  TestData(
    timestamp: DateTime(2023, 4, 17, 17, 33).millisecondsSinceEpoch.toDouble(),
    unit: 1,
  ),
  TestData(
    timestamp: DateTime(2023, 4, 17, 17, 34).millisecondsSinceEpoch.toDouble(),
    unit: 2,
  ),
];

class TestData {
  final double unit;
  final double timestamp;

  const TestData({
    required this.timestamp,
    required this.unit,
  });
}
