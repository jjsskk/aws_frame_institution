import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../GraphQL_Method/graphql_controller.dart';
import '../../../provider/login_state.dart';
import '../../../storage/storage_service.dart';
import '../institution_information.dart';
import 'package:provider/provider.dart';

class AddInstitutionNewsPage extends StatefulWidget {
  const AddInstitutionNewsPage({Key? key}) : super(key: key);

  @override
  _AddInstitutionNewsPageState createState() => _AddInstitutionNewsPageState();
}

class _AddInstitutionNewsPageState extends State<AddInstitutionNewsPage> {
  final StorageService _storageService = StorageService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();

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
        leading: IconButton(
          icon: Icon(Icons.arrow_circle_left_outlined,
              color: Colors.white, size: 35),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          '기관소식 추가',
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
          TextField(
            controller: _titleController,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(labelText: '제목'),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _contentController,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(labelText: '내용'),
            maxLines: 4,
          ),
          SizedBox(height: 16),
          TextField(
            controller: _urlController,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(labelText: 'url'),
            maxLines: 4,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.white),),

            onPressed: _pickImage,
            child: Text('이미지 선택', style: TextStyle(color: Color(0xFF2B3FF0))),
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
              // 예시: String imageUrl = await uploadImageToS3(_image);
              String imageUrl = await uploadImageToS3(_image);

              var result = await gql.createInstitutionNews(
                  _contentController.text,
                  imageUrl,
                  "INSTITUTION_NAME",
                  gql._institutionNumber,
                  _titleController.text,
                  _urlController.text
              );

              if (result != null) { // GraphQL 업로드가 성공했다면...

                // Provider에 새 공지사항 추가
                Provider.of<LoginState>(context, listen: false).newsUpdate();
                ScaffoldMessenger.of(context).showSnackBar(  // SnackBar 표시
                  SnackBar(content: Text('기관소식이 추가되었습니다.')),
                );
              }


              Navigator.pop(context);
            },
            child: Text('완료', style: TextStyle(color: Color(0xFF2B3FF0))),
          ),
        ],
      ),
    );
  }

}
