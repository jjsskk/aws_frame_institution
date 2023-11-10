import 'dart:io';
import 'package:aws_frame_institution/models/InstitutionNewsTable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../GraphQL_Method/graphql_controller.dart';
import '../../../provider/login_state.dart';
import '../../../storage/storage_service.dart';
import '../institution_information.dart';
import 'package:provider/provider.dart';

class updateInstitutionNewsPage extends StatefulWidget {
  final InstitutionNewsTable news;
  final StorageService storageService;

  const updateInstitutionNewsPage(
      {Key? key, required this.news, required this.storageService})
      : super(key: key);

  @override
  _updateInstitutionNewsPageState createState() =>
      _updateInstitutionNewsPageState();
}

class _updateInstitutionNewsPageState extends State<updateInstitutionNewsPage> {
  final StorageService _storageService = StorageService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();

  File? _image;
  final ImagePicker _picker = ImagePicker();
  final gql = GraphQLController.Obj;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<String> uploadImageToS3(File? image) async {
    if (image == null) {
      return "";
    }
    String imagePath = image.path;

    String imageUrl =
        await _storageService.uploadImageAtPathUrlProtected(imagePath);
    return imageUrl;
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    _titleController.text = widget.news.TITLE!;
    widget.news.CONTENT != null
        ? _contentController.text = widget.news.CONTENT!
        : _contentController.text = "";
    widget.news.URL != null
        ? _contentController.text = widget.news.URL!
        : _contentController.text = "";

  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('기관소식 변경'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
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
          TextField(
            controller: _urlController,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(labelText: 'url'),
            maxLines: 4,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _pickImage,
            child: Text('이미지 선택'),
          ),
          _image != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Image.file(_image!),
                )
              : widget.news.IMAGE != null
                  ? widget.news.IMAGE!.isNotEmpty
                      ? FutureBuilder<String>(
                          future: _storageService
                              .getImageUrlFromS3(widget.news.IMAGE!),
                          builder: (BuildContext context,
                              AsyncSnapshot<String> snapshot) {
                            if (snapshot.hasData) {
                              String imageUrl = snapshot.data!;
                              return Image.network(imageUrl);
                            } else if (snapshot.hasError) {
                              return Text('이미지를 불러올 수 없습니다.');
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                        )
                      : Container()
                  : Container(),
          ElevatedButton(
            onPressed: () async {
              // TODO: AWS S3에 이미지 업로드
              String imageUrl = '';

              if(_image != null) {
                imageUrl = await uploadImageToS3(_image);
              } else if(widget.news.IMAGE != null) {
                imageUrl = widget.news.IMAGE!;
              }


              var result = await gql.updateInstitutionNews(
                newsId: widget.news.NEWS_ID,
                content: _contentController.text,
                image: imageUrl,
                institution: widget.news.INSTITUTION,
                institution_id: widget.news.INSTITUTION_ID,
                title: _titleController.text,
                url: _urlController.text,
              );

              Map<String, String> news = {};

              if (result != null) { // GraphQL 업로드가 성공했다면...

                news['title'] = _titleController.text;
                news['content'] = _contentController.text;
                news['image'] = imageUrl;
                news['url'] = _urlController.text;

                // Provider에 새 공지사항 추가
                Provider.of<LoginState>(context, listen: false).newsUpdate();
                ScaffoldMessenger.of(context).showSnackBar(  // SnackBar 표시
                  SnackBar(content: Text('기관소식이 수정되었습니다.')),
                );
              }

              Navigator.pop(context, news); // 여기를 수정했습니다. result는 업데이트된 데이터입니다.
            },
            child: Text('완료'),
          ),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red)),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('취소', style: TextStyle(color: Colors.white)),
          ),

        ],
      ),
    );
  }
}
