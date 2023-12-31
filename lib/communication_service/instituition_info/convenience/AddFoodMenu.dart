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
        leading: IconButton(
          icon: Icon(Icons.arrow_circle_left_outlined,
              color: Colors.white, size: 35),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          '식단 추가',
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

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                Text(
                    '일자 선택',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  child: Row(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height / 30,
                        width: MediaQuery.of(context).size.width / 3.8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: AssetImage("image/report (20).png"),
                            // 여기에 배경 이미지 경로를 지정합니다.
                            fit: BoxFit.fill, // 이미지가 전체 화면을 커버하도록 설정합니다.
                          ),
                        ),
                        child: Center(
                          child: CustomDropDown(
                            Items: widget.month,
                            selected: date,
                            onChanged: _onDateSelected,
                          ),
                        ),
                      ),
                    ],

                  ),
                ),
              ],
            ),
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
              String imageUrl = await uploadImageToS3(_image);

              var result = await gql.createFood(
                  date,
                  imageUrl,
                gql.institutionNumber,
              );

              if(result == true){
                ScaffoldMessenger.of(context).showSnackBar(  // SnackBar 표시
                  SnackBar(content: Text('식단정보가 추가되었습니다.')),
                );
              }


              Navigator.pop(context, result);
            },
            child: Text('완료', style: TextStyle(color: Color(0xFF2B3FF0))),
          ),
        ],
      ),
    );
  }

}
