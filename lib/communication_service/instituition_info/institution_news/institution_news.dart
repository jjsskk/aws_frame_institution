import 'package:aws_frame_institution/models/InstitutionNewsTable.dart';
import 'package:flutter/material.dart';

import '../../../GraphQL_Method/graphql_controller.dart';
import '../../../models/InstitutionAnnouncementTable.dart';
import '../../../storage/storage_service.dart';

class InstitutionNewsPage extends StatefulWidget {
  const InstitutionNewsPage({Key? key}) : super(key: key);

  @override
  _InstitutionNewsPageState createState() => _InstitutionNewsPageState();
}

class _InstitutionNewsPageState extends State<InstitutionNewsPage> {
  late Future<List<InstitutionNewsTable>> news;
  final gql = GraphQLController.Obj;
  final storageService = StorageService();

  @override
  void initState() {
    super.initState();
    news = gql.queryInstitutionNewsByInstitutionId("INST_ID_123");
  }

  String getYearMonthDay(String dateString) {
    return dateString.substring(0, 10);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: FutureBuilder<List<InstitutionNewsTable>>(
        future: news,
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
  String getYearMonthDay(String dateString) {
    return dateString.substring(0, 10);
  }
  InstitutionNewsDetailPage({Key? key, required this.news, required this.storageService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('기관소식 세부 정보'),
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
              Text(news.CONTENT!),
              SizedBox(height: 16),
              Text(news.URL!),
              SizedBox(height: 16),
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
