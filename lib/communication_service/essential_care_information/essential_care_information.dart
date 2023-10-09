import 'dart:math';
import 'package:aws_frame_institution/communication_service/essential_care_information/add_essential_care_information.dart';
import 'package:aws_frame_institution/models/InstitutionEssentialCareTable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../GraphQL_Method/graphql_controller.dart';
import '../../storage/storage_service.dart';
import 'dart:io';
import '../instituition_info/convenience/Convenience.dart';

class EssentialCareInfoPage extends StatefulWidget {
  const EssentialCareInfoPage({Key? key}) : super(key: key);

  @override
  State<EssentialCareInfoPage> createState() => _EssentialCareInfoPageState();
}

class _EssentialCareInfoPageState extends State<EssentialCareInfoPage> {
  final _formKey = GlobalKey<FormState>(); // validator을 위한 글로벌키
  List<InstitutionEssentialCareTable> _essentialCare = [];
  final StorageService storageService = StorageService();
  late final gql;
  int index = 0;
  bool isImageSelected = false;
  String imageUrl = '';
  late CustomDropDown customDropDown;
  final StorageService _storageService = StorageService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _medicationController = TextEditingController();
  final TextEditingController _medicationWayController =
      TextEditingController();
  String userid = "";
  List<String> nameList = [];
  String name = '';
  File? _image;
  String institutionId = "";
  String institution = '';
  final ImagePicker _picker = ImagePicker();

  String convertToE164(String phoneNumber, String countryCode) {
    // 전화번호의 맨 앞자리가 0인 경우, 국가 코드로 대체
    if (phoneNumber.startsWith('+')) {
      phoneNumber = phoneNumber.substring(3);
    }

    return countryCode + phoneNumber;
  }

  void getEssentialCare() {
    gql
        .queryEssentialCareInformationByInstitutionId("INST_ID_123")
        .then((value) {
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
          nameList = tempNameList; // 이번에는 먼저 가공한 데이터로 setName을 수행함.

          name = nameList[index]; // 가장 첫 이름으로 함
          print(nameList);

          if (_essentialCare.isNotEmpty && index < _essentialCare.length) {
            String convertToE164(String phoneNumber, String countryCode) {
              // 전화번호의 맨 앞자리가 0인 경우, 국가 코드로 대체
              if (phoneNumber.startsWith('+')) {
                phoneNumber = phoneNumber.substring(3);
              }

              return countryCode + phoneNumber;
            }

            _essentialCare[index].MEDICATION != null
                ? _nameController.text = _essentialCare[index].NAME!
                : "";
            _essentialCare[index].BIRTH != null
                ? _birthController.text = _essentialCare[index].BIRTH!
                : "";
            _essentialCare[index].PHONE_NUMBER != null
                ? _phoneNumberController.text =
                    convertToE164(_essentialCare[index].PHONE_NUMBER!, "0")
                : "";

            _essentialCare[index].MEDICATION != null
                ? _medicationController.text = _essentialCare[index].MEDICATION!
                : "";
            _essentialCare[index].MEDICATION_WAY != null
                ? _medicationWayController.text =
                    _essentialCare[index].MEDICATION_WAY!
                : "";
            // phoneNumber = convertToE164(_essentialCare[index].PHONE_NUMBER!, "+82");
            imageUrl = _essentialCare[index].IMAGE != null
                ? _essentialCare[index].IMAGE!
                : "";
            userid = _essentialCare[index].USER_ID != null
                ? _essentialCare[index].USER_ID!
                : "";
            institutionId = _essentialCare[index].INSTITUTION_ID != null
                ? _essentialCare[index].INSTITUTION_ID!
                : "";
            institution = _essentialCare[index].INSTITUTION != null
                ? _essentialCare[index].INSTITUTION!
                : "";
          }
        });
      } else {
        setState(() {
          _essentialCare = []; // 데이터가 없는 경우 이미지 URL을 빈 문자열로 설정
        });
      }
    }).catchError((error) {
      setState(() {
        _essentialCare = []; // 에러 발생 시 이미지 URL을 빈 문자열로 설정
      });
      print("Error fetching data: $error");
    });
  }

  void initState() {
    super.initState();
    gql = GraphQLController.Obj;
    index = 0; //맨 처음 dropdown
    getEssentialCare();
    isImageSelected = false;
  }

  void _NameSelected(String selectedName) {
    setState(() {
      isImageSelected = false;
      print(nameList);
      name = selectedName;
      index = nameList.indexOf(selectedName);
      print(name);
      if (_essentialCare.isNotEmpty && index < _essentialCare.length) {
        _essentialCare[index].MEDICATION != null
            ? _nameController.text = _essentialCare[index].NAME!
            : "";
        _essentialCare[index].BIRTH != null
            ? _birthController.text = _essentialCare[index].BIRTH!
            : "";
        _essentialCare[index].PHONE_NUMBER != null
            ? _phoneNumberController.text =
                convertToE164(_essentialCare[index].PHONE_NUMBER!, "0")
            : "";
        _essentialCare[index].MEDICATION != null
            ? _medicationController.text = _essentialCare[index].MEDICATION!
            : "";
        _essentialCare[index].MEDICATION_WAY != null
            ? _medicationWayController.text =
                _essentialCare[index].MEDICATION_WAY!
            : "";
        imageUrl = _essentialCare[index].IMAGE != null
            ? imageUrl = _essentialCare[index].IMAGE!
            : "";
        userid = _essentialCare[index].USER_ID != null
            ? _essentialCare[index].USER_ID!
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
    return Scaffold(
      appBar: AppBar(
        title: Text('필수 돌봄 정보'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          nameList.isNotEmpty
              ? CustomDropDown(
                  Items: nameList,
                  selected: name,
                  onChanged: _NameSelected,
                )
              : Container(),
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
          Row(
            children: [
              ElevatedButton(
                onPressed: () async {
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

                    setState(() {
                      nameList = [];
                      getEssentialCare();
                      print(nameList);
                      isImageSelected = false;
                    });
                  }
                },
                child: Text('완료'),
              ),
              TextButton(
                  onPressed: () async {
                    gql.deleteEssentialCare(userid , institutionId);
                    // 만약 필요한 업데이트가 있다면 setState() 호출

                      setState(() {
                        index = 0; //맨 처음 dropdown
                        getEssentialCare();
                        isImageSelected = false;
                      });

                  },
                  child: Text("삭제 -")
              ),

              TextButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddEssentialCareInfoPage()),
                    );

                    // 만약 필요한 업데이트가 있다면 setState() 호출
                    if (result == true) {
                      setState(() {
                        index = 0; //맨 처음 dropdown
                        getEssentialCare();
                        isImageSelected = false;
                      });
                    }
                  },
                  child: Text("추가 +")
              )
            ],
          ),
        ],
      ),
    );
  }
}
