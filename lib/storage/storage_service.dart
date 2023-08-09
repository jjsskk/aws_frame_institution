import 'dart:async';
import 'dart:io';
import 'package:amplify_core/amplify_core.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

class StorageService {
  // 1 먼저 StreamController를 초기화하여 Amazon S3에서 검색된 이미지 URL을 관리합니다
  late StreamController<List<String>> imageUrlsController;

  StorageService(){
    imageUrlsController = StreamController<List<String>>();
  }
  void createdeleteStreamController(){
    imageUrlsController.close();
    imageUrlsController = StreamController<List<String>>();
    getImages();
    print('hhhhh');
  }
  // 2 이 기능은 GalleryPage에 표시해야 하는 이미지를 가져오는 프로세스를 시작합니다.
  void getImages() async {
    try {
      // 3 사용자가 업로드한 사진만 표시하기 때문에 액세스 수준을 StorageAccessLevel.private로 지정하여 사용자의 개인 사진을 비공개로 유지합니다.
      final listOptions =
      S3ListOptions(accessLevel: StorageAccessLevel.private);
      // 4 다음으로 S3ListOptions을 지정하여 모든 관련 사진을 나열하도록 Storage에 요청합니다.
      final result = await Amplify.Storage.list(options: listOptions);
      // print('key:'+result.items.first.key);
      // 5 목록 결과가 성공적이면 목록 결과에는 사진의 실제 URL이 아닌 키 목록만
      // 포함되어 있기 때문에 각 사진의 실제 다운로드 URL을 가져와야 합니다.
      final getUrlOptions =
      GetUrlOptions(accessLevel: StorageAccessLevel.private);
      // 6 .map을 사용하여 목록 결과에서 각 항목마다 반복하고 각 항목의 다운로드 URL을 비동기식으로 반환합니다.
      final List<String> imageUrls =
      await Future.wait(result.items.map((item) async { //  Future.wait(a)a안에 모든 작업이 다중요청/병렬처리 되고
        // 그 a의 모든작업이 끝날때까지 기다림( await)
        final urlResult =
        await Amplify.Storage.getUrl(key: item.key, options: getUrlOptions);
        return urlResult.url;
      }));
      //list.map((event)=>event.value(key)) ->List<Map<string,string>>의 안의 map들이 event에 순자적으로 들어가서
      // 각 map의 value(key)값을 반환(for a in b문 혹은 foreach로 생각해도 무방)

      // 7 마지막으로, 관찰할 스트림으로 URL 목록을 전송하기만 하면 됩니다
      imageUrlsController.add(imageUrls);

      // 8 도중에 오류가 발생하면 인쇄하기만 하면 됩니다.
    } catch (e) {
      print('Storage List error - $e');
    }
  }

  // 1
  void uploadImageAtPath(String imagePath) async {
    final imageFile = File(imagePath);
    // 2
    final imageKey = '${DateTime.now().millisecondsSinceEpoch}.jpg';

    try {
      // 3
      final options = S3UploadFileOptions(
          accessLevel: StorageAccessLevel.private);

      // 4
      await Amplify.Storage.uploadFile(
          local: imageFile, key: imageKey, options: options);

      // 5
      getImages();
    } catch (e) {
      print('upload error - $e');
    }
  }

}