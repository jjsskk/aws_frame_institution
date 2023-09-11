import 'package:aws_frame_institution/communication_service/comment/comment_view.dart';
import 'package:aws_frame_institution/communication_service/communication_yard.dart';
import 'package:aws_frame_institution/communication_service/instituition_info/institution_information.dart';
import 'package:aws_frame_institution/communication_service/user_activity.dart';
import 'package:aws_frame_institution/communication_service/essential_care_information.dart';
import 'package:aws_frame_institution/provider/login_state.dart';
import 'package:aws_frame_institution/traning%20record/analyzing_report.dart';
import 'package:flutter/material.dart';

class GlobalDrawer {
  static Widget getDrawer(BuildContext context, LoginState appState) {
    var colorScheme = Theme.of(context).colorScheme;
    var theme = Theme.of(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('image/frame.png'),
              backgroundColor: Colors.white,
            ),
            accountName: Text('이름 : ${appState.managerName}'),
            accountEmail: Text('E-mail : ${appState.managerEmail}'),
            decoration: BoxDecoration(
                color: Colors.deepPurpleAccent,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40.0),
                    bottomRight: Radius.circular(40.0))),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: const Text('로그아웃'),
            onTap: appState.authService.logOut,
          ),
          // ListTile(
          //   leading: Icon(Icons.logout),
          //   title: const Text('훈련 보고서'),
          //   onTap: (){
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //           builder: (context) =>
          //               TraningReportPage()),
          //     );
          //   },
          // ),
          // ListTile(
          //   leading: Icon(Icons.logout),
          //   title: const Text('     분석 보고서'),
          //   onTap: (){
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //           builder: (context) =>
          //               AnalyzingReportPage()),
          //     );
          //   },
          // ),
          // ListTile(
          //   leading: Icon(Icons.logout),
          //   title: const Text('     뇌신호 그래프'),
          //   onTap: (){
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //           builder: (context) =>
          //               BrainSignalPage()),
          //     );
          //   },
          // ),
          // ListTile(
          //   leading: Icon(Icons.logout),
          //   title: const Text('소통마당'),
          //   onTap: (){
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //           builder: (context) =>
          //               CommunicationYardPage()),
          //     );
          //   },
          // ),
          // ListTile(
          //   leading: Icon(Icons.logout),
          //   title: const Text('     이용자 돌봄정보'),
          //   onTap: (){
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //           builder: (context) =>
          //               EssentialCareInfoPage()),
          //     );
          //   },
          // ),
          // ListTile(
          //   leading: Icon(Icons.logout),
          //   title: const Text('     이용자 활동기록'),
          //   onTap: (){
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //           builder: (context) =>
          //               UserActivityPage()),
          //     );
          //   },
          // ),
          // ListTile(
          //   leading: Icon(Icons.logout),
          //   title: const Text('     코멘트 모아보기'),
          //   onTap: (){
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //           builder: (context) =>
          //              CommentViewPage()),
          //     );
          //   },
          // ),
          // ListTile(
          //   leading: Icon(Icons.logout),
          //   title: const Text('     기관정보'),
          //   onTap: (){
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //           builder: (context) =>
          //               InstitutionInfoPage(initialIndex: 0,)),
          //     );
          //   },
          // ),
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
    );
  }
}
