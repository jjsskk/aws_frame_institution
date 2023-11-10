import 'dart:io';
import 'package:aws_frame_institution/communication_service/instituition_info/institution_information.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../GraphQL_Method/graphql_controller.dart';
import '../../../storage/storage_service.dart';
import 'Convenience.dart';


class AddFoodMenuPage extends StatefulWidget {
  final String date;
  final List<String> month;
  const AddFoodMenuPage({required this.date, required this.month});

  @override
  _AddFoodMenuPageState createState() => _AddFoodMenuPageState();
}

class _AddFoodMenuPageState extends State<AddFoodMenuPage> {
  String date = '';
  void _onDateSelected(String selectedDate) {
    setState(() {
      date = selectedDate;
    });
  }
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
    date = widget.date;
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
        title: Text('식단 추가'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: CustomDropDown(
                    Items: widget.month,
                    selected: date,
                    onChanged: _onDateSelected,
                  ),
                ),
              ],
            ),
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

              var result = await gql.createFood(
                  date,
                  imageUrl,
                  "INST_ID_123",
              );

              if(result == true){
                ScaffoldMessenger.of(context).showSnackBar(  // SnackBar 표시
                  SnackBar(content: Text('식단정보가 추가되었습니다.')),
                );
              }


              Navigator.pop(context, result);
            },
            child: Text('완료'),
          ),
        ],
      ),
    );
  }

}
