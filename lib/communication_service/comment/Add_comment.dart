import 'package:flutter/material.dart';

class AddCommentPage extends StatelessWidget {
  AddCommentPage({Key? key}) : super(key: key);
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('코멘트 추가'),
        centerTitle: true,
      ),
      body: Column(
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
          SizedBox(height: 16),

          ElevatedButton(
            onPressed: () {

              // Navigator.pop(context);
            },
            child: Text('완료'),
          ),
        ],
      ),
    );
  }
}
