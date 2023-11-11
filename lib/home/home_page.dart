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
import 'package:aws_frame_institution/home/hompage_linechart.dart';
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

  late final bottomappbar;
  late final keyObj;
  late var appState;
  final gql = GraphQLController.Obj;

  bool loading_Manager = true;
  bool loading_comment = true;

  bool checkAttribute = false; //  to call getProtectorAttributes() once
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
      checkAttribute = true;
      var attribute = await Amplify.Auth.fetchUserAttributes();
      {
        attribute.forEach((element) {
          if (element.userAttributeKey.key == "name")
            setState(() {
              // username = element.value;
              appState.managerName = (element.value) ?? "no result";
              print(appState.managerName);
            });

          if (element.userAttributeKey.key == "phone_number")
            setState(() {
              // userphonenumber = element.value;
              appState.managerPhonenumber = (element.value) ?? " no result";
            });

          if (element.userAttributeKey.key == "email")
            setState(() {
              // useremail = element.value;
              appState.managerEmail = (element.value) ?? "no result";
              // loading = false;
            });

          if (element.userAttributeKey.key.toLowerCase() ==
              "custom:institutionNumber".toLowerCase())
            setState(() {
              // useremail = element.value;
              appState.institutionNumber = (element.value) ?? "no result";
            });
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

    if (!checkAttribute) getInstitutionAttributes();
    return (loading_Manager || loading_comment)
        ? LoadingPage()
        : Scaffold(
            drawer: GlobalDrawer.getDrawer(context, appState),
            key: keyObj.key,
            appBar: AppBar(
              title: Text(
                ' ${appState.managerName} 담당자님 안녕하세요',
                style: TextStyle(fontSize: 15),
              ),
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.logout,
                    semanticLabel: 'logout',
                  ),
                  onPressed: widget.shouldLogOut,
                ),
              ],
              automaticallyImplyLeading:
                  false, // -> important to making top drawer button not visible while keeping drawer function in scaffold
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    // GraphPage(),
                    Text('기관정보'),
                    TextButton(
                        onPressed: () {
                          gql.createUserData();
                        },
                        child: Text('유저 추가')),
                    TextButton(
                        onPressed: () {
                          gql.createAnnounceData();
                        },
                        child: Text('공지 추가')),

                    TextButton(
                        onPressed: () {
                          gql.queryAnnounceItem().then((value) {
                            print(value);
                          });
                        },
                        child: Text('값 부르기')),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => InstitutionInfoPage(
                                          initialIndex: 0,
                                        )),
                              );
                            },
                            child: Text('공지사항')),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => InstitutionInfoPage(
                                          initialIndex: 1,
                                        )),
                              );
                            },
                            child: Text('기관 소식')),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => InstitutionInfoPage(
                                          initialIndex: 2,
                                        )),
                              );
                            },
                            child: Text('시간표')),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => InstitutionInfoPage(
                                          initialIndex: 3,
                                        )),
                              );
                            },
                            child: Text('편의사항')),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('이용자 관리'),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          EssentialCareInfoPage()),
                                );
                              },
                              child: Text('필수 돌봄 정보'),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('훈련 보고서'),
                            TextButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            InstitutionSummaryPage()),
                                  );
                                },
                                icon: Icon(Icons.accessibility_new_rounded),
                                label: Text('기관 요약 보고서')),
                            const SizedBox(
                              width: 10,
                            ),
                            TextButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            IndividualAnalysisPage()),
                                  );
                                },
                                icon: Icon(Icons.account_box),
                                label: Text('개별 분석 보고서')),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CommentViewPage()),
                          );
                        },
                        child: Text('보호자 코멘트')),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: _buildListCards(context),
                      ),
                    )
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
              tooltip: 'Create',
              child: CircleAvatar(
                radius: 28,
                backgroundImage: AssetImage('image/frame.png'),
                backgroundColor: Colors.white,
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: bottomappbar);
  }

  List<StatelessWidget> _buildListCards(BuildContext context) {
    if (_comments.isEmpty) {
      return const <Card>[];
    }
    final ThemeData theme = Theme.of(context);

    var temp = _comments.map((comment) {
      return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CommentViewPage()),
          );
        },
        child: Stack(
          children: [
            Card(
              child: ListTile(
                title: Text(
                  comment['title'],
                  style: TextStyle(color: Colors.black),
                ),
                subtitle: Text(comment['username'] + ' 훈련자님'),
                trailing: Text(comment['date']),
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
              ),
            ),
            // Card(
            //   clipBehavior: Clip.antiAlias,
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: Row(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: <Widget>[
            //         Expanded(
            //           flex: 1,
            //           child: Card(
            //             child: AspectRatio(
            //               aspectRatio: 1 / 1,
            //               child: CircleAvatar(
            //                 child: Image.asset(
            //                   'image/frame.png',
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ),
            //         SizedBox(
            //           width: 8,
            //         ),
            //         Expanded(
            //           flex: 2,
            //           child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: <Widget>[
            //               Text(comment['date']),
            //               SizedBox(
            //                 height: 5,
            //               ),
            //               Text(
            //                 comment['username'] + ' 훈련자님',
            //                 style: TextStyle(
            //                     fontSize: 15, fontWeight: FontWeight.bold),
            //               ),
            //               SizedBox(
            //                 height: 5,
            //               ),
            //               Text(
            //                 comment['title'],
            //                 style: TextStyle(
            //                     fontSize: 15, fontWeight: FontWeight.bold),
            //               ),
            //               const SizedBox(height: 4.0),
            //             ],
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            comment['new_conversation'] == true
                ? Container(
                    alignment: Alignment.topRight,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage('image/new_message.png'),
                    ),
                  )
                : const SizedBox()
            // Container(
            //   alignment: Alignment.topLeft,
            //   margin: EdgeInsets.all(20),
            //   padding: EdgeInsets.all(10),
            //   decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(100),
            //       border: Border.all(width: 2, color: Colors.white)),
            //   child: Icon(
            //     Icons.add_comment,
            //     color: Colors.white,
            //   ),
            // ),
          ],
        ),
      );
    }).toList();

    return temp;
  }
}
