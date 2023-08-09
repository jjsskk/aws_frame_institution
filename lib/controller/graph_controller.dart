import 'dart:io';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';

class GraphController extends GetxController{
  // var productList = <Product>[].obs; //api를 불려올떄마다 ui를 자동으로업데이트 가능해짐
  final data = <List<dynamic>>[].obs;
  //data = observable
  var showspinner =true.obs;
  late final contents;
  final csvname;
  GraphController({required this.csvname});

  void _loadCSV()  {

    // final _rawData =
    // await rootBundle.loadString("csv/20230206_165833_Spectrum.csv");
    // print('rawdata : ' + _rawData);
    try {
      data.value = const CsvToListConverter().convert(contents);
    } catch (e) {
      print(e);
    }
    showspinner.toggle();
    // print('aws csv content :${data[0][0]}');
  }

  Future<void> downloadFile() async {
    final documentsDir = await getApplicationDocumentsDirectory();
    final filepath = documentsDir.path + csvname;
    final file = File(filepath);
    print('file path : '+filepath);


    // final listOptions =
    // S3ListOptions(accessLevel: StorageAccessLevel.private);
    final downloadOptions = S3DownloadFileOptions(
      accessLevel: StorageAccessLevel.protected,
      // e.g. us-west-2:2f41a152-14d1-45ff-9715-53e20751c7ee
    );


    try {
       final result = await Amplify.Storage.downloadFile(
        key: csvname,
        local: file,
         options:downloadOptions ,
        onProgress: (progress) {
          safePrint('Fraction completed: ${progress.getFractionCompleted()}');
        },
      );
      contents = result.file.readAsStringSync();
      // Or you can reference the file that is created above
      // final contents = file.readAsStringSync();
      safePrint('Downloaded contents: $contents');
    } on StorageException catch (e) {
      safePrint('Error downloading file: $e');
    }
    _loadCSV();
  }
  @override
  void onInit() {
    super.onInit();
    // fetchData();
    downloadFile();
  }


}