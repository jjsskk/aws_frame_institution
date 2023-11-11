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

      if (mounted) {
        setState(() {
          loading_conversation = false;
        });
      }
    });

    stream = gql.subscribeInstitutionCommentConversation();
    print(stream);
    subscribeConversationChange();
  }

  @override
  Widget build(BuildContext context) {
    appState = context.watch<LoginState>();

    return Scaffold(
      appBar: AppBar(
        title: Text('코멘트 상세보기',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                          user: user,
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
                                          borderRadius:
                                              BorderRadius.circular(50),
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
                                            Text('$user 훈련자님의 보호자님에게',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Divider(
                                              thickness: 2.0,
                                            ),
                                            Text(date),
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
                              padding:
                                  const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(commentTitle,
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold)),
                                          Divider(
                                            thickness: 2.0,
                                          ),
                                          Text(commentContent,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold)),
                                          const SizedBox(
                                            height: 10,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            thickness: 2.0,
                          ),
                          Column(
                            children: _buildListCards(),
                          )
                        ],
                      ),
                    ),
                    NewMessage(
                      user_id: widget.user_id,
                      board_id: widget.board_id,
                      writer: gql.managerName,
                      email: gql.managerEmail,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  List<Column> _buildListCards() {
    if (_conversations.isEmpty) {
      return const [];
    }

    return _conversations.map((value) {
      return Column(
        children: [
          Container(
            constraints: BoxConstraints(
              maxHeight: double.infinity, // container 길이를 text에 맞게 유연하게 늘릴수 있다.
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
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            child: Icon(
                              Icons.person,
                              color: Colors.black,
                              size: 20,
                            ),
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(value['writer'],
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      gql.managerEmail == value['email']
                          ? Container(
                              width: MediaQuery.of(context).size.width / 8,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("image/ui (18).png"),
                                  // 여기에 배경 이미지 경로를 지정합니다.
                                  fit: BoxFit.fill, // 이미지가 전체 화면을 커버하도록 설정합니다.
                                ),
                              ),
                              child: Center(
                                  child: InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('해당 댓글을 삭제하시겠습니까?'),
                                          actions: [
                                            TextButton(
                                                onPressed: () async {
                                                  final check = await gql
                                                      .deleteCommentConversationdata(
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
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                      content: const Text(
                                                        '댓글이 삭제 되지 못했습니다. 다시 시도해주세요.',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
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
                                child: Text(
                                  '삭제',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                            )
                          : const SizedBox(),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(value['content'],
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    value['date'].substring(0, 10) ==
                            DateTime.now().toString().substring(0, 10)
                        ? value['date'].substring(11, 19)
                        : value['date'].substring(0, 10) +
                            ' ' +
                            value['date'].substring(11, 19),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          )
        ],
      );
      // return Card(
      //   child: ListTile(
      //     leading: Icon(Icons.message),
      //     title: Row(
      //       children: [
      //         Text(value['writer'], style: TextStyle(color: Colors.black)),
      //         const SizedBox(
      //           width: 10,
      //         ),
      //         Text(
      //           value['date'].substring(0, 10) ==
      //                   DateTime.now().toString().substring(0, 10)
      //               ? value['date'].substring(11, 19)
      //               : value['date'].substring(0, 10) +
      //                   ' ' +
      //                   value['date'].substring(11, 19),
      //           style: TextStyle(color: Colors.black),
      //         ),
      //       ],
      //     ),
      //     subtitle: Text(value['content']),
      //     trailing: gql.managerEmail == value['email']
      //         ? IconButton(
      //             onPressed: () {
      //               showDialog(
      //                   context: context,
      //                   useRootNavigator: false,
      //                   builder: (BuildContext context) {
      //                     return AlertDialog(
      //                       title: const Text('해당 댓글을 삭제하시겠습니까?'),
      //                       actions: [
      //                         TextButton(
      //                             onPressed: () async {
      //                               final check =
      //                                   await gql.deleteCommentConversationdata(
      //                                 value['board_id'],
      //                                 value['conversation_id'],
      //                               );
      //                               if (check) {
      //                                 // ScaffoldMessenger.of(context)
      //                                 //     .showSnackBar(SnackBar(
      //                                 //   content: Text(
      //                                 //     '댓글이 삭제 되었습니다',
      //                                 //     style:
      //                                 //     TextStyle(fontWeight: FontWeight.bold),
      //                                 //   ),
      //                                 // ));
      //                                 Navigator.pop(context);
      //                               } else {
      //                                 ScaffoldMessenger.of(context)
      //                                     .showSnackBar(SnackBar(
      //                                   content: const Text(
      //                                     '댓글이 삭제 되지 못했습니다. 다시 시도해주세요.',
      //                                     style: TextStyle(
      //                                         fontWeight: FontWeight.bold),
      //                                   ),
      //                                 ));
      //                                 Navigator.pop(context);
      //                               }
      //                             },
      //                             child: const Text('네')),
      //                         TextButton(
      //                             onPressed: () {
      //                               Navigator.pop(context);
      //                             },
      //                             child: const Text('아니요'))
      //                       ],
      //                     );
      //                   });
      //             },
      //             icon: const Icon(Icons.delete))
      //         : const SizedBox(),
      //   ),
      // );
    }).toList();
  }
}
