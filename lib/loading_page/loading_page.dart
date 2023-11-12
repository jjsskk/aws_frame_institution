import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class LoadingPage extends StatelessWidget {
  LoadingPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("image/ui (2).png"), // 여기에 배경 이미지 경로를 지정합니다.
            fit: BoxFit.fill, // 이미지가 전체 화면을 커버하도록 설정합니다.
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width:MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2,
              child: Image.asset("image/ui (7).png"),
            ),
            SpinKitThreeBounce( // 모양 사용
              color: const Color(0xff1f43f3), // 색상 설정
              size: MediaQuery.of(context).size.width/5
              , // 크기 설정
              duration: Duration(seconds: 2), //속도 설정
            ),
            const SizedBox(
              height: 20,
            ),
            // Text('로딩중...')
          ],
        ),
      ),
    );
  }
}
