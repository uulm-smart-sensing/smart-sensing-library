import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'sensor_view_data.dart';

/// Widget for displaying Graph in Historic View
class GraphView extends StatefulWidget {
  final int lineDataCount;
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
          lineTouchData: lineTouchData,
          gridData: gridData,
          titlesData: titleData,
          borderData: borderData,
          lineBarsData: chartData(widget.lineDataCount),
          minX: getMinX(widget.lineData),
          maxX: getMaxX(widget.lineData),
          minY: getMinY(widget.lineData) - 1,
          maxY: getMaxY(widget.lineData) + 1,
        ),
      );

  /// Determines whether there will be 3 or 1 linechart depending on the
  /// parameter
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
        widget.lineData.map((data) => FlSpot(data.timestamp, data.y!)).toList(),
      );

  LineChartBarData get lineChartBarDataZ => _getLineChartBarData(
        Colors.blue,
        widget.lineData.map((data) => FlSpot(data.timestamp, data.z!)).toList(),
      );
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

  /// Handles the data from Graph
  LineChartBarData _getLineChartBarData(Color color, List<FlSpot> spots) =>
      LineChartBarData(
        color: color,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        barWidth: 3,
        spots: spots,
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
