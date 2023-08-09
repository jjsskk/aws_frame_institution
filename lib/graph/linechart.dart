import 'dart:io';

import 'package:aws_frame_institution/controller/graph_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:get/get.dart';

class Linechart extends StatefulWidget {
  Linechart({required this.csvlist});

  late List<String> csvlist;

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

  late var controller;
  String _selectedCsv = '';

  @override
  void initState() {
    super.initState();
    controller = Get.find<GraphController>(tag: widget.csvlist.first);
    setState(() {
      _selectedCsv = widget.csvlist.first;
    });
    // _loadCSVaws();
  }

  bool showChart2 = false;

  // List<List<dynamic>> _data = []; //use for csv file in local device

  // Future<void> _loadCSVaws() async {
  //   final documentsDir = await getApplicationDocumentsDirectory();
  //   final filepath = documentsDir.path + '/20230206_165833_Spectrum.csv';
  //   final file = File(filepath);
  //   print('file path : ' + filepath);
  //
  //   // final listOptions =
  //   // S3ListOptions(accessLevel: StorageAccessLevel.private);
  //   final downloadOptions = S3DownloadFileOptions(
  //     accessLevel: StorageAccessLevel.protected,
  //     // e.g. us-west-2:2f41a152-14d1-45ff-9715-53e20751c7ee
  //   );
  //
  //   try {
  //     final result = await Amplify.Storage.downloadFile(
  //       key: '20230206_165833_Spectrum.csv',
  //       local: file,
  //       options: downloadOptions,
  //       onProgress: (progress) {
  //         safePrint('Fraction completed: ${progress.getFractionCompleted()}');
  //       },
  //     );
  //     final contents = result.file.readAsStringSync();
  //     // Or you can reference the file that is created above
  //     // final contents = file.readAsStringSync();
  //     safePrint('Downloaded contents: $contents');
  //     final rawdata = const CsvToListConverter().convert(contents);
  //
  //     setState(() {
  //       _data = rawdata;
  //     });
  //   } on StorageException catch (e) {
  //     safePrint('Error downloading file: $e');
  //   }
  // }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
        color: Color(0xff68737d), fontWeight: FontWeight.bold, fontSize: 10);
    String text = value.toString();
    text = text + 's';
    if (text == '75.0s') text = '';
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
            height: 10,
          ),
          DropdownButton(
              value: _selectedCsv,
              items: widget.csvlist
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCsv = value!;
                  controller = Get.find<GraphController>(tag: value);
                  showChart2 = false;
                });
              }),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent),
            child: Text(
              'green : attention\npurple : meditation',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {},
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
                    child: Obx(() {
                      return controller.showspinner.value
                          ? Center(child: CircularProgressIndicator())
                          : LineChart(
                              showChart2 ? mainChart2() : mainChart(),
                            );
                    }),
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
                    showChart2 ? 'mediation' : 'attention',
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
                // interval: 3,
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
      minX: 1,
      maxX: 75,
      minY: 0,
      maxY: 100,
      lineBarsData: [
        LineChartBarData(
          spots: [
            for (int i = 0; i < controller.data.length; i++)
              FlSpot(i + 1, controller.data[i][1].toDouble())

            // FlSpot(0, 3),
            // FlSpot(2.6, 2),
            // FlSpot(4.9, 5),
            // FlSpot(6.8, 3.1),
            // FlSpot(8, 4),
            // FlSpot(9.5, 3),
            // FlSpot(11, 4),
          ],
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

  LineChartData mainChart2() {
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
                // interval: 3,
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
      minX: 1,
      maxX: 75,
      minY: 0,
      maxY: 100,
      lineBarsData: [
        LineChartBarData(
          spots: [
            for (int i = 0; i < controller.data.length; i++)
              FlSpot(i + 1, controller.data[i][2].toDouble())

            // FlSpot(0, 3),
            // FlSpot(2.6, 2),
            // FlSpot(4.9, 5),
            // FlSpot(6.8, 3.1),
            // FlSpot(8, 4),
            // FlSpot(9.5, 3),
            // FlSpot(11, 4),
          ],
          isCurved: true,
          gradient: LinearGradient(colors: gradientColors2),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
                colors: gradientColors2
                    .map((color) => color.withOpacity(0.3))
                    .toList()),
          ),
        ),
      ],
    );
  }
}
