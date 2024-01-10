import 'dart:math';

import 'package:aws_frame_institution/loading_page/loading_page.dart';
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

  final iconColor = Colors.white;

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
  int indexLineChart = 0;

  List<String> users = []; // storing user Ids having similar ageEra

  // to know when data is fetched for calculating average data
  List<Future<dynamic?>> futuresList = [];
  int ageEra = 0;
  var month = 1; // for DropdownDatePicker
  var year = 2023; // for DropdownDatePicker
  List<String> monthList = [
    '1월',
    '2월',
    '3월',
    '4월',
    '5월',
    '6월',
    '7월',
    '8월',
    '9월',
    '10월',
    '11월',
    '12월',
  ];
  List<String> yearList = [];

  String dropdownYear = '';
  String dropdownMonth = '';

  var selectedBirth = ''; //selected user birth

  int numberForonedata = 1; // for extractRequiredUserData()

  Map<String, List<int>> allData = {}; // variable for _getBars()

  int indexDropdown = 0;
  Map<String, String> nameDeepPng = {};
  Map<String, String> nameLightPng = {};

  void makeButtonNameList() {
    // "avg_att": "평균\n집중도",
    // "avg_med": "평균\n안정감",
    // "con_score": "주의력",
    // "spacetime_score": "시공간",
    // "exec_score": "집행기능",
    // "mem_score": "기억력",
    // "ling_score": "언어기능",
    // "cal_score": "계산력",
    // "reac_score": "반응속도",
    // "orient_score": "지남력",
    nameDeepPng['avg_att'] = 'image/report (23).png';
    nameDeepPng['avg_med'] = 'image/report (10).png';
    nameDeepPng['con_score'] = 'image/report (27).png';
    nameDeepPng['spacetime_score'] = 'image/report (28).png';
    nameDeepPng['exec_score'] = 'image/report (29).png';
    nameDeepPng['mem_score'] = 'image/report (30).png';
    nameDeepPng['ling_score'] = 'image/report (31).png';
    nameDeepPng['cal_score'] = 'image/report (32).png';
    nameDeepPng['reac_score'] = 'image/report (33).png';
    nameDeepPng['orient_score'] = 'image/report (26).png';
    nameLightPng['avg_att'] = 'image/report (13).png';
    nameLightPng['avg_med'] = 'image/report (14).png';
    nameLightPng['con_score'] = 'image/report (35).png';
    nameLightPng['spacetime_score'] = 'image/report (36).png';
    nameLightPng['exec_score'] = 'image/report (37).png';
    nameLightPng['mem_score'] = 'image/report (38).png';
    nameLightPng['ling_score'] = 'image/report (39).png';
    nameLightPng['cal_score'] = 'image/report (40).png';
    nameLightPng['reac_score'] = 'image/report (41).png';
    nameLightPng['orient_score'] = 'image/report (34).png';
  }

  String name = "";
  String selectedLabel = '';
  bool useSides = false;
  List<String> nameList = [];

  void makeYearDropdownValues() {
    month = DateTime.now().month;
    year = DateTime.now().year;
    var tempYear = year - 3;
    for (; tempYear < year + 4; tempYear++) yearList.add('$tempYear년');

    dropdownMonth = '$month월';
    dropdownYear = '$year년';
  }

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
      // 해당 id 유저(훈련인)의 데이터 불러오기
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
    // String selectedBirth = "19651008";
    int year = int.parse(selectedBirth.substring(0, 4));
    int month = int.parse(selectedBirth.substring(4, 6));
    int day = int.parse(selectedBirth.substring(6, 8));
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
    "avg_att": "집중도",
    "avg_med": "안정감",
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
            topTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false, // 이 부분을 false로 설정하여 상단 x축의 숫자를 숨깁니다.
              ),
            ),
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
            border: Border.all(color: const Color(0xffffff), width: 1)),
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
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(1.0),
      mainAxisSpacing: 30,
      // 메인 축 간격 설정
      crossAxisSpacing: 4.0,
      childAspectRatio: 0.7,
      // s21 -> 0.7
      // 가로 세로 비율 조절
      // 교차 축 간격 설정
      children: buttonLabels.keys
          .map((label) => Column(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(selectedLabel == label
                            ? nameDeepPng[label]!
                            : nameLightPng[label]!), // 여기에 배경 이미지 경로를 지정합니다.
                        fit: BoxFit.fill, // 이미지가 전체 화면을 커버하도록 설정합니다.
                      ),
                    ),
                    child: InkWell(
                        onTap: () {
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
                        child: Image.asset(selectedLabel == label
                            ? nameDeepPng[label]!
                            : nameLightPng[label]!)),

                  ),
                  Expanded(
                    child: Text(
                      buttonLabels[label]!,
                      style: TextStyle(
                          fontSize: 16.0,
                          height: 1.3,
                          fontWeight: FontWeight.w500,
                          color: selectedLabel == label
                              ? Colors.black
                              : Colors.grey
                          // : Color(0xFF2B3FF0),
                          ),
                    ),
                  ),
                ],
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

  Future<void> fetchUserLists() async {
    try {
      final userName = await gql.queryListUsers();
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
        name = nameList[indexDropdown];
        selectedBirth = name.substring(name.length - 9, name.length - 1);
        print('생년월일 : $selectedBirth');
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
    indexDropdown = nameList.indexOf(selectedName);
    print(name);
    print(nameToId[name]);
    // });
    // fetchLatestOneBrainData(nameToId[name]!);

    setState(() {
      loadingForAverage = true;
    });

    selectedBirth = selectedName.substring(
        selectedName.length - 9, selectedName.length - 1);
    print('생일: ${selectedBirth}');
    futuresList = [];
    futuresList.add(extractRequiredBrainMonthData(nameToId[name]!));

    calculateAverageSignal();

    fetchOneYearBrainDataForGraph();
  }


  @override
  void initState() {
    super.initState();
    gql = GraphQLController.Obj;
    makeButtonNameList();
    makeYearDropdownValues();
    // fetchLatestOneBrainData('1');
    indexDropdown = 0;
    fetchUserLists();
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var theme = Theme.of(context);

    const ticks = [20, 40, 60, 80, 100];
    var features = [
      "지남력($ORIENT_SCORE)",
      "주의력($CON_SCORE)",
      "시공간($SPACETIME_SCORE)",
      "집행기능($EXEC_SCORE)",
      "기억력($MEM_SCORE)",
      "언어기능($LING_SCORE)",
      "계산력($CAL_SCORE)",
      "반응속도($REAC_SCORE)",
      // "집중력($AVG_ATT)",
      // "안정감($AVG_MED)",
    ];
    var data = [
      [
        ORIENT_SCORE,
        CON_SCORE,
        SPACETIME_SCORE,
        EXEC_SCORE,
        MEM_SCORE,
        LING_SCORE,
        CAL_SCORE,
        REAC_SCORE,

        // AVG_ATT,
        // AVG_MED,
      ]
    ];

    // 빌드하는 부분입니다. 이 곳에서는 그래프가 들어가는 box의 쉐입을 정하는 곳입니다. 그래프가 있는 곳 박스를 수정하고 싶다면 이 곳을 수정하시면 됩니다.
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_circle_left_outlined,
              color: iconColor, size: 35),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('개별 분석 보고서',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: iconColor)),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('image/ui (5).png'), // 여기에 원하는 이미지 경로를 써주세요.
              fit: BoxFit.cover, // 이미지가 AppBar를 꽉 채우도록 설정
            ),
          ),
        ),
      ),
      body: (loadingForGraph || loadingForAverage)
          ? LoadingPage()
          : Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image:
                      AssetImage("image/ui (2).png"), // 여기에 배경 이미지 경로를 지정합니다.
                  fit: BoxFit.fill, // 이미지가 전체 화면을 커버하도록 설정합니다.
                ),
              ),
              child: SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          nameList.isNotEmpty
                              ? Container(
                                  height:
                                      MediaQuery.of(context).size.height / 25,
                                  width:
                                      MediaQuery.of(context).size.width / 1.9,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                      image:
                                          AssetImage("image/report (20).png"),
                                      // 여기에 배경 이미지 경로를 지정합니다.
                                      fit: BoxFit
                                          .fill, // 이미지가 전체 화면을 커버하도록 설정합니다.
                                    ),
                                  ),
                                  child: Center(
                                    child: CustomDropDown(
                                      Items: nameList,
                                      selected: name,
                                      onChanged: _NameSelected,
                                    ),
                                  ),
                                )
                              : Container(),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                height: MediaQuery.of(context).size.height / 25,
                                width: MediaQuery.of(context).size.width / 3.5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                    image: AssetImage("image/report (20).png"),
                                    // 여기에 배경 이미지 경로를 지정합니다.
                                    fit:
                                        BoxFit.fill, // 이미지가 전체 화면을 커버하도록 설정합니다.
                                  ),
                                ),
                                child: Center(
                                  child: DropdownButton<String>(
                                    dropdownColor: const Color(0xff1f43f3),
                                    value: dropdownYear,
                                    icon: Icon(
                                      // Add this
                                      Icons.arrow_drop_down, // Add this
                                      color: iconColor, // Add this
                                    ),
                                    onChanged: (String? value) {
                                      setState(
                                        () {
                                          dropdownYear = value!;
                                          year =
                                              int.parse(value!.substring(0, 4));
                                        },
                                      );
                                      print(year);
                                    },
                                    items: yearList
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: TextStyle(
                                              color: iconColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                              Container(
                                height: MediaQuery.of(context).size.height / 25,
                                width: MediaQuery.of(context).size.width / 4,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                    image: AssetImage("image/report (20).png"),
                                    // 여기에 배경 이미지 경로를 지정합니다.
                                    fit:
                                        BoxFit.fill, // 이미지가 전체 화면을 커버하도록 설정합니다.
                                  ),
                                ),
                                child: Center(
                                  child: DropdownButton<String>(
                                    dropdownColor: const Color(0xff1f43f3),
                                    value: dropdownMonth,
                                    icon: Icon(
                                      // Add this
                                      Icons.arrow_drop_down, // Add this
                                      color: iconColor, // Add this
                                    ),
                                    onChanged: (String? value) {
                                      setState(
                                        () {
                                          dropdownMonth = value!;
                                          int len = value!.length;
                                          month = int.parse(value!
                                              .substring(0, len > 2 ? 2 : 1));
                                        },
                                      );
                                      print(month);
                                    },
                                    items: monthList
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: TextStyle(
                                              color: iconColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                              // pub deb에서 받은 오픈소스 날짜 드랍 다운 박스 ->디지인 asset 파일에 입힐수 없어서 주석처리
                              // Expanded(
                              //   child: DropdownDatePicker(
                              //     inputDecoration: InputDecoration(
                              //         enabledBorder: const OutlineInputBorder(
                              //           borderSide: BorderSide(
                              //               color: Colors.grey, width: 1.0),
                              //         ),
                              //         border: OutlineInputBorder(
                              //             borderRadius:
                              //                 BorderRadius.circular(10))),
                              //     // optional
                              //     isDropdownHideUnderline: true,
                              //     // optional
                              //     isFormValidator: true,
                              //     // optional
                              //     startYear: 2022,
                              //     // optional
                              //     endYear: 2030,
                              //     // optional
                              //     width: 10,
                              //     // optional
                              //     locale: "zh_CN",
                              //     // selectedDay: 14, // optional
                              //     showDay: false,
                              //     selectedMonth: month,
                              //     // optional
                              //     selectedYear: year,
                              //     // optional
                              //     // onChangedDay: (value) => print('onChangedDay: $value'),
                              //     onChangedMonth: (value) {
                              //       print('onChangedMonth: $value');
                              //       month = int.parse(value!);
                              //     },
                              //     onChangedYear: (value) {
                              //       print('onChangedYear: $value');
                              //       year = int.parse(value!);
                              //     },
                              //     //boxDecoration: BoxDecoration(
                              //     // border: Border.all(color: Colors.grey, width: 1.0)), // optional
                              //     // showDay: false,// optional
                              //     // dayFlex: 2,// optional
                              //     // locale: "zh_CN",// optional
                              //     // hintDay: 'Day', // optional
                              //     // hintMonth: 'Month', // optional
                              //     // hintYear: 'Year', // optional
                              //     // hintTextStyle: TextStyle(color: Colors.grey), // optional
                              //   ),
                              // ),
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: iconColor,
                                ),
                                child: Center(
                                  child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          loadingForAverage = true;
                                        });
                                        futuresList = [];
                                        futuresList.add(
                                            extractRequiredBrainMonthData(nameToId[
                                                name]!)); //맨위 유저 dropdown에 선택된 유저 id의 뇌파그래프 불러옴

                                        calculateAverageSignal();
                                      },
                                      icon: Icon(
                                        Icons.search,
                                        color: const Color(0xff1f43f3),
                                      )),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text("$name님의 두뇌나이",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),

                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 320,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('image/report (25).png'),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text('$name님의 두뇌 \n나이는 27세!',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          // Divider(
                          //   thickness: 2.0,
                          // ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          // Text("최근 훈련 참여도"),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //   children: [
                          //     Column(
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       mainAxisAlignment: MainAxisAlignment.start,
                          //       children: [
                          //         Text('영역별 성취도'),
                          //         const SizedBox(
                          //           height: 10,
                          //         ),
                          //         Row(
                          //           children: [Text('Top1')],
                          //         ),
                          //         const SizedBox(
                          //           height: 10,
                          //         ),
                          //         Row(
                          //           children: [Text('Top2')],
                          //         ),
                          //         const SizedBox(
                          //           height: 10,
                          //         ),
                          //         Row(
                          //           children: [Text('Top3')],
                          //         )
                          //       ],
                          //     ),
                          //     Container(
                          //         height:
                          //             MediaQuery.of(context).size.height / 5,
                          //         child: VerticalDivider(
                          //           thickness: 2.0,
                          //           width: 20,
                          //           endIndent: 0,
                          //           indent: 20,
                          //         )),
                          //     Column(
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       mainAxisAlignment: MainAxisAlignment.start,
                          //       children: [
                          //         Text('영역별 수행도'),
                          //         const SizedBox(
                          //           height: 10,
                          //         ),
                          //         Row(
                          //           children: [Text('Top1')],
                          //         ),
                          //         const SizedBox(
                          //           height: 10,
                          //         ),
                          //         Row(
                          //           children: [Text('Top2')],
                          //         ),
                          //         const SizedBox(
                          //           height: 10,
                          //         ),
                          //         Row(
                          //           children: [Text('Top3')],
                          //         )
                          //       ],
                          //     )
                          //   ],
                          // ),
                          const SizedBox(
                            height: 10,
                          ),
                          Divider(
                            thickness: 2.0,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "영역별 한달 평균 점수",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),

                          const SizedBox(
                            height: 10,
                          ),
                          Stack(
                            children: [
                              Container(
                                height: MediaQuery.of(context).size.height / 2,
                                width: MediaQuery.of(context).size.width,
                                child: Image.asset("image/report (18).png"),
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                    height: 63, //s21 ->70
                                  ),
                                  Container(
                                    height: MediaQuery.of(context).size.height /
                                        3.02,
                                    child: radar_chart.RadarChart(
                                      data: data,
                                      ticks: ticks,
                                      features: features,
                                      reverseAxis: false,
                                      outlineColor: Colors.transparent,
                                      axisColor: Colors.transparent,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // Padding(
                          //   padding: EdgeInsets.zero,
                          //   child: Container(
                          //     height: MediaQuery.of(context).size.height / 3.5,
                          //     child: radar_chart.RadarChart.light(
                          //       ticks: ticks,
                          //       features: features,
                          //       data: data,
                          //       reverseAxis: false,
                          //       useSides: true,
                          //     ),
                          //   ),
                          // ),
                          const SizedBox(
                            height: 10,
                          ),
                          Divider(
                            thickness: 2.0,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "세부 결과 그래프",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          _buildButtons(),
                          // TextButton(
                          //   onPressed: () async {
                          //     await gql.createMonthlyData();
                          //     setState(() {
                          //       braincount++;
                          //       brainbutton = "$braincount번 추가";
                          //     });
                          //   },
                          //   child: Text(brainbutton),
                          // ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            constraints: BoxConstraints(
                              maxHeight: double
                                  .infinity, // container 길이를 text에 맞게 유연하게 늘릴수 있다.
                            ),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("image/community (20).png"),
                                // 여기에 배경 이미지 경로를 지정합니다.
                                fit: BoxFit.fill, // 이미지가 전체 화면을 커버하도록 설정합니다.
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 15.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              7,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              7,
                                          child: Image.asset(
                                              nameDeepPng[selectedLabel]!)),
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
                                          maskFilter: MaskFilter.blur(
                                              BlurStyle.solid, 3),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '  $nameForLinechart',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text("$AVG (평균연령 $ageEra)",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text('자세한 평가는 전문가가 직접 적어줄거에요',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                      AVG <= SCORE
                                          ? '평균보다 점수가 높으시군요. 훌륭합니다!'
                                          : '평균보다 점수가부족합니다. 강해지세요!',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          AspectRatio(
                            aspectRatio: 6 / 5,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  color: iconColor.withOpacity(0.5)),
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
            ),
    );
  }
}
