import 'package:flutter/cupertino.dart';

import '../../../GraphQL_Method/graphql_controller.dart';
import '../../../models/InstitutionAnnouncementTable.dart';
import '../../../models/InstitutionNewsTable.dart';

class AnnouncementModel extends ChangeNotifier {
  List<InstitutionAnnouncementTable> _announcements = [];
  final gql = GraphQLController.Obj;

  Future<List<InstitutionAnnouncementTable>> getAnnouncements(String institutionId){

    return gql.queryInstitutionAnnouncementsByInstitutionId(institutionId:institutionId );
  }

  Future<void> refresh() async {
    _announcements = await getAnnouncements("INST_ID_123");
    notifyListeners();
  }

  List<InstitutionAnnouncementTable> get announcements => _announcements;
}

class InstitutionNewsModel extends ChangeNotifier {
  List<InstitutionNewsTable> _news = [];
  final gql = GraphQLController.Obj;

  Future<List<InstitutionNewsTable>> getNews(String institutionId){

    return gql.queryInstitutionNewsByInstitutionId(institutionId: gql.institutionNumber);
  }

  Future<void> refresh() async {
    _news = await getNews(gql.institutionNumber);
    notifyListeners();
  }

  List<InstitutionNewsTable> get news => _news;
}
