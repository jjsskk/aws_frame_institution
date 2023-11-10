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
    if(mounted) { // 해당 State 객체가 현재 트리에 마운트되어 있는지 확인
      setState(() {
        _news = gql.queryInstitutionNewsByInstitutionId(institutionId: "INST_ID_123");
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
    _news = gql.queryInstitutionNewsByInstitutionId(institutionId: "INST_ID_123");
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

      body: FutureBuilder<List<InstitutionNewsTable>>(
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
                return Card(
                  child: ListTile(
                    title: Text(news.TITLE!,
                      style: TextStyle(color: Colors.black),
                    ),
                    subtitle: Text(getYearMonthDay(news.createdAt.toString())),
                    onTap: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InstitutionNewsDetailPage(news: news, storageService: storageService),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }

          return Center(child: Text('공지사항이 없습니다.'));
        },
      ),
    );
  }
}

class InstitutionNewsDetailPage extends StatelessWidget {
  final InstitutionNewsTable news;
  final StorageService storageService;
  final gql = GraphQLController.Obj;

  String getYearMonthDay(String dateString) {
    return dateString.substring(0, 10);
  }
  InstitutionNewsDetailPage({Key? key, required this.news, required this.storageService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('기관소식 세부 정보'),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => updateInstitutionNewsPage(news: news, storageService: storageService),
              ),
            );
          }, icon: Icon(Icons.create)),
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
                  var result = gql.deleteInstitutionNews(institutionId: news.INSTITUTION_ID!, newsId: news.NEWS_ID!);

                  if (result != null) {
                    Provider.of<LoginState>(context, listen:false).newsUpdate();

                    ScaffoldMessenger.of(context).showSnackBar(  // SnackBar 표시
                      SnackBar(content: Text('기관소식이 삭제되었습니다.')),
                    );

                    Navigator.pop(context);
                  }
                }
              },
              icon: Icon(Icons.delete)
          )

        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(news.TITLE!, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              Text('작성일: ' + getYearMonthDay(news.createdAt.toString())),
              SizedBox(height: 16),
              news.CONTENT != null ? Text(news.CONTENT!) : Text(""),
              SizedBox(height: 16),
              news.URL != null ? Text(news.CONTENT!) : Text(""),
              SizedBox(height: 16),
              if(news.IMAGE !=null)
              if (news.IMAGE!.isNotEmpty)
                FutureBuilder<String>(
                  future: storageService.getImageUrlFromS3(news.IMAGE!),
                  builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.hasData) {
                      String imageUrl = snapshot.data!;
                      return Image.network(imageUrl);
                    } else if (snapshot.hasError) {
                      return Text('이미지를 불러올 수 없습니다.');
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
