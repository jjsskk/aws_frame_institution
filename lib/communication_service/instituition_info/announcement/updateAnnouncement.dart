import 'dart:io';
import 'package:aws_frame_institution/communication_service/instituition_info/institution_information.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../GraphQL_Method/graphql_controller.dart';
import '../../../models/InstitutionAnnouncementTable.dart';
import '../../../provider/login_state.dart';
import '../../../storage/storage_service.dart';
import 'announcement.dart';
import 'package:provider/provider.dart';

class updateAnnouncementPage extends StatefulWidget {
  final InstitutionAnnouncementTable announcement;
  final StorageService storageService;
  final gql = GraphQLController.Obj;

  updateAnnouncementPage(
      {Key? key, required this.announcement, required this.storageService})
      : super(key: key);

  @override
  _updateAnnouncementPageState createState() => _updateAnnouncementPageState();
}

class _updateAnnouncementPageState extends State<updateAnnouncementPage> {
  final StorageService _storageService = StorageService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  DateTime dt = DateTime.now();

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _titleController.text = widget.announcement.TITLE!;
    widget.announcement.CONTENT != null
        ? _contentController.text = widget.announcement.CONTENT!
        : _contentController.text = "";
    widget.announcement.URL != null
        ? _contentController.text = widget.announcement.URL!
        : _contentController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_circle_left_outlined,
              color: Colors.white, size: 35),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          '공지사항 변경',
          style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold), // 글자색을 하얀색으로 설정
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('image/ui (5).png'), // 여기에 원하는 이미지 경로를 써주세요.
              fit: BoxFit.cover, // 이미지가 AppBar를 꽉 채우도록 설정
            ),
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
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
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.white),),
            onPressed: _pickImage,
            child: Text('이미지 선택',style: TextStyle(color: Color(0xFF2B3FF0)),),
          ),
          _image != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Image.file(_image!),
                )
              : widget.announcement.IMAGE != null
                  ? widget.announcement.IMAGE!.isNotEmpty
                      ? FutureBuilder<String>(
                          future: _storageService
                              .getImageUrlFromS3(widget.announcement.IMAGE!),
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
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.white),),
            onPressed: () async {
              // TODO: AWS S3에 이미지 업로드
              String imageUrl = '';
              if(_image != null) {
                imageUrl = await uploadImageToS3(_image);
              } else if(widget.announcement.IMAGE != null) {
                imageUrl = widget.announcement.IMAGE!;
              }

              var result = await gql.updateAnnouncement(
                announcementId: widget.announcement.ANNOUNCEMENT_ID,
                content: _contentController.text,
                image: imageUrl,
                institution: widget.announcement.INSTITUTION,
                institution_id: widget.announcement.INSTITUTION_ID,
                title: _titleController.text,
                url: _urlController.text,
              );
              Map<String, String> announcement = {};
              if (result != null) { // GraphQL 업로드가 성공했다면...
                announcement['title'] = _titleController.text;
                announcement['content'] = _contentController.text;
                announcement['image'] = imageUrl;
                announcement['url'] = _urlController.text;

                // Provider에 새 공지사항 추가
                Provider.of<LoginState>(context, listen: false).announceUpdate();
                ScaffoldMessenger.of(context).showSnackBar(  // SnackBar 표시
                  SnackBar(content: Text('공지사항이 수정되었습니다.')),
                );

              }

              Navigator.pop(context, announcement);
            },
            child: Text('완료',style: TextStyle(color: Color(0xFF2B3FF0)),),
          ),
        ],
      ),
    );
  }
}
