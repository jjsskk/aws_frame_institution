import 'package:aws_frame_institution/communication_service/instituition_info/schedule/schedule.dart';
import 'package:flutter/material.dart';

import '../../GraphQL_Method/graphql_controller.dart';
import '../../models/InstitutionAnnouncementTable.dart';
import 'announcement/AddAnnouncement.dart';
import 'institution_news/AddInstitutionNews.dart';
import 'convenience/Convenience.dart';
import 'announcement/announcement.dart';
import 'institution_news/institution_news.dart';

class InstitutionInfoPage extends StatefulWidget {
  InstitutionInfoPage({Key? key, required this.initialIndex}) : super(key: key);
  final int initialIndex;

  @override
  _InstitutionInfoPageState createState() => _InstitutionInfoPageState();
}

class _InstitutionInfoPageState extends State<InstitutionInfoPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final gql = GraphQLController.Obj;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        initialIndex: widget.initialIndex, length: 4, vsync: this);
    _tabController.addListener(_handleTabIndex);
  }
  TabBar get _tabBar => TabBar(
    controller: _tabController,
    indicatorColor: Color(0xFF1F2EAE),  // 밑줄 색상 변경
    labelColor: Color(0xFF1F2EAE), // 선택된 탭의 글자색 변경
    unselectedLabelColor: Colors.grey,  // 선택되지 않은 탭의 글자색 변경
    labelStyle: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),  // 선택된 탭의 글자크기 변경
    unselectedLabelStyle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),  // 선택되지 않은 탭의 글자크기 변경
    tabs: [
      Tab(text: '공지사항',),
      Tab(text: '기관소식',),
      Tab(text: '시간표'),
      Tab(text: '편의사항'),
    ],
  );

  @override
  void dispose() {
    if (_tabController.indexIsChanging) {
      _tabController.removeListener(_handleTabIndex);
    }
    _tabController.dispose();
    super.dispose();
  }


  void _handleTabIndex() {
    setState(() {});
  }

  void _onCreateIconPressed(BuildContext context) {
    if (_tabController.index == 0) {
      Navigator.push<bool>(
        context,
        MaterialPageRoute(builder: (context) => AddAnnouncementPage()),
      ).then((value) {
        if (value == true) {
          setState(() {
            // 공지사항이 성공적으로 추가되었다면 상태 업데이트(다시 데이터 로딩)
            AnnouncementPage();
            print("oooo");
          });
        }
      });
    } else if (_tabController.index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddInstitutionNewsPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var appBarHeight = AppBar().preferredSize.height;  // AppBar의 높이를 구함
    var theme = Theme.of(context);
    return  Scaffold(
        appBar: AppBar(
          leading:IconButton(
            icon: Icon(Icons.arrow_circle_left_outlined, color: Colors.white, size: 35),
        onPressed: (){
          Navigator.pop(context);
        },
      ),
          elevation: 0.0,
          flexibleSpace: Container(
            height: MediaQuery.of(context).padding.top + kToolbarHeight,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('image/ui (5).png'), // 여기에 원하는 이미지 경로를 써주세요.
                fit: BoxFit.cover, // 이미지가 AppBar를 꽉 채우도록 설정
              ),
            ),
          ),
          title: Text('기관 정보',style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
          centerTitle: true,
          actions: _tabController.index < 2 // 수정된 부분
              ? [
                  IconButton(
                    icon: Icon(Icons.create, color: Colors.white, size: 25,),
                    onPressed: () {
                      _onCreateIconPressed(context);
                    },
                  ),
                ]
              : [
                ],
          bottom:PreferredSize(
            preferredSize: Size.fromHeight(50.0),
            child: Material(
                color: Colors.white, // TabBar의 배경을 반투명하게 설정
                child:_tabBar
            ),
          ),
        ),
        body: Stack(  // Stack 위젯으로 배경 이미지 추가
          children: [
            Container(
              height: appBarHeight,  // 이미지의 높이를 AppBar의 높이로 설정
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('image/community (7).png'),  // 배경 이미지 파일 경로
                  fit: BoxFit.cover,  // 이미지를 화면에 꽉 차게 표시
                ),
              ),
            ),
             TabBarView(
              controller: _tabController,
                children: [
              AnnouncementPage(),
              InstitutionNewsPage(),
              SchedulePage(),
              ConveniencePage()
            ]),
          ],
        ),
      );

  }
}
