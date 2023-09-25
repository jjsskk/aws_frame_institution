import 'package:aws_frame_institution/communication_service/comment/new_message.dart';
import 'package:flutter/material.dart';

class DetailCommentPage extends StatelessWidget {
  DetailCommentPage({Key? key}) : super(key: key);
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  List<List<String>> data = [
    ['홍길동', '안녕', '2022-2-22'],
    ['김항도', '반가워', '2022-2-22'],
    ['김한동', 'helo', '2023-2-22']
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('코멘트 추가'),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: (){
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
                    readOnly: true,
                    controller: _titleController,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(labelText: '제목'),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    readOnly: true,
                    controller: _contentController,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(labelText: '내용'),
                    maxLines: 4,
                  ),
                  SizedBox(height: 16),
                  Column(
                    children:  _buildListCards(),
                  )
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
            NewMessage(),

          ],
        ),
      ),
    );
  }
  List<Card> _buildListCards() {
    if (data.isEmpty) {
      return const <Card>[];
    }

    return data.map((comment) {
      return Card(
        child: ListTile(
          leading: Icon(Icons.message),
          title: Row(
            children: [
              Text(comment[0],
                  style: TextStyle(color: Colors.black)),
              const SizedBox(
                width: 10,
              ),
              Text(
                comment[2],
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
          subtitle: Text(comment[1]),
        ),
      );
    }).toList();
  }
}
