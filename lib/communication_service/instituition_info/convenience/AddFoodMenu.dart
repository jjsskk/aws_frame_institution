import 'dart:io';
import 'package:aws_frame_institution/communication_service/instituition_info/institution_information.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../GraphQL_Method/graphql_controller.dart';
import '../../../storage/storage_service.dart';


class AddFoodMenuPage extends StatefulWidget {
  const AddFoodMenuPage({Key? key}) : super(key: key);

  @override
  _AddFoodMenuPageState createState() => _AddFoodMenuPageState();
}

class _AddFoodMenuPageState extends State<AddFoodMenuPage> {
  final StorageService _storageService = StorageService();
  final TextEditingController dateController = TextEditingController();

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
        title: Text('공지사항 추가'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [

          TextField(
            controller: dateController,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(labelText: 'url'),
            maxLines: 4,
          ),
          SizedBox(height: 16),
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

              // await gql.createAnnouncement(
              //     _contentController.text,
              //     imageUrl,
              //     "INSTITUTION_NAME",
              //     "INST_ID_123",
              //     _titleController.text,
              //     _urlController.text
              // );

              print(dateController.text);
              print(imageUrl);


              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InstitutionInfoPage(initialIndex: 3)),
              );
            },
            child: Text('완료'),
          ),
        ],
      ),
    );
  }

}
