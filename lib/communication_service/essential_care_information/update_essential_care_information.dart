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
  String birth = '';
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
        ? name = widget.essentialCareTable.NAME!
        : "";
    widget.essentialCareTable.BIRTH != null
        ? birth = widget.essentialCareTable.BIRTH!
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
        leading: IconButton(
          icon: Icon(Icons.arrow_circle_left_outlined,
              color: Colors.white, size: 35),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          '이용인 정보 수정',
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
            child: Image.asset(('image/community (14).png')),
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
            child: Image.asset(('image/community (14).png')),
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              minimumSize: Size(150, 150),
              maximumSize: Size(150, 150),
            ),
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text("이름: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
                  Container(
                    decoration: BoxDecoration(
                      color:Color(0xFFD3D8EA),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Text(name,style: TextStyle(fontSize: 15)),
                    ),
                  ),
                ],
              ),
              Flexible(
                child: Container(),
              ),
              Row(
                children: [
                  Text("생년월일: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
                  Container(
                    decoration: BoxDecoration(
                      color:Color(0xFFD3D8EA),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Text(birth,style: TextStyle(fontSize: 15)),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),

          SizedBox(height: 16),
          Form(
            key: _formKey,
            child: Column(
              children: [
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
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.white),),

            onPressed: () async {

              // TODO: AWS S3에 이미지 업로드


                if (_formKey.currentState!.validate()) {
                  if (isImageSelected == true) {
                    imageUrl = await uploadImageToS3(_image);
                  }

                  if(await gql.updateEssentialCare(
                      birth,
                      name,
                      imageUrl,
                      _phoneNumberController.text,
                      institution,
                      institutionId,
                      _medicationController.text,
                      _medicationWayController.text,
                      userid)){
                    ScaffoldMessenger.of(context).showSnackBar(  // SnackBar 표시
                      SnackBar(content: Text('필수 돌봄 정보가 수정되었습니다.')),
                    );
                  }
                }

                print(_phoneNumberController.text);

                Navigator.pop(context, true);

            },
            child: Text('완료', style: TextStyle(color: Color(0xFF2B3FF0))),
          ),
        ],
      ),
    );
  }
}

