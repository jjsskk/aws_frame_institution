import 'dart:io';
import 'package:aws_frame_institution/models/InstitutionNewsTable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../GraphQL_Method/graphql_controller.dart';
import '../../../storage/storage_service.dart';
import '../institution_information.dart';

class updateInstitutionNewsPage extends StatefulWidget {
  final InstitutionNewsTable news;
  final StorageService storageService;
  const updateInstitutionNewsPage({Key? key, required this.news, required this.storageService}) : super(key: key);

  @override
  _updateInstitutionNewsPageState createState() => _updateInstitutionNewsPageState();
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


    String imageUrl = await _storageService.uploadImageAtPathUrlProtected(imagePath);
    return imageUrl;

  }

  void initState() {
    // TODO: implement initState
    super.initState();
    _titleController.text = widget.news.TITLE!;
    _contentController.text = widget.news.CONTENT!;
    _urlController.text = widget.news.URL!;
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
              : widget.news.IMAGE!.isNotEmpty
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
              : Container(),
          ElevatedButton(
            onPressed: () async {
              // TODO: AWS S3에 이미지 업로드
              String imageUrl = '';

              _image != null
                  ? imageUrl = await uploadImageToS3(_image)
                  : imageUrl = widget.news.IMAGE!;

              await gql.updateInstitutionNews(
                newsId: widget.news.NEWS_ID,
                content: _contentController.text,
                image: imageUrl,
                institution: widget.news.INSTITUTION,
                institution_id: widget.news.INSTITUTION_ID,
                title: _titleController.text,
                url: _urlController.text,
              );


              Navigator.pop(context);
            },
            child: Text('완료'),
          ),
        ],
      ),
    );
  }

}
