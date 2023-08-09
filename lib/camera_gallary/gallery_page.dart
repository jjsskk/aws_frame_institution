import 'dart:async';

import 'package:aws_frame_institution/analytics/analytics_events.dart';
import 'package:aws_frame_institution/analytics/analytics_service.dart';
import 'package:aws_frame_institution/storage/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

// 1
class GalleryPage extends StatefulWidget {
  // 2
  final VoidCallback shouldLogOut;

  // 3
  final VoidCallback shouldShowCamera;

  final VoidCallback didtogglegallery;

  final StreamController<List<String>> imageUrlsController;

  final StorageService storageservice;

  final Function(String pickedImage) addImageFunc;


  GalleryPage(
      {Key? key,
      required this.imageUrlsController,
      required this.shouldLogOut,
      required this.shouldShowCamera,
      required this.didtogglegallery,
        required this.storageservice,
        required this.addImageFunc})
      : super(key: key) {
    AnalyticsService.log(ViewGalleryEvent());
  }

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  String url ='';



  @override
  void dispose() {
    widget.storageservice.createdeleteStreamController();
    super.dispose();
  }

  void showAlert(BuildContext context, String urltmp) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              backgroundColor: Colors.white,
              child:Container(
                padding: EdgeInsets.all(10),
                width: 150,
                height: 110,
                child: Column(
                  children: [
                    Text('Are you want to select this image for your profile?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.indigoAccent
                    ),),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        TextButton.icon(
                            onPressed: () {
                              setState(() {
                                url = urltmp;
                              });
                              widget.addImageFunc(urltmp);
                              Navigator.pop(context); //팝업창을 끔
                            },
                            icon: Icon(Icons.check),
                            label: Text('Yes')),
                        SizedBox(
                          width: 10,
                        ),
                        TextButton.icon(
                            onPressed: () {
                              Navigator.pop(context); //팝업창을 끔
                            },
                            icon: Icon(Icons.close),
                            label: Text('NO')),
                        SizedBox(
                          width: 10,
                        )
                      ],
                    )

                  ],
                ),
              )

          );
        });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: url == '' ? null: NetworkImage(url),
                backgroundColor: Colors.white,
              ),
              accountName: Text('JinSu'),
              accountEmail: Text('kkk@naver.com'),
              decoration: BoxDecoration(
                  color: Colors.deepPurpleAccent,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40.0),
                      bottomRight: Radius.circular(40.0))),
            ),
            ListTile(
              leading: Icon(Icons.home,color: Colors.grey[850],),
              title: Text('Home'),
              onTap: (){
                print('home is clicked');
              },
              trailing: Icon(Icons.add),
            ),
            ListTile(
              leading: Icon(Icons.settings,
                color: Colors.grey[850],),
              title: Text('Setting'),
              onTap: () {
                print('setting is clicked');
              },
              trailing: Icon(Icons.add),
            ),
            ListTile(
              leading: Icon(Icons.question_answer,
                color: Colors.grey[850],),
              title: Text('Q&A'),
              onTap: () {
                print('Q&A is clicked');
              },
              trailing: Icon(Icons.add),
            )
          ],
        ),
      ),
      appBar: AppBar(
        // leading: IconButton(
        //     onPressed: () {
        //       didtogglegallery;
        //       Navigator.pop(context);
        //     },
        //     icon: const Icon(Icons.arrow_back)),
        // automaticallyImplyLeading: false,
        backgroundColor: Colors.deepPurple,
        title: Text('Gallery!'),
        centerTitle: true,
        actions: [
      IconButton(
          onPressed: widget.didtogglegallery, // it is just function address so dont use like this
          // (){ widget.didtogglegallery; } just write address so it is not executed
          icon: const Icon(Icons.arrow_back)),
          // 4
          // Log Out Button
          Padding(
            padding: const EdgeInsets.all(8),
            child:
                GestureDetector(child: Icon(Icons.logout), onTap: widget.shouldLogOut),
          )
        ],
      ),
      // 5
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.camera_alt), onPressed: widget.shouldShowCamera),
      body: Container(child: _galleryGrid()),
    );
  }

  Widget _galleryGrid() {
    return StreamBuilder(
        // 1
        stream: widget.imageUrlsController.stream,
        builder: (context, snapshot) {

          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
            if (snapshot.data!.length != 0) {
              return GridView.builder(
                  padding: EdgeInsets.all(10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  // 4
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: (){
                        // print('click ${snapshot.data![index]}');
                        showAlert(context,snapshot.data![index]);

                      },
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: CachedNetworkImage(
                          imageUrl: snapshot.data![index],
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                              alignment: Alignment.center,
                              child: CircularProgressIndicator()),
                          //이미지가 로드되는 동안 위젯에 CircularProgressIndicator가 표시됩니다
                        ),
                      ),
                    );
                  });
            } else {
              // 5
              return Center(child: Text('No images to display.'));
            }

        });
  }
}
