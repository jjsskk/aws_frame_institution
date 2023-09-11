import 'dart:io';
import 'package:aws_frame_institution/communication_service/instituition_info/institution_information.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../GraphQL_Method/graphql_controller.dart';
import '../../../storage/storage_service.dart';

class AddEssentialCareInfoPage extends StatefulWidget {
  const AddEssentialCareInfoPage({Key? key}) : super(key: key);

  @override
  _AddEssentialCareInfoPageState createState() =>
      _AddEssentialCareInfoPageState();
}

class _AddEssentialCareInfoPageState extends State<AddEssentialCareInfoPage> {
  final _formKey = GlobalKey<FormState>(); // validator을 위한 글로벌키
  bool isImageSelected = false;
  final StorageService _storageService = StorageService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _medicationController = TextEditingController();
  final TextEditingController _medicationWayController =
      TextEditingController();
  DateTime dt = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isImageSelected = false;
  }

  File? _image;
  final ImagePicker _picker = ImagePicker();
  final gql = GraphQLController.Obj;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        isImageSelected = true;
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

    String imageUrl =
        await _storageService.uploadImageAtPathUrlProtected(imagePath);
    return imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('필수 돌봄 정보 추가'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _image != null
              ? ElevatedButton(
                  onPressed: _pickImage,
                  child: ClipOval(
                    child: SizedBox(
                      width: 150,
                      height: 150,
                      child: Image.file(
                        _image!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(150, 150),
                    maximumSize: Size(150, 150),
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(0),
                  ),
                )
              : ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('이미지 선택'),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    minimumSize: Size(150, 150),
                    maximumSize: Size(150, 150),
                  ),
                ),
          TextField(
            controller: _nameController,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(labelText: '이름'),
          ),
          SizedBox(height: 16),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _birthController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(labelText: '생년월일(8자리)'),
                  validator: (value) {
                    if (value == null || value.length != 8) {
                      return '생년월일을 8글자로 입력해주세요';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _phoneNumberController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(labelText: '전화번호'),
                  validator: (value) {
                    if (value == null || !value.startsWith('010')) {
                      return '전화번호 형식을 올바르게 입력해주세요';
                    } else if (value.length != 11) {
                      return '전화번호를 올바르게 입력해주세요';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _medicationController,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(labelText: '복용약'),
            minLines: 1,
            maxLines: 4,
          ),
          SizedBox(height: 16),
          TextField(
            controller: _medicationWayController,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(labelText: '복용법'),
            minLines: 1,
            maxLines: 4,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              // TODO: AWS S3에 이미지 업로드
              if (_formKey.currentState!.validate()) {
                String imageUrl = "";

                if (isImageSelected == true) {
                  imageUrl = await uploadImageToS3(_image);
                }

                await gql.createEssentialCare(
                    _birthController.text,
                    _nameController.text,
                    imageUrl,
                    _phoneNumberController.text,
                    imageUrl,
                    // 그냥 일단 institution으로 이미지를 보낼거임
                    "INST_ID_123",
                    _medicationController.text,
                    _medicationWayController.text,
                    "${dt}"
                );

                print(_phoneNumberController.text);

                Navigator.pop(context, true);
              }
            },
            child: Text('완료'),
          ),
        ],
      ),
    );
  }
}

