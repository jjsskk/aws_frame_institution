import 'dart:math';
import 'package:aws_frame_institution/GraphQL_Method/graphql_controller.dart';
import 'package:aws_frame_institution/communication_service/essential_care_information/add_essential_care_information.dart';
import 'package:aws_frame_institution/communication_service/essential_care_information/update_essential_care_information.dart';
import 'package:aws_frame_institution/loading_page/loading_page.dart';
import 'package:aws_frame_institution/models/InstitutionEssentialCareTable.dart';
import 'package:aws_frame_institution/storage/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:io';

class EssentialCareInfoPage extends StatefulWidget {
  const EssentialCareInfoPage({Key? key}) : super(key: key);

  @override
  State<EssentialCareInfoPage> createState() => _EssentialCareInfoPageState();
}
//todo: 유저 테이블에서 가져올 수 있게
//todo: 질문 사항: 유저 테이블에서 연동
class _EssentialCareInfoPageState extends State<EssentialCareInfoPage> {
  final _formKey = GlobalKey<FormState>(); // validator을 위한 글로벌키
  List<InstitutionEssentialCareTable> _essentialCare = [];
  final StorageService storageService = StorageService();
  late final gql;
  int index = 0;

  String imageUrl = '';
  late CustomDropDown customDropDown;
  final StorageService _storageService = StorageService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _medicationController = TextEditingController();
  final TextEditingController _medicationWayController =
      TextEditingController();
  String _userid = "";
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
  final ImagePicker _picker = ImagePicker();
  bool loading =true;

  String convertToE164(String phoneNumber, String countryCode) {
    // 전화번호의 맨 앞자리가 0인 경우, 국가 코드로 대체
    if (phoneNumber.startsWith('+')) {
      phoneNumber = phoneNumber.substring(3);
    }

    return countryCode + phoneNumber;
  }

  Future<void> getEssentialCare() async {
    _essentialCare = [];
    await gql
        .queryEssentialCareInformationByInstitutionId(
            institutionId: "INST_ID_123")
        .then((value) {
      if (value != null) {
        List<String> tempNameList = [];
        for (var care in value) {
          if (care.NAME != null) {
            // NAME이 null이 아닌 경우에만 추가
            String tempName = "${care.NAME!}";
            tempNameList.add(tempName);
          }
        }
        nameList = [];
        setState(() {
          _essentialCare = value;
          nameList = tempNameList; // 이번에는 먼저 가공한 데이터로 setName을 수행함.
          name = nameList.isNotEmpty ? nameList[0] : '';
          print("name");
          print(name);


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
            _essentialCare[index].PHONE_NUMBER != null
                ? phoneNumber =
                    convertToE164(_essentialCare[index].PHONE_NUMBER!, "0")
                : "";

            _essentialCare[index].MEDICATION != null
                ? medication = _essentialCare[index].MEDICATION!
                : "";
            _essentialCare[index].MEDICATION_WAY != null
                ? medicationWay = _essentialCare[index].MEDICATION_WAY!
                : "";
            // phoneNumber = convertToE164(_essentialCare[index].PHONE_NUMBER!, "+82");
            imageUrl = _essentialCare[index].IMAGE != null
                ? _essentialCare[index].IMAGE!
                : "";
            _userid = _essentialCare[index].USER_ID != null
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
      setState(() {
        loading = false;
      });
    }).catchError((error) {
      setState(() {
        _essentialCare = []; // 에러 발생 시 이미지 URL을 빈 문자열로 설정
      });
      print("Error fetching data: $error");
    });
  }

  void initState() {
    super.initState();
    nameList = [];
    gql = GraphQLController.Obj;
    index = 0; //맨 처음 dropdown
    getEssentialCare();

  }

  void _NameSelected(String selectedName) {
    setState(() {


      print(nameList);
      name = selectedName;
      index = nameList.indexOf(selectedName);

      print(name);
      print(index);
      if (_essentialCare.isNotEmpty && index < _essentialCare.length) {
        _essentialCare[index].NAME != null
            ? essentialName = _essentialCare[index].NAME!
            : "";
        _essentialCare[index].BIRTH != null
            ? birth = _essentialCare[index].BIRTH!
            : "";

        _essentialCare[index].PHONE_NUMBER != null
            ? phoneNumber =
                convertToE164(_essentialCare[index].PHONE_NUMBER!, "0")
            : "";
        _essentialCare[index].MEDICATION != null
            ? medication = _essentialCare[index].MEDICATION!
            : "";
        _essentialCare[index].MEDICATION_WAY != null
            ? medicationWay =
                _essentialCare[index].MEDICATION_WAY!
            : "";
        imageUrl = _essentialCare[index].IMAGE != null
            ? imageUrl = _essentialCare[index].IMAGE!
            : "";
        _userid = _essentialCare[index].USER_ID != null
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
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('image/ui (5).png'), // 여기에 원하는 이미지 경로를 써주세요.
              fit: BoxFit.cover, // 이미지가 AppBar를 꽉 채우도록 설정
            ),
          ),
        ),
      ),
      body:loading? LoadingPage(): ListView(
        padding: EdgeInsets.all(16),
        children: [
          nameList.isNotEmpty
              ? Row(
                children: [
                  Container(
            height: MediaQuery.of(context).size.height / 23,
            width: MediaQuery.of(context).size.width / 3.5,
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
          imageUrl != ""
              ? FutureBuilder<String>(
              future: storageService.getImageUrlFromS3(imageUrl),
              builder:
                  (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.hasData) {
                  String careImageUrl = snapshot.data!;
                  return Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.contain,
                        image: NetworkImage(careImageUrl),
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('이미지를 불러올 수 없습니다.');
                }
                return CircularProgressIndicator();
              })
              : Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.contain,
                image: AssetImage('image/community (14).png'),
              ),
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


          SizedBox(height: 30),
          Row(
            children: [
              Text("전화번호: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
              Container(
                decoration: BoxDecoration(
                  color:Color(0xFFD3D8EA),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Text(phoneNumber,style: TextStyle(fontSize: 15)),
                ),
              ),

            ],
          ),
          SizedBox(height: 30),
          medication != ""
              ? Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("복용약: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
              Container(
                decoration: BoxDecoration(
                  color:Color(0xFFD3D8EA),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Text(medication,style: TextStyle(fontSize: 15)),
                ),
              ),

            ],
          )
              : Text(""),
          SizedBox(height: 30),
          medicationWay != ""
              ? Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("복용법: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
              SizedBox(width: 5,),
              Container(
                decoration: BoxDecoration(
                  color:Color(0xFFD3D8EA),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Text(medicationWay, style: TextStyle(fontSize: 15),)
                ),
              ),

            ],
          )
              : Text(""),

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
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UpdateEssentialCareInfoPage(
                              essentialCareTable: _essentialCare[index])),
                    );

                    // 만약 필요한 업데이트가 있다면 setState() 호출
                    if (result == true) {
                      setState(() {
                        index = 0; //맨 처음 dropdown
                        getEssentialCare();

                      });
                    }

                    // if (_formKey.currentState!.validate()) {
                    //   if (isImageSelected == true) {
                    //     imageUrl = await uploadImageToS3(_image);
                    //   }
                    //
                    //   await gql.updateEssentialCare(
                    //       _birthController.text,
                    //       _nameController.text,
                    //       imageUrl,
                    //       _phoneNumberController.text,
                    //       institution,
                    //       institutionId,
                    //       _medicationController.text,
                    //       _medicationWayController.text,
                    //       userid);
                    //
                    //   setState(() {
                    //     nameList = [];
                    //     getEssentialCare();
                    //     print(nameList);
                    //     isImageSelected = false;
                    //   });
                    // }
                  },
                  child: Text('수정',
                      style:
                      TextStyle(fontWeight: FontWeight.bold))),
         const SizedBox(width: 10,),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff1f43f3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      )),
                  onPressed: () async {
                    // Show confirmation dialog
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('삭제 확인'),
                          content: const Text('정말로 이 항목을 삭제하시겠습니까?'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('예'),
                              onPressed: () => Navigator.of(context).pop(true),
                            ),
                            TextButton(
                              child: const Text('아니오'),
                              onPressed: () => Navigator.of(context).pop(false),
                            ),
                          ],
                        );
                      },
                    );
                    if (confirmed ?? false) {
                      nameList = [];
                      name = '';
                      await gql.deleteEssentialCare(_userid, institutionId);

                      // Show snackbar after deletion
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('$essentialName 항목이 성공적으로 삭제되었습니다.'),
                        ),
                      );
                      // setState() 내부에서 getEssentialCare() 함수를 호출합니다.
                      setState(() {
                        // await getEssentialCare();
                        getEssentialCare();
                        loading = false;
                        // if (nameList.isNotEmpty) {
                        //   // nameList.remove(name);
                        //   // _essentialCare.removeAt(index);
                        //   name = nameList[0];
                        //   _NameSelected(name);
                        //   if (nameList.isNotEmpty) {
                        //
                        //   } else {
                        //     name = '';
                        //     print('empty');
                        //   }
                        // } else {
                        //   name = '';
                        // }
                      });
                    }
                  },
                  child: Text('삭제',
                      style:
                      TextStyle(fontWeight: FontWeight.bold))),
              const SizedBox(width: 10,),

              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff1f43f3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      )),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddEssentialCareInfoPage(nameList: nameList)),
                    );

                    // 만약 필요한 업데이트가 있다면 setState() 호출
                    if (result == true) {
                      setState(() async {
                        index = 0; //맨 처음 dropdown
                        await getEssentialCare();
                      });
                    }
                  },
                  child: Text('추가+',
                      style:
                      TextStyle(fontWeight: FontWeight.bold))),

            ],
          ),
        ],
      ),
    );
  }
}


class CustomDropDown extends StatefulWidget {
  final List<String> Items;
  final String selected;
  final Function(String) onChanged;

  const CustomDropDown(
      {Key? key,
        required this.Items,
        required this.onChanged,
        required this.selected})
      : super(key: key);

  @override
  _CustomDropDownState createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      dropdownColor: Colors.indigoAccent,
      style: TextStyle(color: Colors.black),
      icon: Icon(
        // Add this
        Icons.arrow_drop_down, // Add this
        color: Colors.white, // Add this
      ),
      value: widget.selected, // 이 부분을 widget.selected로 변경합니다.
      items: [
        for (var name in widget.Items)
          DropdownMenuItem(
            child: Text(name,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
            value: name,
          ),
      ],
      onChanged: (value) {
        widget.onChanged(value!);
      },
    );
  }
}
