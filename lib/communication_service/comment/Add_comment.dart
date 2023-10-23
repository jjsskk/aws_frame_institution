import 'package:aws_frame_institution/GraphQL_Method/graphql_controller.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    int index =0;
    gql.queryListUsers(institutionId: "123").then((users) {
      users.forEach((value) {
        if(index == 0){
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
        title: Text('코멘트 추가'),
        centerTitle: true,
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                DropdownButton<String>(
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
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle(color: Colors.black)),
                    );
                  }).toList(),
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
                    final check = await gql.createCommentBoarddata(
                        selectedUserId,
                        _titleController.text.trim(),
                        '김한동',
                        _contentController.text.trim(),
                        selectedUserName,
                        '1234');
                    if (check) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          '코멘트가 저장되었습니다',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ));
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
              ],
            ),
    );
  }
}
