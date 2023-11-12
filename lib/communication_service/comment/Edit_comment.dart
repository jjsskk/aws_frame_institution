import 'package:aws_frame_institution/GraphQL_Method/graphql_controller.dart';
import 'package:aws_frame_institution/communication_service/comment/new_message.dart';
import 'package:flutter/material.dart';

class EditCommentPage extends StatefulWidget {
  EditCommentPage(
      {Key? key,
      required this.user_id,
      required this.board_id,
      required this.title,
      required this.content,
      required this.user})
      : super(key: key);

  final user_id;
  final board_id;

  String title;

  String content;

  final user;

  @override
  State<EditCommentPage> createState() => _EditCommentPageState();
}

class _EditCommentPageState extends State<EditCommentPage> {
  late TextEditingController _titleController;

  late TextEditingController _contentController;

  final gql = GraphQLController.Obj;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _contentController = TextEditingController(text: widget.content);
    // gql.getInstitutionCommentBoard(widget.user_id,widget.board_id).then((value){
    //   print(value);
    //   title=value.TITLE;
    //   content=value.CONTENT;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('코멘트 수정',
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
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('image/ui (3).png'), // 여기에 원하는 이미지 경로를 써주세요.
              fit: BoxFit.cover, // 이미지가 AppBar를 꽉 채우도록 설정
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Container(
                        constraints: BoxConstraints(
                          maxHeight: double
                              .infinity, // container 길이를 text에 맞게 유연하게 늘릴수 있다.
                        ),
                        // height: MediaQuery.of(context).size.height / 10,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("image/ui (9).png"),
                            // 여기에 배경 이미지 경로를 지정합니다.
                            fit: BoxFit.fill, // 이미지가 전체 화면을 커버하도록 설정합니다.
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.black,
                                    ),
                                    height: 35,
                                    width: 35,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('${widget.user} 훈련자님의 보호자님에게',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Divider(
                                          thickness: 2.0,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
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
                              final check = await gql.updateCommentBoarddata(
                                  widget.user_id,
                                  widget.board_id,
                                  _titleController.text.trim(),
                                  _contentController.text.trim());
                              if (check) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                    '코멘트가 저장되었습니다',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ));
                                Navigator.pop(context);
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
                              height: MediaQuery.of(context).size.height / 9,
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
                      ),


                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
