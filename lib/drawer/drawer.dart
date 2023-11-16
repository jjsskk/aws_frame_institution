

import 'package:aws_frame_institution/GraphQL_Method/graphql_controller.dart';
import 'package:aws_frame_institution/communication_service/comment/comment_view.dart';
// import 'package:aws_frame_institution/communication_service/comment_view.dart';
import 'package:aws_frame_institution/communication_service/communication_yard.dart';
import 'package:aws_frame_institution/communication_service/essential_care_information/essential_care_information.dart';
import 'package:aws_frame_institution/communication_service/instituition_info/institution_information.dart';
import 'package:aws_frame_institution/communication_service/user_activity.dart';
// import 'package:aws_frame_institution/communication_service/user_care_information.dart';
import 'package:aws_frame_institution/provider/login_state.dart';
import 'package:aws_frame_institution/traning%20record/analyzing_report.dart';
import 'package:aws_frame_institution/traning%20record/individual_analysis_report.dart';
import 'package:aws_frame_institution/traning%20record/institution_summary_report.dart';
// import 'package:aws_frame_institution/traning%20record/brain_signal_graph.dart';
// import 'package:aws_frame_institution/traning%20record/traning_report.dart';
import 'package:flutter/material.dart';

class GlobalDrawer {
  static Widget getDrawer(BuildContext context, LoginState appState) {
    var colorScheme = Theme.of(context).colorScheme;
    var theme = Theme.of(context);
    final gql = GraphQLController.Obj;
    return Drawer(
        child: Container(
          decoration: BoxDecoration(
            // 여기에서 원하는 이미지로 경로를 변경하세요.
            image: DecorationImage(
              image: AssetImage("image/mainmenu (4).png"),
              fit: BoxFit.cover, // 이미지가 전체를 채우도록 조정합니다.
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage('image/ui (6).png'),
                  backgroundColor: Colors.white,
                ),
                accountName: Text('이름 : ${gql.managerName}'),
                accountEmail: Text('E-mail : ${gql.managerEmail}'),
                decoration: BoxDecoration(
                    color: Colors.indigoAccent,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40.0),
                        bottomRight: Radius.circular(40.0))),
              ),

              ListTile(
                title: const Text(''),
              ),

              GestureDetector(
                onTap: () {
                  // 탭하면 훈련 보고서 페이지로 이동합니다.
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => IndividualAnalysisPage()),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(12.0), // 버튼 주위의 패딩 설정
                  decoration: BoxDecoration(
                    // 배경 이미지 추가
                    image: DecorationImage(
                      image: AssetImage("image/mainmenu (5).png"), // 버튼 배경 이미지 경로
                      fit: BoxFit.cover, // 배경 이미지가 컨테이너를 꽉 채우도록 설정
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      // 아이콘 설정
                      SizedBox(width: 10), // 아이콘과 텍스트 사이의 공간 설정
                      Text('',
                          style: TextStyle(color: Colors.white)),
                      // 텍스트 설정
                    ],
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  '      개별 분석 보고서',
                  style: TextStyle(
                      fontSize: 20, // 폰트 크기를 16으로 설정합니다.
                      color: Colors.white,
                      fontWeight: FontWeight.bold// 색상을 테마의 주 색상으로 설정합니다.
                    // 추가적인 스타일 속성을 여기에 적용할 수 있습니다.
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => IndividualAnalysisPage()),
                  );
                },
              ),
              ListTile(
                title: Text(
                  '      기관 요약 보고서',
                  style: TextStyle(
                      fontSize: 20, // 폰트 크기를 16으로 설정합니다.
                      color: Colors.white,
                      fontWeight: FontWeight.bold// 색상을 테마의 주 색상으로 설정합니다.
                    // 추가적인 스타일 속성을 여기에 적용할 수 있습니다.
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InstitutionSummaryPage()),
                  );
                },
              ),

              ListTile(
                title: const Text(''),
              ),


              GestureDetector(
                onTap: () {
                  // 탭하면 훈련 보고서 페이지로 이동합니다.
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  CommunicationYardPage()),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(12.0), // 버튼 주위의 패딩 설정
                  decoration: BoxDecoration(
                    // 배경 이미지 추가
                    image: DecorationImage(
                      image: AssetImage("image/mainmenu (6).png"), // 버튼 배경 이미지 경로
                      fit: BoxFit.cover, // 배경 이미지가 컨테이너를 꽉 채우도록 설정
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      // 아이콘 설정
                      SizedBox(width: 10), // 아이콘과 텍스트 사이의 공간 설정
                      Text('',
                          style: TextStyle(color: Colors.white)),
                      // 텍스트 설정
                    ],
                  ),
                ),
              ),

              ListTile(
                title: Text(
                  '       이용자 돌봄정보',
                  style: TextStyle(
                      fontSize: 20, // 폰트 크기를 16으로 설정합니다.
                      color: Colors.white,
                      fontWeight: FontWeight.bold// 색상을 테마의 주 색상으로 설정합니다.
                    // 추가적인 스타일 속성을 여기에 적용할 수 있습니다.
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EssentialCareInfoPage()),
                  );
                },
              ),

              // ListTile(
              //   title: Text(
              //     '       이용자 활동기록',
              //     style: TextStyle(
              //         fontSize: 20, // 폰트 크기를 16으로 설정합니다.
              //         color: Colors.white,
              //         fontWeight: FontWeight.bold// 색상을 테마의 주 색상으로 설정합니다.
              //       // 추가적인 스타일 속성을 여기에 적용할 수 있습니다.
              //     ),
              //   ),
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (context) => UserActivityPage()),
              //     );
              //   },
              // ),


              ListTile(
                title: Text(
                  '       코멘트 모아보기',
                  style: TextStyle(
                      fontSize: 20, // 폰트 크기를 16으로 설정합니다.
                      color: Colors.white,
                      fontWeight: FontWeight.bold// 색상을 테마의 주 색상으로 설정합니다.
                    // 추가적인 스타일 속성을 여기에 적용할 수 있습니다.
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CommentViewPage()),
                  );
                },
              ),

              ListTile(
                title: Text(
                  '       기관정보',
                  style: TextStyle(
                      fontSize: 20, // 폰트 크기를 16으로 설정합니다.
                      color: Colors.white,
                      fontWeight: FontWeight.bold// 색상을 테마의 주 색상으로 설정합니다.
                    // 추가적인 스타일 속성을 여기에 적용할 수 있습니다.
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InstitutionInfoPage(initialIndex: 0,)),
                  );
                },
              ),
              // ListTile(
              //   leading: IconButton(
              //     icon: const Icon(Icons.person, semanticLabel: 'home'),
              //     color: theme.colorScheme.primary,
              //     onPressed: widget.didtogglegallery,
              //   ),
              //   title: const Text('profile'),
              //   onTap: widget.didtogglegallery,
              //   trailing: Icon(Icons.add),
              // ),
            ],
          ),
        ));
  }
}

// import 'package:aws_frame_institution/GraphQL_Method/graphql_controller.dart';
// import 'package:aws_frame_institution/communication_service/comment/comment_view.dart';
// import 'package:aws_frame_institution/communication_service/communication_yard.dart';
// import 'package:aws_frame_institution/communication_service/instituition_info/institution_information.dart';
// import 'package:aws_frame_institution/communication_service/user_activity.dart';
// import 'package:aws_frame_institution/communication_service/essential_care_information/essential_care_information.dart';
// import 'package:aws_frame_institution/provider/login_state.dart';
// import 'package:aws_frame_institution/traning%20record/analyzing_report.dart';
// import 'package:flutter/material.dart';
//
// class GlobalDrawer {
//   static Widget getDrawer(BuildContext context, LoginState appState) {
//     var colorScheme = Theme.of(context).colorScheme;
//     final gql =GraphQLController.Obj;
//     var theme = Theme.of(context);
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           UserAccountsDrawerHeader(
//             currentAccountPicture: CircleAvatar(
//               backgroundImage: AssetImage('image/frame.png'),
//               backgroundColor: Colors.white,
//             ),
//             accountName: Text('이름 : ${gql.managerName}'),
//             accountEmail: Text('E-mail : ${gql.managerEmail}'),
//             decoration: BoxDecoration(
//                 color: Colors.deepPurpleAccent,
//                 borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(40.0),
//                     bottomRight: Radius.circular(40.0))),
//           ),
//           ListTile(
//             leading: Icon(Icons.logout),
//             title: const Text('로그아웃'),
//             onTap: appState.authService.logOut,
//           ),
//           // ListTile(
//           //   leading: Icon(Icons.logout),
//           //   title: const Text('훈련 보고서'),
//           //   onTap: (){
//           //     Navigator.push(
//           //       context,
//           //       MaterialPageRoute(
//           //           builder: (context) =>
//           //               TraningReportPage()),
//           //     );
//           //   },
//           // ),
//           // ListTile(
//           //   leading: Icon(Icons.logout),
//           //   title: const Text('     분석 보고서'),
//           //   onTap: (){
//           //     Navigator.push(
//           //       context,
//           //       MaterialPageRoute(
//           //           builder: (context) =>
//           //               AnalyzingReportPage()),
//           //     );
//           //   },
//           // ),
//           // ListTile(
//           //   leading: Icon(Icons.logout),
//           //   title: const Text('     뇌신호 그래프'),
//           //   onTap: (){
//           //     Navigator.push(
//           //       context,
//           //       MaterialPageRoute(
//           //           builder: (context) =>
//           //               BrainSignalPage()),
//           //     );
//           //   },
//           // ),
//           // ListTile(
//           //   leading: Icon(Icons.logout),
//           //   title: const Text('소통마당'),
//           //   onTap: (){
//           //     Navigator.push(
//           //       context,
//           //       MaterialPageRoute(
//           //           builder: (context) =>
//           //               CommunicationYardPage()),
//           //     );
//           //   },
//           // ),
//           // ListTile(
//           //   leading: Icon(Icons.logout),
//           //   title: const Text('     이용자 돌봄정보'),
//           //   onTap: (){
//           //     Navigator.push(
//           //       context,
//           //       MaterialPageRoute(
//           //           builder: (context) =>
//           //               EssentialCareInfoPage()),
//           //     );
//           //   },
//           // ),
//           // ListTile(
//           //   leading: Icon(Icons.logout),
//           //   title: const Text('     이용자 활동기록'),
//           //   onTap: (){
//           //     Navigator.push(
//           //       context,
//           //       MaterialPageRoute(
//           //           builder: (context) =>
//           //               UserActivityPage()),
//           //     );
//           //   },
//           // ),
//           // ListTile(
//           //   leading: Icon(Icons.logout),
//           //   title: const Text('     코멘트 모아보기'),
//           //   onTap: (){
//           //     Navigator.push(
//           //       context,
//           //       MaterialPageRoute(
//           //           builder: (context) =>
//           //              CommentViewPage()),
//           //     );
//           //   },
//           // ),
//           // ListTile(
//           //   leading: Icon(Icons.logout),
//           //   title: const Text('     기관정보'),
//           //   onTap: (){
//           //     Navigator.push(
//           //       context,
//           //       MaterialPageRoute(
//           //           builder: (context) =>
//           //               InstitutionInfoPage(initialIndex: 0,)),
//           //     );
//           //   },
//           // ),
//           // ListTile(
//           //   leading: IconButton(
//           //     icon: const Icon(Icons.person, semanticLabel: 'home'),
//           //     color: theme.colorScheme.primary,
//           //     onPressed: widget.didtogglegallery,
//           //   ),
//           //   title: const Text('profile'),
//           //   onTap: widget.didtogglegallery,
//           //   trailing: Icon(Icons.add),
//           // ),
//         ],
//       ),
//     );
//   }
// }
