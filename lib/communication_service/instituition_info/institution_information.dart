import 'package:aws_frame_institution/communication_service/instituition_info/Convenience.dart';
import 'package:aws_frame_institution/communication_service/instituition_info/announcement.dart';
import 'package:aws_frame_institution/communication_service/instituition_info/institution_news.dart';
import 'package:aws_frame_institution/communication_service/instituition_info/schedule.dart';
import 'package:flutter/material.dart';

class InstitutionInfoPage extends StatelessWidget {
  InstitutionInfoPage({Key? key,required this.initialIndex}) : super(key: key);
  late TabController _tabController;

  int initialIndex;

  TabBar get _tabBar => TabBar(
    tabs: [
      Tab(text: '공지사항',),
      Tab(text: '기관소식',),
      Tab(text: '시간표'),
      Tab(text: '편의사항'),
    ],

  );
  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var theme = Theme.of(context);
    return DefaultTabController(
      initialIndex: initialIndex,
      length: 4,
      child: Scaffold(
          appBar: AppBar(
            title: Text('기관 정보'),
            centerTitle: true,
            bottom:PreferredSize(
              preferredSize: _tabBar.preferredSize,
              child: Material(
                color: Colors.blueAccent, //<-- SEE HERE
                child:_tabBar

              ),
            ),

          ),
          body: const TabBarView(children: [
            AnnouncementPage(),
            InstitutionNewsPage(),
            SchedulePage(),
            ConveniencePage()

          ])),
    );
  }
}
