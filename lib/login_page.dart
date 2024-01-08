import 'package:aws_frame_institution/GraphQL_Method/graphql_controller.dart';
import 'package:aws_frame_institution/analytics/analytics_events.dart';
import 'package:aws_frame_institution/analytics/analytics_service.dart';
import 'package:aws_frame_institution/auth_flow/auth_credentials.dart';
import 'package:aws_frame_institution/backey/backKey_dialog.dart';
import 'package:aws_frame_institution/provider/login_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback shouldShowSignUp;
  final VoidCallback shouldShowsresetpassword;
  final Future<void> Function(LoginCredentials value, BuildContext context)
  didProvideCredentials;

  // final ValueChanged<LoginCredentials> didProvideCredentials;

  LoginPage(
      {Key? key,
        required this.didProvideCredentials,
        required this.shouldShowSignUp,
        required this.shouldShowsresetpassword})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // 1
  var _emailController = null;
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool showSpinner = false; //로그인 or signup시 대기시간동안 스핀이 돌도록....
  String _cacheid = '';
  late SharedPreferences _prefs;
  bool isChecked_id = true;
  bool isChecked_autologin = true;

  // bool providerReset = false;

  final iconColor = Colors.black;

  late var appState;

  final gql = GraphQLController.Obj;

  @override
  void initState() {
    super.initState();
    // Get.deleteAll();
    BackButtonInterceptor.add(backKeyInterceptor, context: context);
    _loadId();
    gql.resetVariables();
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(backKeyInterceptor);
    super.dispose();
  }

  // In this app, back key default function make app terminated, not page poped because of Navigator() in main page and login_sesssion page
  Future<bool> backKeyInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    print("BACK BUTTON! "); // Do some stuff.
    if (stopDefaultButtonEvent) return Future(() => true); // prevent

    // If a dialog (or any other route) is open, don't run the interceptor.
    // return type is true -> run interceptor and return type is false -> don't run the interceptor( back key defaut function work)
    if (info.ifRouteChanged(context)) {
      Navigator.of(context).pop();
      return Future(() => true);
    }
    return GlobalBackKeyDialog.getBackKeyDialog(context);
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.blueAccent;
  }

  // 캐시에 있는 데이터를 불러오는 함수
  // 이 함수의 기능으로, 어플을 끄고 켜도 데이터가 유지된다.
  _loadId() async {
    _prefs = await SharedPreferences.getInstance(); // 캐시에 저장되어있는 값을 불러온다.
    setState(() {
      // 캐시에 저장된 값을 반영하여 현재 상태를 설정한다.
      // SharedPreferences에 id, pw로 저장된 값을 읽어 필드에 저장. 없을 경우 ""으로 대입
      _cacheid = (_prefs.getString('id') ?? '');
      display_cacheId();
      print('cache id :$_cacheid'); // Run 기록으로 id와 pw의 값을 확인할 수 있음.
    });
  }

  void display_cacheId() {
    if (_cacheid == '')
      _emailController = TextEditingController();
    else
      _emailController = TextEditingController(text: _cacheid);
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme;
    final theme = Theme.of(context);
    appState = context.watch<LoginState>();

    // display_cacheId();
    // 2
    return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("image/ui (3).png"), // 여기에 배경 이미지 경로를 지정합니다.
              fit: BoxFit.fill, // 이미지가 전체 화면을 커버하도록 설정합니다.
            ),
          ),
          child: ModalProgressHUD(
            inAsyncCall: showSpinner,
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: SafeArea(
                child: ListView(children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width / 1.5,
                      child: Image.asset('image/ui (7).png'),
                    ),
                  ]),
                  // Login Form
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.0),
                    child: _loginForm(textColor),
                  ),
                  // 6
                  // Sign Up Button
                  // Expanded(
                  //   child: Align(
                  //     alignment: Alignment.bottomCenter,
                  Container(
                      height: MediaQuery.of(context).size.height / 6,
                      alignment: Alignment.center,
                      child: TextButton.icon(
                        onPressed: widget.shouldShowSignUp,
                        label: Text(
                          '회원가입 ',
                          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                        ),
                        style: TextButton.styleFrom(
                            iconColor: iconColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            backgroundColor: theme.primaryColorLight),
                        icon: Icon(Icons.arrow_forward,color: Colors.white,),
                      ))
                ]),
              ),
            ),
          ),
        ));
  }

  // 5
  Widget _loginForm(TextTheme textColor) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    isChecked_autologin = !isChecked_autologin;
                  });
                },
                child: Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(isChecked_autologin
                            ? "image/login (10).png"
                            : "image/login (1).png"),
                        // 여기에 배경 이미지 경로를 지정합니다.
                        fit: BoxFit.fill, // 이미지가 전체 화면을 커버하도록 설정합니다.
                      ),
                    ),
                    child: Text('')),
              ),
              Text(
                '자동 로그인',
                style: TextStyle(color: Colors.black),
              ),
              const SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    isChecked_id = !isChecked_id;
                  });
                },
                child: Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(isChecked_id
                            ? "image/login (10).png"
                            : "image/login (1).png"),
                        // 여기에 배경 이미지 경로를 지정합니다.
                        fit: BoxFit.fill, // 이미지가 전체 화면을 커버하도록 설정합니다.
                      ),
                    ),
                    child: Text('')),
              ),
              Text(
                '아이디 저장',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
          // Username TextField
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '이메일',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Container(
            constraints: BoxConstraints(
              maxHeight: double.infinity, // container 길이를 text에 맞게 유연하게 늘릴수 있다.
            ),
            // height: MediaQuery.of(context).size.height / 10,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("image/ui (8).png"),
                // 여기에 배경 이미지 경로를 지정합니다.
                fit: BoxFit.fill, // 이미지가 전체 화면을 커버하도록 설정합니다.
              ),
            ),
            child: Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 2.0, horizontal: 15.0),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '이메일을 입력해주세요';
                  }
                  return null;
                },
                style: TextStyle(color: Colors.black),
                controller: _emailController,
                decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.grey),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: iconColor, width: 2))),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '비밀번호',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          // Password TextField
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
              const EdgeInsets.symmetric(vertical: 2.0, horizontal: 15.0),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '비밀번호를 입력해주세요';
                  }
                  return null;
                },
                style: TextStyle(color: Colors.black),
                controller: _passwordController,
                decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.grey),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: iconColor, width: 2))),
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
              ),
            ),
          ),

          SizedBox(
            height: 30,
          ),

          // Login Button
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: _login,
              child: Container(
                height: MediaQuery.of(context).size.width / 4.5,
                width: MediaQuery.of(context).size.width / 4.5,
                decoration: BoxDecoration(
                  color: null,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'image/login (3).png', // 이미지 파일의 경로로 변경
                    fit: BoxFit.fitWidth, // 이미지가 버튼에 맞게 맞춰지도록 설정
                  ),
                ),
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () {},
                  child: Text(
                    '아이디 찾기',
                    style: TextStyle(
                        color: Colors.indigoAccent,
                        fontWeight: FontWeight.bold),
                  )),
              Text(
                ' / ',
                style: TextStyle(
                    color: Colors.indigoAccent, fontWeight: FontWeight.bold),
              ),
              TextButton(
                  onPressed: widget.shouldShowsresetpassword,
                  child: Text(
                    '비밀번호 찾기',
                    style: TextStyle(
                        color: Colors.indigoAccent,
                        fontWeight: FontWeight.bold),
                  )),
            ],
          ),
        ],
      ),
    );
  }

  // 7
  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      showSpinner = true;
    });
    _formKey.currentState!.validate();
    final Email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (isChecked_id)
      _prefs.setString(
          'id', Email); // id를 키로 가지고 있는 값에 입력받은 _id(email)를 넣어줌. = cache에 넣어줌
    else
      _prefs.remove('id');

    if (isChecked_autologin)
      _prefs.setBool('autologin',
          true); // id를 키로 가지고 있는 값에 입력받은 _id(email)를 넣어줌. = cache에 넣어줌
    else
      _prefs.remove('autologin');

    print('username: $Email');
    final credentials = LoginCredentials(username: Email, password: password);
    await widget.didProvideCredentials(credentials, context);
    // AnalyticsService.log(LoginEvent());

    setState(() {
      showSpinner = false;
    });
  }
}
