import 'package:flutter/material.dart';

import '../../../GraphQL_Method/graphql_controller.dart';
import '../../../models/InstitutionAnnouncementTable.dart';
import '../../../storage/storage_service.dart';

class AnnouncementPage extends StatefulWidget {
  const AnnouncementPage({Key? key}) : super(key: key);

  @override
  _AnnouncementPageState createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {
  late Future<List<InstitutionAnnouncementTable>> _announcements;
  final gql = GraphQLController.Obj;
  final storageService = StorageService();

  @override
  void initState() {
    super.initState();
    _announcements = gql.queryInstitutionAnnouncementsByInstitutionId("INST_ID_123");
  }

  String getYearMonthDay(String dateString) {
    return dateString.substring(0, 10);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: FutureBuilder<List<InstitutionAnnouncementTable>>(
        future: _announcements,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final announcement = snapshot.data![index];
                return Card(
                  child: ListTile(
                    title: Text(announcement.TITLE!,
                      style: TextStyle(color: Colors.black),
                    ),
                    subtitle: Text(getYearMonthDay(announcement.createdAt.toString())),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AnnouncementDetailPage(announcement: announcement, storageService: storageService),
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

class AnnouncementDetailPage extends StatelessWidget {
  final InstitutionAnnouncementTable announcement;
  final StorageService storageService;
  String getYearMonthDay(String dateString) {
    return dateString.substring(0, 10);
  }
  AnnouncementDetailPage({Key? key, required this.announcement, required this.storageService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('공지사항 세부 정보'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(announcement.TITLE!, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              Text('작성일: ' + getYearMonthDay(announcement.createdAt.toString())),
              SizedBox(height: 16),
              Text(announcement.CONTENT!),
              SizedBox(height: 16),
              Text(announcement.URL!),
              SizedBox(height: 16),
              if (announcement.IMAGE!.isNotEmpty)
                FutureBuilder<String>(
                  future: storageService.getImageUrlFromS3(announcement.IMAGE!),
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
