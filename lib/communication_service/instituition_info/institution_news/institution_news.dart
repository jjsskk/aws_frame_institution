import 'package:aws_frame_institution/communication_service/instituition_info/institution_news/updateInstitutionNews.dart';
import 'package:aws_frame_institution/models/InstitutionNewsTable.dart';
import 'package:flutter/material.dart';

import '../../../GraphQL_Method/graphql_controller.dart';
import '../../../models/InstitutionAnnouncementTable.dart';
import '../../../provider/login_state.dart';
import '../../../storage/storage_service.dart';
import 'package:provider/provider.dart';

class InstitutionNewsPage extends StatefulWidget {
  const InstitutionNewsPage({Key? key}) : super(key: key);

  @override
  _InstitutionNewsPageState createState() => _InstitutionNewsPageState();
}

class _InstitutionNewsPageState extends State<InstitutionNewsPage> {
  late Future<List<InstitutionNewsTable>> _news;
  final gql = GraphQLController.Obj;
  final storageService = StorageService();
  late LoginState newsProvider;

  void refresh() {
    if (mounted) {
      // 해당 State 객체가 현재 트리에 마운트되어 있는지 확인
      setState(() {
        _news = gql.queryInstitutionNewsByInstitutionId(
            institutionId: "INST_ID_123");
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    // Remove the listener when the widget is disposed.
    newsProvider.removeListener(refresh);
  }

  @override
  void initState() {
    super.initState();
    _news =
        gql.queryInstitutionNewsByInstitutionId(institutionId: "INST_ID_123");
    // Provider 구독 설정
    newsProvider = Provider.of<LoginState>(context, listen: false);

    // isUpdated 값 변경 감지 -> 데이터 새로 불러오기
    newsProvider.addListener(refresh);
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
        child: FutureBuilder<List<InstitutionNewsTable>>(
          future: _news,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final news = snapshot.data![index];
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
                                builder: (context) => InstitutionNewsDetailPage(
                                    news: news, storageService: storageService),
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
                                        news.createdAt.toString()),
                                    style: TextStyle(
                                        color: Colors.black,
                                        backgroundColor: Colors.transparent,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                    news.TITLE!,
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

            return Center(child: Text('기관소식이 없습니다.'));
          },
        ),
      ),
    );
  }
}

class InstitutionNewsDetailPage extends StatefulWidget {
  final InstitutionNewsTable news;
  final StorageService storageService;
  InstitutionNewsDetailPage(
      {Key? key, required this.news, required this.storageService})
      : super(key: key);

  @override
  State<InstitutionNewsDetailPage> createState() => _InstitutionNewsDetailPageState();
}

class _InstitutionNewsDetailPageState extends State<InstitutionNewsDetailPage> {
  final gql = GraphQLController.Obj;
  late InstitutionNewsTable news;
  String title = '', content  = '', url = '', image = '';

  String getYearMonthDay(String dateString) {
    return dateString.substring(0, 10);
  }
  @override
  void initState() {
    // TODO: implement initState

    title = widget.news.TITLE!;
    widget.news.CONTENT  != null ? content = widget.news.CONTENT!: content = '';
    widget.news.URL!=null ?url = widget.news.URL!:url = '';
    widget.news.IMAGE!=null?image = widget.news.IMAGE!: image = '';
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
          '기관소식 세부 정보',
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
                    builder: (context) => updateInstitutionNewsPage(
                        news: widget.news, storageService: widget.storageService),
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
              icon: Icon(Icons.create, color: Colors.white,size: 25)),
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
                          onPressed: () => Navigator.of(context)
                              .pop(true), // '예' 버튼을 누르면 true 반환
                        ),
                        TextButton(
                          child: Text('아니오'),
                          onPressed: () => Navigator.of(context)
                              .pop(false), // '아니오' 버튼을 누르면 false 반환
                        ),
                      ],
                    );
                  },
                );

                if (shouldDelete == true) {
                  // '예' 버튼을 눌렀다면...
                  var result = gql.deleteInstitutionNews(
                      institutionId: news.INSTITUTION_ID!,
                      newsId: news.NEWS_ID!);

                  if (result != null) {
                    Provider.of<LoginState>(context, listen: false)
                        .newsUpdate();

                    ScaffoldMessenger.of(context).showSnackBar(
                      // SnackBar 표시
                      SnackBar(content: Text('기관소식이 삭제되었습니다.')),
                    );

                    Navigator.pop(context);
                  }
                }
              },
              icon: Icon(Icons.delete, color: Colors.white,size: 25,))
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
                    getYearMonthDay(widget.news.createdAt.toString())),
                SizedBox(height: 8),
                Divider(),
                SizedBox(height: 8),
                content != null ? Text(content) : Text(""),
                SizedBox(height: 16),
                url != null ? Text(url) : Text(""),
                SizedBox(height: 16),
                if (image != null)
                  if (image!.isNotEmpty)
                    FutureBuilder<String>(
                      future: widget.storageService.getImageUrlFromS3(image!),
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
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ),


              ],
            ),
          ),
        ),
      ),
    );
  }
}
