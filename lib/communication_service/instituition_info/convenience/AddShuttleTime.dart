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


    String imageUrl = await _storageService.uploadImageAtPathUrlProtected(imagePath);
    return imageUrl;

  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('셔틀 시간표 추가'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [

          ElevatedButton(
            onPressed: _pickImage,
            child: Text('이미지 선택'),
          ),
          if (_image != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Image.file(_image!),
            ),
          ElevatedButton(
            onPressed: () async {
              // TODO: AWS S3에 이미지 업로드
              String imageUrl = await uploadImageToS3(_image);

              var result = await gql.createShuttleTime(
                imageUrl,
                "INST_ID_123",
              );


              Navigator.pop(context, result);
            },
            child: Text('완료'),
          ),
        ],
      ),
    );
  }

}
