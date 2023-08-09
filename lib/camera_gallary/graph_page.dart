import 'package:aws_frame_institution/controller/graph_controller.dart';
import 'package:aws_frame_institution/graph/linechart.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:get/get.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';

class GraphPage extends StatefulWidget {
  const GraphPage({
    Key? key,
  }) : super(key: key);

  // final VoidCallback didtogglegraph;

  @override
  State<GraphPage> createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  List<String> csvlist = [];

  // late String csvname;
  late var file_exist;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      file_exist
          ? (csvlist.length == 0
              ? Center(child: CircularProgressIndicator())
              : Linechart(
                  csvlist: csvlist,
                ))
          : Center(
              child: Text('저장된 파일이 없습니다...'),
            )
    ]);
  }

  @override
  void initState() {
    super.initState();
    // downloadFile();
    file_exist = true;
    configure();
  } //jkj

  void configure() async {
    final listOptions =
        S3ListOptions(accessLevel: StorageAccessLevel.protected);
    // 4 다음으로 S3ListOptions을 지정하여 모든 관련 사진을 나열하도록 Storage에 요청합니다.
    final result = await Amplify.Storage.list(options: listOptions);
    // print("result : ${result.items.length}");
    if (result.items.length != 0) {
      //folder length
      for (var item in result.items) {
        // file in folder
        if (item.key != '') {
          // print('list : ${item.key}');
          Get.put(GraphController(csvname: item.key), tag: item.key);
          setState(() {
            csvlist.add(item.key);
          });
        }
      }
      // csvname =csvlist.first;
      if (csvlist.isNotEmpty)
        setState(() {
          file_exist = true;
        });
      else
        setState(() {
          file_exist = false;
        });
    } else {
      setState(() {
        file_exist = false;
      });
    }
  }
// Future<void> downloadFile() async {
//   final documentsDir = await getApplicationDocumentsDirectory();
//   final filepath = documentsDir.path + '/20230206_165833_Spectrum.csv';
//   final file = File(filepath);
//   print('file path : '+filepath);
//
//   // final listOptions =
//   // S3ListOptions(accessLevel: StorageAccessLevel.private);
//   final downloadOptions = S3DownloadFileOptions(
//     accessLevel: StorageAccessLevel.protected,
//     // e.g. us-west-2:2f41a152-14d1-45ff-9715-53e20751c7ee
//
//   );
//
//   try {
//     final result = await Amplify.Storage.downloadFile(
//       key: '20230206_165833_Spectrum.csv',
//       local: file,
//       options:downloadOptions ,
//       onProgress: (progress) {
//         safePrint('Fraction completed: ${progress.getFractionCompleted()}');
//       },
//     );
//     final contents = result.file.readAsStringSync();
//     setState(() {
//       rawdata = contents;
//     });
//     // Or you can reference the file that is created above
//     // final contents = file.readAsStringSync();
//     safePrint('Downloaded contents: $contents');
//   } on StorageException catch (e) {
//     safePrint('Error downloading file: $e');
//   }
// }
}

// class GraphPage extends StatefulWidget {
//   const GraphPage({
//     Key? key,
//   }) : super(key: key);
//
//   // final VoidCallback didtogglegraph;
//
//   @override
//   State<GraphPage> createState() => _GraphPageState();
// }
//
// class _GraphPageState extends State<GraphPage> {
//   List<String> csvlist = [];
//
//   // late String csvname;
//   late var file_exist;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           leading: IconButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               icon: const Icon(Icons.arrow_back)),
//           automaticallyImplyLeading: false,
//           title: Text('Graph Page'),
//           backgroundColor: Colors.deepPurpleAccent,
//         ),
//         body: file_exist
//             ? (csvlist.length == 0
//                 ? Center(child: CircularProgressIndicator())
//                 : Linechart(
//                     csvlist: csvlist,
//                   ))
//             : Center(
//                 child: Text('저장된 파일이 없습니다...'),
//               ));
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     // downloadFile();
//     file_exist = true;
//     configure();
//   } //jkj
//
//   void configure() async {
//     final listOptions =
//         S3ListOptions(accessLevel: StorageAccessLevel.protected);
//     // 4 다음으로 S3ListOptions을 지정하여 모든 관련 사진을 나열하도록 Storage에 요청합니다.
//     final result = await Amplify.Storage.list(options: listOptions);
//     // print("result : ${result.items.length}");
//     if (result.items.length != 0) {
//       //folder length
//       for (var item in result.items) {
//         // file in folder
//         if (item.key != '') {
//           // print('list : ${item.key}');
//           Get.put(GraphController(csvname: item.key), tag: item.key);
//           setState(() {
//             csvlist.add(item.key);
//           });
//         }
//       }
//       // csvname =csvlist.first;
//       if (csvlist.isNotEmpty)
//         setState(() {
//           file_exist = true;
//         });
//       else
//         setState(() {
//           file_exist = false;
//         });
//     } else {
//       setState(() {
//         file_exist = false;
//       });
//     }
//   }
// // Future<void> downloadFile() async {
// //   final documentsDir = await getApplicationDocumentsDirectory();
// //   final filepath = documentsDir.path + '/20230206_165833_Spectrum.csv';
// //   final file = File(filepath);
// //   print('file path : '+filepath);
// //
// //   // final listOptions =
// //   // S3ListOptions(accessLevel: StorageAccessLevel.private);
// //   final downloadOptions = S3DownloadFileOptions(
// //     accessLevel: StorageAccessLevel.protected,
// //     // e.g. us-west-2:2f41a152-14d1-45ff-9715-53e20751c7ee
// //
// //   );
// //
// //   try {
// //     final result = await Amplify.Storage.downloadFile(
// //       key: '20230206_165833_Spectrum.csv',
// //       local: file,
// //       options:downloadOptions ,
// //       onProgress: (progress) {
// //         safePrint('Fraction completed: ${progress.getFractionCompleted()}');
// //       },
// //     );
// //     final contents = result.file.readAsStringSync();
// //     setState(() {
// //       rawdata = contents;
// //     });
// //     // Or you can reference the file that is created above
// //     // final contents = file.readAsStringSync();
// //     safePrint('Downloaded contents: $contents');
// //   } on StorageException catch (e) {
// //     safePrint('Error downloading file: $e');
// //   }
// // }
// }
