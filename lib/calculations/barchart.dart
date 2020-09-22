import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Barchart extends StatefulWidget {
  @override
  _OverviewdataState createState() => _OverviewdataState();
}

class _OverviewdataState extends State<Barchart> {
  @override
  void initState() {
    super.initState();
  }

  int touchedIndex;

  final List<double> weeklyData = [5.0, 6.5, 5.0, 7.5, 9.0, 11.5, 6.5];

  BarChartGroupData _buildBar(
    int x,
    double y, {
    bool isTouched = false,
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: y,
          color: isTouched ? Colors.yellow : Colors.white,
          width: 22,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: 20,
            color: Color(0xff72d8bf),
          ),
        ),
      ],
    );
  }

  List<BarChartGroupData> _buildAllBars() {
    return List.generate(
      weeklyData.length,
      (index) =>
          _buildBar(index, weeklyData[index], isTouched: index == touchedIndex),
    );
  }

  FlTitlesData _buildAxes() {
    return FlTitlesData(
      // Build X axis.
      bottomTitles: SideTitles(
        showTitles: true,
        textStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        margin: 16,
        getTitles: (double value) {
          switch (value.toInt()) {
            case 0:
              return 'M';
            case 1:
              return 'T';
            case 2:
              return 'W';
            case 3:
              return 'T';
            case 4:
              return 'F';
            case 5:
              return 'S';
            case 6:
              return 'S';
            default:
              return '';
          }
        },
      ),
      // Build Y axis.
      leftTitles: SideTitles(
        showTitles: false,
        getTitles: (double value) {
          return value.toString();
        },
      ),
    );
  }

  BarTouchData _buildBarTouchData() {
    return BarTouchData(
      touchTooltipData: BarTouchTooltipData(
        tooltipBgColor: Colors.blueGrey,
        getTooltipItem: (group, groupIndex, rod, rodIndex) {
          String weekDay;
          switch (group.x.toInt()) {
            case 0:
              weekDay = 'Monday';
              break;
            case 1:
              weekDay = 'Tuesday';
              break;
            case 2:
              weekDay = 'Wednesday';
              break;
            case 3:
              weekDay = 'Thursday';
              break;
            case 4:
              weekDay = 'Friday';
              break;
            case 5:
              weekDay = 'Saturday';
              break;
            case 6:
              weekDay = 'Sunday';
              break;
          }
          return BarTooltipItem(
            weekDay + '\n' + (rod.y).toString(),
            TextStyle(color: Colors.yellow),
          );
        },
      ),
      touchCallback: (barTouchResponse) {
        setState(() {
          if (barTouchResponse.spot != null &&
              barTouchResponse.touchInput is! FlPanEnd &&
              barTouchResponse.touchInput is! FlLongPressEnd) {
            touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
          } else {
            touchedIndex = -1;
          }
        });
      },
    );
  }

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: _buildBarTouchData(),
      titlesData: _buildAxes(),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: _buildAllBars(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          'Analysis',
          style: TextStyle(
              color: const Color(0xff0f4a3c),
              fontSize: 24,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          'Weekly Sales',
          style: TextStyle(
              color: const Color(0xff379982),
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 25,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: BarChart(
              mainBarData(),
            ),
          ),
        ),
      ],
    );
  }
}
