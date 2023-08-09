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
        print('User created successfully: ${response.data}');
          birth += 10000;
          useridint++;
          userid = "$useridint";
      }
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
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
  //
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
  // Future<List<MonthlyDBTest?>> queryListMonthlyDBItems() async {
  //   try {
  //     var ID = '3';
  //     int limit =
  //         12; // Fetch the latest 12 data items, you can change this value to fetch more or less
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
