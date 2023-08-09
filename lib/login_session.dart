import 'package:aws_frame_institution/camera_gallary/camera_page.dart';
import 'package:aws_frame_institution/camera_gallary/gallery_page.dart';
import 'package:aws_frame_institution/camera_gallary/graph_page.dart';
import 'package:aws_frame_institution/home/home_page.dart';
import 'package:aws_frame_institution/storage/storage_service.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class LoginSession extends StatefulWidget {
  // 1 CameraFlow는 사용자가 로그아웃할 때 상태 변경을 트리거하고 main.dart에서 상태를
  // 다시 업데이트해야 합니다. GalleryPage를 생성하고 나서 잠시 후 이 기능을 구현하겠습니다.
  final VoidCallback shouldLogOut;

  LoginSession({Key? key, required this.shouldLogOut}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginSessionState();
}

class _LoginSessionState extends State<LoginSession> {
  late CameraDescription _camera;

  // 2 이 플래그는 카메라가 표시되어야 하는지 여부를 결정하는 상태 역할을 합니다.
  bool _shouldShowCamera = false;
  bool _gallerypage = false;
  bool _graphpage = false;

  late StorageService _storageService;

  String pickedimageurl='';

  void pickedImage(String image) {
    pickedimageurl = image;
  }

  // 3
  List<MaterialPage> get _pages {
    return [
      MaterialPage(
          child: HomePage(
            pickedimageurl: pickedimageurl,
        didtogglegallery: () =>_toggleGalleryOpen(true),
        // didtogglegraph: () {_toggleGraphOpen(true);},
              shouldLogOut: widget.shouldLogOut
      )),
      // Show Gallery Page

      // if(_graphpage)
      //   MaterialPage(
      //       child: GraphPage(didtogglegraph: (){_toggleGraphOpen(false);},
      //
      //       )),

      if (_gallerypage)
        MaterialPage(
            child: GalleryPage( addImageFunc: pickedImage,
              storageservice: _storageService,
                didtogglegallery:()=>_toggleGalleryOpen(false),
                imageUrlsController: _storageService.imageUrlsController,
                shouldLogOut: widget.shouldLogOut,
                shouldShowCamera: () => _toggleCameraOpen(true))),

      // Show Camera Page
      if (_shouldShowCamera)
        MaterialPage(
            child: CameraPage(
                camera: _camera,
                didProvideImagePath: (imagePath) {
                  //이제 CameraPage가 카메라로 초기화되고 이미지가 촬영되면
                  // imagePath를 반환합니다. 여기서는 사진을 찍은 후 카메라를 닫기만 합니다.
                  this._toggleCameraOpen(false);
                  this._storageService.uploadImageAtPath(imagePath);
                })),
    ];
  }

  @override
  void initState() {
    super.initState();
    _getCamera();
    _storageService = StorageService();
    _storageService.getImages();
  }

  @override
  void dispose() {
    _storageService.imageUrlsController.close();
    super.dispose();
  }
  // final GlobalKey<NavigatorState> navigatorKey = GlobalKey()
  @override
  Widget build(BuildContext context) {
    // 4 _MyAppState와 마찬가지로 Navigator 위젯을 사용하여 세션에 대해 지정된 시간에 표시할 페이지를 결정합니다.
    return Navigator(
      // key: navigatorKey,
      pages: _pages,
      onPopPage: (route, result) => route.didPop(result),
    );
  }

  // 5 이 메서드를 사용하면 호출 사이트에 setState()를 구현할 필요 없이 카메라 표시 여부를 전환할 수 있습니다.
  void _toggleCameraOpen(bool isOpen) {
    setState(() {
      this._shouldShowCamera = isOpen;
    });
  }

  void _toggleGalleryOpen(bool isOpen) {
    setState(() {
      this._gallerypage = isOpen;
    });
  }

  void _toggleGraphOpen(bool isOpen) {
    setState(() {
      this._graphpage = isOpen;
    });
  }

  void _getCamera() async {
    final camerasList = await availableCameras();
    setState(() {
      final firstCamera = camerasList.first;
      this._camera = firstCamera;
    });
  }
}
