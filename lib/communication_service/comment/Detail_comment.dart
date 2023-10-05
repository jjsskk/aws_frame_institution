import 'dart:async';

import 'package:amplify_core/amplify_core.dart';
import 'package:aws_frame_institution/GraphQL_Method/graphql_controller.dart';
import 'package:aws_frame_institution/communication_service/comment/Edit_comment.dart';
import 'package:aws_frame_institution/communication_service/comment/new_message.dart';
import 'package:aws_frame_institution/provider/login_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailCommentPage extends StatefulWidget {
  DetailCommentPage({Key? key, required this.user_id, required this.board_id})
      : super(key: key);

  final user_id;
  final board_id;

  @override
  State<DetailCommentPage> createState() => _DetailCommentPageState();
}

class _DetailCommentPageState extends State<DetailCommentPage> {
  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _contentController = TextEditingController();

  List<Map<String, dynamic>> _conversations = [];

  List<List<String>> data = [
    ['홍길동', '안녕', '2022-2-22'],
    ['김항도', '반가워', '2022-2-22'],
    ['김한동', 'helo', '2023-2-22']
  ];
  late var appState;
  final gql = GraphQLController.Obj;
  late Stream<GraphQLResponse>? stream;
  StreamSubscription<GraphQLResponse<dynamic>>? listener = null;

  String commentTitle = '';
  String commentContent = '';
  String user = '';
  bool loading_comment = true;
  bool loading_conversation = true;
  String date = '';

  void subscribeConversationChange() {
    listener = stream!.listen(
      (snapshot) {
        print('data : ${snapshot.data!}');
        gql
            .listInstitutionCommentConversation(widget.board_id,
                nextToken: null)
            .then((result) {
          print(result);
          _conversations = [];
          result.forEach((value) {
            // print(value.createdAt.toString().substring(0,10));
            _conversations.add({
              // 'date': value.createdAt.toString().substring(0, 10),
              'date': value.createdAt.toString() ?? '',
              'content': value.CONTENT ?? '',
              'writer': value.WRITER ?? '',
              'board_id': value.BOARD_ID ?? '',
              'conversation_id': value.CONVERSATION_ID ?? '',
              'email': value.EMAIL ?? ''
            });
          });
          _conversations.sort((a, b) {
            String aa = a['date'];

            String bb = b['date'];
            return aa.compareTo(bb);
          });
          if (mounted) {
            setState(() {
              _conversations = _conversations;
            });
          }
        });
      },
      onError: (Object e) => safePrint('Error in subscription stream: $e'),
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (listener != null) listener?.cancel();
  }

  @override
  void initState() {
    super.initState();
    gql
        .getInstitutionCommentBoard(widget.user_id, widget.board_id)
        .then((value) {
      print(value);
      commentTitle = value.TITLE ?? '';
      commentContent = value.CONTENT ?? '';
      user = value.USERNAME ?? '';
      date = value.createdAt.toString().substring(0, 10) ?? '';
      if (value.NEW_CONVERSATION_PROTECTOR == true) {
        // print('NEW_CONVERSATION_PROTECTOR == true');
        gql.updateCommentBoarddataForReadConversation(
            widget.user_id, widget.board_id);
      }
      if (mounted) {
        setState(() {
          loading_comment = false;
        });
      }
    });

    gql
        .listInstitutionCommentConversation(widget.board_id, nextToken: null)
        .then((result) {
      print(result);
      result.forEach((value) {
        // print(value.createdAt.toString().substring(0,10));
        _conversations.add({
          // 'date': value.createdAt.toString().substring(0, 10),
          'date': value.createdAt.toString() ?? '',
          'content': value.CONTENT ?? '',
          'writer': value.WRITER ?? '',
          'board_id': value.BOARD_ID ?? '',
          'conversation_id': value.CONVERSATION_ID ?? '',
          'email': value.EMAIL ?? ''
        });
      });
      _conversations.sort((a, b) {
        String aa = a['date'];

        String bb = b['date'];
        return aa.compareTo(bb);
      });

      stream = gql.subscribeInstitutionCommentConversation();
      print(stream);
      subscribeConversationChange();
      if (mounted) {
        setState(() {
          loading_conversation = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    appState = context.watch<LoginState>();

    return Scaffold(
      appBar: AppBar(
        title: Text('코멘트 추가'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.edit,
              semanticLabel: 'Edit',
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditCommentPage(
                          user_id: widget.user_id,
                          board_id: widget.board_id,
                          title: commentTitle,
                          content: commentContent,
                        )),
              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.delete,
              semanticLabel: 'Delete',
            ),
            onPressed: () {
              showDialog(
                  context: context,
                  useRootNavigator: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('해당 코멘트를 삭제하시겠습니까?'),
                      actions: [
                        TextButton(
                            onPressed: () async {
                              final check = await gql.deleteCommentBoarddata(
                                widget.user_id,
                                widget.board_id,
                              );
                              if (check) {
                                await listener?.cancel();
                                _conversations.forEach((value) async {
                                  await gql.deleteCommentConversationdata(
                                    value['board_id'],
                                    value['conversation_id'],
                                  );
                                });
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: const Text(
                                    '코멘트가 삭제 되었습니다',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ));
                                listener = null;
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: const Text(
                                    '코멘트가 삭제 되지 못했습니다. 다시 시도해주세요.',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ));
                                Navigator.of(context).pop();
                              }
                            },
                            child: const Text('네')),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('아니요'))
                      ],
                    );
                  });
            },
          ),
        ],
      ),
      body: (loading_comment || loading_conversation)
          ? Center(child: CircularProgressIndicator())
          : GestureDetector(
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
                                Text('00 복지관',
                                    style: TextStyle(color: Colors.black)),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text(
                                    '($user 훈련자님의 보호자님에게)',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Text(date),
                          ),
                        ),
                        Text('제목'),
                        Text(commentTitle),
                        SizedBox(height: 16),
                        Divider(
                          thickness: 2.0,
                        ),
                        Text('내용'),
                        Text(commentContent),
                        SizedBox(height: 16),
                        Divider(
                          thickness: 2.0,
                        ),
                        Column(
                          children: _buildListCards(),
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
                  NewMessage(
                    user_id: widget.user_id,
                    board_id: widget.board_id,
                    writer: appState.managerName,
                    email: appState.managerEmail,
                  ),
                ],
              ),
            ),
    );
  }

  List<Card> _buildListCards() {
    if (_conversations.isEmpty) {
      return const <Card>[];
    }

    return _conversations.map((value) {
      return Card(
        child: ListTile(
          leading: Icon(Icons.message),
          title: Row(
            children: [
              Text(value['writer'], style: TextStyle(color: Colors.black)),
              const SizedBox(
                width: 10,
              ),
              Text(
                value['date'].substring(0, 10) ==
                        DateTime.now().toString().substring(0, 10)
                    ? value['date'].substring(11, 19)
                    : value['date'].substring(0, 10) +
                        ' ' +
                        value['date'].substring(11, 19),
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
          subtitle: Text(value['content']),
          trailing: appState.managerEmail == value['email']
              ? IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        useRootNavigator: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('해당 댓글을 삭제하시겠습니까?'),
                            actions: [
                              TextButton(
                                  onPressed: () async {
                                    final check =
                                        await gql.deleteCommentConversationdata(
                                      value['board_id'],
                                      value['conversation_id'],
                                    );
                                    if (check) {
                                      // ScaffoldMessenger.of(context)
                                      //     .showSnackBar(SnackBar(
                                      //   content: Text(
                                      //     '댓글이 삭제 되었습니다',
                                      //     style:
                                      //     TextStyle(fontWeight: FontWeight.bold),
                                      //   ),
                                      // ));
                                      Navigator.pop(context);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: const Text(
                                          '댓글이 삭제 되지 못했습니다. 다시 시도해주세요.',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ));
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: const Text('네')),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('아니요'))
                            ],
                          );
                        });
                  },
                  icon: const Icon(Icons.delete))
              : const SizedBox(),
        ),
      );
    }).toList();
  }
}
