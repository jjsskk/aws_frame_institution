import 'package:aws_frame_institution/GraphQL_Method/graphql_controller.dart';
import 'package:aws_frame_institution/communication_service/comment/new_message.dart';
import 'package:flutter/material.dart';

class EditCommentPage extends StatefulWidget {
  EditCommentPage(
      {Key? key,
      required this.user_id,
      required this.board_id,
      required this.title,
      required this.content})
      : super(key: key);

  final user_id;
  final board_id;

  String title;

  String content;

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
        title: Text('코멘트 추가'),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.person),
                      title: Row(
                        children: [
                          Text('00 복지관', style: TextStyle(color: Colors.black)),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            '(00 훈련자님의 보호자님에게)',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                      subtitle: Text('2022-2-22'),
                    ),
                  ),
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
                  ElevatedButton(
                    onPressed: () async {
                      final check = await gql.updateCommentBoarddata(
                          widget.user_id,
                          widget.board_id,
                          _titleController.text.trim(),
                          _contentController.text.trim());
                      if (check) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            '코멘트가 저장되었습니다',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ));
                        Navigator.pop(context);
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            '코멘트가 저장되지 못했습니다. 다시 시도해주세요.',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ));
                      }
                    },
                    child: Text('완료'),
                  ),
                  // ListView.builder(
                  //   itemCount: data.length,
                  //   itemBuilder: (context, index) {
                  //     // final announcement = snapshot.data![index];
                  //     return Card(
                  //       child: ListTile(
                  //         leading: Icon(Icons.message),
                  //         title: Row(
                  //           children: [
                  //             Text(data[index][0],
                  //                 style: TextStyle(color: Colors.black)),
                  //             const SizedBox(
                  //               width: 10,
                  //             ),
                  //             Text(
                  //               data[index][2],
                  //               style: TextStyle(color: Colors.black),
                  //             ),
                  //           ],
                  //         ),
                  //         subtitle: Text(data[index][1]),
                  //       ),
                  //     );
                  //   },
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


}
