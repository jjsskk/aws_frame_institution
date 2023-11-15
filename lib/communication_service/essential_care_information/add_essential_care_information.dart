import 'dart:io';
import 'package:aws_frame_institution/communication_service/essential_care_information/update_essential_care_information.dart';
import 'package:aws_frame_institution/communication_service/instituition_info/institution_information.dart';
import 'package:aws_frame_institution/loading_page/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../GraphQL_Method/graphql_controller.dart';
import '../../../storage/storage_service.dart';

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../models/MonthlyBrainSignalTable.dart';
import '../../models/UserTable.dart';
import '../instituition_info/convenience/Convenience.dart';

class AddEssentialCareInfoPage extends StatefulWidget {
  final List<String> nameList;
  const AddEssentialCareInfoPage({Key? key, required this.nameList}) : super(key: key);


  @override
  State<AddEssentialCareInfoPage> createState() =>
      _AddEssentialCareInfoPageState();
}

//todo: 유저 테이블에서 가져올 수 있게
//todo: 질문 사항: 유저 테이블에서 연동
class _AddEssentialCareInfoPageState extends State<AddEssentialCareInfoPage> {
  final _formKey = GlobalKey<FormState>(); // validator을 위한 글로벌키
  List<UserTable> _essentialCare = [];
  final StorageService storageService = StorageService();
  late final gql;
  int index = 0;
  bool isImageSelected = false;
  String imageUrl = '';
  late CustomDropDown customDropDown;
  DateTime dt = DateTime.now();
  final StorageService _storageService = StorageService();

  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _medicationController = TextEditingController();
  final TextEditingController _medicationWayController =
      TextEditingController();
  String userid = "";
  List<String> nameList = [];
  String name = '';
  String essentialName = '';
  String birth = '';
  String phoneNumber = '';
  String medication = '';
  String medicationWay = '';
  File? _image;
  String institutionId = "";
  String institution = '';
  String userId = '';
  final ImagePicker _picker = ImagePicker();
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

  String convertToE164(String phoneNumber, String countryCode) {
    // 전화번호의 맨 앞자리가 0인 경우, 국가 코드로 대체
    if (phoneNumber.startsWith('+')) {
      phoneNumber = phoneNumber.substring(3);
    }

    return countryCode + phoneNumber;
  }

  Future<void> getEssentialCare() async {
      print(gql.institutionNumber);
    await gql.queryListUsers().then((value) {
      if (value != null) {

        List<String> tempNameList = [];
        for (var care in value) {
          if (care.NAME != null) {
            // NAME이 null이 아닌 경우에만 추가
            String tempName = "${care.NAME!} (${care.BIRTH!})";
            tempNameList.add(tempName);
          }
        }

        setState(() {
          _essentialCare = value;
          for(var i in widget.nameList){
            int idx = tempNameList.indexOf(i);
            tempNameList.remove(i);
            _essentialCare.removeAt(idx);
          }
          nameList = tempNameList; // 이번에는 먼저 가공한 데이터로 setName을 수행함.

          name = nameList[index]; // 가장 첫 이름으로 함

          if (_essentialCare.isNotEmpty && index < _essentialCare.length) {
            String convertToE164(String phoneNumber, String countryCode) {
              // 전화번호의 맨 앞자리가 0인 경우, 국가 코드로 대체
              if (phoneNumber.startsWith('+')) {
                phoneNumber = phoneNumber.substring(3);
              }

              return countryCode + phoneNumber;
            }

            _essentialCare[index].NAME != null
                ? essentialName = _essentialCare[index].NAME!
                : "";
            _essentialCare[index].BIRTH != null
                ? birth = _essentialCare[index].BIRTH!
                : "";
            institutionId = _essentialCare[index].INSTITUTION_ID != null
                ? _essentialCare[index].INSTITUTION_ID!
                : "";
            institution = _essentialCare[index].INSTITUTION != null
                ? _essentialCare[index].INSTITUTION!
                : "";
            userId = _essentialCare[index].ID != null
                ? _essentialCare[index].INSTITUTION!
                : "";
          }
        });
      } else {
        setState(() {
          print('object');
          _essentialCare = []; // 데이터가 없는 경우 이미지 URL을 빈 문자열로 설정
        });
      }
      setState(() {
        loading =false;
      });
    }).catchError((error) {
      setState(() {
        _essentialCare = []; // 에러 발생 시 이미지 URL을 빈 문자열로 설정
      });
      print("Error fetching data: $error");
    });
  }
  bool loading = true;

  void initState() {
    super.initState();
    gql = GraphQLController.Obj;
    index = 0; //맨 처음 dropdown
    getEssentialCare();

  }


  void _NameSelected(String selectedName) {
    setState(() {
      print(nameList);
      // name = selectedName;
      index = nameList.indexOf(selectedName);
      print(name);
      if (_essentialCare.isNotEmpty && index < _essentialCare.length) {
        _essentialCare[index].NAME != null
            ? essentialName = _essentialCare[index].NAME!
            : "";
        _essentialCare[index].BIRTH != null
            ? birth = _essentialCare[index].BIRTH!
            : "";
        institutionId = _essentialCare[index].INSTITUTION_ID != null
            ? _essentialCare[index].INSTITUTION_ID!
            : "";
        institution = _essentialCare[index].INSTITUTION != null
            ? _essentialCare[index].INSTITUTION!
            : "";
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
          '이용인 정보 추가',
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
      body: loading? LoadingPage():ListView(
        padding: EdgeInsets.all(16),
        children: [
          nameList.isNotEmpty
              ? Row(
                children: [
                  Container(
            height: MediaQuery.of(context).size.height / 23,
            width: MediaQuery.of(context).size.width / 2.1,
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
                          Items: nameList,
                          selected: name,
                          onChanged: _NameSelected,
                        ),
                    ),
                  ),
                ],
              )
              : Container(),
          SizedBox(height: 30),
          _image != null
              ? ElevatedButton(
            onPressed: _pickImage,
            child: ClipOval(
              child: SizedBox(
                width: 200,
                height: 200,
                child: Image.file(
                  _image!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(200, 200),
              maximumSize: Size(200, 200),
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
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text("이름: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                  Container(
                    decoration: BoxDecoration(
                      color:Color(0xFFD3D8EA),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Text(essentialName,style: TextStyle(fontSize: 15)),
                    ),
                  ),
                ],
              ),
              Flexible(
                child: Container(),
              ),
              Row(
                children: [
                  Text("생년월일: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [


              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff1f43f3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      )),
                  onPressed: () async {
                    if(nameList.isEmpty){

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("알림"),
                            content: Text("추가할 수 있는 이용자가 없습니다."),
                            actions: [
                              TextButton(
                                child: Text("확인"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );

                    }
                    // TODO: AWS S3에 이미지 업로드
                    if (_formKey.currentState!.validate()) {
                      String imageUrl = "";

                      if (isImageSelected == true) {
                        imageUrl = await uploadImageToS3(_image);
                      }

                      if(await gql.createEssentialCare(
                          birth,
                          essentialName,
                          imageUrl,
                          _phoneNumberController.text,
                          imageUrl,
                          // 그냥 일단 institution으로 이미지를 보낼거임
                          gql.institutionNumber,
                          _medicationController.text,
                          _medicationWayController.text,
                          userId
                      )){
                        ScaffoldMessenger.of(context).showSnackBar(  // SnackBar 표시
                          SnackBar(content: Text('필수돌봄정보가 생성되었습니다.')),
                        );
                      }

                      print(_phoneNumberController.text);

                      Navigator.pop(context, true);
                    }
                  },
                  child: Text('완료',
                      style:
                      TextStyle(fontWeight: FontWeight.bold, color: Colors.white)))
            ],
          ),
        ],
      ),
    );
  }
}

//
// class AddEssentialCareInfoPage extends StatefulWidget {
//   const AddEssentialCareInfoPage({Key? key}) : super(key: key);
//
//   @override
//   _AddEssentialCareInfoPageState createState() =>
//       _AddEssentialCareInfoPageState();
// }
//
// class _AddEssentialCareInfoPageState extends State<AddEssentialCareInfoPage> {
//   final _formKey = GlobalKey<FormState>(); // validator을 위한 글로벌키
//   bool isImageSelected = false;
//   final StorageService _storageService = StorageService();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _birthController = TextEditingController();
//   final TextEditingController _phoneNumberController = TextEditingController();
//   final TextEditingController _medicationController = TextEditingController();
//   final TextEditingController _medicationWayController =
//       TextEditingController();
//   DateTime dt = DateTime.now();
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     isImageSelected = false;
//   }
//
//   File? _image;
//   final ImagePicker _picker = ImagePicker();
//   final gql = GraphQLController.Obj;
//
//   Future<void> _pickImage() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//
//     setState(() {
//       if (pickedFile != null) {
//         _image = File(pickedFile.path);
//         isImageSelected = true;
//       } else {
//         print('No image selected.');
//       }
//     });
//   }
//
//   Future<String> uploadImageToS3(File? image) async {
//     if (image == null) {
//       return "";
//     }
//     String imagePath = image.path;
//
//     String imageUrl =
//         await _storageService.uploadImageAtPathUrlProtected(imagePath);
//     return imageUrl;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var colorScheme = Theme.of(context).colorScheme;
//     var theme = Theme.of(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('필수 돌봄 정보 추가'),
//       ),
//       body: ListView(
//         padding: EdgeInsets.all(16),
//         children: [
//           _image != null
//               ? ElevatedButton(
//                   onPressed: _pickImage,
//                   child: ClipOval(
//                     child: SizedBox(
//                       width: 150,
//                       height: 150,
//                       child: Image.file(
//                         _image!,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     minimumSize: Size(150, 150),
//                     maximumSize: Size(150, 150),
//                     shape: CircleBorder(),
//                     padding: EdgeInsets.all(0),
//                   ),
//                 )
//               : ElevatedButton(
//                   onPressed: _pickImage,
//                   child: Text('이미지 선택'),
//                   style: ElevatedButton.styleFrom(
//                     shape: CircleBorder(),
//                     minimumSize: Size(150, 150),
//                     maximumSize: Size(150, 150),
//                   ),
//                 ),
//           TextField(
//             controller: _nameController,
//             style: TextStyle(color: Colors.black),
//             decoration: InputDecoration(labelText: '이름'),
//           ),
//           SizedBox(height: 16),
//           Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 TextFormField(
//                   controller: _birthController,
//                   style: TextStyle(color: Colors.black),
//                   decoration: InputDecoration(labelText: '생년월일(8자리)'),
//                   validator: (value) {
//                     if (value == null || value.length != 8) {
//                       return '생년월일을 8글자로 입력해주세요';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 16),
//                 TextFormField(
//                   controller: _phoneNumberController,
//                   style: TextStyle(color: Colors.black),
//                   decoration: InputDecoration(labelText: '전화번호'),
//                   validator: (value) {
//                     if (value == null || !value.startsWith('010')) {
//                       return '전화번호 형식을 올바르게 입력해주세요';
//                     } else if (value.length != 11) {
//                       return '전화번호를 올바르게 입력해주세요';
//                     }
//                     return null;
//                   },
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 16),
//           TextField(
//             controller: _medicationController,
//             style: TextStyle(color: Colors.black),
//             decoration: InputDecoration(labelText: '복용약'),
//             minLines: 1,
//             maxLines: 4,
//           ),
//           SizedBox(height: 16),
//           TextField(
//             controller: _medicationWayController,
//             style: TextStyle(color: Colors.black),
//             decoration: InputDecoration(labelText: '복용법'),
//             minLines: 1,
//             maxLines: 4,
//           ),
//           SizedBox(height: 16),
//           ElevatedButton(
//             onPressed: () async {
//               // TODO: AWS S3에 이미지 업로드
//               if (_formKey.currentState!.validate()) {
//                 String imageUrl = "";
//
//                 if (isImageSelected == true) {
//                   imageUrl = await uploadImageToS3(_image);
//                 }
//
//                 if(await gql.createEssentialCare(
//                     _birthController.text,
//                     _nameController.text,
//                     imageUrl,
//                     _phoneNumberController.text,
//                     imageUrl,
//                     // 그냥 일단 institution으로 이미지를 보낼거임
//                     "INST_ID_123",
//                     _medicationController.text,
//                     _medicationWayController.text,
//                     "${dt}"
//                 )){
//                   final snackBar = SnackBar(
//                     content: const Text('공지사항이 생성되었습니다'),
//                   );
//                 }
//
//                 print(_phoneNumberController.text);
//
//                 Navigator.pop(context, true);
//               }
//             },
//             child: Text('완료'),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
