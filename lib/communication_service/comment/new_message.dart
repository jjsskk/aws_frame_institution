import 'package:aws_frame_institution/GraphQL_Method/graphql_controller.dart';
import 'package:aws_frame_institution/provider/login_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewMessage extends StatefulWidget {
  NewMessage(
      {Key? key,
      required this.user_id,
      this.board_id,
      required this.writer,
      required this.email,
      required this.detectConversationChange})
      : super(key: key);

  final void Function() detectConversationChange;
  final user_id;
  final board_id;
  final writer;
  final email;

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _contentController = TextEditingController();
  String _userEnterMessage = '';
  final gql = GraphQLController.Obj;

  late LoginState commentProvider;

  @override
  void initState() {
    super.initState();
    commentProvider = Provider.of<LoginState>(context, listen: false);
  }

  void _sendMessage() async {
    print(widget.board_id);
    final check_create = await gql.createCommentConversationdata(
        widget.board_id,
        widget.writer,
        _contentController.text.trim(),
        widget.email);
    if (check_create) {
      final check_update = await gql
          .updateCommentBoarddataForNewConversation(
              widget.user_id, widget.board_id);

      if (check_update && (commentProvider.detectCommentChange != null))
        commentProvider.detectCommentChange!(widget.user_id);

      widget.detectConversationChange();
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text(
      //     '코멘트가 저장되었습니다',
      //     style: TextStyle(fontWeight: FontWeight.bold),
      //   ),
      // ));

      FocusScope.of(context).unfocus();
      _contentController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          '알수없는 오류가 발생했습니다. 다시 시도해주세요.',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              maxLength: 255,
              style: TextStyle(color: Colors.black),
              maxLines: null,
              //자동으로 줄바꿈해줌
              controller: _contentController,
              onChanged: (value) {
                setState(() {
                  _userEnterMessage = value;
                });
              },
            ),
          ),
          IconButton(
            onPressed: _userEnterMessage.trim().isEmpty ? null : _sendMessage,
            icon: Icon(Icons.send),
            color: Colors.blue,
          )
        ],
      ),
    );
  }
}
