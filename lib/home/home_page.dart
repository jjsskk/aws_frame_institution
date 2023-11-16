import 'package:aws_frame_institution/GraphQL_Method/graphql_controller.dart';
import 'package:aws_frame_institution/backey/backKey_dialog.dart';
import 'package:aws_frame_institution/bottomappbar/bottom_appbar.dart';
import 'package:aws_frame_institution/camera_gallary/graph_page.dart';
import 'package:aws_frame_institution/communication_service/comment/Detail_comment.dart';
import 'package:aws_frame_institution/communication_service/comment/comment_view.dart';
import 'package:aws_frame_institution/communication_service/communication_yard.dart';
import 'package:aws_frame_institution/communication_service/essential_care_information/essential_care_information.dart';
import 'package:aws_frame_institution/communication_service/instituition_info/institution_information.dart';
import 'package:aws_frame_institution/drawer/drawer.dart';
import 'package:aws_frame_institution/bottomappbar/globalkey.dart';
import 'package:aws_frame_institution/loading_page/loading_page.dart';
import 'package:aws_frame_institution/login_session.dart';
import 'package:aws_frame_institution/provider/login_state.dart';
import 'package:aws_frame_institution/traning%20record/individual_analysis_report_old.dart';
import 'package:aws_frame_institution/traning%20record/institution_summary_report.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

import '../traning record/analyzing_report.dart';
import '../traning record/individual_analysis_report.dart';

class HomePage extends StatefulWidget {
  HomePage(
      {Key? key,
      required this.didtogglegallery,
      // required this.didtogglegraph,
      required this.pickedimageurl,
      required this.shouldLogOut})
      : super(key: key);
  final VoidCallback didtogglegallery;

  // final VoidCallback didtogglegraph;
  final VoidCallback shouldLogOut;
  String pickedimageurl = '';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // final GlobalKey<ScaffoldState> _key = GlobalKey();

  var buttonTextStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
  var iconColor = Colors.white;
  late final bottomappbar;
  late final keyObj;
  late var appState;
  final gql = GraphQLController.Obj;

  bool loading_Manager = true;
  bool loading_comment = true;

  // bool checkAttribute = false; //  to call getProtectorAttributes() once
  int year = 0;
  int month = 0;
  List<Map<String, dynamic>> _comments = [];

  void storeAndSort(var result) {
    _comments = [];
    result.forEach((value) {
      // print(value.createdAt.toString().substring(0,10));
      _comments.add({
        'date': value.createdAt.toString().substring(0, 10) ?? '',
        'title': value.TITLE ?? '',
        'username': value.USERNAME ?? '',
        'user_id': value.USER_ID ?? '',
        'board_id': value.BOARD_ID ?? '',
        'new_conversation': value.NEW_CONVERSATION_PROTECTOR,
        'new_conversation_createdat':
            value.NEW_CONVERSATION_CREATEDAT.toString()
      });
    });
    _comments.sort((a, b) {
      String aa = a['new_conversation_createdat'];

      String bb = b['new_conversation_createdat'];
      return bb.compareTo(aa);
    });
    // 상위 5개의 항목만 저장
    _comments = _comments.length > 5 ? _comments.sublist(0, 5) : _comments;
  }

  @override
  void initState() {
    super.initState();
    getInstitutionAttributes();
    BackButtonInterceptor.add(backKeyInterceptor,
        context: context); // for back key
    keyObj = KeyForBottomAppbar();
    bottomappbar = GlobalBottomAppBar(keyObj: keyObj);
    year = DateTime.now().year;
    month = DateTime.now().month;
    gql
        .listInstitutionCommentBoard('INSTITUTION_ID', '1234', '$year',
            month < 10 ? '0${month}' : '$month',
            nextToken: null) //institution_id
        .then((result) {
      print(result);
      if (result.isNotEmpty) {
        storeAndSort(result);
      }

      if (mounted) {
        setState(() {
          loading_comment = false;
        });
      }
    });
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(backKeyInterceptor);
    super.dispose();
  }

  void getInstitutionAttributes() async {
    try {
      // checkAttribute = true;
      var attribute = await Amplify.Auth.fetchUserAttributes();
      {
        attribute.forEach((element) {
          if (element.userAttributeKey.key == "name") {
            // username = element.value;
            gql.managerName = (element.value) ?? "no result";
            print(appState.managerName);
          } else if (element.userAttributeKey.key == "phone_number") {
            // userphonenumber = element.value;
            gql.managerPhonenumber = (element.value) ?? " no result";
          } else if (element.userAttributeKey.key == "email") {
            // useremail = element.value;
            gql.managerEmail = (element.value) ?? "no result";
            // loading = false;
          } else if (element.userAttributeKey.key.toLowerCase() ==
              "custom:institutionNumber".toLowerCase()) {
            // useremail = element.value;
            gql.institutionNumber = (element.value) ?? "no result";
          }
        });
        setState(() {
          loading_Manager = false;
        });
      }
    } catch (e) {
      print("error : $e");
    }
  }

  // In this app, back key default function make app terminated, not page poped because of Navigator() in main page and login_sesssion page
  Future<bool> backKeyInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    print("BACK BUTTON! "); // Do some stuff.
    if (stopDefaultButtonEvent) return Future(() => true); // prevent

    // If a dialog (or any other route) is open, don't run the interceptor.
    // return type is true -> run interceptor and return type is false -> don't run the interceptor( back key defaut function work)
    if (info.ifRouteChanged(context)) {
      Navigator.of(context).pop();
      return Future(() => true);
    }
    return GlobalBackKeyDialog.getBackKeyDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var theme = Theme.of(context);
    appState = context.watch<LoginState>();
    return (loading_Manager || loading_comment)
        ? LoadingPage()
        : Scaffold(
            drawer: GlobalDrawer.getDrawer(context, appState),
            key: keyObj.key,
            appBar: AppBar(
              title: Text(' ${gql.managerName} 담당자님 안녕하세요!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: iconColor)),
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image:
                        AssetImage('image/ui (5).png'), // 여기에 원하는 이미지 경로를 써주세요.
                    fit: BoxFit.cover, // 이미지가 AppBar를 꽉 채우도록 설정
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon:  Icon(
                    color:iconColor,
                    Icons.logout,
                    semanticLabel: 'logout',
                  ),
                  onPressed: widget.shouldLogOut,
                ),
              ],
              automaticallyImplyLeading:
                  false, // -> important to making top drawer button not visible while keeping drawer function in scaffold
            ),
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image:
                      AssetImage("image/ui (3).png"), // 여기에 배경 이미지 경로를 지정합니다.
                  fit: BoxFit.fill, // 이미지가 전체 화면을 커버하도록 설정합니다.
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      // GraphPage(),
                      Text(
                        '기관 정보',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      // TextButton(
                      //     onPressed: () {
                      //       gql.createUserData();
                      //     },
                      //     child: Text('유저 추가')),
                      // TextButton(
                      //     onPressed: () {
                      //       gql.createAnnounceData();
                      //     },
                      //     child: Text('공지 추가')),
                      //
                      // TextButton(
                      //     onPressed: () {
                      //       gql.queryAnnounceItem().then((value) {
                      //         print(value);
                      //       });
                      //     },
                      //     child: Text('값 부르기')),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff1f43f3),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    )),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => InstitutionInfoPage(
                                              initialIndex: 0,
                                            )),
                                  );
                                },
                                child: Text(
                                  '공지사항',
                                  style: buttonTextStyle,
                                )),
                          ),
                          Flexible(
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff1f43f3),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    )),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => InstitutionInfoPage(
                                              initialIndex: 1,
                                            )),
                                  );
                                },
                                child: Text('기관 소식', style: buttonTextStyle)),
                          ),
                          Flexible(
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff1f43f3),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    )),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => InstitutionInfoPage(
                                              initialIndex: 2,
                                            )),
                                  );
                                },
                                child: Text('시간표', style: buttonTextStyle)),
                          ),
                          Flexible(
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff1f43f3),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    )),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => InstitutionInfoPage(
                                              initialIndex: 3,
                                            )),
                                  );
                                },
                                child: Text('편의사항', style: buttonTextStyle)),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            EssentialCareInfoPage()),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero, // 내부 여백을 제거합니다.
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  // Column의 크기를 자식의 크기에 맞춤
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  // 중앙 정렬
                                  children: <Widget>[
                                    Image.asset(
                                      'image/community (8).png',
                                      width: MediaQuery.of(context).size.width/4,
                                      height: MediaQuery.of(context).size.width/4,
                                    ),
                                    // 아이콘
                                    Text('이용자 돌봄 정보',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    // 텍스트
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Text('훈련 보고서'),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        InstitutionSummaryPage()),
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero, // 내부 여백을 제거합니다.
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              // Column의 크기를 자식의 크기에 맞춤
                              mainAxisAlignment: MainAxisAlignment.center,
                              // 중앙 정렬
                              children: <Widget>[
                                Image.asset(
                                  'image/report (10).png',
                                  width: MediaQuery.of(context).size.width/4,
                                  height: MediaQuery.of(context).size.width/4,
                                ),
                                // 아이콘
                                Text('기관 요약 보고서',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                // 텍스트
                              ],
                            ),
                          ),
                          // ElevatedButton(
                          //     style: ElevatedButton.styleFrom(
                          //         backgroundColor: const Color(0xff1f43f3),
                          //         shape: RoundedRectangleBorder(
                          //           borderRadius:
                          //               BorderRadius.circular(15.0),
                          //         )),
                          //     onPressed: () {
                          //       Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //             builder: (context) =>
                          //                 InstitutionSummaryPage()),
                          //       );
                          //     },
                          //     child: Text(
                          //       '기관 요약 보고서',
                          //       style:
                          //           TextStyle(fontWeight: FontWeight.bold),
                          //     )),
                          const SizedBox(
                            width: 10,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        IndividualAnalysisPage()),
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero, // 내부 여백을 제거합니다.
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              // Column의 크기를 자식의 크기에 맞춤
                              mainAxisAlignment: MainAxisAlignment.center,
                              // 중앙 정렬
                              children: <Widget>[
                                Image.asset(
                                  'image/community (14).png',
                                  width: MediaQuery.of(context).size.width/4,
                                  height: MediaQuery.of(context).size.width/4,
                                ),
                                // 아이콘
                                Text('개별 분석 보고서',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                // 텍스트
                              ],
                            ),
                          ),

                          // TextButton.icon(
                          //     onPressed: () {
                          //       Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //             builder: (context) =>
                          //                 IndividualAnalysisPage()),
                          //       );
                          //     },
                          //     icon: Icon(Icons.account_box),
                          //     label: Text('개별 분석 보고서')),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height / 3,
                          maxHeight: double.infinity,
                        ),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("image/community (7).png"),
                            // 여기에 배경 이미지 경로를 지정합니다.
                            fit: BoxFit.fill, // 이미지가 전체 화면을 커버하도록 설정합니다.
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xff1f43f3),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          )),
                                      onPressed: () {},
                                      child: Text(
                                        '한달 간 최근 코멘트',
                                        style: buttonTextStyle,
                                      )),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xff1f43f3),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          )),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CommentViewPage()),
                                        );
                                      },
                                      child: Text(
                                        '더 보기 >>',
                                        style: buttonTextStyle,
                                      )),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Column(
                                children: _buildListCards(context),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
              tooltip: 'Create',
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage('image/ui (14).png'),
                backgroundColor: Colors.transparent,
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: bottomappbar);
  }

  List<Column> _buildListCards(BuildContext context) {
    if (_comments.isEmpty) {
      return [
        Column(
          children: [
            Text('한달 내 최신 코멘트가 없습니다', style: TextStyle(color: Colors.black)),
          ],
        ),
      ];
    }
    final ThemeData theme = Theme.of(context);

    return _comments.map((comment) {
      return Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailCommentPage(
                          user_id: comment['user_id'],
                          board_id: comment['board_id'],
                        )),
              );
            },
            child: Container(
              constraints: BoxConstraints(
                maxHeight:
                    double.infinity, // container 길이를 text에 맞게 유연하게 늘릴수 있다.
              ),
              // height: MediaQuery.of(context).size.height / 10,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("image/ui (8).png"),
                  // 여기에 배경 이미지 경로를 지정합니다.
                  fit: BoxFit.fill, // 이미지가 전체 화면을 커버하도록 설정합니다.
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(comment['title'],
                            style: buttonTextStyle),
                        Text(
                          comment['date'],
                          style: TextStyle(color: iconColor),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(comment['username'] + ' 훈련자님',
                        style: buttonTextStyle),
                  ],
                ),
              ),
            ),

            //
            // Stack(
            //   children: [
            //     Card(
            //       child: ListTile(
            //         title: Text(
            //           comment['title'],
            //           style: TextStyle(color: Colors.black),
            //         ),
            //         subtitle: Text(comment['username'] + ' 훈련자님'),
            //         trailing: Text(comment['date']),
            //         onTap: () {
            //           Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //                 builder: (context) => DetailCommentPage(
            //                       user_id: comment['user_id'],
            //                       board_id: comment['board_id'],
            //                     )),
            //           );
            //         },
            //       ),
            //     ),
            //     comment['new_conversation'] == true
            //         ? Container(
            //             alignment: Alignment.topRight,
            //             child: CircleAvatar(
            //               backgroundColor: Colors.white,
            //               backgroundImage: AssetImage('image/new_message.png'),
            //             ),
            //           )
            //         : const SizedBox(),
            //   ],
            // ),
          ),
          const SizedBox(
            height: 5,
          )
        ],
      );
    }).toList();
  }
}
