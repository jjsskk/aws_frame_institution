import 'package:aws_frame_institution/GraphQL_Method/graphql_controller.dart';
import 'package:aws_frame_institution/loading_page/loading_page.dart';
import 'package:aws_frame_institution/models/InstitutionCommentBoardTable.dart';
import 'package:aws_frame_institution/provider/login_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddCommentPage extends StatefulWidget {
  AddCommentPage({Key? key}) : super(key: key);

  @override
  State<AddCommentPage> createState() => _AddCommentPageState();
}

class _AddCommentPageState extends State<AddCommentPage> {
  Map<String, String> _userData = {};
  String selectedUserId = '';
  String selectedUserName = '';
  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _contentController = TextEditingController();

  late String dropdownValue;

  final gql = GraphQLController.Obj;

  bool loading = true;

  late LoginState commentProvider;

  @override
  void initState() {
    super.initState();
    commentProvider = Provider.of<LoginState>(context, listen: false);
    int index = 0;
    gql.queryListUsers().then((users) {
      users.forEach((value) {
        if (index == 0) {
          selectedUserName = '${value.NAME}(${value.BIRTH})';
          dropdownValue = selectedUserName;
          selectedUserId = '${value.ID}';
        }
        _userData[value.ID] = '${value.NAME}(${value.BIRTH})';
        index++;
      });
      setState(() {
        loading = false;
      });
    });
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
        title: Text('코멘트 추가',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
      body: loading
          ? LoadingPage()
          : GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image:
                        AssetImage('image/ui (3).png'), // 여기에 원하는 이미지 경로를 써주세요.
                    fit: BoxFit.cover, // 이미지가 AppBar를 꽉 채우도록 설정
                  ),
                ),
                child: ListView(
                  padding: const EdgeInsets.all(10.0),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height / 19,
                          width: MediaQuery.of(context).size.width / 2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: AssetImage("image/report (20).png"),
                              // 여기에 배경 이미지 경로를 지정합니다.
                              fit: BoxFit.fill, // 이미지가 전체 화면을 커버하도록 설정합니다.
                            ),
                          ),
                          child: Center(
                            child: DropdownButton<String>(
                              icon: Icon(
                                // Add this
                                Icons.arrow_drop_down, // Add this
                                color: Colors.white, // Add this
                              ),
                              dropdownColor: const Color(0xff1f43f3),
                              value: dropdownValue,
                              onChanged: (String? value) {
                                setState(() {
                                  dropdownValue = value!;
                                });
                                selectedUserName = value!;
                                _userData.forEach((key, mapValue) {
                                  if (value == mapValue) {
                                    selectedUserId = key;
                                    print('userid: ' + selectedUserId);
                                  }
                                });
                              },
                              items: _userData.values
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height / 3,
                        maxHeight: double.infinity,
                      ),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("image/community (7).png"),
                          // 여기에 배경 이미지 경로를 지정합니다.
                          fit: BoxFit.fill, // 이미지가 전체 화면을 커버하도록 설정합니다.
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
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
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () async {
                            final check = await gql.createCommentBoarddata(
                                selectedUserId,
                                _titleController.text.trim(),
                                _contentController.text.trim(),
                                selectedUserName,
                                gql.institutionNumber);
                            if (check) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                  '코멘트가 저장되었습니다',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ));
                              if (commentProvider.detectCommentChange != null)
                                commentProvider
                                    .detectCommentChange!(selectedUserId);
                              Navigator.pop(context);
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                  '코멘트가 저장되지 못했습니다. 다시 시도해주세요.',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ));
                            }
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height / 10,
                            width: MediaQuery.of(context).size.width / 3,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("image/community (18).png"),
                                // 여기에 배경 이미지 경로를 지정합니다.
                                fit: BoxFit.fill, // 이미지가 전체 화면을 커버하도록 설정합니다.
                              ),
                            ),
                            child: Text(''),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
