import 'package:aws_frame_institution/bottomappbar/bottom_appbar.dart';
import 'package:aws_frame_institution/drawer/drawer.dart';
import 'package:aws_frame_institution/bottomappbar/globalkey.dart';
import 'package:aws_frame_institution/provider/login_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentViewPage extends StatefulWidget {
  CommentViewPage({Key? key}) : super(key: key);

  @override
  State<CommentViewPage> createState() => _CommentViewPageState();
}

const List<String> _filterlist = ['날짜', '내용'];

class _CommentViewPageState extends State<CommentViewPage> {
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _products = [
    {"date": "2023/7/16", "content": "안녕하세요"},
    {"date": "2023/7/17", "content": "운동하세요"},
    {"date": "2023/6/17", "content": "살려줘"}
  ];

  List<Map<String, dynamic>> _foundComments = [
    {"date": "2023/7/16", "content": "안녕하세요"},
    {"date": "2023/7/17", "content": "운동하세요"},
    {"date": "2023/6/17", "content": "살려줘"}
  ];

  String dropdownValue = _filterlist.first;

  FloatingActionButtonLocation _fabLocation =
      FloatingActionButtonLocation.centerDocked;

  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = _products;
    } else {
      if (dropdownValue == '날짜')
        results = _products
            .where((comment) => comment["date"]
                .toLowerCase()
                .contains(enteredKeyword.toLowerCase()))
            .toList();
      else
        results = _products
            .where((comment) => comment["content"]
                .toLowerCase()
                .contains(enteredKeyword.toLowerCase()))
            .toList();
      print(results);
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _foundComments = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<LoginState>();
    return Scaffold(
      appBar: AppBar(
        title: Text('코멘트 모아보기'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
                      child: Container(
                        // Add padding around the search bar
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        // Use a Material design search bar
                        child: TextField(
                          style: TextStyle(color: Colors.black),
                          controller: _searchController,
                          onChanged: (value) => _runFilter(value),
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            // Add a clear button to the search bar
                            suffixIcon: IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () => _searchController.clear(),
                            ),
                            // Add a search icon or button to the search bar
                            prefixIcon: IconButton(
                              icon: Icon(Icons.search),
                              onPressed: () {
                                _runFilter(_searchController.text.trim());
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      onChanged: (String? value) {
                        setState(
                          () {
                            dropdownValue = value!;
                          },
                        );
                      },
                      items: _filterlist
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
              Expanded(
                child: _foundComments.isNotEmpty
                    ? ListView(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(16.0),
                        children: _buildListCards(context),
                      )
                    : const Text(
                        '검색된 내용이 없습니다',
                        style: TextStyle(fontSize: 24),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
    ;
  }

  List<Card> _buildListCards(BuildContext context) {
    if (_foundComments.isEmpty) {
      return const <Card>[];
    }
    final ThemeData theme = Theme.of(context);

    return _foundComments.map((comment) {
      return Card(
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Card(
                  child: AspectRatio(
                    aspectRatio: 1 / 1,
                    child: CircleAvatar(
                      child: Image.asset(
                        'image/frame.png',
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(comment['date']),
                    SizedBox(
                      height: 5,
                    ),
                    // TODO: Handle overflowing labels (103)
                    Text(
                      comment['content'],
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4.0),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
}
