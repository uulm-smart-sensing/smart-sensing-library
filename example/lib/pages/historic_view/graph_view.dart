import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'sensor_view_data.dart';

/// A widget that displays a line chart based on provided line data.
/// It takes a list of SensorViewData objects and renders a line chart with
/// X,Y, and Z values based on the provided data.
class GraphView extends StatefulWidget {
  /// [lineDataCount] is the number of line data to display.
  final int lineDataCount;

  /// [lineData] is the list of sensor view data to be plotted on the chart.
  final List<SensorViewData> lineData;

  const GraphView({
    super.key,
    required this.lineData,
    required this.lineDataCount,
  });

  @override
  State<GraphView> createState() => _GraphView();
}

class _GraphView extends State<GraphView> {
  @override
  Widget build(BuildContext context) => LineChart(
        LineChartData(
          // Configuration for touch events on the chart
          lineTouchData: lineTouchData,
          // Configuration for the chart grid
          gridData: gridData,
          // Configuration for the chart titles (axes labels)
          titlesData: titleData,
          // Configuration for the chart border
          borderData: borderData,
          // Configuration for the line chart data
          lineBarsData: chartData(widget.lineDataCount),
          // Minimum value on the X-axis
          minX: getMinX(widget.lineData),
          // Maximum value on the X-axis
          maxX: getMaxX(widget.lineData),
          // Minimum value on the Y-axis
          minY: getMinY(widget.lineData) - 1,
          // Maximum value on the Y-axis
          maxY: getMaxY(widget.lineData) + 1,
        ),
      );

  /// Constructs a list of line chart bar data based on the quantity specified.
  List<LineChartBarData> chartData(int quantity) => [
        lineChartBarDataX,
        lineChartBarDataY,
        lineChartBarDataZ
      ].take(quantity).toList();

  LineChartBarData get lineChartBarDataX => _getLineChartBarData(
        Colors.red,
        widget.lineData.map((data) => FlSpot(data.timestamp, data.x)).toList(),
      );

  LineChartBarData get lineChartBarDataY => _getLineChartBarData(
        Colors.green,
        widget.lineData
            .map((data) => FlSpot(data.timestamp, data.y ?? 0))
            .toList(),
      );

  LineChartBarData get lineChartBarDataZ => _getLineChartBarData(
        Colors.blue,
        widget.lineData
            .map((data) => FlSpot(data.timestamp, data.z ?? 0))
            .toList(),
      );
  FlGridData get gridData => FlGridData(show: false);

  /// Configuration for the chart border.
  FlBorderData get borderData => FlBorderData(
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
      );

  /// Configuration for touch events on the chart.
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
              color: touchedSpot.bar.color,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            );
            var date =
                DateTime.fromMillisecondsSinceEpoch(touchedSpot.x.toInt());
            return LineTooltipItem(
              "${'${DateFormat('HH:mm').format(date)} '}\n"
              "${touchedSpot.y.toStringAsFixed(2)}",
              textStyle,
            );
          }).toList(),
        ),
      );

  /// Constructs line chart bar data based on the provided color and spots.
  LineChartBarData _getLineChartBarData(Color color, List<FlSpot> spots) =>
      LineChartBarData(
        color: color,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        barWidth: 3,
        spots: spots,
      );

  /// Configuration for the chart titles (axes labels)
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
        interval: getMaxX(widget.lineData) - getMinX(widget.lineData) / 2,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 14,
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

  SideTitles get leftTitles {
    var maxY = getMaxY(widget.lineData);
    var interval = ((maxY / 2).ceilToDouble() * 2).toDouble();
    return SideTitles(
      showTitles: true,
      reservedSize: 40,
      getTitlesWidget: leftTitleWidgets,
      interval: interval,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    var newValue = value.round();
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text('$newValue', style: style),
    );
  }
}
