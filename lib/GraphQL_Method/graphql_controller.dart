import 'dart:convert';

import 'package:amplify_core/amplify_core.dart';
import 'package:aws_frame_institution/models/InstitutionAnnouncementTable.dart';
import 'package:aws_frame_institution/models/ModelProvider.dart';
import 'package:flutter/material.dart';

//needed when using queryItem method
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'dart:math';
import 'package:ntp/ntp.dart';

class GraphQLController {
  static final _Obj = GraphQLController._internal();

  static get Obj => _Obj;

  factory GraphQLController() {
    return _Obj;
  }

  // It'll be called exactly once, by the static property assignment above
  // it's also private, so it can only be called in this clas
  GraphQLController._internal();

  // institution's attribute info
  String _managerEmail = '';
  String _managerName = '';
  String _managerPhonenumber = '';
  String _institutionNumber = '';

  //user
  var birth = 19640101;
  var userid = "1";
  var useridint = 2;

  //brain signal
  var brainmonth = "20230101";

  void resetVariables() {
    print("provider!!!");
    // institution's attribute info
    _managerEmail = '';
    _managerName = '';
    _managerPhonenumber = '';
    _institutionNumber = '';
  }

  String get managerEmail => _managerEmail;

  String get managerName => _managerName;

  String get managerPhonenumber => _managerPhonenumber;

  String get institutionNumber => _institutionNumber;

  set managerEmail(String value) {
    _managerEmail = value;
  }

  set managerName(String value) {
    _managerName = value;
  }

  set managerPhonenumber(String value) {
    _managerPhonenumber = value;
  }

  set institutionNumber(String value) {
    _institutionNumber = value;
  }

  Future<void> createUserData() async {
    final user = {
      'ID': userid, // Replace with a unique ID for the new user
      'BIRTH': '${birth}',
      'INSTITUTION': 'University XYZ',
      'INSTITUTION_ID': '123',
      'NAME': 'John Doe',
      'SEX': 'Male',
      'CREATEDAT': '${TemporalDateTime.now()}',
      'UPDATEDAT': '${TemporalDateTime.now()}'
    };
    // final row = UserTable(
    //     ID: userid,
    //     BIRTH: birth.toString(),
    //     NAME: "김수",
    //     INSTITUTION: "FRAME",
    //     SEX: "남",
    //     CREATEDAT: TemporalDateTime.now(),
    //     UPDATEDAT: TemporalDateTime.now());
    try {
      final response = await Amplify.API
          .mutate(
            request: GraphQLRequest<String>(
              document: '''
            mutation CreateUserTable(\$input: CreateUserTableInput!) {
                  createUserTable(input: \$input) {
                    ID
                    BIRTH
                    INSTITUTION
                    INSTITUTION_ID
                    NAME
                    SEX
                    CREATEDAT
                    UPDATEDAT
               }  
              }
            ''',
              variables: {
                'input': user,
              },
            ),
          )
          .response;
      {
        final createdUser = response.data;
        if (createdUser == null) {
          safePrint('errors: ${response.errors}');
          return;
        }
        safePrint('Mutation result: ${createdUser.toString()}');
        // print('User created successfully: ${response.data}');
        birth += 10000;
        useridint++;
        userid = "$useridint";
      }
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
    }
  }

  //공지사항용
  Future<bool> createAnnouncement(
      String content,
      String image,
      String institution,
      String institution_id,
      String title,
      String url,
      userId) async {
    final time = '${TemporalDateTime.now()}';
    final row = {
      'ANNOUNCEMENT_ID': userId,
      'CONTENT': content,
      'IMAGE': image,
      'INSTITUTION': institution,
      'INSTITUTION_ID': institution_id,
      'TITLE': title,
      'URL': url,
      'createdAt': time,
      'updatedAt': time
    };
    try {
      final response = await Amplify.API
          .mutate(
            request: GraphQLRequest<String>(
              document: '''
            mutation CreateInstitutionAnnouncementTable(\$input: CreateInstitutionAnnouncementTableInput!) {
                  createInstitutionAnnouncementTable(input: \$input) {
                    ANNOUNCEMENT_ID
                    CONTENT
                    IMAGE
                    INSTITUTION
                    INSTITUTION_ID
                    TITLE
                    URL
                    createdAt
                    updatedAt
               }  
              }
            ''',
              variables: {
                'input': row,
              },
            ),
          )
          .response;
      {
        final createdData = response.data;
        if (createdData == null) {
          safePrint('errors: ${response.errors}');
          return false;
        }
        safePrint('Mutation result: ${createdData.toString()}');
        // print('User created successfully: ${response.data}');;
        useridint++;
        userid = "$useridint";
      }
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
      return false;
    }
    return true;
  }

  Future<bool> updateAnnouncement(
      {required String announcementId,
      required String content,
      required String image,
      required String institution,
      required String institution_id,
      required String title,
      required String url}) async {
    final row = {
      'ANNOUNCEMENT_ID': announcementId,
      'CONTENT': content,
      'IMAGE': image,
      'INSTITUTION': institution,
      'INSTITUTION_ID': institution_id,
      'TITLE': title,
      'URL': url,
      'updatedAt': '${TemporalDateTime.now()}'
    };

    try {
      final response = await Amplify.API
          .mutate(
            request: GraphQLRequest<String>(
              document: '''
          mutation UpdateInstitutionAnnouncementTable(\$input: UpdateInstitutionAnnouncementTableInput!) {
            updateInstitutionAnnouncementTable(input: \$input) {
              ANNOUNCEMENT_ID
              CONTENT
              IMAGE
              INSTITUTION
              INSTITUTION_ID
              TITLE
              URL              
            }  
          }
        ''',
              variables: {
                'input': row,
              },
            ),
          )
          .response;

      final updatedData = response.data;
      if (updatedData == null) {
        safePrint('errors: ${response.errors}');
        return false;
      }
      safePrint('Mutation result: ${updatedData.toString()}');
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
      return false;
    }
    return true;
  }

  //todo: 모달
  Future<bool> deleteAnnouncement(
      {required String institution_id, required String announcementId}) async {
    final row = {
      'INSTITUTION_ID': institution_id,
      'ANNOUNCEMENT_ID': announcementId,
    };

    try {
      final response = await Amplify.API
          .mutate(
            request: GraphQLRequest<String>(
              document: '''
          mutation DeleteInstitutionAnnouncementTable(\$input: DeleteInstitutionAnnouncementTableInput!) {
            deleteInstitutionAnnouncementTable(input: \$input) {
              INSTITUTION_ID
              ANNOUNCEMENT_ID             
            }  
          }
        ''',
              variables: {
                'input': row,
              },
            ),
          )
          .response;

      final deletedData = response.data;
      if (deletedData == null) {
        safePrint('errors: ${response.errors}');
        return false;
      }
      safePrint('Mutation result: ${deletedData.toString()}');
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
      return false;
    }
    return true;
  }

  // 필수돌봄정보
  Future<bool> createEssentialCare(
      String age,
      String name,
      String image,
      String phoneNumber,
      String institution,
      String institution_id,
      String medicationWay,
      String medication,
      String userId) async {
    //todo 이미지가 없넹...
    print("asdf");
    print(age);
    print(name);
    print(phoneNumber);
    print(institution);
    print(image);
    print(medicationWay);
    print(medication);
    print(userId);
    print("sdf");

    String convertToE164(String phoneNumber, String countryCode) {
      // 전화번호의 맨 앞자리가 0인 경우, 국가 코드로 대체
      if (phoneNumber.startsWith('0')) {
        phoneNumber = phoneNumber.substring(1);
      }

      return countryCode + phoneNumber;
    }

    phoneNumber = convertToE164(phoneNumber, "+82");

    final row = {
      'BIRTH': age,
      'NAME': name,
      'IMAGE': image,
      'INSTITUTION': institution,
      'INSTITUTION_ID': institution_id,
      'MEDICATION': medicationWay,
      'MEDICATION_WAY': medication,
      'PHONE_NUMBER': phoneNumber,
      'USER_ID': userId,
      'createdAt': '${TemporalDateTime.now()}',
      'updatedAt': '${TemporalDateTime.now()}'
    };
    try {
      final response = await Amplify.API
          .mutate(
            request: GraphQLRequest<String>(
              document: '''
            mutation createInstitutionEssentialCareTable(\$input: CreateInstitutionEssentialCareTableInput!) {
                  createInstitutionEssentialCareTable(input: \$input) {
                    BIRTH
                    INSTITUTION
                    INSTITUTION_ID
                    IMAGE
                    MEDICATION
                    MEDICATION_WAY
                    NAME
                    PHONE_NUMBER
                    USER_ID
                    createdAt
                    updatedAt
               }  
              }
            ''',
              variables: {
                'input': row,
              },
            ),
          )
          .response;
      {
        final createdData = response.data;
        if (createdData == null) {
          safePrint('errors: ${response.errors}');
          return false;
        }
        safePrint('Mutation result: ${createdData.toString()}');
        // print('User created successfully: ${response.data}');;
        useridint++;
        userid = "$useridint";
      }
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
      return false;
    }
    return true;
  }

//news
  Future<bool> createInstitutionNews(String content, String image,
      String institution, String New_id, String title, String url) async {
    final row = {
      'NEWS_ID': '${TemporalDateTime.now()}',
      'CONTENT': content,
      'IMAGE': image,
      'INSTITUTION': institution,
      'INSTITUTION_ID': New_id,
      'TITLE': title,
      'URL': url,
      'createdAt': '${TemporalDateTime.now()}',
      'updatedAt': '${TemporalDateTime.now()}'
    };
    try {
      final response = await Amplify.API
          .mutate(
            request: GraphQLRequest<String>(
              document: '''
            mutation createInstitutionNewsTable(\$input: CreateInstitutionNewsTableInput!) {
                  createInstitutionNewsTable(input: \$input) {
                    INSTITUTION_ID
                    CONTENT
                    IMAGE
                    INSTITUTION
                    NEWS_ID
                    TITLE
                    URL
                    createdAt
                    updatedAt
               }  
              }
            ''',
              variables: {
                'input': row,
              },
            ),
          )
          .response;
      {
        final createdData = response.data;
        if (createdData == null) {
          safePrint('errors: ${response.errors}');
          return false;
        }
        safePrint('Mutation result: ${createdData.toString()}');
        // print('User created successfully: ${response.data}');;
        useridint++;
        userid = "$useridint";
      }
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
      return false;
    }
    return true;
  }

  Future<bool> updateInstitutionNews(
      {required String newsId,
      required String content,
      required String image,
      required String institution,
      required String institution_id,
      required String title,
      required String url}) async {
    final row = {
      'NEWS_ID': newsId,
      'CONTENT': content,
      'IMAGE': image,
      'INSTITUTION': institution,
      'INSTITUTION_ID': institution_id,
      'TITLE': title,
      'URL': url,
      'updatedAt': '${TemporalDateTime.now()}'
    };

    try {
      final response = await Amplify.API
          .mutate(
            request: GraphQLRequest<String>(
              document: '''
          mutation UpdateInstitutionNewsTable(\$input: UpdateInstitutionNewsTableInput!) {
            updateInstitutionNewsTable(input: \$input) {
              INSTITUTION_ID
              CONTENT
              IMAGE
              INSTITUTION
              NEWS_ID
              TITLE
              URL          
            }  
          }
        ''',
              variables: {
                'input': row,
              },
            ),
          )
          .response;

      final updatedData = response.data;
      if (updatedData == null) {
        safePrint('errors: ${response.errors}');
        return false;
      }
      safePrint('Mutation result: ${updatedData.toString()}');
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
      return false;
    }
    return true;
  }

  Future<bool> deleteInstitutionNews(
      {required String institutionId, required String newsId}) async {
    final row = {
      'INSTITUTION_ID': institutionId,
      'NEWS_ID': newsId,
    };

    try {
      final response = await Amplify.API
          .mutate(
            request: GraphQLRequest<String>(
              document: '''
          mutation DeleteInstitutionNewsTable(\$input: DeleteInstitutionNewsTableInput!) {
            deleteInstitutionNewsTable(input: \$input) {
              INSTITUTION_ID
              NEWS_ID
            }  
          }
        ''',
              variables: {
                'input': row,
              },
            ),
          )
          .response;

      final deletedData = response.data;
      if (deletedData == null) {
        safePrint('errors: ${response.errors}');
        return false;
      }
      safePrint('Mutation result: ${deletedData.toString()}');
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
      return false;
    }
    return false;
  }

//////////////////여기까지
  Future<bool> createFood(
      String dateTime, String imageUrl, String institutionId) async {
    final row = {
      'DATE': dateTime,
      'IMAGE_URL': imageUrl,
      'INSTITUTION_ID': institutionId,
      'createdAt': '${TemporalDateTime.now()}',
      'updatedAt': '${TemporalDateTime.now()}'
    };
    try {
      final response = await Amplify.API
          .mutate(
            request: GraphQLRequest<String>(
              document: '''
            mutation createInstitutionFoodTable(\$input: CreateInstitutionFoodTableInput!) {
                  createInstitutionFoodTable(input: \$input) {
                    DATE
                    IMAGE_URL
                    INSTITUTION_ID
                    createdAt
                    updatedAt
               }  
              }
            ''',
              variables: {
                'input': row,
              },
            ),
          )
          .response;
      {
        final createdData = response.data;
        if (createdData == null) {
          safePrint('errors: ${response.errors}');
          return false;
        }
        if (createdData.toString() == "{\"createInstitutionFoodTable\":null}") {
          var result = updateFood(dateTime, imageUrl, institutionId);
          return result;
        }
        safePrint('Mutation result: ${createdData.toString()}');
      }
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
      return false;
    }
    return true;
  }

  Future<bool> deleteFood(
      {required String dateTime, required String institutionId}) async {
    // dateTime = "202203";

    final row = {'DATE': dateTime, 'INSTITUTION_ID': institutionId};

    print("del");
    print(row['DATE']);
    print(row['INSTITUTION_ID']);
    print(dateTime);
    print(institutionId);

    try {
      final response = await Amplify.API
          .mutate(
            request: GraphQLRequest<String>(
              document: '''
            mutation deleteInstitutionFoodTable(\$input: DeleteInstitutionFoodTableInput!) {
                  deleteInstitutionFoodTable(input: \$input) {
                    INSTITUTION_ID
                    DATE
               }  
              } 
            ''',
              variables: {
                'input': row,
              },
            ),
          )
          .response;

      // final deletedData = response.data;
      // if (deletedData == null) {
      //   safePrint('errors: ${response.errors}');
      //   return;
      // }

      final deletedData = response.data;
      if (deletedData == null ||
          jsonDecode(deletedData!)['deleteInstitutionFoodTable'] == null) {
        safePrint('errors: ${response.errors}');
        return false;
      }
      safePrint('Mutation result: ${deletedData.toString()}');
      // print('User created successfully: ${response.data}');;

      safePrint('Mutation result: ${deletedData.toString()}');
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
      return false;
    }
    return true;
  }

/*
*
* final deletedData = response.data;
        if (deletedData == null || jsonDecode(deletedData!)['deleteInstitutionScheduleTable'] ==
            null) {
          safePrint('errors: ${response.errors}');
          return false;
        }
        safePrint('Mutation result: ${deletedData.toString()}');
        // print('User created successfully: ${response.data}');;
        return true;
      }
    }
*
* */

  Future<bool> updateFood(
      String dateTime, String imageUrl, String institutionId) async {
    //todo update날짜만 바꾸면 될 거 같은뎅..
    final row = {
      'DATE': dateTime,
      'IMAGE_URL': imageUrl,
      'INSTITUTION_ID': institutionId,
      'createdAt': '${TemporalDateTime.now()}',
      'updatedAt': '${TemporalDateTime.now()}'
    };
    try {
      final response = await Amplify.API
          .mutate(
            request: GraphQLRequest<String>(
              document: '''
            mutation updateInstitutionFoodTable(\$input: UpdateInstitutionFoodTableInput!) {
                  updateInstitutionFoodTable(input: \$input) {
                    DATE
                    IMAGE_URL
                    INSTITUTION_ID
                    createdAt
                    updatedAt
               }  
              }
            ''',
              variables: {
                'input': row,
              },
            ),
          )
          .response;
      {
        final updateData = response.data;

        if (updateData == null ||
            jsonDecode(updateData!)['updateInstitutionFoodTable'] == null) {
          safePrint('errors: ${response.errors}');
          return false;
        }
        safePrint('Mutation result: ${updateData.toString()}');
      }
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
      return false;
    }
    return true;
  }

  Future<bool> createShuttleTime(String imageUrl, String institutionId) async {
    final row = {
      'IMAGE_URL': imageUrl,
      'INSTITUTION_ID': institutionId,
      'createdAt': '${TemporalDateTime.now()}',
      'updatedAt': '${TemporalDateTime.now()}'
    };

    try {
      final response = await Amplify.API
          .mutate(
            request: GraphQLRequest<String>(
              document: '''
            mutation createInstitutionShuttleTimeTable(\$input: CreateInstitutionShuttleTimeTableInput!) {
                  createInstitutionShuttleTimeTable(input: \$input) {
                    IMAGE_URL
                    INSTITUTION_ID
                    createdAt
                    updatedAt
               }  
              }
            ''',
              variables: {
                'input': row,
              },
            ),
          )
          .response;
      {
        final createdData = response.data;
        if (createdData == null) {
          safePrint('errors: ${response.errors}');
          return false;
        }
        if (createdData.toString() ==
            "{\"createInstitutionShuttleTimeTable\":null}") {
          return updateShuttleTime(imageUrl, institutionId);
        }
        safePrint('Mutation result: ${createdData.toString()}');
      }
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
      return false;
    }
    return true;
  }

  Future<bool> deleteShuttleTime({required String institutionId}) async {
    final row = {
      'INSTITUTION_ID': institutionId,
    };

    print("del");
    print(institutionId);

    try {
      final response = await Amplify.API
          .mutate(
            request: GraphQLRequest<String>(
              document: '''
            mutation deleteInstitutionShuttleTimeTable(\$input: DeleteInstitutionShuttleTimeTableInput!) {
                  deleteInstitutionShuttleTimeTable(input: \$input) {
                    INSTITUTION_ID
               }  
              }
            ''',
              variables: {
                'input': row,
              },
            ),
          )
          .response;

      final deletedData = response.data;
      if (deletedData == null) {
        safePrint('errors: ${response.errors}');
        return false;
      }

      safePrint('Mutation result: ${deletedData.toString()}');
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
      return false;
    }
    return true;
  }

  Future<bool> updateShuttleTime(String imageUrl, String institutionId) async {
    //todo update날짜만 바꾸면 될 거 같은뎅..
    final row = {
      'IMAGE_URL': imageUrl,
      'INSTITUTION_ID': institutionId,
      'createdAt': '${TemporalDateTime.now()}',
      'updatedAt': '${TemporalDateTime.now()}'
    };
    try {
      final response = await Amplify.API
          .mutate(
            request: GraphQLRequest<String>(
              document: '''
            mutation updateInstitutionShuttleTimeTable(\$input: UpdateInstitutionShuttleTimeTableInput!) {
                  updateInstitutionShuttleTimeTable(input: \$input) {
                    IMAGE_URL
                    INSTITUTION_ID
                    createdAt
                    updatedAt
               }  
              }
            ''',
              variables: {
                'input': row,
              },
            ),
          )
          .response;
      {
        final updateData = response.data;
        if (updateData == null) {
          safePrint('errors: ${response.errors}');
          return false;
        }
        safePrint('Mutation result: ${updateData.toString()}');
      }
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
      return false;
    }
    return true;
  }

// 공지사항 데이터들 불러오기
  Future<List<InstitutionAnnouncementTable>>
      queryInstitutionAnnouncementsByInstitutionId(
          {required String institutionId, String? nextToken}) async {
    try {
      var operation = Amplify.API.query(
        request: GraphQLRequest(
          apiName: "Institution_API_NEW",
          document: """
          query ListInstitutionAnnouncementTables(\$filter: TableInstitutionAnnouncementTableFilterInput, \$limit: Int, \$nextToken: String) {
            listInstitutionAnnouncementTables(filter: \$filter, limit: \$limit, nextToken: \$nextToken) {
              items {
                ANNOUNCEMENT_ID
                CONTENT
                IMAGE
                INSTITUTION
                INSTITUTION_ID
                TITLE
                URL
                createdAt
                updatedAt
              }
              nextToken
            }
          }
        """,
          variables: {
            "filter": {
              "INSTITUTION_ID": {"eq": institutionId}
            },
            "limit": 1000,
            "nextToken": nextToken,
          },
        ),
      );

      var response = await operation.response;

      print(response.data);

      var data = jsonDecode(response.data);
      var items = data['listInstitutionAnnouncementTables']['items'];

      if (items == null || response.data == null) {
        print('errors: ${response.errors}');
        return const [];
      }

      List<InstitutionAnnouncementTable> announcements = (items as List)
          .map((item) => InstitutionAnnouncementTable.fromJson(item))
          .toList();

      var newNextToken = data['listInstitutionAnnouncementTables']['nextToken'];

      if (newNextToken != null) {
        // recursive call for next page's data
        var additionalItems =
            await queryInstitutionAnnouncementsByInstitutionId(
                institutionId: institutionId, nextToken: newNextToken);
        announcements.addAll(additionalItems);
      }

      return announcements;
    } on ApiException catch (e) {
      print('Query failed: $e');
      return const [];
    }
  }

  // 뉴스 데이터들 불러오기
  Future<List<InstitutionNewsTable>> queryInstitutionNewsByInstitutionId(
      {required String institutionId, String? nextToken}) async {
    try {
      var operation = Amplify.API.query(
        request: GraphQLRequest(
          apiName: "Institution_API_NEW",
          document: """
      query ListInstitutionNewsTables(\$filter: TableInstitutionNewsTableFilterInput, \$limit: Int, \$nextToken: String) {
      listInstitutionNewsTables(filter: \$filter, limit: \$limit, nextToken: \$nextToken) {
      items {
      NEWS_ID
      CONTENT
      IMAGE
      INSTITUTION
      INSTITUTION_ID
      TITLE
      URL
      createdAt
      updatedAt
      }
      nextToken
      }
      }
      """,
          variables: {
            "filter": {
              "INSTITUTION_ID": {"eq": institutionId}
            },
            "limit": 1000,
            "nextToken": nextToken,
          },
        ),
      );

      var response = await operation.response;

      print(response.data);

      var data = jsonDecode(response.data);
      var items = data['listInstitutionNewsTables']['items'];

      if (items == null || response.data == null) {
        print('errors: ${response.errors}');
        return const [];
      }

      List<InstitutionNewsTable> news = (items as List)
          .map((item) => InstitutionNewsTable.fromJson(item))
          .toList();

      var newNextToken = data['listInstitutionNewsTables']['nextToken'];

      if (newNextToken != null) {
        // recursive call for next page's data
        var additionalItems = await queryInstitutionNewsByInstitutionId(
            institutionId: institutionId, nextToken: newNextToken);
        news.addAll(additionalItems);
      }

      return news;
    } on ApiException catch (e) {
      print('Query failed: $e');
      return const [];
    }
  }

  Future<bool> updateEssentialCare(
      String age,
      String name,
      String image,
      String phoneNumber,
      String institution,
      String institution_id,
      String medicationWay,
      String medication,
      String userId) async {
    String convertToE164(String phoneNumber, String countryCode) {
      // 전화번호의 맨 앞자리가 0인 경우, 국가 코드로 대체
      if (phoneNumber.startsWith('0')) {
        phoneNumber = phoneNumber.substring(1);
      }

      return countryCode + phoneNumber;
    }

    phoneNumber = convertToE164(phoneNumber, "+82");

    //todo update날짜만 바꾸면 될 거 같은뎅..
    final row = {
      'BIRTH': age,
      'NAME': name,
      'IMAGE': image,
      'INSTITUTION': institution,
      'INSTITUTION_ID': institution_id,
      'MEDICATION': medicationWay,
      'MEDICATION_WAY': medication,
      'PHONE_NUMBER': phoneNumber,
      'USER_ID': userId,
      'createdAt': '${TemporalDateTime.now()}',
      'updatedAt': '${TemporalDateTime.now()}'
    };
    try {
      final response = await Amplify.API
          .mutate(
            request: GraphQLRequest<String>(
              document: '''
            mutation updateInstitutionEssentialCareTable(\$input: UpdateInstitutionEssentialCareTableInput!) {
                  updateInstitutionEssentialCareTable(input: \$input) {
                    BIRTH
                    INSTITUTION
                    INSTITUTION_ID
                    IMAGE
                    MEDICATION
                    MEDICATION_WAY
                    NAME
                    PHONE_NUMBER
                    USER_ID
                    createdAt
                    updatedAt
               }  
              }
            ''',
              variables: {
                'input': row,
              },
            ),
          )
          .response;
      {
        final updateData = response.data;
        if (updateData == null) {
          safePrint('errors: ${response.errors}');
          return false;
        }
        safePrint('Mutation result: ${updateData.toString()}');
      }
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
      return false;
    }
    return true;
  }

  Future<bool> deleteEssentialCare(String userId, String institutionId) async {
    final row = {
      'USER_ID': userId,
      'INSTITUTION_ID': institutionId,
    };
    print('delete');
    print(userId);
    print(institutionId);
    try {
      final response = await Amplify.API
          .mutate(
            request: GraphQLRequest<String>(
              document: '''
          mutation DeleteInstitutionEssentialCareTable(\$input: DeleteInstitutionEssentialCareTableInput!) {
                deleteInstitutionEssentialCareTable(input: \$input) {
                  USER_ID
                  INSTITUTION_ID
             }  
            }
          ''',
              variables: {
                'input': row,
              },
            ),
          )
          .response;

      final deletedData = response.data;
      if (deletedData == null) {
        safePrint('errors: ${response.errors}');
        return false;
      }

      safePrint('Mutation result: ${deletedData.toString()}');
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
      return false;
    }
    return true;
  }

//todo: 안됨
  Future<List<InstitutionEssentialCareTable>>
      queryEssentialCareInformationByInstitutionId(
          {required String institutionId, String? nextToken}) async {
    try {
      var operation = Amplify.API.query(
        request: GraphQLRequest(
          apiName: "Institution_API_NEW",
          document: """
          query ListInstitutionEssentialCareTables(\$filter: TableInstitutionEssentialCareTableFilterInput, \$limit: Int, \$nextToken: String) {
            listInstitutionEssentialCareTables(filter: \$filter, limit: \$limit, nextToken: \$nextToken) {
              items {
                BIRTH
                INSTITUTION
                INSTITUTION_ID
                MEDICATION
                IMAGE
                MEDICATION_WAY
                NAME
                PHONE_NUMBER
                USER_ID
                createdAt
				  updatedAt
              }
              nextToken
            }
          }
        """,
          variables: {
            "filter": {
              "INSTITUTION_ID": {"eq": institutionId}
            },
            "limit": 1000,
            "nextToken": nextToken,
          },
        ),
      );

      var response = await operation.response;

      print(response.data);

      var data = jsonDecode(response.data);
      var items = data['listInstitutionEssentialCareTables']['items'];

      if (items == null || response.data == null) {
        print('errors: ${response.errors}');
        return const [];
      }

      List<InstitutionEssentialCareTable> essentialCare = (items as List)
          .map((item) => InstitutionEssentialCareTable.fromJson(item))
          .toList();

      var newNextToken =
          data['listInstitutionEssentialCareTables']['nextToken'];

      if (newNextToken != null) {
        // recursive call for next page's data
        var additionalItems =
            await queryEssentialCareInformationByInstitutionId(
                institutionId: institutionId, nextToken: newNextToken);
        essentialCare.addAll(additionalItems);
      }

      return essentialCare;
    } on ApiException catch (e) {
      print('Query failed: $e');
      return const [];
    }
  }

  Future<InstitutionFoodTable?> queryFoodByInstitutionIdAndDate(
      String institutionId, String date) async {
    try {
      var operation = Amplify.API.query(
        request: GraphQLRequest(
          document: """
          query ListInstitutionFoodTables(\$INSTITUTION_ID: String, \$DATE: String) {
            listInstitutionFoodTables(filter: {INSTITUTION_ID: {eq: \$INSTITUTION_ID}, DATE: {eq: \$DATE}}) {
              items {
                DATE
                INSTITUTION_ID
                IMAGE_URL
                createdAt
                updatedAt
              }
            }
          }
        """,
          variables: {"INSTITUTION_ID": institutionId, "DATE": date},
        ),
      );
      var response = await operation.response;

      InstitutionFoodTable food =
          (jsonDecode(response.data)['listInstitutionFoodTables']['items']
                  as List)
              .map((item) => InstitutionFoodTable.fromJson(item))
              .toList()
              .first;
      if (food == null) {
        print('errors: ${response.errors}');

        return null;
      }
      // print(food);
      return food;
    } on ApiException catch (e) {
      print('Query failed: $e');
      return null;
    }
  }

  Future<InstitutionShuttleTimeTable?> queryShuttleTimeByInstitutionId(
      String institutionId) async {
    print(institutionId);
    try {
      var operation = Amplify.API.query(
        request: GraphQLRequest(
          document: """
          query ListInstitutionShuttleTimeTables(\$INSTITUTION_ID: String) {
            listInstitutionShuttleTimeTables(filter: {INSTITUTION_ID: {eq: \$INSTITUTION_ID}}) {
              items {
                INSTITUTION_ID
                IMAGE_URL
                createdAt
                updatedAt
              }
            }
          }
        """,
          variables: {
            "INSTITUTION_ID": institutionId,
          },
        ),
      );
      var response = await operation.response;
      print(response.data);
      var responseData = jsonDecode(response.data);
      List<dynamic> items =
          responseData['listInstitutionShuttleTimeTables']['items'];

      InstitutionShuttleTimeTable shuttleTime =
          InstitutionShuttleTimeTable.fromJson(items[0]);

      if (shuttleTime == null) {
        print('errors: ${response.errors}');

        return null;
      }
      print(shuttleTime);
      return shuttleTime;
    } on ApiException catch (e) {
      print('Query failed: $e');
      return null;
    }
  }

  Future<void> createMonthlyData() async {
    final row = {
      'id': "4",
      'month': "20231201",
      'avg_att': Random().nextInt(100) + 1,
      'avg_med': Random().nextInt(100) + 1,
      'con_score': Random().nextInt(100) + 1,
      'spacetime_score': Random().nextInt(100) + 1,
      'exec_score': Random().nextInt(100) + 1,
      'mem_score': Random().nextInt(100) + 1,
      'ling_score': Random().nextInt(100) + 1,
      'cal_score': Random().nextInt(100) + 1,
      'reac_score': Random().nextInt(100) + 1,
      'orient_score': Random().nextInt(100) + 1,
      'createdAt': '${TemporalDateTime.now()}',
      'updatedAt': '${TemporalDateTime.now()}'
    };

    try {
      final response = await Amplify.API
          .mutate(
            request: GraphQLRequest<String>(
              document: '''
            mutation createMonthlyBrainSignalTable(\$input: CreateMonthlyBrainSignalTableInput!) {
                  createMonthlyBrainSignalTable(input: \$input) {
                    id
                    month
                    avg_att
                    avg_med
                    con_score
                    spacetime_score
                    exec_score
                    mem_score
                    ling_score
                    cal_score
                    reac_score
                    orient_score
                    createdAt
                    updatedAt
               }  
              }
            ''',
              variables: {
                'input': row,
              },
            ),
          )
          .response;
      {
        final createdData = response.data;
        if (createdData == null) {
          safePrint('errors: ${response.errors}');
          return;
        }
        safePrint('Mutation result: ${createdData.toString()}');
        // print('User created successfully: ${response.data}');
        birth += 10000;
        useridint++;
        userid = "$useridint";
      }
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
    }
  }

  // 기관 요약 보고서에서 뇌신호 데이터 가져오기(BrainSignalTable = Monthly DB)
  //BETWEEN
  Future<List<MonthlyBrainSignalTable?>> queryListMonthlyDBItemsBetween(
      {required String ID,
      required String startMonth,
      required String endMonth,
      String? nextToken}) async {
    try {
      print("??");
      print(startMonth);
      print(endMonth);
      var operation = Amplify.API.query(
        request: GraphQLRequest(
          apiName: "Institution_API_NEW",
          document: """
          query listMonthlyBrainSignalTables(\$filter: TableMonthlyBrainSignalTableFilterInput, \$limit: Int, \$nextToken: String) {
            listMonthlyBrainSignalTables(
              filter: \$filter,
              limit: \$limit,
              nextToken: \$nextToken
            ) {
              items {
                id
                month
                total_time
                avg_att
                avg_med
                firsts_name
                first_amt
                second_name
                second_amt
                con_score
                spacetime_score
                exec_score
                mem_score
                ling_score
                cal_score 
                reac_score 
                orient_score 
                createdAt 
                updatedAt 
	      }
	      nextToken 
	    }
	  }
        """,
          variables: {
            "filter": {
              "id": {"eq": ID},
              "month": {
                "between": [startMonth, endMonth]
              },
            },
            "limit": 1000,
            "nextToken": nextToken,
          },
        ),
      );

      var response = await operation.response;

      var data = jsonDecode(response.data);
      var items = data['listMonthlyBrainSignalTables']['items'];

      if (items == null || response.data == null) {
        print('errors: ${response.errors}');
        return const [];
      }

      List<MonthlyBrainSignalTable?> monthlyDBTests = (items as List)
          .map((item) => MonthlyBrainSignalTable.fromJson(item))
          .toList();

      var newNextToken = data['listMonthlyBrainSignalTables']['nextToken'];

      if (newNextToken != null) {
        // recursive call for next page's data
        var additionalItems = await queryListMonthlyDBItemsBetween(
            ID: ID,
            startMonth: startMonth,
            endMonth: endMonth,
            nextToken: newNextToken);
        monthlyDBTests.addAll(additionalItems);
      }

      return monthlyDBTests;
    } on ApiException catch (e) {
      print('Query failed:$e');
      return const [];
    }
  }

/*  ----------- jinsu method ------------------        */

  //기관의 스케줄 CRUD 페이지 관련 함수들
  Future<bool?> createScheduledata(String content,
      List<String> tag, String classtime, String date) async {
    var time = '${TemporalDateTime.now()}';
    var row = {
      'SCHEDULE_ID': time,
      'INSTITUTION_ID': institutionNumber,
      'CONTENT': content,
      'TAG': tag,
      'TIME': classtime,
      'DATE': date,
      'createdAt': time,
      'updatedAt': time
    };
    try {
      final response = await Amplify.API
          .mutate(
            request: GraphQLRequest<String>(
              apiName: "Institution_API_NEW",
              document: '''
            mutation createInstitutionEventScheduleTable(\$input: CreateInstitutionEventScheduleTableInput!) {
                  createInstitutionEventScheduleTable(input: \$input) {
                    INSTITUTION_ID
                    SCHEDULE_ID
                    CONTENT
                    TAG
                    TIME
                    DATE
                    createdAt
                    updatedAt
               }  
              }
            ''',
              variables: {
                'input': row,
              },
            ),
          )
          .response;
      {
        final createdData = response.data;
        if (jsonDecode(createdData!)['createInstitutionEventScheduleTable'] ==
            null) {
          safePrint('errors: ${response.errors}');
          return false;
        }
        safePrint('Mutation result: ${createdData.toString()}');
        // print('User created successfully: ${response.data}');;
        useridint++;
        userid = "$useridint";
        return true;
      }
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
      return false;
    }
  }

  //기관이 등록한 스케줄들을 한달단위로 불러오는 함수
  Future<List<InstitutionEventScheduleTable?>>
      queryInstitutionScheduleByInstitutionId(String date,
          {String? nextToken}) async {
    int dateNext = int.parse(date);
    dateNext += 40;
    try {
      var operation = Amplify.API.query(
        request: GraphQLRequest(
          apiName: "Institution_API_NEW",
          document: """
          query ListInstitutionEventScheduleTables(\$filter: TableInstitutionEventScheduleTableFilterInput, \$limit: Int, \$nextToken: String) {
            listInstitutionEventScheduleTables(
              filter: \$filter,
              limit: \$limit,
              nextToken: \$nextToken
            ) {
              items {
                INSTITUTION_ID
                SCHEDULE_ID
                CONTENT
                TAG
                TIME
                DATE
                createdAt
                updatedAt
              }
              nextToken
            }
          }
        """,
          variables: {
            "filter": {
              "INSTITUTION_ID": {"eq": institutionNumber},
              "DATE": {
                "between": [date, '$dateNext']
              },
            },
            "limit": 1000,
            "nextToken": nextToken,
          },
        ),
      );

      var response = await operation.response;
      {
        var data = jsonDecode(response.data);
        var items = data['listInstitutionEventScheduleTables']['items'];

        if (items == null || response.data == null) {
          print('errors: ${response.errors}');
          return const [];
        }
        List<InstitutionEventScheduleTable?> schedules = (items as List)
            .map((item) => InstitutionEventScheduleTable.fromJson(item))
            .toList();
        var newNextToken =
            data['listInstitutionEventScheduleTables']['nextToken'];

        if (newNextToken != null) {
          // recursive call for next page's data
          var nextSchedules = await queryInstitutionScheduleByInstitutionId(
              date,
              nextToken: newNextToken);
          schedules.addAll(nextSchedules);
        }

        return schedules;
      }
    } on ApiException catch (e) {
      print('Query failed: $e');
      return const [];
    }
  }

  Stream<GraphQLResponse>? subscribeInstitutionSchedule(String institutionId) {
    String inst_id = 'aaa';
    try {
      var operation = Amplify.API.subscribe(
        GraphQLRequest(
          apiName: "Institution_API_NEW",
          document: """
     subscription onsubscribeInstitutionEventScheduleTable {
        onsubscribeInstitutionEventScheduleTable {
	            	    INSTITUTION_ID
                    SCHEDULE_ID
                    CONTENT
                    TAG
                    TIME
                    DATE
                    createdAt
                    updatedAt
        }
      }
      """,
        ),
        onEstablished: () {
          print("subscription success");
        },
      ).handleError(
        (Object error) {
          safePrint('Error in subscription stream: $error');
        },
      );

      return operation;
    } on ApiException catch (e) {
      print('Query failed: $e');
      return null;
    }
  }

  Future<bool?> updateScheduledata(String sche_id, String content,
      List<String> tag, String time, String date) async {
    final row = {
      'SCHEDULE_ID': sche_id,
      'INSTITUTION_ID': institutionNumber,
      'CONTENT': content,
      'TAG': tag,
      'TIME': time,
      'DATE': date,
      'updatedAt': '${TemporalDateTime.now()}'
    };
    // final condition = {
    //   'INSTITUTION_ID': {'eq': inst_id},
    //   'SCHEDULE_ID': {'eq': sche_id}
    // };
    try {
      final response = await Amplify.API
          .mutate(
            request: GraphQLRequest<String>(
              apiName: "Institution_API_NEW",
              document: '''
          mutation updateInstitutionEventScheduleTable(\$input: UpdateInstitutionEventScheduleTableInput!) {
            updateInstitutionEventScheduleTable(input: \$input) {
              SCHEDULE_ID
              INSTITUTION_ID
              CONTENT
              TAG
              TIME
              DATE
              updatedAt
            }  
          }
        ''',
              variables: {'input': row},
            ),
          )
          .response;
      {
        final updatedData = response.data;
        if (updatedData == null ||
            jsonDecode(updatedData!)['updateInstitutionEventScheduleTable'] ==
                null) {
          safePrint('errors: ${response.errors}');
          return false;
        }
        safePrint('Mutation result: ${updatedData.toString()}');
        // print('User created successfully: ${response.data}');;
        return true;
      }
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
      return false;
    }
  }

  Future<bool?> deleteScheduledata(
    String schedule_id,
  ) async {
    final row = {
      'INSTITUTION_ID': institutionNumber,
      'SCHEDULE_ID': schedule_id
    };
    try {
      final response = await Amplify.API
          .mutate(
            request: GraphQLRequest<String>(
              apiName: "Institution_API_NEW",
              document: '''
            mutation deleteInstitutionEventScheduleTable(\$input: DeleteInstitutionEventScheduleTableInput!) {
                  deleteInstitutionEventScheduleTable(input: \$input) {
                    INSTITUTION_ID
                    SCHEDULE_ID
               }  
              }
            ''',
              variables: {
                'input': row,
              },
            ),
          )
          .response;
      {
        final deletedData = response.data;
        if (deletedData == null ||
            jsonDecode(deletedData!)['deleteInstitutionEventScheduleTable'] ==
                null) {
          safePrint('errors: ${response.errors}');
          return false;
        }
        safePrint('Mutation result: ${deletedData.toString()}');
        // print('User created successfully: ${response.data}');;
        return true;
      }
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
      return false;
    }
  }

  //기관의 소속 훈련자 데이터 불려오기
  Future<List<UserTable?>> queryListUsers({String? nextToken}) async {
    try {
      var operation = Amplify.API.query(
        request: GraphQLRequest(
          apiName: "Institution_API_NEW",
          document: """
          query ListUserTables(\$INSTITUTION_ID: String, \$limit: Int, \$nextToken: String) {
            listUserTables(
              filter: {INSTITUTION_ID: {eq: \$INSTITUTION_ID}},
              limit: \$limit,
              nextToken: \$nextToken
            ) {
              items {
                ID
                BIRTH
                CREATEDAT
                INSTITUTION
                INSTITUTION_ID
                NAME
                SEX
                UPDATEDAT
              }
              nextToken
            }
          }
        """,
          variables: {
            "INSTITUTION_ID": institutionNumber,
            "limit": 1000,
            "nextToken": nextToken,
          },
        ),
      );

      var response = await operation.response;
      {
        var data = jsonDecode(response.data);
        var items = data['listUserTables']['items'];
        if (response.data == null || items == null) {
          print('errors: ${response.errors}');
          return const [];
        }

        List<UserTable?> Users =
            (items as List).map((item) => UserTable.fromJson(item)).toList();
        var newNextToken = data['listUserTables']['nextToken'];

        if (newNextToken != null) {
          // recursive call for next page's data
          var nextUsers = await queryListUsers(nextToken: newNextToken);
          Users.addAll(nextUsers);
        }
        print(Users);

        return Users;
      }
    } on ApiException catch (e) {
      print('Query failed: $e');
      return const [];
    }
  }

  //comment 페이지 관련 함수들
  Future<bool?> createCommentBoarddata(String user_id, String title,
      String content, String username, String inst_id) async {
    final time = '${TemporalDateTime.now()}';
    final row = {
      'USER_ID': user_id,
      'BOARD_ID': time,
      'CONTENT': content,
      'WRITER': managerName,
      'TITLE': title,
      'USERNAME': username,
      'INSTITUTION_ID': inst_id,
      'NEW_CONVERSATION_PROTECTOR': false,
      'NEW_CONVERSATION_INST': false,
      'NEW_CONVERSATION_CREATEDAT': time,
      'createdAt': time,
      'updatedAt': time
    };
    try {
      final response = await Amplify.API
          .mutate(
            request: GraphQLRequest<String>(
              apiName: "Institution_API_NEW",
              variables: {
                'input': row,
              },
              document: '''
            mutation createInstitutionCommentBoardTable(\$input: CreateInstitutionCommentBoardTableInput!) {
                  createInstitutionCommentBoardTable(input: \$input) {
	                  BOARD_ID
	                  USER_ID
	                  WRITER
	                  CONTENT
	                  TITLE
	                  USERNAME
	                  INSTITUTION_ID
	                  NEW_CONVERSATION_PROTECTOR
	                  NEW_CONVERSATION_INST
	                  NEW_CONVERSATION_CREATEDAT
	                  createdAt
	                  updatedAt
               }  
              }
            ''',
            ),
          )
          .response;
      {
        final createdData = response.data;
        if (createdData == null ||
            jsonDecode(createdData!)['createInstitutionCommentBoardTable'] ==
                null) {
          safePrint('errors: ${response.errors}');
          return false;
        }
        safePrint('Mutation result: ${createdData.toString()}');
        // print('User created successfully: ${response.data}');;
        return true;
      }
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
      return false;
    }
  }

  // 코멘트 테이블의 CRUD 감지하도록 구독하는 함수
  Stream<GraphQLResponse>? subscribeInstitutionCommentBoard() {
    String inst_id = 'aaa';
    try {
      var operation = Amplify.API.subscribe(
        GraphQLRequest(
          apiName: "Institution_API_NEW",
          document: """
     subscription onsubscribeInstitutionCommentBoardTable {
        onsubscribeInstitutionCommentBoardTable {
	                  BOARD_ID
	                  USER_ID
	                  WRITER
	                  CONTENT
	                  TITLE
	                  USERNAME
	                  INSTITUTION_ID
	                  NEW_CONVERSATION_PROTECTOR
	                  NEW_CONVERSATION_INST
	                  NEW_CONVERSATION_CREATEDAT
	                  createdAt
	                  updatedAt
        }
      }
    """,
        ),
        onEstablished: () {
          print("subscription success");
        },
      ).handleError(
        (Object error) {
          safePrint('Error in subscription stream: $error');
        },
      );

      return operation;
    } on ApiException catch (e) {
      print('Query failed: $e');
      return null;
    }
  }

  //한달 단위로 코멘트 불러오기
  Future<List<InstitutionCommentBoardTable?>> listInstitutionCommentBoard(
      String filterName, String Id, String year, String month,
      {String? nextToken}) async {
    final time = '${TemporalDateTime.now()}';
    var remain = time.substring(10); //12
    var start = '$year-$month-00$remain';
    var end = '$year-$month-40$remain';
    print('start: $time');
    print('start: $start');
    try {
      var operation = Amplify.API.query(
        request: GraphQLRequest(
          apiName: "Institution_API_NEW",
          document: """
          query ListInstitutionCommentBoardTables(\$filter: TableInstitutionCommentBoardTableFilterInput, \$limit: Int, \$nextToken: String) {
            listInstitutionCommentBoardTables(
              filter: \$filter,
              limit: \$limit,
              nextToken: \$nextToken
            ) {
              items {
                BOARD_ID
                USER_ID
                WRITER
                TITLE
                USERNAME
                CONTENT
                INSTITUTION_ID
                NEW_CONVERSATION_PROTECTOR
                NEW_CONVERSATION_INST
                NEW_CONVERSATION_CREATEDAT
                createdAt
                updatedAt
              }
              nextToken
            }
          }
        """,
          variables: {
            "filter": {
              filterName: {"eq": Id},
              "NEW_CONVERSATION_CREATEDAT": {
                "between": [start, end]
              },
            },
            "limit": 1000,
            "nextToken": nextToken,
          },
        ),
      );

      var response = await operation.response;
      {
        var data = jsonDecode(response.data);
        var items = data['listInstitutionCommentBoardTables']['items'];
        if (response.data == null || items == null) {
          print('errors: ${response.errors}');
          return const [];
        }
        List<InstitutionCommentBoardTable?> comments = (items as List)
            .map((item) => InstitutionCommentBoardTable.fromJson(item))
            .toList();
        var newNextToken =
            data['listInstitutionCommentBoardTables']['nextToken'];

        if (newNextToken != null) {
          // recursive call for next page's data
          var nextComments = await listInstitutionCommentBoard(
              filterName, Id, year, month,
              nextToken: newNextToken);
          comments.addAll(nextComments!);
        }

        return comments;
      }
    } on ApiException catch (e) {
      print('Query failed: $e');
      return const [];
    }
  }

  //특정 코멘트 하나만 불러오기
  Future<InstitutionCommentBoardTable?> getInstitutionCommentBoard(
      String user_id, String board_id) async {
    // String inst_id = 'aaa';
    // int dateNext = int.parse(date);
    // dateNext += 40;
    try {
      var operation = Amplify.API.query(
        request: GraphQLRequest(
          apiName: "Institution_API_NEW",
          document: """
      query getInstitutionCommentBoardTable(\$USER_ID: String!, \$BOARD_ID: String!) {
       getInstitutionCommentBoardTable(USER_ID: \$USER_ID, BOARD_ID: \$BOARD_ID)
        {
	                  BOARD_ID
	                  USER_ID
	                  WRITER
	                  CONTENT
	                  TITLE
	                  USERNAME
	                  INSTITUTION_ID
	                  NEW_CONVERSATION_PROTECTOR
	                  NEW_CONVERSATION_INST
	                  NEW_CONVERSATION_CREATEDAT
	                  createdAt
	                  updatedAt
          
        }
      }
    """,
          variables: {"USER_ID": user_id, "BOARD_ID": board_id},
        ),
      );

      var response = await operation.response;
      {
        print(response.data);
        if (response.data == null) {
          safePrint('errors: ${response.errors}');
          return null;
        }
        InstitutionCommentBoardTable comment =
            InstitutionCommentBoardTable.fromJson(
                jsonDecode(response.data)['getInstitutionCommentBoardTable']);
        if (comment == null) {
          print('errors: ${response.errors}');
          return null;
        }
        return comment;
      }
    } on ApiException catch (e) {
      print('Query failed: $e');
      return null;
    }
  }

  Future<bool?> updateCommentBoarddata(
      String user_id, String board_id, String title, String content) async {
    final time = '${TemporalDateTime.now()}';
    final row = {
      'USER_ID': user_id,
      'BOARD_ID': board_id,
      'CONTENT': content,
      'TITLE': title,
      'updatedAt': time
    };
    try {
      final response = await Amplify.API
          .mutate(
            request: GraphQLRequest<String>(
              apiName: "Institution_API_NEW",
              variables: {
                'input': row,
              },
              document: '''
            mutation updateInstitutionCommentBoardTable(\$input: UpdateInstitutionCommentBoardTableInput!) {
                  updateInstitutionCommentBoardTable(input: \$input) {
	                  BOARD_ID
	                  USER_ID
	                  CONTENT
	                  INSTITUTION_ID
	                  TITLE
	                  updatedAt
               }  
              }
            ''',
            ),
          )
          .response;
      {
        final updatedData = response.data;
        if (updatedData == null ||
            jsonDecode(updatedData!)['updateInstitutionCommentBoardTable'] ==
                null) {
          safePrint('errors: ${response.errors}');
          return false;
        }
        safePrint('Mutation result: ${updatedData.toString()}');
        // print('User created successfully: ${response.data}');;
        return true;
      }
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
      return false;
    }
  }

  Future<bool?> deleteCommentBoarddata(
    String user_id,
    String board_id,
  ) async {
    final row = {
      'USER_ID': user_id,
      'BOARD_ID': board_id,
    };
    try {
      final response = await Amplify.API
          .mutate(
            request: GraphQLRequest<String>(
              apiName: "Institution_API_NEW",
              document: '''
            mutation deleteInstitutionCommentBoardTable(\$input: DeleteInstitutionCommentBoardTableInput!) {
                  deleteInstitutionCommentBoardTable(input: \$input) {
                    USER_ID
                    BOARD_ID
                    INSTITUTION_ID
               }  
              }
            ''',
              variables: {
                'input': row,
              },
            ),
          )
          .response;
      {
        final deletedData = response.data;
        if (deletedData == null ||
            jsonDecode(deletedData!)['deleteInstitutionCommentBoardTable'] ==
                null) {
          safePrint('errors: ${response.errors}');
          return false;
        }
        safePrint('Mutation result: ${deletedData.toString()}');
        // print('User created successfully: ${response.data}');;
        return true;
      }
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
      return false;
    }
  }

  // 상세 코멘트 보기 페이지 (Detail_comment.dart)에서 댓글을 위한 함수들 (conversation = 댓글)
  Future<bool?> createCommentConversationdata(
      String board_id, String writer, String content, String email) async {
    final time = '${TemporalDateTime.now()}';
    // print('time :${DateTime.now()}');
    // print('time :${DateTime.parse(time).toLocal()}');
    final row = {
      'BOARD_ID': board_id,
      'CONVERSATION_ID': time,
      'CONTENT': content,
      'WRITER': writer,
      'EMAIL': email,
      'createdAt': time,
      'updatedAt': time
    };
    try {
      final response = await Amplify.API
          .mutate(
            request: GraphQLRequest<String>(
              apiName: "Institution_API_NEW",
              variables: {
                'input': row,
              },
              document: '''
            mutation createInstitutionCommentConversationTable(\$input: CreateInstitutionCommentConversationTableInput!) {
                  createInstitutionCommentConversationTable(input: \$input) {
	                  BOARD_ID
	                  CONVERSATION_ID
	                  WRITER
	                  CONTENT
	                  EMAIL
	                  createdAt
	                  updatedAt
               }  
              }
            ''',
            ),
          )
          .response;
      {
        final createdData = response.data;
        if (createdData == null ||
            jsonDecode(createdData!)[
                    'createInstitutionCommentConversationTable'] ==
                null) {
          safePrint('errors: ${response.errors}');
          return false;
        }
        safePrint('Mutation result: ${createdData.toString()}');
        // print('User created successfully: ${response.data}');;
        return true;
      }
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
      return false;
    }
  }

  // 특정 코멘트의 댓글들 불러오기
  Future<List<InstitutionCommentConversationTable?>>
      listInstitutionCommentConversation(String boardId,
          {String? nextToken}) async {
    try {
      var operation = Amplify.API.query(
        request: GraphQLRequest(
          apiName: "Institution_API_NEW",
          document: """
          query ListInstitutionCommentConversationTables(\$filter: TableInstitutionCommentConversationTableFilterInput, \$limit: Int, \$nextToken: String) {
            listInstitutionCommentConversationTables(
              filter: \$filter,
              limit: \$limit,
              nextToken: \$nextToken
            ) {
              items {
                BOARD_ID
                CONVERSATION_ID
                WRITER
                CONTENT
                EMAIL
                createdAt
                updatedAt
              }
              nextToken
            }
          }
        """,
          variables: {
            "filter": {
              "BOARD_ID": {"eq": boardId},
            },
            "limit": 1000,
            "nextToken": nextToken,
          },
        ),
      );

      var response = await operation.response;
      {
        var data = jsonDecode(response.data);
        var items = data['listInstitutionCommentConversationTables']['items'];

        if (items == null || response.data == null) {
          print('errors: ${response.errors}');
          return const [];
        }
        List<InstitutionCommentConversationTable?> conversations = (items
                as List)
            .map((item) => InstitutionCommentConversationTable.fromJson(item))
            .toList();
        var newNextToken =
            data['listInstitutionCommentConversationTables']['nextToken'];
        // print('nullcheck : $newNextToken');
        if (newNextToken != null) {
          // recursive call for next page's data
          var nextConversations = await listInstitutionCommentConversation(
              boardId,
              nextToken: newNextToken);
          conversations.addAll(nextConversations!);
        }

        return conversations;
      }
    } on ApiException catch (e) {
      print('Query failed: $e');
      return const [];
    }
  }

  Stream<GraphQLResponse>? subscribeInstitutionCommentConversation() {
    try {
      var operation = Amplify.API.subscribe(
        GraphQLRequest(
          apiName: "Institution_API_NEW",
          document: """
     subscription onsubscribeInstitutionCommentConversationTable {
        onsubscribeInstitutionCommentConversationTable {
	            	    BOARD_ID
	                  CONVERSATION_ID
	                  WRITER
	                  CONTENT
	                  EMAIL
	                  createdAt
	                  updatedAt
        }
      }
    """,
        ),
        onEstablished: () {
          print("subscription success");
        },
      ).handleError(
        (Object error) {
          safePrint('Error in subscription stream: $error');
        },
      );

      return operation;
    } on ApiException catch (e) {
      print('Query failed: $e');
      return null;
    }
  }

  Future<bool?> updateCommentConversationdata(
    String board_id,
    String conversation_id,
    String content,
  ) async {
    final time = '${TemporalDateTime.now()}';
    final row = {
      'BOARD_ID': board_id,
      'CONVERSATION_ID': conversation_id,
      'CONTENT': content,
      'updatedAt': time
    };
    try {
      final response = await Amplify.API
          .mutate(
            request: GraphQLRequest<String>(
              apiName: "Institution_API_NEW",
              variables: {
                'input': row,
              },
              document: '''
            mutation updateInstitutionCommentConversationTable(\$input: UpdateInstitutionCommentConversationTableInput!) {
                  updateInstitutionCommentConversationTable(input: \$input) {
	            	    BOARD_ID
	                  CONVERSATION_ID
	                  WRITER
	                  CONTENT
	                  EMAIL
	                  createdAt
	                  updatedAt
               }  
              }
            ''',
            ),
          )
          .response;
      {
        final updatedData = response.data;
        if (updatedData == null ||
            jsonDecode(updatedData!)[
                    'updateInstitutionCommentConversationTable'] ==
                null) {
          safePrint('errors: ${response.errors}');
          return false;
        }
        safePrint('Mutation result: ${updatedData.toString()}');
        // print('User created successfully: ${response.data}');;
        return true;
      }
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
      return false;
    }
  }

  Future<bool?> deleteCommentConversationdata(
    String board_id,
    String conversation_id,
  ) async {
    final time = '${TemporalDateTime.now()}';
    final row = {
      'BOARD_ID': board_id,
      'CONVERSATION_ID': conversation_id,
    };
    try {
      final response = await Amplify.API
          .mutate(
            request: GraphQLRequest<String>(
              apiName: "Institution_API_NEW",
              variables: {
                'input': row,
              },
              document: '''
            mutation deleteInstitutionCommentConversationTable(\$input: DeleteInstitutionCommentConversationTableInput!) {
                  deleteInstitutionCommentConversationTable(input: \$input) {
	            	    BOARD_ID
	                  CONVERSATION_ID
	                  WRITER
	                  CONTENT
	                  EMAIL
	                  createdAt
	                  updatedAt
               }  
              }
            ''',
            ),
          )
          .response;
      {
        final deletedData = response.data;
        if (deletedData == null ||
            jsonDecode(deletedData!)[
                    'deleteInstitutionCommentConversationTable'] ==
                null) {
          safePrint('errors: ${response.errors}');
          return false;
        }
        safePrint('Mutation result: ${deletedData.toString()}');
        // print('User created successfully: ${response.data}');;
        return true;
      }
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
      return false;
    }
  }

  //기관에서 최신 댓글을 달았음을 NEW_CONVERSATION_INST column을 true로 표시하도록 업데이트
  Future<bool?> updateCommentBoarddataForNewConversation(
      String user_id, String board_id) async {
    final time = '${TemporalDateTime.now()}';
    final row = {
      'USER_ID': user_id,
      'BOARD_ID': board_id,
      'NEW_CONVERSATION_INST': true,
      'NEW_CONVERSATION_CREATEDAT': time
    };
    try {
      final response = await Amplify.API
          .mutate(
            request: GraphQLRequest<String>(
              apiName: "Institution_API_NEW",
              variables: {
                'input': row,
              },
              document: '''
            mutation updateInstitutionCommentBoardTable(\$input: UpdateInstitutionCommentBoardTableInput!) {
                  updateInstitutionCommentBoardTable(input: \$input) {
	                  BOARD_ID
	                  USER_ID
	                  NEW_CONVERSATION_PROTECTOR
	                  NEW_CONVERSATION_INST
	                  NEW_CONVERSATION_CREATEDAT
               }  
              }
            ''',
            ),
          )
          .response;
      {
        final updatedData = response.data;
        if (updatedData == null ||
            jsonDecode(updatedData!)['updateInstitutionCommentBoardTable'] ==
                null) {
          safePrint('errors: ${response.errors}');
          return false;
        }
        safePrint('Mutation result: ${updatedData.toString()}');
        // print('User created successfully: ${response.data}');;
        return true;
      }
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
      return false;
    }
  }

  // 보호자가 최신 댓글 단 코멘트를 기관이 읽었음을 저장하기 위한 함수
  Future<bool?> updateCommentBoarddataForReadConversation(
      String user_id, String board_id) async {
    final time = '${TemporalDateTime.now()}';
    final row = {
      'USER_ID': user_id,
      'BOARD_ID': board_id,
      'NEW_CONVERSATION_PROTECTOR': false,
    };
    try {
      final response = await Amplify.API
          .mutate(
            request: GraphQLRequest<String>(
              apiName: "Institution_API_NEW",
              variables: {
                'input': row,
              },
              document: '''
            mutation updateInstitutionCommentBoardTable(\$input: UpdateInstitutionCommentBoardTableInput!) {
                  updateInstitutionCommentBoardTable(input: \$input) {
	                  BOARD_ID
	                  USER_ID
	                  NEW_CONVERSATION_PROTECTOR
	                  NEW_CONVERSATION_INST
	                  NEW_CONVERSATION_CREATEDAT
	                  INSTITUTION_ID
               }  
              }
            ''',
            ),
          )
          .response;
      {
        final updatedData = response.data;
        if (updatedData == null ||
            jsonDecode(updatedData!)['updateInstitutionCommentBoardTable'] ==
                null) {
          safePrint('errors: ${response.errors}');
          return false;
        }
        safePrint('Mutation result: ${updatedData.toString()}');
        // print('User created successfully: ${response.data}');;
        return true;
      }
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
      return false;
    }
  }

  Future<List<MonthlyBrainSignalTable?>> queryMonthlyDBLatestItem(
      {required String ID, String? nextToken}) async {
    int currentMonth = DateTime.now().month;
    int day = DateTime.now().day;
    String currentDate =
        '${DateTime.now().year}${currentMonth > 9 ? currentMonth : '0$currentMonth'}40';
    String compareDate =
        '${DateTime.now().year - 1}${currentMonth > 9 ? currentMonth : '0$currentMonth'}01';
    print(currentDate);
    try {
      // var ID = '1';

      var operation = Amplify.API.query(
        request: GraphQLRequest(
          apiName: "Institution_API_NEW",
          document: """
          query listMonthlyBrainSignalTables(\$filter: TableMonthlyBrainSignalTableFilterInput, \$limit: Int, \$nextToken: String) {
            listMonthlyBrainSignalTables(
              filter: \$filter,
              limit: \$limit,
              nextToken: \$nextToken
            ) {
              items {
                id
                month
                total_time
                avg_att
                avg_med
                firsts_name
                first_amt
                second_name
                second_amt
                con_score
                spacetime_score
                exec_score
                mem_score
                ling_score
                cal_score
                reac_score
                orient_score
                createdAt
                updatedAt
              }
              nextToken
            }
          }
        """,
          variables: {
            "filter": {
              "id": {"eq": ID},
              "month": {
                "between": [compareDate, currentDate]
              },
            },
            "limit": 1000,
            "nextToken": nextToken,
          },
        ),
      );

      var response = await operation.response;
      {
        // print("asdf");
        // print(response.data);
        // print("1234");

        var data = jsonDecode(response.data);
        var items = data['listMonthlyBrainSignalTables']['items'];

        if (items == null || response.data == null) {
          print('errors: ${response.errors}');
          return const [];
        }
        // Handle items as needed
        List<MonthlyBrainSignalTable?> monthlyDBTests = (items as List)
            .map((item) => MonthlyBrainSignalTable.fromJson(item))
            .toList();
        var newNextToken = data['listMonthlyBrainSignalTables']['nextToken'];

        if (newNextToken != null) {
          // recursive call for next page's data
          var additionalItems =
              await queryMonthlyDBLatestItem(ID: ID, nextToken: newNextToken);
          monthlyDBTests.addAll(additionalItems);
        }

        return monthlyDBTests;
      }
    } on ApiException catch (e) {
      print('Query failed: $e');
      return const [];
    }
  }

  //개별 분석 보고서 페이지에서 같은 나이대의 훈련자들의 데이터를 불러오기
  Future<List<UserTable?>> queryListUserDBItemsForAverageAge(int start, int end,
      {String? nextToken}) async {
    try {
      var operation = Amplify.API.query(
        request: GraphQLRequest(
          apiName: "Institution_API_NEW",
          document: """
          query ListUserTables(\$filter: TableUserTableFilterInput, \$limit: Int, \$nextToken: String) {
            listUserTables(
              filter: \$filter,
              limit: \$limit,
              nextToken: \$nextToken
            ) {
              items {
                ID
                BIRTH
                CREATEDAT
                INSTITUTION
                INSTITUTION_ID
                NAME
                SEX
                UPDATEDAT
              }
              nextToken
            }
          }
        """,
          variables: {
            "filter": {
              // "INSTITUTION_ID": {"eq":  institutionId},
              "BIRTH": {
                "between": [start, end]
              },
            },
            "limit": 1000,
            "nextToken": nextToken,
          },
        ),
      );

      var response = await operation.response;
      {
        var data = jsonDecode(response.data);
        var items = data['listUserTables']['items'];
        if (response.data == null || items == null) {
          print('errors: ${response.errors}');
          return const [];
        }

        List<UserTable?> Users =
            (items as List).map((item) => UserTable.fromJson(item)).toList();
        var newNextToken = data['listUserTables']['nextToken'];

        if (newNextToken != null) {
          // recursive call for next page's data
          var nextUsers = await queryListUserDBItemsForAverageAge(start, end,
              nextToken: newNextToken);
          Users.addAll(nextUsers);
        }

        return Users;
      }
    } on ApiException catch (e) {
      print('Query failed: $e');
      return const [];
    }
  }

  //개별 분석 보고서에서 특정 유저(훈련자)의 인지 훈련 데이터 불러오기
  Future<List<MonthlyBrainSignalTable?>> queryMonthlyDBRequiredItem(
      String selectedAgeUserId, int yearMonth,
      {String? nextToken}) async {
    try {
      // var ID = '1';

      var operation = Amplify.API.query(
        request: GraphQLRequest(
          apiName: "Institution_API_NEW",
          document: """
          query listMonthlyBrainSignalTables(\$filter: TableMonthlyBrainSignalTableFilterInput, \$limit: Int, \$nextToken: String) {
            listMonthlyBrainSignalTables(
              filter: \$filter,
              limit: \$limit,
              nextToken: \$nextToken
            ) {
              items {
                id
                month
                total_time
                avg_att
                avg_med
                firsts_name
                first_amt
                second_name
                second_amt
                con_score
                spacetime_score
                exec_score
                mem_score
                ling_score
                cal_score
                reac_score
                orient_score
                createdAt
                updatedAt
              }
              nextToken
            }
          }
        """,
          variables: {
            "filter": {
              "id": {"eq": selectedAgeUserId},
              "month": {
                "between": [yearMonth.toString(), (yearMonth + 40).toString()]
              },
            },
            "limit": 1000,
            "nextToken": nextToken,
          },
        ),
      );

      var response = await operation.response;
      {
        print("asdf");
        print(response.data);
        print("1234");

        var data = jsonDecode(response.data);
        var items = data['listMonthlyBrainSignalTables']['items'];

        if (items == null || response.data == null) {
          print('errors: ${response.errors}');
          return const [];
        }
        // Handle items as needed
        List<MonthlyBrainSignalTable?> monthlyDBTests = (items as List)
            .map((item) => MonthlyBrainSignalTable.fromJson(item))
            .toList();
        var newNextToken = data['listMonthlyBrainSignalTables']['nextToken'];

        if (newNextToken != null) {
          // recursive call for next page's data
          var additionalItems = await queryMonthlyDBRequiredItem(
              selectedAgeUserId, yearMonth,
              nextToken: newNextToken);
          monthlyDBTests.addAll(additionalItems);
        }

        return monthlyDBTests;
      }
    } on ApiException catch (e) {
      print('Query failed: $e');
      return const [];
    }
  }
}
