import 'package:aws_frame_institution/communication_service/instituition_info/convenience/AddFoodMenu.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConveniencePage extends StatelessWidget {
  List<String> _generateDateItems() {
    final now = DateTime.now();
    final formatter = DateFormat('yyyy년 MM월');
    final months = <String>[];

    for (int i = -8; i <= 6; ++i) {
      final date = DateTime(now.year, now.month + i, 1);
      months.add(formatter.format(date));
    }

    return months;
  }

  const ConveniencePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateItems = _generateDateItems();
    final themeData = Theme.of(context);
    final appBarColor = themeData.primaryColor;

    return Scaffold(

      body: Column(
        children: [
          // 식단정보 파트
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '식단정보',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      IconButton(
                        icon: const Icon(Icons.create),
                        color: appBarColor,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AddFoodMenuPage()),
                          );
                          // 글쓰기 버튼 클릭시 실행될 로직
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: [Expanded(child: CustomDropDown(dateItems: dateItems))],
                  ),
                ),
              ],
            ),
          ),
          // 셔틀시간표 파트
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '셔틀시간표',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      IconButton(
                        icon: const Icon(Icons.create),
                        color: appBarColor,
                        onPressed: () {
                          // 글쓰기 버튼 클릭시 실행될 로직
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomDropDown extends StatefulWidget {
  final List<String> dateItems;
  CustomDropDown({Key? key, required this.dateItems}) : super(key: key);

  @override
  _CustomDropDownState createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    // 처음 선택 될 값을 정해줍니다. 현재 월을 기준으로 드롭다운 값을 선택합니다.
    selectedValue = widget.dateItems[6];
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      // 선택된 값을 값을 반영하는 value 속성 설정
      style: TextStyle(color: Colors.black),
      value: selectedValue,
      items: [
        for (final date in widget.dateItems)
          DropdownMenuItem(
            child: Text(date),
            value: date,
          ),
      ],
      onChanged: (value) {
        setState(() {
          selectedValue = value;
        });
        // 이곳에서 식단정보 이미지 변경 로직을 구현하세요
      },
    );
  }
}
