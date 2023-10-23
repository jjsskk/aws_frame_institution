import 'package:aws_frame_institution/communication_service/instituition_info/schedule/AddSchedule.dart';
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

  @override
  void dispose() {
    _tabController.removeListener(_handleTabIndex);
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
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('기관 정보'),
        centerTitle: true,
        actions: _tabController.index < 2 // 수정된 부분
            ? [
                IconButton(
                  icon: Icon(Icons.create),
                  onPressed: () {
                    _onCreateIconPressed(context);
                  },
                ),
              ]
            : [
                _tabController.index == 2
                    ? IconButton(
                        icon: Icon(Icons.add_box_rounded),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AddSchedulePage()),
                          );
                        },
                      )
                    : SizedBox()
              ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              text: '공지사항',
            ),
            Tab(
              text: '기관소식',
            ),
            Tab(
              text: '시간표',
            ),
            Tab(
              text: '편의사항',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          AnnouncementPage(),
          InstitutionNewsPage(),
          SchedulePage(),
          ConveniencePage(),
        ],
      ),
    );
  }
}
