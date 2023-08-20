import 'package:aws_frame_institution/GraphQL_Method/graphql_controller.dart';
import 'package:aws_frame_institution/backey/backKey_dialog.dart';
import 'package:aws_frame_institution/bottomappbar/bottom_appbar.dart';
import 'package:aws_frame_institution/camera_gallary/graph_page.dart';
import 'package:aws_frame_institution/communication_service/communication_yard.dart';
import 'package:aws_frame_institution/communication_service/essential_care_information.dart';
import 'package:aws_frame_institution/communication_service/instituition_info/institution_information.dart';
import 'package:aws_frame_institution/drawer/drawer.dart';
import 'package:aws_frame_institution/bottomappbar/globalkey.dart';
import 'package:aws_frame_institution/home/hompage_linechart.dart';
import 'package:aws_frame_institution/loading_page/loading_page.dart';
import 'package:aws_frame_institution/login_session.dart';
import 'package:aws_frame_institution/provider/login_state.dart';
import 'package:aws_frame_institution/traning%20record/individual_analysis_report.dart';
import 'package:aws_frame_institution/traning%20record/institution_summary_report.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

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

  bool checkAttribute = false; //  to call getProtectorAttributes() once

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(backKeyInterceptor,
        context: context); // for back key
    keyObj = KeyForBottomAppbar();
    bottomappbar = GlobalBottomAppBar(keyObj: keyObj);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(backKeyInterceptor);
    super.dispose();
  }

  void getProtectorAttributes() async {
    try {
      checkAttribute = true;
      var attribute = await Amplify.Auth.fetchUserAttributes();
      {
        attribute.forEach((element) {
          if (element.userAttributeKey.key == "name")
            setState(() {
              // username = element.value;
              appState.managerName = (element.value) ?? "no result";
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

    if (!checkAttribute) getProtectorAttributes();

    return (loading_Manager)
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
                    TextButton(onPressed: (){
                      gql.createUserData();
                    }, child: Text('유저 추가')),
                    TextButton(onPressed: (){
                      gql.createAnnounceData();
                    }, child: Text('공지 추가')),

                    TextButton(onPressed: (){
                      gql.queryAnnounceItem().then((value){
                        print(value);
                      });
                    }, child: Text('값 부르기')),
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
                    Text('보호자 코멘트'),
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
}
