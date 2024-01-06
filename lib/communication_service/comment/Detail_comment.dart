import 'dart:async';

import 'package:amplify_core/amplify_core.dart';
import 'package:aws_frame_institution/GraphQL_Method/graphql_controller.dart';
import 'package:aws_frame_institution/communication_service/comment/Edit_comment.dart';
import 'package:aws_frame_institution/communication_service/comment/new_message.dart';
import 'package:aws_frame_institution/loading_page/loading_page.dart';
import 'package:aws_frame_institution/models/InstitutionCommentBoardTable.dart';
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

  var blue = const Color(0xff1f43f3);

  List<Map<String, dynamic>> _conversations = [];

  late var appState;
  final gql = GraphQLController.Obj;
  late Stream<GraphQLResponse>? stream;
  StreamSubscription<GraphQLResponse<dynamic>>? listener = null;

  String commentTitle = '';
  String commentContent = '';
  String user = '';
  String date = '';

  bool loading_comment = true;
  bool loading_conversation = true;

  late LoginState commentProvider;

  /*
   only called when this institution CRUD conversation(댓글) not when other institution CRUD converstaion(댓글)
   ->  detectConversationChange func is used in this page
  */
  void detectConversationChange() {
    gql
        .listInstitutionCommentConversation(widget.board_id, nextToken: null)
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
          loading_conversation = false;
        });
      }
    });
  }

  /*
  called not only when this institution CRUD conversation(댓글) but also when other institution CRUD conversation(댓글)
   -> generate resource waste if using graphql subscribe query(api)
   refer conversation Table of sort key and partition key
   -> subscribeConversationChange func is not used
  */
  void subscribeConversationChange() {
    listener = stream!.listen(
      (snapshot) {
        print('data : ${snapshot.data!}');
        detectConversationChange();
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
    commentProvider = Provider.of<LoginState>(context, listen: false);

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

    detectConversationChange();

    /*
    // using subscribe api for conversation(댓글) CRUD update
    stream = gql.subscribeInstitutionCommentConversation();
    print(stream);
    subscribeConversationChange();
     */
  }

  @override
  Widget build(BuildContext context) {
    appState = context.watch<LoginState>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_circle_left_outlined,
              color: Colors.white, size: 35),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('코멘트 상세보기',
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
                                //해당 comment의 댓글도 전부 삭제
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
                                if (commentProvider.detectCommentChange != null)
                                  commentProvider
                                      .detectCommentChange!(widget.user_id);
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
                                minHeight:
                                    MediaQuery.of(context).size.height / 3,
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
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Divider(
                                              thickness: 2.0,
                                            ),
                                            Text(commentContent,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
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
                        detectConversationChange: detectConversationChange,
                      ),
                    ],
                  ),
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
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: blue,
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
                                                    detectConversationChange();
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
                                child: Center(
                                  child: Text(
                                    'x',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
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
                  Text(value['date'].substring(0, 10) ==
                          DateTime.now().toString().substring(0, 10)
                      ? value['date'].substring(11, 19)
                      : value['date'].substring(0, 10)),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          )
        ],
      );
    }).toList();
  }
}
