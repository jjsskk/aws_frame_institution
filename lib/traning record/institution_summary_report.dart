import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../GraphQL_Method/graphql_controller.dart';
import '../communication_service/instituition_info/convenience/Convenience.dart';
import '../models/MonthlyBrainSignalTable.dart';

class InstitutionSummaryPage extends StatefulWidget {
  InstitutionSummaryPage({Key? key}) : super(key: key);



  @override
  State<InstitutionSummaryPage> createState() => _InstitutionSummaryPageState();
}

class _InstitutionSummaryPageState extends State<InstitutionSummaryPage> {
  Map<String, Map<String, int>> averagesByMonth = {};
  int index = 0;
  String name = "";
  String? selectedLabel;
  bool useSides = false;
  List<String> nameList = [];
  String? startYear = DateTime.now().year.toString();
  String? startMonth = '01';
  String? endYear = DateTime.now().year.toString();
  String? endMonth = '12';
  String day = '01';

  List<String> years = List<String>.generate(50, (i) => (DateTime.now().year - i).toString());
  List<String> months = List<String>.generate(12, (i) => ((i + 1) < 10 ? '0' : '') + (i + 1).toString());

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



  Widget buildDropdown(String selectedValue, List<String> items,
      ValueChanged<String?> onChanged) {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        border: InputBorder.none, // 이 부분을 추가하여 밑줄을 제거합니다.
      ),
      value: selectedValue,
      items: items.map((String value) {
        return new DropdownMenuItem(
          value: value,
          child: new Text(value, style: TextStyle(color: Colors.black),),
        );
      }).toList(),
      onChanged: onChanged,
    );
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
  // List<double> _getGraphData(String label, int colorIndex) {
  //   List<double> graphData = [];
  //   DateTime twelveMonthsAgo = DateTime.now().subtract(Duration(days: 365 * 1));
  //   double maxValue = double.negativeInfinity; // 초기값 설정
  //   double minValue = double.infinity; // 초기값 설정
  //
  //   int count = 0; // 데이터 개수 카운트
  //   for (var result in results) {
  //     // 날짜 필터링
  //     String? monthStr = result?.month;
  //     int year = int.parse(monthStr!.substring(0, 4));
  //     int month = int.parse(monthStr.substring(4, 6));
  //     DateTime date = DateTime(year, month);
  //
  //     if (date.isBefore(twelveMonthsAgo)) {
  //       continue;
  //     }
  //     double? value;
  //     switch (label) {
  //       case "avg_att":
  //         value = result?.avg_att?.toDouble();
  //         break;
  //       case "avg_med":
  //         value = result?.avg_med?.toDouble();
  //         break;
  //       case "con_score":
  //         value = result?.con_score?.toDouble();
  //         break;
  //       case "spacetime_score":
  //         value = result?.spacetime_score?.toDouble();
  //         break;
  //       case "exec_score":
  //         value = result?.exec_score?.toDouble();
  //         break;
  //       case "mem_score":
  //         value = result?.mem_score?.toDouble();
  //         break;
  //       case "ling_score":
  //         value = result?.ling_score?.toDouble();
  //         break;
  //       case "cal_score":
  //         value = result?.cal_score?.toDouble();
  //         break;
  //       case "reac_score":
  //         value = result?.reac_score?.toDouble();
  //         break;
  //       case "orient_score":
  //         value = result?.orient_score?.toDouble();
  //         break;
  //       default:
  //         value = null;
  //     }
  //
  //     if (value != null) {
  //       graphData.add(value);
  //     }
  //   }
  //   return graphData;
  // }
  List<double> _getGraphData(String label, int colorIndex) {
    List<double> graphData = [];
    DateTime twelveMonthsAgo = DateTime.now().subtract(Duration(days: 365));

    for (var month in averagesByMonth.keys) {
      int year = int.parse(month.substring(0, 4));
      int monthInt = int.parse(month.substring(4, 6));
      DateTime date = DateTime(year, monthInt);

      if (date.isAfter(twelveMonthsAgo)) {
        var value = averagesByMonth[month]?[label];
        if (value != null) {
          graphData.add(value.toDouble());
        }
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
    List<Color> selectedGradientColors = [      buttomColors[colorIndex],
      buttomColors[colorIndex].withOpacity(0.8),
    ];


    return LineChartData(
        lineTouchData: LineTouchData(enabled: true),
        gridData: FlGridData(
          show: false,
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
            topTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false, // 이 부분을 false로 설정하여 상단 x축의 숫자를 숨깁니다.
              ),
            ),

            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false))),
        borderData: FlBorderData(
            show: false,
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
          padding: EdgeInsets.all(8), child: LineChart(_getLineChartData())),
    );
  }
  void onSearchPressed() async {
    if(startYear == null || startMonth == null || endYear == null || endMonth == null){
      showDialog(context: context,builder:(BuildContext context)=>AlertDialog(title: Text("년도와 월을 올바르게 선택해주세요"),));
      return;
    }
    int startYr = int.parse(startYear!);
    int startMth = int.parse(startMonth!);
    int endYr = int.parse(endYear!);
    int endMth = int.parse(endMonth!);


    if(DateTime(endYr,endMth).isBefore(DateTime(startYr,startMth))){
      showDialog(context: context,builder:(BuildContext context)=>AlertDialog(title: Text("년도를 올바르게 선택해주세요"),));
      return;
    }

    // Fetch data with the specified range
    final dataStartStr=startYear!+startMonth!+day;
    final dataEndStr=endYear!+endMonth!+day;


    // final users = await gql.queryListUsers(institutionId: "123"); // User list query here
    //
    // for(var user in users){
    //   fetchData(startYear!, startMonth!, endYear!, endMonth!, day);
    // }
    fetchData(startYear!, startMonth!, endYear!, endMonth!, day);
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
      mainAxisSpacing: 4.0,  // 메인 축 간격 설정
      crossAxisSpacing: 4.0,  // 교차 축 간격 설정
      children: buttonLabels.keys.map((label) => ElevatedButton(

        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 1),
          shape: CircleBorder(),
          fixedSize: Size(10.0, 5.0),
          primary: selectedLabel == label ? Color(0xFF2B3FF0) : null,  // 선택된 라벨에 따라 색상 변경

        ),
        onPressed: () {
          for (var result in results) {
            String? month = result?.month.substring(4, 6);
            var value;
            switch (label) {
              case "avg_att":
                value = result?.avg_att;
                break;
              case "avg_med":
                value = result?.avg_med;
                break;
              case "con_score":
                value = result?.con_score;
                break;
              case "spacetime_score":
                value = result?.spacetime_score;
                break;
              case "exec_score":
                value = result?.exec_score;
                break;
              case "mem_score":
                value = result?.mem_score;
                break;
              case "ling_score":
                value = result?.ling_score;
                break;
              case "cal_score":
                value = result?.cal_score;
                break;
              case "reac_score":
                value = result?.reac_score;
                break;
              case "orient_score":
                value = result?.orient_score;
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
          style: TextStyle(fontSize: 16.0, height: 1.3, fontWeight: FontWeight.w500,color: selectedLabel == label ? Colors.white : Color(0xFF2B3FF0), ),

        ),
      )).toList(),
    );
  }


  double numberOfFeatures = 3;
  List<MonthlyBrainSignalTable?> results = []; //넣어 둘 친구
  late final gql;
  int usercount = 0;
  int braincount = 0;
  Map<String, String> nameToId = {};
  List<List<MonthlyBrainSignalTable?>> userList = [];

  Future<void> fetchData(String startYear, String startMonth,String endYear,String endMonth,String day,) async {
    try {
      averagesByMonth = {};
      final users = await gql.queryListUsers(institutionId: gql._institutionNumber);
      final dataStartStr=startYear+startMonth!+day;
      final dataEndStr=endYear!+endMonth!+day;
      results = [];
      for (var user in users) {
        print(user.ID);
        final data = await gql.queryListMonthlyDBItemsBetween(ID: user.ID, startMonth: dataStartStr, endMonth: dataEndStr);

        // print("Type of myResult: ${data.runtimeType}");

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
          } else {
            print("null");
          }
        }

        setState(() {
          for (var i in data) {
            results.add(i);
          }
        });
      }

      // for (var user in results) {
      //   print(user);
      // }

      Map<String, List<MonthlyBrainSignalTable>> groupedByMonth = {};
      for (var item in results) {
        String yearMonth = item!.month.substring(0, 6);
        if (!groupedByMonth.containsKey(yearMonth)) {
          groupedByMonth[yearMonth] = [];
        }
        groupedByMonth[yearMonth]?.add(item);
      }


      for (var month in groupedByMonth.keys) {
        var group = groupedByMonth[month];

        int? totalAvgAtt =
        group?.map((item) => item.avg_att).reduce((a, b) => a! + b!);
        int avgAtt = (totalAvgAtt! / group!.length).round();

        int? totalAvgMed =
        group?.map((item) => item.avg_med).reduce((a, b) => a! + b!);
        int avgMed = (totalAvgMed! / group!.length).round();

        int? totalConScore =
        group?.map((item) => item.con_score).reduce((a, b) => a! + b!);
        int avgConScore = (totalConScore! / group!.length).round();

        int? totalSpacetimeScore =
        group?.map((item) => item.spacetime_score).reduce((a, b) => a! + b!);
        int avgSpacetimeScore = (totalSpacetimeScore! / group!.length).round();

        int? totalExecScore =
        group?.map((item) => item.exec_score).reduce((a, b) => a! + b!);
        int avgExecScore = (totalExecScore! / group!.length).round();

        int? totalMemScore =
        group?.map((item) => item.mem_score).reduce((a, b) => a! + b!);
        int avgMemScore = (totalMemScore! / group!.length).round();

        int? totalLingScore =
        group?.map((item) => item.ling_score).reduce((a, b) => a! + b!);
        int avgLingScore = (totalLingScore! / group!.length).round();

        int? totalCalScore =
        group?.map((item) => item.cal_score).reduce((a, b) => a! + b!);
        int avgCalScore = (totalCalScore! / group!.length).round();

        int? totalReacScore =
        group?.map((item) => item.reac_score).reduce((a, b) => a! + b!);
        int avgReacScore = (totalReacScore! / group!.length).round();

        int? totalOrientScore =
        group?.map((item) => item.orient_score).reduce((a, b) => a! + b!);
        int avgOrientScore = (totalOrientScore! / group!.length).round();

        averagesByMonth[month] = {
          'avg_att': avgAtt,
          'avg_med': avgMed,
          'con_score': avgConScore,
          'spacetime_score': avgSpacetimeScore,
          'exec_score': avgExecScore,
          'mem_score': avgMemScore,
          'ling_score': avgLingScore,
          'cal_score': avgCalScore,
          'reac_score': avgReacScore,
          'orient_score': avgOrientScore
        };
      }

      print('ddd');
      print(averagesByMonth);
      print(dataStartStr);
    } catch (error) {
      print(error);
    }
  }


  @override
  void initState() {
    super.initState();
    gql = GraphQLController.Obj;
    index = 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchData(startYear!, startMonth!, endYear!, endMonth!, day).then((_) {
        if (ModalRoute.of(context)!.isCurrent) {
          setState(() {
            isLoading = false;
          });
        }
      });
    });
  }
  bool isLoading = true;
  var brainbutton = '뇌파 데이터 추가';

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var theme = Theme.of(context);

    // 빌드하는 부분입니다. 이 곳에서는 그래프가 들어가는 box의 쉐입을 정하는 곳입니다. 그래프가 있는 곳 박스를 수정하고 싶다면 이 곳을 수정하시면 됩니다.
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_circle_left_outlined,
              color: Colors.white, size: 35),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          '기관 요약 보고서',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold), // 글자색을 하얀색으로 설정
        ),
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
      body:  isLoading
        ? Center(child: CircularProgressIndicator()) :
      SingleChildScrollView(
        child: Center(
          child: Container(
            color: Colors.white,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 50, // Or any other specific height
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        Expanded(child: buildDropdown(startYear??'---',years,(value){setState((){startYear=value;});} )),
                        Expanded(child: buildDropdown(startMonth??'---',months,(value){setState((){startMonth=value;});})),
                        Expanded(child: buildDropdown(endYear??'---',years,(value){setState((){endYear=value;});})),
                        Expanded(child: buildDropdown(endMonth??'---',months,(value){setState((){endMonth=value;});})),
                        ElevatedButton(onPressed:onSearchPressed,child:Text('검색'),),
                      ],
                    ),
                  ),
                  _buildButtons(),
                  AspectRatio(
                    aspectRatio: 6 / 5,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          color: Colors.white.withOpacity(0.5)),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
