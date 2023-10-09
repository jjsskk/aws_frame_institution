import 'dart:io';
import 'package:aws_frame_institution/communication_service/instituition_info/institution_information.dart';
import 'package:aws_frame_institution/models/InstitutionEssentialCareTable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../GraphQL_Method/graphql_controller.dart';
import '../../../storage/storage_service.dart';

class UpdateEssentialCareInfoPage extends StatefulWidget {
  final InstitutionEssentialCareTable essentialCareTable;

  const UpdateEssentialCareInfoPage({Key? key, required this.essentialCareTable}) : super(key: key);

  @override
  _UpdateEssentialCareInfoPageState createState() =>
      _UpdateEssentialCareInfoPageState();
}

class _UpdateEssentialCareInfoPageState extends State<UpdateEssentialCareInfoPage> {
  final _formKey = GlobalKey<FormState>(); // validator을 위한 글로벌키
  final StorageService storageService = StorageService();
  bool isImageSelected = false;
  String userid = "";
  List<String> nameList = [];
  String name = '';
  String institutionId = "";
  String institution = '';
  String imageUrl = '';

  String convertToE164(String phoneNumber, String countryCode) {
    // 전화번호의 맨 앞자리가 0인 경우, 국가 코드로 대체
    if (phoneNumber.startsWith('+')) {
      phoneNumber = phoneNumber.substring(3);
    }

    return countryCode + phoneNumber;
  }
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
    widget.essentialCareTable.NAME != null
        ? _nameController.text = widget.essentialCareTable.NAME!
        : "";
    widget.essentialCareTable.BIRTH != null
        ? _birthController.text = widget.essentialCareTable.BIRTH!
        : "";
    widget.essentialCareTable.PHONE_NUMBER != null
        ? _phoneNumberController.text =
        convertToE164(widget.essentialCareTable.PHONE_NUMBER!, "0")
        : "";

    widget.essentialCareTable.MEDICATION != null
        ? _medicationController.text = widget.essentialCareTable.MEDICATION!
        : "";
    widget.essentialCareTable.MEDICATION_WAY != null
        ? _medicationWayController.text =
    widget.essentialCareTable.MEDICATION_WAY!
        : "";
    // phoneNumber = convertToE164(_essentialCare[index].PHONE_NUMBER!, "+82");
    imageUrl = widget.essentialCareTable.IMAGE != null
        ? widget.essentialCareTable.IMAGE!
        : "";
    userid = widget.essentialCareTable.USER_ID != null
        ? widget.essentialCareTable.USER_ID!
        : "";
    institutionId = widget.essentialCareTable.INSTITUTION_ID != null
        ? widget.essentialCareTable.INSTITUTION_ID!
        : "";
    institution = widget.essentialCareTable.INSTITUTION != null
        ? widget.essentialCareTable.INSTITUTION!
        : "";

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
        title: Text('필수 돌봄 정보 수정'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          isImageSelected == false
              ? imageUrl != ""
              ? FutureBuilder<String>(
              future: storageService.getImageUrlFromS3(imageUrl),
              builder: (BuildContext context,
                  AsyncSnapshot<String> snapshot) {
                if (snapshot.hasData) {
                  String careImageUrl = snapshot.data!;
                  return ElevatedButton(
                    onPressed: _pickImage,
                    child: ClipOval(
                      child: SizedBox(
                        width: 150,
                        height: 150,
                        child: Image.network(
                          careImageUrl,
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(150, 150),
                      maximumSize: Size(150, 150),
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(0),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('이미지를 불러올 수 없습니다.');
                }
                return CircularProgressIndicator();
              })
              : ElevatedButton(
            onPressed: _pickImage,
            child: Text('이미지 선택'),
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              minimumSize: Size(150, 150),
              maximumSize: Size(150, 150),
            ),
          )
              : _image != null
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
                  if (isImageSelected == true) {
                    imageUrl = await uploadImageToS3(_image);
                  }

                  await gql.updateEssentialCare(
                      _birthController.text,
                      _nameController.text,
                      imageUrl,
                      _phoneNumberController.text,
                      institution,
                      institutionId,
                      _medicationController.text,
                      _medicationWayController.text,
                      userid);
                }

                print(_phoneNumberController.text);

                Navigator.pop(context, true);

            },
            child: Text('완료'),
          ),
        ],
      ),
    );
  }
}

