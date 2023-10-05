import 'dart:convert';

import 'package:amplify_core/amplify_core.dart';
import 'package:aws_frame_institution/models/InstitutionAnnouncementTable.dart';
import 'package:aws_frame_institution/models/ModelProvider.dart';
import 'package:flutter/material.dart';

//needed when using queryItem method
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'dart:math';

class GraphQLController {
  GraphQLController();

  static final _Obj = GraphQLController();

  static get Obj => _Obj;

  //user
  var birth = 19640101;
  var userid = "1";
  var useridint = 2;

  //brain signal
  var brainmonth = "20230101";

  Future<void> createUserData() async {
    final user = {
      'ID': userid, // Replace with a unique ID for the new user
      'BIRTH': '${birth}',
      'INSTITUTION': 'University XYZ',
      'INSTITUTION_ID': '123',
      'NAME': 'John Doe',
      'SEX': 'Male',
      'CREATEDAT' : '${TemporalDateTime.now()}',
      'UPDATEDAT' : '${TemporalDateTime.now()}'
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
      final response = await Amplify.API.mutate(
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
      ).response;
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

  Future<void> createAnnounceData() async {
    final row = {
      'ANNOUNCEMENT_ID': userid,
      'CONTENT': 'fdfdf',
      'IMAGE': 'dfdf',
      'INSTITUTION': 'String',
      'INSTITUTION_ID': 'String!',
      'TITLE': 'String',
      'URL': 'String',
      'createdAt' : '${TemporalDateTime.now()}',
      'updatedAt' : '${TemporalDateTime.now()}'
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
      final response = await Amplify.API.mutate(
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
      ).response;
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



  //공지사항용
  Future<void> createAnnouncement(String content, String image, String institution, String institution_id, String title, String url, userId) async {
    final row = {
      'ANNOUNCEMENT_ID': userId,
      'CONTENT': content,
      'IMAGE': image,
      'INSTITUTION': institution,
      'INSTITUTION_ID': institution_id,
      'TITLE': title,
      'URL': url,
      'createdAt' : '${TemporalDateTime.now()}',
      'updatedAt' : '${TemporalDateTime.now()}'
    };
    try {
      final response = await Amplify.API.mutate(
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
      ).response;
      {
        final createdData = response.data;
        if (createdData == null) {
          safePrint('errors: ${response.errors}');
          return;
        }
        safePrint('Mutation result: ${createdData.toString()}');
        // print('User created successfully: ${response.data}');;
        useridint++;
        userid = "$useridint";
      }
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
    }
  }

  Future<void> updateAnnouncement({required String announcementId, required String content, required String image, required String institution, required String institution_id, required String title, required String url}) async {
    final row = {
      'ANNOUNCEMENT_ID': announcementId,
      'CONTENT': content,
      'IMAGE': image,
      'INSTITUTION': institution,
      'INSTITUTION_ID': institution_id,
      'TITLE': title,
      'URL': url,
      'updatedAt' : '${TemporalDateTime.now()}'
    };

    try {
      final response = await Amplify.API.mutate(
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

      ).response;

      final updatedData = response.data;
      if (updatedData == null) {
        safePrint('errors: ${response.errors}');
        return;
      }
      safePrint('Mutation result: ${updatedData.toString()}');

    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
    }
  }

  Future<void> deleteAnnouncement({required String institution_id, required String announcementId}) async {
    final row = {
      'INSTITUTION_ID': institution_id,
      'ANNOUNCEMENT_ID': announcementId,
    };

    try {
      final response = await Amplify.API.mutate(
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

      ).response;

      final deletedData = response.data;
      if (deletedData == null) {
        safePrint('errors: ${response.errors}');
        return;
      }
      safePrint('Mutation result: ${deletedData.toString()}');

    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
    }
  }




  //공지사항용
  Future<void> createEssentialCare(String age,String name, String image,String phoneNumber,String institution, String institution_id, String medicationWay, String medication, String userId) async {
    //todo 이미지가 없넹...
    print(age);
    print(name);
    print(phoneNumber);
    print(institution);

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
      'createdAt' : '${TemporalDateTime.now()}',
      'updatedAt' : '${TemporalDateTime.now()}'
    };
    try {
      final response = await Amplify.API.mutate(
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
      ).response;
      {
        final createdData = response.data;
        if (createdData == null) {
          safePrint('errors: ${response.errors}');
          return;
        }
        safePrint('Mutation result: ${createdData.toString()}');
        // print('User created successfully: ${response.data}');;
        useridint++;
        userid = "$useridint";
      }
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
    }
  }

//news
  Future<void> createInstitutionNews(String content, String image, String institution, String New_id, String title, String url) async {
    final row = {
      'NEWS_ID': userid,
      'CONTENT': content,
      'IMAGE': image,
      'INSTITUTION': institution,
      'INSTITUTION_ID': New_id,
      'TITLE': title,
      'URL': url,
      'createdAt' : '${TemporalDateTime.now()}',
      'updatedAt' : '${TemporalDateTime.now()}'
    };
    try {
      final response = await Amplify.API.mutate(
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
      ).response;
      {
        final createdData = response.data;
        if (createdData == null) {
          safePrint('errors: ${response.errors}');
          return;
        }
        safePrint('Mutation result: ${createdData.toString()}');
        // print('User created successfully: ${response.data}');;
        useridint++;
        userid = "$useridint";
      }
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
    }
  }
  Future<void> updateInstitutionNews({required String newsId, required String content, required String image, required String institution, required String institution_id, required String title, required String url}) async {
    final row = {
      'NEWS_ID': newsId,
      'CONTENT': content,
      'IMAGE': image,
      'INSTITUTION': institution,
      'INSTITUTION_ID': institution_id,
      'TITLE': title,
      'URL': url,
      'updatedAt' : '${TemporalDateTime.now()}'
    };

    try {
      final response = await Amplify.API.mutate(
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

      ).response;

      final updatedData = response.data;
      if (updatedData == null) {
        safePrint('errors: ${response.errors}');
        return;
      }
      safePrint('Mutation result: ${updatedData.toString()}');

    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
    }
  }

  Future<void> deleteInstitutionNews({required String institutionId, required String newsId}) async {
    final row = {
      'INSTITUTION_ID': institutionId,
      'NEWS_ID': newsId,
    };

    try {
      final response = await Amplify.API.mutate(
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

      ).response;

      final deletedData = response.data;
      if (deletedData == null) {
        safePrint('errors: ${response.errors}');
        return;
      }
      safePrint('Mutation result: ${deletedData.toString()}');

    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
    }
  }



  Future<void> createFoodMenu(String dateTime, String imageUrl, String institutionId) async {
    final row = {
      'DATE': dateTime,
      'IMAGE_URL': imageUrl,
      'INSTITUTION_ID': institutionId,
      'createdAt' : '${TemporalDateTime.now()}',
      'updatedAt' : '${TemporalDateTime.now()}'
    };
    try {
      final response = await Amplify.API.mutate(
        request: GraphQLRequest<String>(
          document: '''
            mutation createInstitutionFoodMenuTable(\$input: CreateInstitutionFoodMenuTableInput!) {
                  createInstitutionFoodMenuTable(input: \$input) {
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
      ).response;
      {
        final createdData = response.data;
        if (createdData == null) {
          safePrint('errors: ${response.errors}');

        }
        if (createdData.toString() == "{\"createInstitutionFoodMenuTable\":null}"){
          return updateFoodMenu(dateTime, imageUrl, institutionId);
        }
        safePrint('Mutation result: ${createdData.toString()}');
      }
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
    }
  }
  Future<void> deleteFoodMenu({required String dateTime, required String institutionId}) async {
    final row = {
      'DATE': dateTime,
      'INSTITUTION_ID': institutionId,
    };
    print("del");
    print(dateTime);
    print(institutionId);


    try {
      final response = await Amplify.API.mutate(
        request: GraphQLRequest<String>(
          document: '''
            mutation deleteInstitutionFoodMenuTable(\$input: DeleteInstitutionFoodMenuTableInput!) {
                  deleteInstitutionFoodMenuTable(input: \$input) {
                    INSTITUTION_ID
                    DATE
               }  
              } 
            ''',
          variables: {
            'input': row,
          },
        ),
      ).response;

      // final deletedData = response.data;
      // if (deletedData == null) {
      //   safePrint('errors: ${response.errors}');
      //   return;
      // }

      final deletedData = response.data;
      if (deletedData == null || jsonDecode(deletedData!)['deleteInstitutionFoodMenuTable'] ==
          null) {
        safePrint('errors: ${response.errors}');
        return ;
      }
      safePrint('Mutation result: ${deletedData.toString()}');
      // print('User created successfully: ${response.data}');;
      return ;


      safePrint('Mutation result: ${deletedData.toString()}');

    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
    }
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


  Future<void> updateFoodMenu(String dateTime, String imageUrl, String institutionId) async {
    //todo update날짜만 바꾸면 될 거 같은뎅..
    final row = {
      'DATE': dateTime,
      'IMAGE_URL': imageUrl,
      'INSTITUTION_ID': institutionId,
      'createdAt' : '${TemporalDateTime.now()}',
      'updatedAt' : '${TemporalDateTime.now()}'
    };
    try {
      final response = await Amplify.API.mutate(
        request: GraphQLRequest<String>(
          document: '''
            mutation updateInstitutionFoodMenuTable(\$input: UpdateInstitutionFoodMenuTableInput!) {
                  updateInstitutionFoodMenuTable(input: \$input) {
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
      ).response;
      {
        final updateData = response.data;
        if (updateData == null) {
          safePrint('errors: ${response.errors}');
          return;
        }
        safePrint('Mutation result: ${updateData.toString()}');
      }
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
    }
  }

  Future<void> createShuttleTime(String dateTime, String imageUrl, String institutionId) async {
    final row = {
      'DATE': dateTime,
      'IMAGE_URL': imageUrl,
      'INSTITUTION_ID': institutionId,
      'createdAt' : '${TemporalDateTime.now()}',
      'updatedAt' : '${TemporalDateTime.now()}'
    };
    try {
      final response = await Amplify.API.mutate(
        request: GraphQLRequest<String>(
          document: '''
            mutation createInstitutionShuttleTImeTable(\$input: CreateInstitutionShuttleTImeTableInput!) {
                  createInstitutionShuttleTImeTable(input: \$input) {
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
      ).response;
      {
        final createdData = response.data;
        if (createdData == null) {
          safePrint('errors: ${response.errors}');

        }
        if (createdData.toString() == "{\"createInstitutionShuttleTImeTable\":null}"){
          return updateShuttleTime(dateTime, imageUrl, institutionId);
        }
        safePrint('Mutation result: ${createdData.toString()}');
      }
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
    }
  }


  Future<void> deleteShuttleTime({required String dateTime, required String institutionId}) async {
    final row = {
      'DATE': dateTime,
      'INSTITUTION_ID': institutionId,
    };

    print("del");
    print(dateTime);
    print(institutionId);

    try {
      final response = await Amplify.API.mutate(
        request: GraphQLRequest<String>(
          document: '''
            mutation deleteInstitutionShuttleTImeTable(\$input: DeleteInstitutionShuttleTImeTableInput!) {
                  deleteInstitutionShuttleTImeTable(input: \$input) {
                    INSTITUTION_ID
                    DATE
               }  
              }
            ''',
          variables: {
            'input': row,
          },
        ),
      ).response;

      final deletedData = response.data;
      if (deletedData == null) {
        safePrint('errors: ${response.errors}');
        return;
      }

      safePrint('Mutation result: ${deletedData.toString()}');

    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
    }
  }


  Future<void> updateShuttleTime(String dateTime, String imageUrl, String institutionId) async {
    //todo update날짜만 바꾸면 될 거 같은뎅..
    final row = {
      'DATE': dateTime,
      'IMAGE_URL': imageUrl,
      'INSTITUTION_ID': institutionId,
      'createdAt' : '${TemporalDateTime.now()}',
      'updatedAt' : '${TemporalDateTime.now()}'
    };
    try {
      final response = await Amplify.API.mutate(
        request: GraphQLRequest<String>(
          document: '''
            mutation updateInstitutionShuttleTImeTable(\$input: UpdateInstitutionShuttleTImeTableInput!) {
                  updateInstitutionShuttleTImeTable(input: \$input) {
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

      ).response;
      {
        final updateData = response.data;
        if (updateData == null) {
          safePrint('errors: ${response.errors}');
          return;
        }
        safePrint('Mutation result: ${updateData.toString()}');
      }
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
    }
  }





  Future<List<InstitutionAnnouncementTable>> queryInstitutionAnnouncementsByInstitutionId(String institutionId) async {
    try {
      var operation = Amplify.API.query(
        request: GraphQLRequest(
          document: """
          query ListInstitutionAnnouncementTables(\$INSTITUTION_ID: String) {
            listInstitutionAnnouncementTables(filter: {INSTITUTION_ID: {eq: \$INSTITUTION_ID}}) {
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
            }
          }
        """,
          variables: {
            "INSTITUTION_ID": institutionId,
          },
        ),
      );

      var response = await operation.response;
      List<InstitutionAnnouncementTable> announcements =
      (jsonDecode(response.data)['listInstitutionAnnouncementTables']['items'] as List)
          .map((item) => InstitutionAnnouncementTable.fromJson(item))
          .toList();
      if (announcements == null) {
        print('errors: ${response.errors}');
        return const [];
      }
      return announcements;
    } on ApiException catch (e) {
      print('Query failed: $e');
      return const [];
    }
  }

  Future<List<InstitutionNewsTable>> queryInstitutionNewsByInstitutionId(String institutionId) async {
    try {
      var operation = Amplify.API.query(
        request: GraphQLRequest(
          document: """
          query ListInstitutionNewsTables(\$INSTITUTION_ID: String) {
            listInstitutionNewsTables(filter: {INSTITUTION_ID: {eq: \$INSTITUTION_ID}}) {
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
            }
          }
        """,
          variables: {
            "INSTITUTION_ID": institutionId,
          },
        ),
      );

      var response = await operation.response;
      List<InstitutionNewsTable> news =
      (jsonDecode(response.data)['listInstitutionNewsTables']['items'] as List)
          .map((item) => InstitutionNewsTable.fromJson(item))
          .toList();
      if (news == null) {
        print('errors: ${response.errors}');
        return const [];
      }
      return news;
    } on ApiException catch (e) {
      print('Query failed: $e');
      return const [];
    }
  }
  Future<void> updateEssentialCare(String age,String name, String image,String phoneNumber,String institution, String institution_id, String medicationWay, String medication, String userId) async {

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
      'createdAt' : '${TemporalDateTime.now()}',
      'updatedAt' : '${TemporalDateTime.now()}'
    };
    try {
      final response = await Amplify.API.mutate(
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
      ).response;
      {
        final updateData = response.data;
        if (updateData == null) {
          safePrint('errors: ${response.errors}');
          return;
        }
        safePrint('Mutation result: ${updateData.toString()}');
      }
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
    }
  }

  Future<void> deleteEssentialCare(String userId, String institutionId) async {
    final row = {
      'USER_ID': userId,
      'INSTITUTION_ID': institutionId,
    };

    try {
      final response = await Amplify.API.mutate(
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
      ).response;

      final deletedData = response.data;
      if (deletedData == null) {
        safePrint('errors: ${response.errors}');
        return;
      }

      safePrint('Mutation result: ${deletedData.toString()}');

    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
    }
  }



  Future<List<InstitutionEssentialCareTable>> queryEssentialCareInformationByInstitutionId(String institutionId) async {
    try {
      var operation = Amplify.API.query(
        request: GraphQLRequest(
          document: """
          query listInstitutionEssentialCareTables(\$INSTITUTION_ID: String) {
            listInstitutionEssentialCareTables(filter: {INSTITUTION_ID: {eq: \$INSTITUTION_ID}}) {
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
            }
          }
        """,
          variables: {
            "INSTITUTION_ID": institutionId,
          },
        ),
      );

      var response = await operation.response;

      List<InstitutionEssentialCareTable> essentialCare =
      (jsonDecode(response.data)['listInstitutionEssentialCareTables']['items'] as List)
          .map((item) => InstitutionEssentialCareTable.fromJson(item))
          .toList();

      if (essentialCare == null) {
        print('errors: ${response.errors}');
        return const [];
      }
      print(essentialCare);
      return essentialCare;
    } on ApiException catch (e) {
      print('Query failed: $e');
      return const [];
    }
  }


  Future<InstitutionFoodMenuTable?> queryFoodMenuByInstitutionIdAndDate(String institutionId, String date) async {
    try {

      var operation = Amplify.API.query(
        request: GraphQLRequest(
          document: """
          query ListInstitutionFoodMenuTables(\$INSTITUTION_ID: String, \$DATE: String) {
            listInstitutionFoodMenuTables(filter: {INSTITUTION_ID: {eq: \$INSTITUTION_ID}, DATE: {eq: \$DATE}}) {
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
          variables: {
            "INSTITUTION_ID": institutionId,
            "DATE": date
          },
        ),
      );
      var response = await operation.response;

      InstitutionFoodMenuTable foodMenu =
          (jsonDecode(response.data)['listInstitutionFoodMenuTables']['items'] as List)
              .map((item) => InstitutionFoodMenuTable.fromJson(item))
              .toList()
              .first;
      if (foodMenu == null) {
        print('errors: ${response.errors}');

        return null;
      }
      // print(foodMenu);
      return foodMenu;
    } on ApiException catch (e) {
      print('Query failed: $e');
      return  null;
    }
  }

  Future<InstitutionShuttleTImeTable?> queryShuttleTimeByInstitutionId(String institutionId, String date) async {
    print(institutionId);
    print(date);
    try {
      var operation = Amplify.API.query(
        request: GraphQLRequest(
          document: """
          query ListInstitutionShuttleTImeTables(\$INSTITUTION_ID: String, \$DATE: String) {
            listInstitutionShuttleTImeTables(filter: {INSTITUTION_ID: {eq: \$INSTITUTION_ID}, DATE: {eq: \$DATE}}) {
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
          variables: {
            "INSTITUTION_ID": institutionId,
            "DATE": date
          },
        ),
      );
      var response = await operation.response;
      print(response.data);
      var responseData = jsonDecode(response.data);
      List<dynamic> items = responseData['listInstitutionShuttleTImeTables']['items'];

      InstitutionShuttleTImeTable shuttleTime = InstitutionShuttleTImeTable.fromJson(items[0]);


      if (shuttleTime == null) {
        print('errors: ${response.errors}');

        return null;
      }
      print(shuttleTime);
      return shuttleTime;
    } on ApiException catch (e) {
      print('Query failed: $e');
      return  null;
    }
  }

  //todo 봉인!!!
  Future<MonthlyDBTestMsoytcsvrreplapznkyt6lt6saStaging?> queryMonthlyDBItem() async {
    try {
      var ID = '2';

      var operation = Amplify.API.query(
        request: GraphQLRequest(
          document: """
        query ListMonthlyDBTests(\$id: ID) {
          listMonthlyDBTests(
            filter: {id: {eq: \$id}
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
          }
        }
      """,
          variables: {
            "id": ID,
          },
        ),
      );

      var response = await operation.response;
      print("i love you");
      print(response.data);

      Map<String, dynamic> json = jsonDecode(response.data);
      MonthlyDBTestMsoytcsvrreplapznkyt6lt6saStaging monthlyDBTest =
          (json['listMonthlyDBTests']['items'] as List)
              .map((item) => MonthlyDBTestMsoytcsvrreplapznkyt6lt6saStaging.fromJson(item))
              .toList()
              .first;

      if (monthlyDBTest == null) {
        print('errors: ${response.errors}');
        return null;
      }
      print(monthlyDBTest);
      return monthlyDBTest;
    } on ApiException catch (e) {
      print('Query failed: $e');
      return null;
    }
  }


  Future<void> createMonthlyData() async {

    final row = {
      'id': "2",
      'month': "20231101",
      'avg_att': Random().nextInt(100) + 1,
      'avg_med': Random().nextInt(100) + 1,
      'con_score': Random().nextInt(100) + 1,
      'spacetime_score': Random().nextInt(100) + 1,
      'exec_score': Random().nextInt(100) + 1,
      'mem_score': Random().nextInt(100) + 1,
      'ling_score' : Random().nextInt(100) + 1,
      'cal_score' : Random().nextInt(100) + 1,
      'reac_score' : Random().nextInt(100) + 1,
      'orient_score' : Random().nextInt(100) + 1,
      'createdAt' : '${TemporalDateTime.now()}',
      'updatedAt' : '${TemporalDateTime.now()}'
    };

    try {
      final response = await Amplify.API.mutate(
        request: GraphQLRequest<String>(
          document: '''
            mutation CreateMonthlyDBTestMsoytcsvrreplapznkyt6lt6saStaging(\$input: CreateMonthlyDBTestMsoytcsvrreplapznkyt6lt6saStagingInput!) {
                  createMonthlyDBTestMsoytcsvrreplapznkyt6lt6saStaging(input: \$input) {
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
      ).response;
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

/*  ----------- jinsu method ------------------        */

  Future<bool?> createScheduledata(
      String institution,
      String inst_id,
      String schedule_id,
      String content,
      String tag,
      String time,
      String date) async {
    final row = {
      'INSTITUTION': institution,
      'INSTITUTION_ID': inst_id,
      'SCHEDULE_ID': schedule_id,
      'CONTENT': content,
      'TAG': tag,
      'TIME': time,
      'DATE': date,
      'createdAt': '${TemporalDateTime.now()}',
      'updatedAt': '${TemporalDateTime.now()}'
    };
    try {
      final response = await Amplify.API
          .mutate(
        request: GraphQLRequest<String>(
          document: '''
            mutation createInstitutionScheduleTable(\$input: CreateInstitutionScheduleTableInput!) {
                  createInstitutionScheduleTable(input: \$input) {
                    INSTITUTION
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
      ).response;
      {
        final createdData = response.data;
        if (jsonDecode(createdData!)['createInstitutionScheduleTable'] ==
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

  Future<List<InstitutionScheduleTable>>
  queryInstitutionScheduleByInstitutionId(String institutionId,String date) async {
    String inst_id = 'aaa';
    int dateNext = int.parse(date);
    dateNext += 40;
    try {
      var operation = Amplify.API.query(
        request: GraphQLRequest(
          document: """
      query listInstitutionScheduleTables(\$filter: TableInstitutionScheduleTableFilterInput) {
        listInstitutionScheduleTables(
          filter: \$filter,
        ) {
          items {
                    INSTITUTION
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
      }
    """,
          variables: {
            "filter": {
              "INSTITUTION_ID": {"eq": institutionId},
              "DATE": {"between": [date,'$dateNext']}
            },
          },
        ),
      );

      var response = await operation.response;
      List<InstitutionScheduleTable> schedules =
      (jsonDecode(response.data)['listInstitutionScheduleTables']['items']
      as List)
          .map((item) => InstitutionScheduleTable.fromJson(item))
          .toList();
      if (schedules == null) {
        print('errors: ${response.errors}');
        return const [];
      }
      return schedules;
    } on ApiException catch (e) {
      print('Query failed: $e');
      return const [];
    }
  }
  Future<List<InstitutionScheduleTable>>
  subscribeInstitutionScheduleByInstitutionId(String institutionId) async {
    String inst_id = 'aaa';
    try {
      var operation = Amplify.API.query(
        request: GraphQLRequest(
          document: """
      query listInstitutionScheduleTables(\$filter: TableInstitutionScheduleTableFilterInput) {
        listInstitutionScheduleTables(
          filter: \$filter,
        ) {
          items {
                    INSTITUTION
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
      }
    """,
          variables: {
            "filter": {
              "INSTITUTION_ID": {"eq": institutionId}
            },
          },
        ),
      );

      var response = await operation.response;
      List<InstitutionScheduleTable> schedules =
      (jsonDecode(response.data)['listInstitutionScheduleTables']['items']
      as List)
          .map((item) => InstitutionScheduleTable.fromJson(item))
          .toList();
      if (schedules == null) {
        print('errors: ${response.errors}');
        return const [];
      }
      return schedules;
    } on ApiException catch (e) {
      print('Query failed: $e');
      return const [];
    }
  }

  Future<bool?> updateScheduledata(
      String institution,
      String inst_id,
      String sche_id,
      String content,
      String tag,
      String time,
      String date) async {
    final row = {
      'INSTITUTION': institution,
      'INSTITUTION_ID': inst_id,
      'SCHEDULE_ID': sche_id,
      'CONTENT': content,
      'TAG': tag,
      'TIME': time,
      'DATE': date,
      'createdAt': '${TemporalDateTime.now()}',
      'updatedAt': '${TemporalDateTime.now()}'
    };
    // final condition = {
    //   'INSTITUTION_ID': {'eq': inst_id},
    //   'SCHEDULE_ID': {'eq': sche_id}
    // };
    try {

      final response = await Amplify.API.mutate(
        request: GraphQLRequest<String>(
          document: '''
          mutation updateInstitutionScheduleTable(\$input: UpdateInstitutionScheduleTableInput!) {
            updateInstitutionScheduleTable(input: \$input) {
              INSTITUTION
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
            'input': row
          },
        ),
      ).response;
      {
        final updatedData = response.data;
        if (updatedData == null || jsonDecode(updatedData!)['updateInstitutionScheduleTable'] ==
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
      String inst_id,
      String schedule_id,
      ) async {
    final row = {'INSTITUTION_ID': inst_id, 'SCHEDULE_ID': schedule_id};
    try {
      final response = await Amplify.API
          .mutate(
        request: GraphQLRequest<String>(
          document: '''
            mutation deleteInstitutionScheduleTable(\$input: DeleteInstitutionScheduleTableInput!) {
                  deleteInstitutionScheduleTable(input: \$input) {
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
        if (jsonDecode(deletedData!)['deleteInstitutionScheduleTable'] ==
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
  // Future<void> createMonthlyData() async {
  //   try {
  //     final row = MonthlyDBTest(
  //       id: "3",
  //       month: brainmonth,
  //       avg_att: Random().nextInt(100) + 1,
  //       avg_med: Random().nextInt(100) + 1,
  //       con_score: Random().nextInt(100) + 1,
  //       spacetime_score: Random().nextInt(100) + 1,
  //       exec_score: Random().nextInt(100) + 1,
  //       mem_score: Random().nextInt(100) + 1,
  //       ling_score: Random().nextInt(100) + 1,
  //       cal_score: Random().nextInt(100) + 1,
  //       reac_score: Random().nextInt(100) + 1,
  //       orient_score: Random().nextInt(100) + 1,
  //     );
  //     final request = ModelMutations.create(row);
  //     final response = await Amplify.API.mutate(request: request).response;
  //     int month = int.parse(brainmonth);
  //     month += 100;
  //     brainmonth = "$month";
  //
  //     final createdUser = response.data;
  //     if (createdUser == null) {
  //       safePrint('errors: ${response.errors}');
  //       return;
  //     }
  //     safePrint('Mutation result: ${createdUser.month}');
  //   } on ApiException catch (e) {
  //     safePrint('Mutation failed: $e');
  //   }
  // }

  // Future<MonthlyDBTest?> queryMonthlyDBItem() async {
  //   try {
  //     var ID = '3';
  //     int limit =
  //         1; // Fetch the latest 1 data items, you can change this value to fetch more or less
  //     String sortDirection =
  //         "DESC"; // Set to "ASC" for ascending order, or "DESC" for descending order
  //
  //     var operation = Amplify.API.query(
  //       request: GraphQLRequest(
  //         document: """
  //         query ListMonthlyDBTests(\$id: ID, \$limit: Int, \$sortDirection: ModelSortDirection) {
  //           listMonthlyDBTests(
  //             id: \$id,
  //             limit: \$limit,
  //             sortDirection: \$sortDirection
  //           ) {
  //             items {
  //               id
  //               month
  //               total_time
  //               avg_att
  //               avg_med
  //               firsts_name
  //               first_amt
  //               second_name
  //               second_amt
  //               con_score
  //               spacetime_score
  //               exec_score
  //               mem_score
  //               ling_score
  //               cal_score
  //               reac_score
  //               orient_score
  //               createdAt
  //               updatedAt
  //             }
  //           }
  //         }
  //       """,
  //         variables: {
  //           "id": ID,
  //           "limit": limit,
  //           "sortDirection": sortDirection,
  //         },
  //       ),
  //     );
  //
  //     var response = await operation.response;
  //     // print(response.data);
  //     // Map<String, dynamic> json = jsonDecode(response.data);
  //     // in Dart, you can use the jsonDecode function from the dart:convert library. The jsonDecode function parses a JSON string and returns the corresponding Dart object.
  //     MonthlyDBTest monthlyDBTest =
  //         (jsonDecode(response.data)['listMonthlyDBTests']['items'] as List)
  //             .map((item) => MonthlyDBTest.fromJson(item))
  //             .toList()
  //             .first;
  //     if (monthlyDBTest == null) {
  //       safePrint('errors: ${response.errors}');
  //       // safePrint('errors: ${response}');
  //     }
  //     return monthlyDBTest;
  //   } on ApiException catch (e) {
  //     safePrint('Query failed: $e');
  //     return null;
  //   }
  // }
  //
  // // Future<List<MonthlyDBTest?>> queryListMonthlyDBItems(int yearMonth) async {
  // //   var ID = '3';
  // //   // final queryPredicate = MonthlyDBTest.ID.eq(ID);
  // //   //20240211- 10000 + 50
  // //   //if( yearmonth >  )2
  // //   print("yearmonth:${yearMonth - 10000 + 50}");
  // //   final queryPredicateDateMax = MonthlyDBTest.MONTH.le("$yearMonth");
  // //   final queryPredicateDatemin =
  // //       MonthlyDBTest.MONTH.gt("${yearMonth - 10000 + 50}");
  // //   final queryPredicateall = MonthlyDBTest.ID
  // //       .eq(ID)
  // //       .and(queryPredicateDateMax)
  // //       .and(queryPredicateDatemin);
  // //
  // //   try {
  // //     final request = ModelQueries.list<MonthlyDBTest>(MonthlyDBTest.classType,
  // //         where: queryPredicateall);
  // //     final response = await Amplify.API.query(request: request).response;
  // //
  // //     final items = response.data?.items;
  // //     if (items == null) {
  // //       print('errors: ${response.errors}');
  // //       return const [];
  // //     }
  // //     return items;
  // //   } on ApiException catch (e) {
  // //     print('Query failed: $e');
  // //     return const [];
  // //   }
  // // }
  //
  Future<List<MonthlyDBTestMsoytcsvrreplapznkyt6lt6saStaging?>> queryListMonthlyDBItems({required String ID}) async {
    try {
      print("id");
      print(ID);
      var operation = Amplify.API.query(
        request: GraphQLRequest(
          document: """
          query ListMonthlyDBTests(\$id: String) {
            listMonthlyDBTestMsoytcsvrreplapznkyt6lt6saStagings(
            filter: {id: {eq: \$id}}
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
            }
          }
        """,
          variables: {
            "id": ID,
          },
        ),
      );

      var response = await operation.response;
      print(response.data);

      // Map<String, dynamic> json = jsonDecode(response.data);
      // in Dart, you can use the jsonDecode function from the dart:convert library. The jsonDecode function parses a JSON string and returns the corresponding Dart object.
      List<MonthlyDBTestMsoytcsvrreplapznkyt6lt6saStaging> monthlyDBTests =
          (jsonDecode(response.data)['listMonthlyDBTestMsoytcsvrreplapznkyt6lt6saStagings']['items'] as List)
              .map((item) => MonthlyDBTestMsoytcsvrreplapznkyt6lt6saStaging.fromJson(item))
              .toList();

      if (monthlyDBTests == null || jsonDecode(response.data)['listMonthlyDBTestMsoytcsvrreplapznkyt6lt6saStagings']['items'] == null) {
        safePrint('errors: ${response.errors}');
        return const [];
      }
      // print("monthlyDBTests");
      // print(monthlyDBTests);
      return monthlyDBTests;
    } on ApiException catch (e) {
      print('Query failed: $e');
      return const [];
    }
  }


  Future<List<UserTable?>> queryListUsers({required String institutionId}) async {
    try {

      var operation = Amplify.API.query(
        request: GraphQLRequest(
          document: """
          query listUserTables(\$INSTITUTION_ID: String) {
            listUserTables(
            filter: {INSTITUTION_ID: {eq: \$INSTITUTION_ID}}
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
            }
          }
        """,
          variables: {
            "INSTITUTION_ID": institutionId,
          },
        ),
      );
      print("유저쿼리!!!");
      var response = await operation.response;

      print(response.data);
      // Map<String, dynamic> json = jsonDecode(response.data);
      // in Dart, you can use the jsonDecode function from the dart:convert library. The jsonDecode function parses a JSON string and returns the corresponding Dart object.
      List<UserTable> Users =
      (jsonDecode(response.data)['listUserTables']['items'] as List)
          .map((item) => UserTable.fromJson(item))
          .toList();
      if (Users == null) {
        print('errors: ${response.errors}');
        return const [];
      }
      return Users;
    } on ApiException catch (e) {
      print('Query failed: $e');
      return const [];
    }
  }
  //
  // // Future<List<MonthlyDBTest?>> queryMonthlyDBTwoItems(int yearMonth) async {
  // //   var ID = '3';
  // //   // final queryPredicate = MonthlyDBTest.ID.eq(ID);
  // //   //20240211- 10000 + 50
  // //   //if( yearmonth >  )2
  // //   print("yearmonth:${yearMonth - 10000 + 50}");
  // //   final queryPredicateDateMax = MonthlyDBTest.MONTH.le("$yearMonth");
  // //   final queryPredicateDatemin =
  // //   MonthlyDBTest.MONTH.gt("${yearMonth - 10000 + 50}");
  // //   final queryPredicateall = MonthlyDBTest.ID
  // //       .eq(ID)
  // //       .and(queryPredicateDateMax)
  // //       .and(queryPredicateDatemin);
  // //
  // //   try {
  // //     final request = ModelQueries.list<MonthlyDBTest>(MonthlyDBTest.classType,
  // //         where: queryPredicateall,
  // //    );
  // //     final response = await Amplify.API.query(request: request).response;
  // //
  // //     final items = response.data?.items;
  // //     if (items == null) {
  // //       print('errors: ${response.errors}');
  // //       return const [];
  // //     }
  // //     return items;
  // //   } on ApiException catch (e) {
  // //     print('Query failed: $e');
  // //     return const [];
  // //   }
  // // }
  //
  // Future<List<MonthlyDBTest?>> queryMonthlyDBLatestTwoItems() async {
  //   try {
  //     var ID = '3';
  //     int limit =
  //         2; // Fetch the latest 2 data items, you can change this value to fetch more or less
  //     String sortDirection =
  //         "DESC"; // Set to "ASC" for ascending order, or "DESC" for descending order
  //
  //     var operation = Amplify.API.query(
  //       request: GraphQLRequest(
  //         document: """
  //         query ListMonthlyDBTests(\$id: ID, \$limit: Int, \$sortDirection: ModelSortDirection) {
  //           listMonthlyDBTests(
  //             id: \$id,
  //             limit: \$limit,
  //             sortDirection: \$sortDirection
  //           ) {
  //             items {
  //               id
  //               month
  //               total_time
  //               avg_att
  //               avg_med
  //               firsts_name
  //               first_amt
  //               second_name
  //               second_amt
  //               con_score
  //               spacetime_score
  //               exec_score
  //               mem_score
  //               ling_score
  //               cal_score
  //               reac_score
  //               orient_score
  //               createdAt
  //               updatedAt
  //             }
  //           }
  //         }
  //       """,
  //         variables: {
  //           "id": ID,
  //           "limit": limit,
  //           "sortDirection": sortDirection,
  //         },
  //       ),
  //     );
  //
  //     var response = await operation.response;
  //     // print(response.data);
  //     // Map<String, dynamic> json = jsonDecode(response.data);
  //     // in Dart, you can use the jsonDecode function from the dart:convert library. The jsonDecode function parses a JSON string and returns the corresponding Dart object.
  //     List<MonthlyDBTest> monthlyDBTests =
  //         (jsonDecode(response.data)['listMonthlyDBTests']['items'] as List)
  //             .map((item) => MonthlyDBTest.fromJson(item))
  //             .toList();
  //     if (monthlyDBTests == null) {
  //       print('errors: ${response.errors}');
  //       return const [];
  //     }
  //     return monthlyDBTests;
  //   } on ApiException catch (e) {
  //     print('Query failed: $e');
  //     return const [];
  //   }
  // }
  //
  // Future<MonthlyDBTest?> queryMonthlyDBRequiredItem(
  //     String id, int yearMonth) async {
  //   print(yearMonth + 40);
  //   final queryPredicateDate = MonthlyDBTest.MONTH
  //       .between(yearMonth.toString(), (yearMonth + 40).toString());
  //   final queryPredicateboth = MonthlyDBTest.ID.eq(id).and(queryPredicateDate);
  //
  //   try {
  //     final request = ModelQueries.list<MonthlyDBTest>(
  //       MonthlyDBTest.classType,
  //       where: queryPredicateboth,
  //     );
  //     final response = await Amplify.API.query(request: request).response;
  //     final test = response.data?.items.last; // latest data
  //     if (test == null) {
  //       safePrint('errors: ${response.errors}');
  //       return null;
  //     }
  //     print(test.toString());
  //     return test;
  //   } on ApiException catch (e) {
  //     safePrint('Query failed: $e');
  //     return null;
  //   }
  // }
  //
  // Future<UserDBTest?> queryUserDBItem(String id) async {
  //   const ID = '1';
  //
  //   final queryPredicate = UserDBTest.ID.eq(ID);
  //   // final queryPredicateboth = UserDBTest.BIRTH.between(start, end).and(queryPredicateId);
  //
  //   try {
  //     final request = ModelQueries.list<UserDBTest>(
  //       UserDBTest.classType,
  //       where: queryPredicate,
  //     );
  //     final response = await Amplify.API.query(request: request).response;
  //     final test = response.data?.items.first;
  //     if (test == null) {
  //       safePrint('errors: ${response.errors}');
  //     }
  //     print(test.toString());
  //     return test;
  //   } on ApiException catch (e) {
  //     safePrint('Query failed: $e');
  //     return null;
  //   }
  // }
  //
  // Future<List<UserDBTest?>> queryListUserDBItems(int start, int end) async {
  //   final queryPredicate = UserDBTest.BIRTH.between(start, end);
  //   try {
  //     final request =
  //         ModelQueries.list(UserDBTest.classType, where: queryPredicate);
  //     final response = await Amplify.API.query(request: request).response;
  //
  //     final items = response.data?.items;
  //     if (items == null) {
  //       print('errors: ${response.errors}');
  //       return <UserDBTest?>[];
  //     }
  //     return items;
  //   } on ApiException catch (e) {
  //     print('Query failed: $e');
  //   }
  //   return <UserDBTest?>[];
  // }
}
