
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Linechart extends StatefulWidget {
  Linechart({required this.data,required this.dataName});

  Map<int, int> data;
  String dataName;

  @override
  _LinechartState createState() => _LinechartState();
}

class _LinechartState extends State<Linechart> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  List<Color> gradientColors2 = [
    Colors.deepPurpleAccent,
    Colors.purple,
  ];

  // late var controller;
  // String _selectedCsv = '';

  @override
  void initState() {
    super.initState();
    // convertXborder();
    // controller = Get.find<GraphController>(tag: widget.csvlist.first);
  }

  bool showChart2 = false;

  double minX = 0;
  double maxX = 0;

  // void convertXborder() {
  //   minX = double.parse(widget.data.keys.first);
  //   maxX = double.parse(widget.data.keys.last);
  //   if (minX == 12.0) {
  //
  //     minX = 0;
  //   }
  // }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
        color: Color(0xff68737d), fontWeight: FontWeight.bold, fontSize: 11);

    String text = widget.data.keys.toList()[value.toInt()].toString();
    text = text + '월';
    // if (text == '0월') text = '12월';

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style, textAlign: TextAlign.center),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff67727d),
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text = '';
    switch (value.toInt()) {
      case 20:
        text = '20';
        break;
      case 40:
        text = '40';
        break;
      case 60:
        text = '60';
        break;
      case 80:
        text = '80';
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[

          SizedBox(
            height: 20,
          ),

          Stack(
            children: [
              AspectRatio(
                aspectRatio: 3 / 2,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      color: Color(0xff232d37)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                    child: LineChart(mainChart()),
                  ),
                ),
              ),
              SizedBox(
                width: 80,
                height: 34,
                child: TextButton(
                  onPressed: () {
                    print('click');
                    setState(() {
                      showChart2 = !showChart2;
                    });
                  },
                  child: Text(
                    widget.dataName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: showChart2
                          ? Colors.deepPurpleAccent
                          : Color(0xff23b6e6),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  LineChartData mainChart() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                interval: 1,
                getTitlesWidget: bottomTitleWidgets),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,

              getTitlesWidget: leftTitleWidgets,

              reservedSize: 28,
              // margin: 12,
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false))),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: widget.data.length - 1,
      minY: 0,
      maxY: 100,
      lineBarsData: [
        LineChartBarData(
          spots: _pushData(),

          isCurved: true,
          gradient: LinearGradient(colors: gradientColors),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
                colors: gradientColors
                    .map((color) => color.withOpacity(0.3))
                    .toList()),
          ),
        ),
      ],
    );
  }

  List<FlSpot> _pushData() {
    List<FlSpot> spots = [];

    int index = 0;
    widget.data.forEach((key, value) {
      print(key);
        spots.add(FlSpot(index.toDouble(), value.toDouble()));
      index++;
    });
    return spots;
  }
}
