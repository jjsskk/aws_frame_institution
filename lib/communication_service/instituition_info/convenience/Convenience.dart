import 'package:aws_frame_institution/communication_service/instituition_info/convenience/AddShuttleTime.dart';
import 'package:aws_frame_institution/models/InstitutionFoodMenuTable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../GraphQL_Method/graphql_controller.dart';
import '../../../storage/storage_service.dart';
import 'AddFoodMenu.dart';

class ConveniencePage extends StatefulWidget {
  const ConveniencePage({Key? key}) : super(key: key);

  @override
  _ConveniencePageState createState() => _ConveniencePageState();
}

class _ConveniencePageState extends State<ConveniencePage> {
  late Future<InstitutionFoodMenuTable?> foodMenu;
  late final gql;
  final StorageService storageService = StorageService();
  String FOOD_IMAGE_URL = '';
  String SHUTTLE_IMAGE_URL = '';

  void getFoodMenu() {
    gql.queryFoodMenuByInstitutionIdAndDate("INST_ID_123", date).then((value) {
      if (value != null) {
        setState(() {
          FOOD_IMAGE_URL = value.IMAGE_URL;
        });
      } else {
        setState(() {
          FOOD_IMAGE_URL = ''; // 데이터가 없는 경우 이미지 URL을 빈 문자열로 설정
        });
      }
    }).catchError((error) {
      setState(() {
        FOOD_IMAGE_URL = ''; // 에러 발생 시 이미지 URL을 빈 문자열로 설정
      });
      print("Error fetching data: $error");
    });
  }

  void getShuttleTime() {
    gql.queryShuttleTimeByInstitutionId("INST_ID_123", "20200303").then((value) {
      if (value != null) {
        setState(() {
          print("image");
          print(SHUTTLE_IMAGE_URL);
          SHUTTLE_IMAGE_URL = value.IMAGE_URL;
        });
      } else {
        setState(() {
          SHUTTLE_IMAGE_URL = ''; // 데이터가 없는 경우 이미지 URL을 빈 문자열로 설정
        });
      }
    }).catchError((error) {
      setState(() {
        SHUTTLE_IMAGE_URL = ''; // 에러 발생 시 이미지 URL을 빈 문자열로 설정
      });
      print("Error fetching data: $error");
    });
  }


  List<String> _generateDateItems() {
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM');
    final months = <String>[];

    for (int i = -8; i <= 6; ++i) {
      final date = DateTime(now.year, now.month + i, 1);
      months.add(formatter.format(date));
    }

    return months;
  }

  String date = '';

  @override
  void initState() {
    super.initState();
    gql = GraphQLController.Obj;
    date = _generateDateItems()[6];
    getShuttleTime();
    getFoodMenu();
    gql.createMonthlyData();


    // foodMenu = gql.queryFoodMenuByInstitutionId("INST_ID_123", date);
  }

  void _onDateSelected(String selectedDate) {
    setState(() {
      date = selectedDate;
      getFoodMenu();
      // foodMenu = gql.queryFoodMenuByInstitutionId("INST_ID_123", date);
    });
  }

  @override
  Widget build(BuildContext context) {
    final dateItems = _generateDateItems();
    final themeData = Theme.of(context);
    final appBarColor = themeData.primaryColor;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            //this point
            child: SingleChildScrollView(
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
                              MaterialPageRoute(
                                builder: (context) => AddFoodMenuPage(
                                  month: _generateDateItems(),
                                  date: date,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomDropDown(
                            Items: dateItems,
                            selected: date,
                            onChanged: _onDateSelected,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // FutureBuilder<InstitutionFoodMenuTable?>(
                  // future: foodMenu,
                  // builder: (context, snapshot) {
                  //   if (snapshot.connectionState ==
                  //       ConnectionState.waiting) {
                  //     return Center(child: CircularProgressIndicator());
                  //   }
                  //   if (snapshot.hasData) {
                  //     print(foodMenu);
                  //     if (snapshot.data!.IMAGE_URL!.isNotEmpty)

                  FOOD_IMAGE_URL != '' ? FutureBuilder<String>(
                      future: storageService.getImageUrlFromS3(FOOD_IMAGE_URL),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        if (snapshot.hasData) {
                          String foodImageUrl = snapshot.data!;
                          return Image.network(
                            foodImageUrl,
                          );
                        } else if (snapshot.hasError) {
                          return Text('이미지를 불러올 수 없습니다.');
                        }
                          return CircularProgressIndicator();


                      }): Text('데이터가 없습니다'),

                  //   }
                  //   print("aasdasdas");
                  //   print(foodMenu);
                  //   return Center(child: Text('편의사항이 없습니다.'));
                  // }
                  //     ),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddShuttleTimePage(),
                                  ),
                                );
                              }, // 기능 구현
                            ),
                          ],
                        ),

                        SHUTTLE_IMAGE_URL != '' ? FutureBuilder<String>(
                            future: storageService.getImageUrlFromS3(SHUTTLE_IMAGE_URL),
                            builder: (BuildContext context,
                                AsyncSnapshot<String> snapshot) {
                              if (snapshot.hasData) {
                                String imageUrl = snapshot.data!;
                                return Image.network(
                                  imageUrl,
                                );
                              } else if (snapshot.hasError) {
                                return Text('이미지를 불러올 수 없습니다.');
                              }
                              return CircularProgressIndicator();
                            }): Text('데이터가 없습니다'),
                      ],
                    ),
                  ),
                  // 셔틀 시간표 목록 구현
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomDropDown extends StatefulWidget {
  final List<String> Items;
  final String selected;
  final Function(String) onChanged;

  const CustomDropDown(
      {Key? key,
      required this.Items,
      required this.onChanged,
      required this.selected})
      : super(key: key);

  @override
  _CustomDropDownState createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      style: TextStyle(color: Colors.black),
      value: selectedValue,
      items: [
        for (final date in widget.Items)
          DropdownMenuItem(
            child: Text(date),
            value: date,
          ),
      ],
      onChanged: (value) {
        setState(() {
          selectedValue = value;
        });
        widget.onChanged(value!);
      },
    );
  }
}
