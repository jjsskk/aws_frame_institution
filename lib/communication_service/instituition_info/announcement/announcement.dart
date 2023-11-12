import 'package:aws_frame_institution/communication_service/instituition_info/announcement/updateAnnouncement.dart';
import 'package:aws_frame_institution/loading_page/loading_page.dart';
import 'package:flutter/material.dart';

import '../../../GraphQL_Method/graphql_controller.dart';
import '../../../models/InstitutionAnnouncementTable.dart';
import '../../../provider/login_state.dart';
import '../../../storage/storage_service.dart';
import 'package:provider/provider.dart';

class AnnouncementPage extends StatefulWidget {
  const AnnouncementPage({Key? key}) : super(key: key);

  @override
  _AnnouncementPageState createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {
  late Future<List<InstitutionAnnouncementTable>> _announcements;
  final gql = GraphQLController.Obj;
  final storageService = StorageService();
  late LoginState announcementProvider;

  Future<List<InstitutionAnnouncementTable>> getAnnouncements(
      String institutionId) {
    return gql.queryInstitutionAnnouncementsByInstitutionId(
        institutionId: institutionId);
  }

  void refresh() {
    if (mounted) {
      // 해당 State 객체가 현재 트리에 마운트되어 있는지 확인
      setState(() {
        _announcements = getAnnouncements("INST_ID_123");
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    // Remove the listener when the widget is disposed.
    announcementProvider.removeListener(refresh);
  }

  @override
  void initState() {
    super.initState();

    // 초기 데이터 로딩
    _announcements = getAnnouncements("INST_ID_123");

    // Provider 구독 설정
    announcementProvider = Provider.of<LoginState>(context, listen: false);

    // isUpdated 값 변경 감지 -> 데이터 새로 불러오기
    announcementProvider.addListener(refresh);
  }

  String getYearMonthDay(String dateString) {
    return dateString.substring(0, 10);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('image/ui (4).png'),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder<List<InstitutionAnnouncementTable>>(
          future: _announcements,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingPage();
            }

            if (snapshot.hasData) {
              snapshot.data!
                  .sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final announcement = snapshot.data![index];
                  return Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 350,
                      child: AspectRatio(
                        aspectRatio: 1232 / 392,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AnnouncementDetailPage(
                                    announcement: announcement,
                                    storageService: storageService),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('image/community (7).png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    getYearMonthDay(
                                        announcement.createdAt.toString()),
                                    style: TextStyle(
                                        color: Colors.black,
                                        backgroundColor: Colors.transparent,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                    announcement.TITLE!,
                                    style: TextStyle(
                                        color: Colors.black,
                                        backgroundColor: Colors.transparent,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }

            return Center(child: Text('공지사항이 없습니다.'));
          },
        ),
      ),
    );
  }
}



class AnnouncementDetailPage extends StatefulWidget {
  final InstitutionAnnouncementTable announcement;
  final StorageService storageService;

  AnnouncementDetailPage(
      {Key? key, required this.announcement, required this.storageService})
      : super(key: key);

  @override
  State<AnnouncementDetailPage> createState() => _AnnouncementDetailPageState();
}

class _AnnouncementDetailPageState extends State<AnnouncementDetailPage> {
  final gql = GraphQLController.Obj;

  String title = '', content = '', url = '', image = 'loading';

  String getYearMonthDay(String dateString) {
    return dateString.substring(0, 10);
  }

  bool isUpdated = false;

  @override
  void initState() {
    title = widget.announcement.TITLE!;
    widget.announcement.CONTENT != null
        ? content = widget.announcement.CONTENT!
        : content = '';
    widget.announcement.URL != null ? url = widget.announcement.URL! : url = '';
    widget.announcement.IMAGE != null
        ? image = widget.announcement.IMAGE!
        : image = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_circle_left_outlined,
              color: Colors.white, size: 35),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          '공지사항 세부 정보',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('image/ui (5).png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => updateAnnouncementPage(
                        announcement: widget.announcement,
                        storageService: widget.storageService),
                  ),
                );

                if (result != null) {
                  setState(() {
                    title = result['title'];
                    result['content'] != null? content = result['content'] : content ='';
                    result['url']!= null? url = result['url']: url = '';
                    result['image'] != null? image = result['image']:image = '';
                  });
                }

              },
              icon: Icon(Icons.create,color: Colors.white, size: 25,)),
          IconButton(
              onPressed: () async {
                // showDialog 함수를 사용하여 다이얼로그 표시
                bool? shouldDelete = await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('삭제 확인'),
                      content: Text('정말로 삭제하시겠습니까?'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('예'),
                          onPressed: () => Navigator.of(context).pop(true),  // '예' 버튼을 누르면 true 반환
                        ),
                        TextButton(
                          child: Text('아니오'),
                          onPressed: () => Navigator.of(context).pop(false),  // '아니오' 버튼을 누르면 false 반환
                        ),
                      ],
                    );
                  },
                );

                if (shouldDelete == true) {  // '예' 버튼을 눌렀다면...
                  var result = gql.deleteAnnouncement(institution_id: widget.announcement.INSTITUTION_ID!, announcementId:
                  widget.announcement.ANNOUNCEMENT_ID!);

                  if (result != null) {
                    Provider.of<LoginState>(context, listen:false).announceUpdate();

                    ScaffoldMessenger.of(context).showSnackBar(  // SnackBar 표시
                      SnackBar(content: Text('공지사항이 삭제되었습니다.')),
                    );

                    Navigator.pop(context);
                  }
                }
              },
              icon: Icon(Icons.delete, color: Colors.white, size: 25,)
          )

        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('image/ui (4).png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style:
                    TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('작성일: ' +
                    getYearMonthDay(widget.announcement.createdAt.toString())),
                SizedBox(height: 8),
                Divider(),
                SizedBox(height: 8),
                content != null ? Text(content) : Text(""),
                SizedBox(height: 16),
                url != null ? Text(url) : Text(""),
                SizedBox(height: 16),

                image != 'loading'
                    ? image != ''
                    ? FutureBuilder<String>(
                    future: widget.storageService
                        .getImageUrlFromS3(image),
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
                      return Center(child: Text(''));
                    })
                    : Center(child: Text(''))
                    : Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

