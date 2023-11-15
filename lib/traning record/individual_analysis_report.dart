import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_radar_chart/flutter_radar_chart.dart' as radar_chart;
import 'package:age_calculator/age_calculator.dart';
import 'package:datepicker_dropdown/datepicker_dropdown.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../GraphQL_Method/graphql_controller.dart';
import '../communication_service/instituition_info/convenience/Convenience.dart';
import '../models/MonthlyBrainSignalTable.dart';

class IndividualAnalysisPage extends StatefulWidget {
  IndividualAnalysisPage({Key? key}) : super(key: key);

  @override
  State<IndividualAnalysisPage> createState() => _IndividualAnalysisPageState();
}

class _IndividualAnalysisPageState extends State<IndividualAnalysisPage> {
  bool loadingForAverage = true;
  bool loadingForGraph = true;

  var userbutton = '유저 데이터 추가';
  var brainbutton = '뇌파 데이터 추가';
  late final gql;
  int usercount = 0; // DATA count added to USER DB
  int braincount = 0; // DATA count added to MONTHLY DB

  int CON_SCORE = 0;

  // 주의력 점수
  int SPACETIME_SCORE = 0;

  //시공간 점수
  int EXEC_SCORE = 0;

  //집행기능 점수
  int MEM_SCORE = 0;

  // 기억력 점수
  int LING_SCORE = 0;

  //언어기능 점수
  int CAL_SCORE = 0;

  //계산력 점수
  int REAC_SCORE = 0;

  //반응속도 점수
  int ORIENT_SCORE = 0;

  int AVG_ATT = 0;

  //평균 집중력

  int AVG_MED = 0;

  //평균 안정감

  int CON_SCORE_AVG = 0; // 주의력 점수

  int SPACETIME_SCORE_AVG = 0; //시공간 점수

  int EXEC_SCORE_AVG = 0; //집행기능 점수

  int MEM_SCORE_AVG = 0; // 기억력 점수

  int LING_SCORE_AVG = 0; //언어기능 점수

  int CAL_SCORE_AVG = 0; //계산력 점수

  int REAC_SCORE_AVG = 0; //반응속도 점수

  int ORIENT_SCORE_AVG = 0; //지남력점수

  int AVG_ATT_AVG = 0; //평균 집중력

  int AVG_MED_AVG = 0; //평균 안정감

  int AVG = 0; //for linechart
  int SCORE = 0; //for linechart
  String nameForLinechart = '';

  List<String> users = []; // storing user Ids having similar ageEra

  // to know when data is fetched for calculating average data
  List<Future<dynamic?>> futuresList = [];
  int ageEra = 0;
  var month = 1; // for DropdownDatePicker
  var year = 2023; // for DropdownDatePicker

  int numberForonedata = 1; // for extractRequiredUserData()

  Map<String, List<int>> allData = {}; // variable for _getBars()

  int index = 0;
  String name = "";
  String? selectedLabel;
  bool useSides = false;
  List<String> nameList = [];

  void extractLatestBrainData(String ID) {
    gql.queryMonthlyDBLatestItem(ID: ID).then((values) {
      print(values);
      if (values.isNotEmpty) {
        values.sort((a, b) {
          String aa = a.month;

          String bb = b.month;
          return bb.compareTo(aa);
        });

        var value = values.first;
        setState(() {
          CON_SCORE = value!.con_score;
          SPACETIME_SCORE = value!.spacetime_score;
          EXEC_SCORE = value!.exec_score;
          MEM_SCORE = value!.mem_score;
          LING_SCORE = value!.ling_score;
          CAL_SCORE = value!.cal_score;
          REAC_SCORE = value!.reac_score;
          ORIENT_SCORE = value!.orient_score;
          AVG_ATT = value!.avg_att;
          AVG_MED = value!.avg_med;
          month = int.parse(value.month.substring(4, 6));
          print("month : $month");
          year = int.parse(value.month.substring(0, 4));
        });
      }
      extractSimilarAge();
    });
  }

  Future<dynamic> extractRequiredBrainMonthData(String id) {
    int changeddate = year * 10000 + month * 100;
    numberForonedata = 0;
    Future<dynamic> future =
        gql.queryMonthlyDBRequiredItem(id, changeddate).then((values) {
      if (values.isNotEmpty) {
        values.sort((a, b) {
          String aa = a.month;

          String bb = b.month;
          return bb.compareTo(aa);
        });
        var value = values.first;
        setState(() {
          numberForonedata++;
          CON_SCORE = value!.con_score;
          SPACETIME_SCORE = value!.spacetime_score;
          EXEC_SCORE = value!.exec_score;
          MEM_SCORE = value!.mem_score;
          LING_SCORE = value!.ling_score;
          CAL_SCORE = value!.cal_score;
          REAC_SCORE = value!.reac_score;
          ORIENT_SCORE = value!.orient_score;
          AVG_ATT = value!.avg_att;
          AVG_MED = value!.avg_med;
        });
      }
    });

    return future;
  }

  void extractSimilarAge() {
    users = [];
    String birth = "19651008";
    int year = int.parse(birth.substring(0, 4));
    int month = int.parse(birth.substring(4, 6));
    int day = int.parse(birth.substring(6, 8));
    DateTime birthday = DateTime(year, month, day);

    DateDuration duration;

    // Find out your age as of today's date 2021-03-08
    duration = AgeCalculator.age(birthday);
    int age = duration.years;
    print('Your age is ${age}'); // Your age is Years: 24, Months: 0, Days: 3

    ageEra = ((duration.years ~/ 10) * 10);

    int diff = age - ageEra;

    print(diff);

    int maxYear = (year + diff) * 10000;
    int minYear = (year - (9 - diff)) * 10000;
    print(minYear);
    print(maxYear);

    gql.queryListUserDBItemsForAverageAge(minYear, maxYear).then((result) {
      // extract SimilarAge users Ids
      // print(result);
      result.forEach((value) {
        // print("${value.id}");
        users.add(value.ID);
      });
      futuresList = [];
      calculateAverageSignal();
    }).catchError((error) {
      print(error);
    });
  }

  void calculateAverageSignal() async {
    // futuresList = [];
    allData = {};

    int CON_SCORE_SUM = 0; // 주의력 점수

    int SPACETIME_SCORE_SUM = 0; //시공간 점수

    int EXEC_SCORE_SUM = 0; //집행기능 점수

    int MEM_SCORE_SUM = 0; // 기억력 점수

    int LING_SCORE_SUM = 0; //언어기능 점수

    int CAL_SCORE_SUM = 0; //계산력 점수

    int REAC_SCORE_SUM = 0; //반응속도 점수

    int ORIENT_SCORE_SUM = 0; //지남력점수

    int AVG_ATT_SUM = 0;

    int AVG_MED_SUM = 0;

    // String month = "20230701";
    // int monthint = int.parse(month.substring(0, 7));
    // monthint = monthint *10;
    int changeddate = year * 10000 + month * 100;

    print("monthint: $changeddate");

    int numberForavg = 0;
    users.forEach((id) async {
      // print(id);
      Future<dynamic> future =
          gql.queryMonthlyDBRequiredItem(id, changeddate).then((values) {
        if (values.isNotEmpty) {
          // var value = values.last;
          values.forEach((value) {
            numberForavg++;
            CON_SCORE_SUM += value.con_score as int;

            SPACETIME_SCORE_SUM += value.spacetime_score as int;

            EXEC_SCORE_SUM += value.exec_score as int; //집행기능 점수

            MEM_SCORE_SUM += value.mem_score as int; // 기억력 점수

            LING_SCORE_SUM += value.ling_score as int; //언어기능 점수

            CAL_SCORE_SUM += value.cal_score as int; //계산력 점수

            REAC_SCORE_SUM += value.reac_score as int; //반응속도 점수

            ORIENT_SCORE_SUM += value.orient_score as int; //지남력점수

            AVG_ATT_SUM += value.avg_att as int;

            AVG_MED_SUM += value.avg_med as int;
            // int a = (CON_SCORE_SUM ~/ number);
            // print("con : ${a}");
          });
        }
      });
      futuresList.add(future);
    });
    // Wait for all the Futures to complete using Future.wait()
    await Future.wait<dynamic>(futuresList).then((List<dynamic> results) {
      // All Futures are completed
      // results is a list containing the results of each Future in the order they were added
    }).catchError((error) {
      // Handle any errors that occurred during the asynchronous operations
      print('Error occurred: $error');
    });
    setState(() {
      if (numberForavg > 0) {
        if (numberForonedata == 0) {
          CON_SCORE = 0;
          SPACETIME_SCORE = 0;
          EXEC_SCORE = 0;
          MEM_SCORE = 0;
          LING_SCORE = 0;
          CAL_SCORE = 0;
          REAC_SCORE = 0;
          ORIENT_SCORE = 0;
          AVG_ATT = 0;
          AVG_MED = 0;
          numberForonedata = 0;
        }

        CON_SCORE_AVG = (CON_SCORE_SUM ~/ numberForavg); //135/3= 45
        allData['주의력'] = [CON_SCORE, CON_SCORE_AVG];

        SPACETIME_SCORE_AVG = (SPACETIME_SCORE_SUM ~/ numberForavg);
        allData['시공간'] = [SPACETIME_SCORE, SPACETIME_SCORE_AVG];

        EXEC_SCORE_AVG = (EXEC_SCORE_SUM ~/ numberForavg);
        allData['집행기능'] = [EXEC_SCORE, EXEC_SCORE_AVG];

        MEM_SCORE_AVG = (MEM_SCORE_SUM ~/ numberForavg);
        allData['기억력'] = [MEM_SCORE, MEM_SCORE_AVG];

        LING_SCORE_AVG = (LING_SCORE_SUM ~/ numberForavg); //언어기능 점수
        allData['언어기능'] = [LING_SCORE, LING_SCORE_AVG];

        CAL_SCORE_AVG = (CAL_SCORE_SUM ~/ numberForavg); //계산력 점수
        allData['계산력'] = [CAL_SCORE, CAL_SCORE_AVG];

        REAC_SCORE_AVG = (REAC_SCORE_SUM ~/ numberForavg); //반응속도 점수
        allData['반응 속도'] = [REAC_SCORE, REAC_SCORE_AVG];

        ORIENT_SCORE_AVG = (ORIENT_SCORE_SUM ~/ numberForavg);
        allData['지남력'] = [ORIENT_SCORE, ORIENT_SCORE_AVG];

        AVG_ATT_AVG = (AVG_ATT_SUM ~/ numberForavg);
        allData['집중력'] = [AVG_ATT, AVG_ATT_AVG];

        AVG_MED_AVG = (AVG_MED_SUM ~/ numberForavg);
        allData['안정감'] = [AVG_MED, AVG_MED_AVG];
      } else {
        if (numberForonedata == 0) {
          CON_SCORE = 0;
          SPACETIME_SCORE = 0;
          EXEC_SCORE = 0;
          MEM_SCORE = 0;
          LING_SCORE = 0;
          CAL_SCORE = 0;
          REAC_SCORE = 0;
          ORIENT_SCORE = 0;
          numberForonedata = 0;
          AVG_ATT = 0;
          AVG_MED = 0;
        }

        CON_SCORE_AVG = 0; //135/3= 45
        allData['주의력'] = [CON_SCORE, CON_SCORE_AVG];

        SPACETIME_SCORE_AVG = 0;
        allData['시공간'] = [SPACETIME_SCORE, SPACETIME_SCORE_AVG];

        EXEC_SCORE_AVG = 0;
        allData['집행기능'] = [EXEC_SCORE, EXEC_SCORE_AVG];

        MEM_SCORE_AVG = 0;
        allData['기억력'] = [MEM_SCORE, MEM_SCORE_AVG];

        LING_SCORE_AVG = 0; //언어기능 점수
        allData['언어기능'] = [LING_SCORE, LING_SCORE_AVG];

        CAL_SCORE_AVG = 0; //계산력 점수
        allData['계산력'] = [CAL_SCORE, CAL_SCORE_AVG];

        REAC_SCORE_AVG = 0; //반응속도 점수
        allData['반응 속도'] = [REAC_SCORE, REAC_SCORE_AVG];

        ORIENT_SCORE_AVG = 0;
        allData['지남력'] = [ORIENT_SCORE, ORIENT_SCORE_AVG];

        AVG_ATT_AVG = 0;
        allData['집중력'] = [AVG_ATT, AVG_ATT_AVG];

        AVG_MED_AVG = 0;
        allData['안정감'] = [AVG_MED, AVG_MED_AVG];
      }

      SCORE = AVG_ATT;
      AVG = AVG_ATT_AVG;
      nameForLinechart = '집중도';
      selectedLabel = "avg_att"; //to show avg_Att values on graph

      loadingForAverage = false;
    });
  }

//그래프 버튼마다 색상을 다르게 하기 위해 존재함 각각 그래프의 색상!
  List<Color> buttomColors = [
    Color(0xff237ACF), // Dark Blue
    Color(0xff905C7E), // Orchid
    Color(0xffAA7F39), // Golden Brown
    Color(0xffDD6031), // Deep Orange
    Color(0xff3CDBD3), // Turquoise
    Color(0xff117A65), // Jungle Green
    Color(0xff764BA2), // Purple
    Color(0xff801336), // Burgundy
    Color(0xffEB9F9A), // Salmon
    Color(0xffFAD201), // Yellow
  ];

// 이 코드는 그래프의 x축의 값을 나타내는 위젯입니다. 각 월을 반환합니다.
  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    // value가 0 또는 양수이고 값이 리스트 범위 내에 있음을 확인합니다.
    if (value >= 0 && value < results.length) {
      String? currentDate = results[value.toInt()]?.month;

      int year = int.parse(currentDate!.substring(0, 4));
      int month = int.parse(currentDate.substring(4, 6));
      String text = "$month월";

      final style = TextStyle(
          color: Color(0xff68737d), fontWeight: FontWeight.bold, fontSize: 12);

      return SideTitleWidget(
        axisSide: meta.axisSide,
        child: Text(text, style: style, textAlign: TextAlign.center),
      );
    } else {
      return Container();
    }
  }

//이 위젯은 그래프의 각 y축의 값을 나타내는 위젯입니다.
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

// 버튼의 각 라벨들을 매핑해주는 것들입니다. 왼쪽에 있는 것은 db를 통해서 불러온 값이고 오른쪽이 보여주고자 하는 값입니다.
  Map<String, String> buttonLabels = {
    "avg_att": "평균\n집중도",
    "avg_med": "평균\n안정감",
    "con_score": "주의력",
    "spacetime_score": "시공간",
    "exec_score": "집행기능",
    "mem_score": "기억력",
    "ling_score": "언어기능",
    "cal_score": "계산력",
    "reac_score": "반응속도",
    "orient_score": "지남력",
  }; //버튼 이름

//그래프의 데이터를 가져오는 메서드 입니다.
//twelveMonthsAgo이라는 변수를 통해서 최근 1년까지를 설정하고 버튼을 눌렀을때 그 이름에 따른 데이터를 가져오게 됩니다.
//그래프 데이터를 각각 수집한 것을 graphData라는 리스트에 넣어 반환하게 됩니다.
  List<double> _getGraphData(String label, int colorIndex) {
    List<double> graphData = [];
    DateTime twelveMonthsAgo = DateTime.now().subtract(Duration(days: 365 * 1));
    double maxValue = double.negativeInfinity; // 초기값 설정
    double minValue = double.infinity; // 초기값 설정

    int count = 0; // 데이터 개수 카운트
    for (var result in results) {
      // 날짜 필터링
      String? monthStr = result?.month;
      int year = int.parse(monthStr!.substring(0, 4));
      int month = int.parse(monthStr.substring(4, 6));
      DateTime date = DateTime(year, month);

      if (date.isBefore(twelveMonthsAgo)) {
        continue;
      }
      double? value;
      switch (label) {
        case "avg_att":
          value = result?.avg_att?.toDouble();
          break;
        case "avg_med":
          value = result?.avg_med?.toDouble();
          break;
        case "con_score":
          value = result?.con_score?.toDouble();
          break;
        case "spacetime_score":
          value = result?.spacetime_score?.toDouble();
          break;
        case "exec_score":
          value = result?.exec_score?.toDouble();
          break;
        case "mem_score":
          value = result?.mem_score?.toDouble();
          break;
        case "ling_score":
          value = result?.ling_score?.toDouble();
          break;
        case "cal_score":
          value = result?.cal_score?.toDouble();
          break;
        case "reac_score":
          value = result?.reac_score?.toDouble();
          break;
        case "orient_score":
          value = result?.orient_score?.toDouble();
          break;
        default:
          value = null;
      }

      if (value != null) {
        graphData.add(value);
      }
    }
    return graphData;
  }

//그래프 데이터를 통해서 각 값을 가져오고 보여주는 부분입니다.
// 라인 차트의 디자인을 변경하고 싶다면 이 부분을 수정하면 될 것입니다.
// selectedGradientColors 여기서 그라데이션 색상이 정해집니다. 두가지로 구성이 되어있는데 하나는 위에서 정한 색상으로 하고 다른 하나는
// 정한 색상에 투명도를 0.8로 줍니다. 컬러 인덱스와 라벨 인덱스는 동일하게 갑니다.
// CHART의 디자인을 변경하고 싶다면 LineChartData를 수정하면 됩니다.
  LineChartData _getLineChartData() {
    List<double> graphData = [];
    int colorIndex = 0;
    if (selectedLabel != null) {
      colorIndex = buttonLabels.keys.toList().indexOf(selectedLabel!);
      graphData = _getGraphData(selectedLabel!, colorIndex);
    }
    List<Color> selectedGradientColors = [
      buttomColors[colorIndex],
      buttomColors[colorIndex].withOpacity(0.8),
    ];

    return LineChartData(
        lineTouchData: LineTouchData(enabled: true),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
        ),
        titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
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
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false))),
        borderData: FlBorderData(
            show: true,
            border: Border.all(color: const Color(0xff37434d), width: 1)),
        minX: 0,
        maxX: (graphData.length - 1).toDouble(),
        minY: 0,
        maxY: 100,
        lineBarsData: [
          LineChartBarData(
            spots: graphData
                .asMap()
                .map((i, e) => MapEntry(i, FlSpot(i.toDouble(), e)))
                .values
                .toList(),
            isCurved: true,
            gradient: LinearGradient(colors: selectedGradientColors),
            barWidth: 5,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                  colors: selectedGradientColors
                      .map((color) => color.withOpacity(0.3))
                      .toList()),
            ),
          )
        ]);
  }

//이 위젯은 컨테이너를 생성하고 그 안에 PADDING을 넣고 LineChart를 그리게 됩니다.
// 정리하면 _buildLineChart는 LineChart를 불러오고 LineChart는 _getLineChartData함수를 통해서 _getGraphData이 데이터를 불러와
//buttonColors를 통해 그래프의 색을 정하고, leftTitleWidgets를 통해 Y축을 정하고 bottomTitleWidgets으로 x축의 값을 정해 그리게 됩니다.

  Widget _buildLineChart() {
    List<double> graphData = [];
    if (selectedLabel != null) {
      graphData = _getGraphData(
          selectedLabel!, buttonLabels.keys.toList().indexOf(selectedLabel!));
      if (graphData.isNotEmpty) {
        var maxValue = graphData.reduce((a, b) => a > b ? a : b);
        var minValue = graphData.reduce((a, b) => a < b ? a : b);
        var sumValue = graphData.reduce((a, b) => a + b).toDouble();
        var avgValue = sumValue / graphData.length;
        print('최고 점수: $maxValue');
        print('최소 점수: $minValue');
        print('평균 점수: $avgValue');
      }
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 300,
      child: Padding(
          padding: EdgeInsets.all(16), child: LineChart(_getLineChartData())),
    );
  }

//그래프 위에 버튼을 구성하는 위젯입니다.
//그리드를 통해 버튼을 2행으로 구성해서 총 10개를 보여주게 됩니다. 그래서 1행당 5개의 버튼이 존재하게 됩니다.
// 버튼의 모양을 수정하고 싶다면 이 부분을 수정하면 될 것입니다.
  Widget _buildButtons() {
    return GridView.count(
      crossAxisCount: 5,
      // 2행을 만듦
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      // 스크롤을 막음
      padding: EdgeInsets.all(1.0),
      children: buttonLabels.keys
          .map((label) => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(), // 이 부분을 통해서 원형으로 구성하게 됩니다.

                  fixedSize: Size(10.0, 5.0), // 원하는 버튼 width와 height를 설
                ),
                onPressed: () {
                  for (var result in results) {
                    String? month = result?.month.substring(4, 6);
                    var value;
                    switch (label) {
                      case "avg_att":
                        value = result?.avg_att;
                        SCORE = AVG_ATT;
                        AVG = AVG_ATT_AVG;
                        nameForLinechart = '집중도';
                        break;
                      case "avg_med":
                        value = result?.avg_med;
                        SCORE = AVG_MED;
                        AVG = AVG_MED_AVG;
                        nameForLinechart = '안정감';
                        break;
                      case "con_score":
                        value = result?.con_score;
                        SCORE = CON_SCORE;
                        AVG = CON_SCORE_AVG;
                        nameForLinechart = '주의려';
                        break;
                      case "spacetime_score":
                        value = result?.spacetime_score;
                        SCORE = SPACETIME_SCORE;
                        AVG = SPACETIME_SCORE_AVG;
                        nameForLinechart = '시공간';
                        break;
                      case "exec_score":
                        value = result?.exec_score;
                        SCORE = EXEC_SCORE;
                        AVG = EXEC_SCORE_AVG;
                        nameForLinechart = '집행기능';
                        break;
                      case "mem_score":
                        value = result?.mem_score;
                        SCORE = MEM_SCORE;
                        AVG = MEM_SCORE_AVG;
                        nameForLinechart = '기억력';
                        break;
                      case "ling_score":
                        value = result?.ling_score;
                        SCORE = LING_SCORE;
                        AVG = LING_SCORE_AVG;
                        nameForLinechart = '언어기능';
                        break;
                      case "cal_score":
                        value = result?.cal_score;
                        SCORE = CAL_SCORE;
                        AVG = CAL_SCORE_AVG;
                        nameForLinechart = '계산력';
                        break;
                      case "reac_score":
                        value = result?.reac_score;
                        SCORE = REAC_SCORE;
                        AVG = REAC_SCORE_AVG;
                        nameForLinechart = '반응속도';
                        break;
                      case "orient_score":
                        value = result?.orient_score;
                        SCORE = ORIENT_SCORE;
                        AVG = ORIENT_SCORE_AVG;
                        nameForLinechart = '지남력';
                        break;
                      default:
                        value = null;
                    }
                    setState(() {
                      selectedLabel = label;
                    });
                    print("Month: $month, $label: $value");
                  }
                },
                child: Text(
                  buttonLabels[label]!,
                  style: TextStyle(fontSize: 13.0, height: 1.3), // 버튼 텍스트 크기 조절
                ),
              ))
          .toList(),
    );
  }

  double numberOfFeatures = 3;
  List<MonthlyBrainSignalTable?> results = []; //넣어 둘 친구

  Map<String, String> nameToId = {};

  void fetchOneYearBrainDataForGraph() async {
    setState(() {
      loadingForGraph = true;
    });
    // final data = await gql.queryListMonthlyDB();
    // final data = await gql.queryListMonthlyDBItems(ID: '1');
    // final data = await gql.queryListMonthlyDBItems(ID: nameToId[name]);
    final data = await gql.queryMonthlyDBLatestItem(ID: nameToId[name]);
    {
      print(data);
      print("Type of myResult: ${data.runtimeType}");

      // 날짜에 따라 오름차순으로 정렬
      data.sort((a, b) {
        int yearA = int.parse(a.month.substring(0, 4));
        int monthA = int.parse(a.month.substring(4, 6));
        int dayA = int.parse(a.month.substring(6, 8));
        DateTime aDate = DateTime(yearA, monthA, dayA);

        int yearB = int.parse(b.month.substring(0, 4));
        int monthB = int.parse(b.month.substring(4, 6));
        int dayB = int.parse(b.month.substring(6, 8));
        DateTime bDate = DateTime(yearB, monthB, dayB);

        return aDate.compareTo(bDate);
      });

      for (int i = 0; i < data.length; i++) {
        MonthlyBrainSignalTable? currentItem = data[i];
        if (currentItem != null) {
          // currentItem에 대한 작업 수행
          print(data[i]);
        } else {
          // 아이템이 null인 경우에 대한 처리
          print("null");
        }
      }

      results = data;

      selectedLabel = "avg_att";

      setState(() {
        loadingForGraph = false;
      });
    }
  }

  Future<void> fetchData() async {
    try {
      final userName = await gql.queryListUsers(institutionId: "1234");
      {
        List<String> tempNameList = [];
        for (var data in userName) {
          if (data.NAME != null) {
            // NAME이 null이 아닌 경우에만 추가
            String tempName = "${data.NAME!} (${data.BIRTH!})";
            print(tempName);
            tempNameList.add(tempName);
            nameToId[tempName] = data.ID!;
          }
        }
        nameList = tempNameList;
        name = nameList[index];
        print('nametoid ' + nameToId[name]!);
        // extractLatestBrainData(nameToId.values.first);
        extractLatestBrainData(nameToId[name]!);
        print('first:' + nameToId.values.first);
      }

      fetchOneYearBrainDataForGraph();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _NameSelected(String selectedName) async {
    // setState(() {
    name = selectedName;
    index = nameList.indexOf(selectedName);
    print(name);
    print(nameToId[name]);
    // });
    // fetchLatestOneBrainData(nameToId[name]!);

    setState(() {
      loadingForAverage = true;
    });
    futuresList = [];
    futuresList.add(extractRequiredBrainMonthData(nameToId[name]!));

    calculateAverageSignal();

    fetchOneYearBrainDataForGraph();
  }

// void fetchLatestOneBrainData(String ID) {
//   gql.queryMonthlyDBOneItem(ID: ID).then((results) {
//     print(results);
//
//     results.sort((a, b) {
//       String aa = a.month;
//
//       String bb = b.month;
//       return bb.compareTo(aa);
//     });
//
//     var result = results.first;
//     setState(() {
//       CON_SCORE = "${result!.con_score}";
//       SPACETIME_SCORE = "${result!.spacetime_score}";
//       EXEC_SCORE = "${result!.exec_score}";
//       MEM_SCORE = "${result!.mem_score}";
//       LING_SCORE = "${result!.ling_score}";
//       CAL_SCORE = "${result!.cal_score}";
//       REAC_SCORE = "${result!.reac_score}";
//       ORIENT_SCORE = "${result!.orient_score}";
//       AVG_ATT = "${result!.avg_att}";
//       AVG_MED = "${result!.avg_med}";
//       // loading = false;
//     });
//   });
// }

  @override
  void initState() {
    gql = GraphQLController.Obj;
    super.initState();
    // fetchLatestOneBrainData('1');
    index = 0;
    fetchData();
    // extractLatestBrainData('1');
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var theme = Theme.of(context);

    const ticks = [20, 40, 60, 80, 100];
    var features = [
      "주의력($CON_SCORE)",
      "시공간($SPACETIME_SCORE)",
      "집행기능($EXEC_SCORE)",
      "기억력($MEM_SCORE)",
      "언어기능($LING_SCORE)",
      "계산력($CAL_SCORE)",
      "반응속도($REAC_SCORE)",
      "지남력($ORIENT_SCORE)",
      "집중력($AVG_ATT)",
      "안정감($AVG_MED)",
    ];
    var data = [
      [
        CON_SCORE,
        SPACETIME_SCORE,
        EXEC_SCORE,
        MEM_SCORE,
        LING_SCORE,
        CAL_SCORE,
        REAC_SCORE,
        ORIENT_SCORE,
        AVG_ATT,
        AVG_MED,
      ]
    ];

    // 빌드하는 부분입니다. 이 곳에서는 그래프가 들어가는 box의 쉐입을 정하는 곳입니다. 그래프가 있는 곳 박스를 수정하고 싶다면 이 곳을 수정하시면 됩니다.
    return Scaffold(
      appBar: AppBar(
        title: Text('뇌 신호 그래프'),
        centerTitle: true,
      ),
      body: (loadingForGraph || loadingForAverage)
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Center(
                child: Container(
                  color: Colors.white,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        nameList.isNotEmpty
                            ? CustomDropDown(
                                Items: nameList,
                                selected: name,
                                onChanged: _NameSelected,
                              )
                            : Container(),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownDatePicker(
                                inputDecoration: InputDecoration(
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 1.0),
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                // optional
                                isDropdownHideUnderline: true,
                                // optional
                                isFormValidator: true,
                                // optional
                                startYear: 2022,
                                // optional
                                endYear: 2030,
                                // optional
                                width: 10,
                                // optional
                                locale: "zh_CN",
                                // selectedDay: 14, // optional
                                showDay: false,
                                selectedMonth: month,
                                // optional
                                selectedYear: year,
                                // optional
                                // onChangedDay: (value) => print('onChangedDay: $value'),
                                onChangedMonth: (value) {
                                  print('onChangedMonth: $value');
                                  month = int.parse(value!);
                                },
                                onChangedYear: (value) {
                                  print('onChangedYear: $value');
                                  year = int.parse(value!);
                                },
                                //boxDecoration: BoxDecoration(
                                // border: Border.all(color: Colors.grey, width: 1.0)), // optional
                                // showDay: false,// optional
                                // dayFlex: 2,// optional
                                // locale: "zh_CN",// optional
                                // hintDay: 'Day', // optional
                                // hintMonth: 'Month', // optional
                                // hintYear: 'Year', // optional
                                // hintTextStyle: TextStyle(color: Colors.grey), // optional
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    loadingForAverage = true;
                                  });
                                  futuresList = [];
                                  futuresList.add(extractRequiredBrainMonthData(
                                      nameToId[name]!));

                                  calculateAverageSignal();
                                },
                                icon: Icon(Icons.search))
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text("$name님의 두뇌나이"),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: 130,
                              height: 130,
                              child: CircleAvatar(
                                backgroundImage: AssetImage('image/brain.jpg'),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text('$name의 두뇌 \n나이는 10세!')
                          ],
                        ),
                        Divider(
                          thickness: 2.0,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text("최근 훈련 참여도"),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('영역별 성취도'),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [Text('Top1')],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [Text('Top2')],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [Text('Top3')],
                                )
                              ],
                            ),
                            Container(
                                height: MediaQuery.of(context).size.height / 5,
                                child: VerticalDivider(
                                  thickness: 2.0,
                                  width: 20,
                                  endIndent: 0,
                                  indent: 20,
                                )),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('영역별 수행도'),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [Text('Top1')],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [Text('Top2')],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [Text('Top3')],
                                )
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Divider(
                          thickness: 2.0,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text("영역별 평균 점수"),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: EdgeInsets.zero,
                          child: Container(
                            height: MediaQuery.of(context).size.height / 3.5,
                            child: radar_chart.RadarChart.light(
                              ticks: ticks,
                              features: features,
                              data: data,
                              reverseAxis: false,
                              useSides: true,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Divider(
                          thickness: 2.0,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text("세부 결과 그래프"),
                        const SizedBox(
                          height: 10,
                        ),
                        _buildButtons(),
                        TextButton(
                          onPressed: () async {
                            await gql.createMonthlyData();
                            setState(() {
                              braincount++;
                              brainbutton = "$braincount번 추가";
                            });
                          },
                          child: Text(brainbutton),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(nameForLinechart,style: TextStyle(color: Colors.black),),
                              Expanded(
                                child: LinearPercentIndicator(
                                  animation: true,
                                  lineHeight: 20.0,
                                  animationDuration: 2000,
                                  percent: SCORE / 100,
                                  animateFromLastPercent: true,
                                  center: Text("$SCORE"),
                                  isRTL: false,
                                  barRadius: Radius.elliptical(5, 15),
                                  progressColor: Colors.greenAccent,
                                  maskFilter:
                                      MaskFilter.blur(BlurStyle.solid, 3),
                                ),
                              ),
                              Text("$AVG"),
                              Text('(평균연령 $ageEra)'),
                            ],
                          ),
                        ),
                        AVG <= SCORE
                            ? Text('평균보다 점수가 높으시군요. 훌륭합니다!')
                            : Text('평균보다 점수가부족합니다. 강해지세요!'),
                        AspectRatio(
                          aspectRatio: 6 / 5,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                color: Color(0xff232d37)),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: _buildLineChart(),
                            ),
                          ),
                        ),
                      ]),
                ),
              ),
            ),
    );
  }

}
