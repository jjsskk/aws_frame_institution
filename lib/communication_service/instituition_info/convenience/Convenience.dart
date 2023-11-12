import 'package:aws_frame_institution/communication_service/instituition_info/convenience/AddShuttleTime.dart';
import 'package:aws_frame_institution/models/InstitutionFoodMenuTable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../GraphQL_Method/graphql_controller.dart';
import '../../../models/InstitutionFoodTable.dart';
import '../../../storage/storage_service.dart';
import 'AddFoodMenu.dart';

class ConveniencePage extends StatefulWidget {
  const ConveniencePage({Key? key}) : super(key: key);

  @override
  _ConveniencePageState createState() => _ConveniencePageState();
}

class _ConveniencePageState extends State<ConveniencePage> {
  late Future<InstitutionFoodTable?> food;
  late final gql;
  final StorageService storageService = StorageService();
  String FOOD_IMAGE_URL = 'loading';
  String FOOD_INSTITUTION_ID = '';
  String FOOD_DATETIME = '';
  String SHUTTLE_IMAGE_URL = 'loading';
  String SHUTTLE_INSTITUTION_ID = '';

  void getFood() {
    gql.queryFoodByInstitutionIdAndDate("INST_ID_123", date).then((value) {
      if (value != null) {
        setState(() {
          FOOD_IMAGE_URL = value.IMAGE_URL;
          FOOD_INSTITUTION_ID = value.INSTITUTION_ID;
          FOOD_DATETIME = value.DATE;
        });
      } else {
        setState(() {
          FOOD_IMAGE_URL = 'null'; // 데이터가 없는 경우 이미지 URL을 빈 문자열로 설정
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
    gql.queryShuttleTimeByInstitutionId("INST_ID_123").then((value) {
      if (value != null) {
        setState(() {
          SHUTTLE_IMAGE_URL = value.IMAGE_URL;
          SHUTTLE_INSTITUTION_ID = value.INSTITUTION_ID;
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
    getFood();
    gql.createMonthlyData();

    // foodMenu = gql.queryFoodMenuByInstitutionId("INST_ID_123", date);
  }

  void _onDateSelected(String selectedDate) {
    setState(() {
      date = selectedDate;
      getFood();
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.create),
                              color: Color(0xFF2B3FF0),
                              onPressed: () async {
                                var result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddFoodMenuPage(
                                      month: _generateDateItems(),
                                      date: date,
                                    ),
                                  ),
                                );

                                if (result != null) {
                                  setState(() {
                                    getFood();
                                  });
                                }
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              color: Color(0xFF2B3FF0),
                              onPressed: () async {
                                // Show confirmation dialog
                                final confirmed = await showDialog<bool>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('삭제 확인'),
                                      content:
                                          const Text('정말로 이 항목을 삭제하시겠습니까?'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('예'),
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                        ),
                                        TextButton(
                                          child: const Text('아니오'),
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                        ),
                                      ],
                                    );
                                  },
                                );

                                if (confirmed ?? false) {
                                  var result = await gql.deleteFood(
                                      dateTime: FOOD_DATETIME,
                                      institutionId: FOOD_INSTITUTION_ID);

                                  // Show snackbar after deletion
                                  if (result != null)
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                '$FOOD_DATETIME월 식단정보가 성공적으로 삭제되었습니다.')));

                                  setState(() {
                                    getFood();
                                  });
                                }
                              },
                            )
                          ],
                        )
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

                  FOOD_IMAGE_URL != 'loading'
                      ? FOOD_IMAGE_URL != ''
                          ? FutureBuilder<String>(
                              future: storageService
                                  .getImageUrlFromS3(FOOD_IMAGE_URL),
                              builder: (BuildContext context,
                                  AsyncSnapshot<String> snapshot) {
                                if (snapshot.hasData) {
                                  String foodImageUrl = snapshot.data!;
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),  // 모서리를 둥글게
                                    child: Image.network(foodImageUrl),
                                  );

                                } else if (snapshot.hasError) {
                                  return Center(child: Text('이미지를 불러올 수 없습니다.'));
                                }
                                return Center(child: Text('데이터가 없습니다.'));
                              })
                          : Center(child: Text('데이터가 없습니다.'))
                      : Center(child: CircularProgressIndicator()),

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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.create),
                                  color: Color(0xFF2B3FF0),
                                  onPressed: () async {
                                    var result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AddShuttleTimePage(),
                                      ),
                                    );

                                    if (result != null) {
                                      setState(() {
                                        print("qwer");
                                        getShuttleTime();
                                      });
                                    }
                                  }, // 기능 구현
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  color: Color(0xFF2B3FF0),
                                  onPressed: () async {
                                    // Show confirmation dialog
                                    final confirmed = await showDialog<bool>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('삭제 확인'),
                                          content:
                                              const Text('정말로 이 항목을 삭제하시겠습니까?'),
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Text('예'),
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(true),
                                            ),
                                            TextButton(
                                              child: const Text('아니오'),
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(false),
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                    if (confirmed ?? false) {
                                      var result = await gql.deleteShuttleTime(
                                          institutionId:
                                              SHUTTLE_INSTITUTION_ID);

                                      // Show snackbar after deletion
                                      if (result != null)
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    '셔틀시간이 성공적으로 삭제되었습니다.')));

                                      setState(() {
                                        getShuttleTime();
                                      });
                                    }
                                  },
                                )
                              ],
                            ),
                          ],
                        ),
                        SHUTTLE_IMAGE_URL != 'loading'
                            ? SHUTTLE_IMAGE_URL != ''
                                ? FutureBuilder<String>(
                                    future: storageService
                                        .getImageUrlFromS3(SHUTTLE_IMAGE_URL),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<String> snapshot) {
                                      if (snapshot.hasData) {
                                        String imageUrl = snapshot.data!;
                                        return ClipRRect(
                                          borderRadius: BorderRadius.circular(10.0),  // 모서리를 둥글게
                                          child: Image.network(imageUrl),
                                        );
                                      } else if (snapshot.hasError) {
                                        return Text('이미지를 불러올 수 없습니다.');
                                      }
                                      return Text('데이터가 없습니다');
                                    })
                                : Text('데이터가 없습니다.')
                            : CircularProgressIndicator(),
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
      dropdownColor: Colors.indigoAccent,

      icon: Icon(
        // Add this
        Icons.arrow_drop_down, // Add this
        color: Colors.white, // Add this
      ),
      value: selectedValue,
      items: [
        for (final date in widget.Items)
          DropdownMenuItem(
            child: Text(date,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
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
