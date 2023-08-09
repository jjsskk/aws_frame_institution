import 'package:aws_frame_institution/analytics/analytics_events.dart';
import 'package:aws_frame_institution/analytics/analytics_service.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class CameraPage extends StatefulWidget {
  // 1
  final CameraDescription camera;
  // 2
  final ValueChanged didProvideImagePath;

  CameraPage({Key? key, required this.camera, required this.didProvideImagePath})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // 3
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          // 4
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(this._controller);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      // 5
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.camera), onPressed: _takePicture),
    );
  }

  // 6
  void _takePicture() async {
    try {
      await _initializeControllerFuture;
      //
      // final tmpDirectory = await getTemporaryDirectory();
      // final filePath = '${DateTime.now().millisecondsSinceEpoch}.png';
      // final path = join(tmpDirectory.path, filePath);

      final image =await _controller.takePicture();
      print(image.path); //image.path에 이미 자동으로 이미지 저장된 임시폴더 경로 다들어감
      // print('path : $path');
      widget.didProvideImagePath(image.path);
      //이제 CameraPage가 카메라로 초기화되고 이미지가 촬영되면 imagePath를 반환합니다. 여기서는 사진을 찍은 후 카메라를 닫기만 합니다.
      AnalyticsService.log(TakePictureEvent(
          cameraDirection: widget.camera.lensDirection.toString()));
    } catch (e) {
      print(' make invalid file path - $e');
    }
  }

  // 7 마지막으로, 페이지가 삭제되고 나면 CameraController를 폐기해야 합니다.
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}