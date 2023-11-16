import 'dart:io';
import 'package:aws_frame_institution/communication_service/instituition_info/institution_information.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../GraphQL_Method/graphql_controller.dart';
import '../../../storage/storage_service.dart';
import 'Convenience.dart';

class AddShuttleTimePage extends StatefulWidget {
  const AddShuttleTimePage({Key? key}) : super(key: key);

  @override
  _AddShuttleTimePageState createState() => _AddShuttleTimePageState();
}

class _AddShuttleTimePageState extends State<AddShuttleTimePage> {
  final StorageService _storageService = StorageService();

  File? _image;
  final ImagePicker _picker = ImagePicker();
  final gql = GraphQLController.Obj;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  Future<String> uploadImageToS3(File? image) async {
    if (image == null) {
      return "";
    }
    String imagePath = image.path;

    String imageUrl =
        await _storageService.uploadImageAtPathUrl(imagePath);
    return imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_circle_left_outlined,
              color: Colors.white, size: 35),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          '셔틀 시간표 추가',
          style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold), // 글자색을 하얀색으로 설정
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('image/ui (5).png'), // 여기에 원하는 이미지 경로를 써주세요.
              fit: BoxFit.cover, // 이미지가 AppBar를 꽉 채우도록 설정
            ),
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          ElevatedButton(
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.white),),

            onPressed: _pickImage,
            child: Text('이미지 선택',style: TextStyle(color: Color(0xFF2B3FF0)),),
          ),
          if (_image != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Image.file(_image!),
            ),
          ElevatedButton(
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.white),),

            onPressed: () async {
              // TODO: AWS S3에 이미지 업로드
              String imageUrl = await uploadImageToS3(_image);

              var result = await gql.createShuttleTime(
                imageUrl,
                gql.institutionNumber,
              );

              if (result != null) {
                if (result != null)
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('셔틀시간이 성공적으로 변경되었습니다.')));
              }
              Navigator.pop(context, result);
            },
            child: Text('완료',style: TextStyle(color: Color(0xFF2B3FF0)),),
          ),
        ],
      ),
    );
  }
}
