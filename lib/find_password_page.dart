import 'package:aws_frame_institution/backey/backKey_dialog.dart';
import 'package:flutter/material.dart';
import 'package:aws_frame_institution/auth_flow/auth_credentials.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

const List<String> _emaillist = [
  'naver.com',
  'gmail.com',
  'kakao.com',
  'daum.net'
];

class Find_Password_Page extends StatefulWidget {
  Find_Password_Page(
      {Key? key,
      required this.resetPassword,
      required this.confirmResetPassword,
      required this.shouldShowLogin})
      : super(key: key);

  final VoidCallback shouldShowLogin;
  final Future<void> Function(
      String username,
      Function(bool check) checkvelification,
      BuildContext context) resetPassword;
  final Future<void> Function(String username, String newPasswor,
      String confirmationCode, BuildContext context) confirmResetPassword;

  @override
  State<Find_Password_Page> createState() => _Find_Password_PageState();
}

class _Find_Password_PageState extends State<Find_Password_Page> {
  final _verificationCodeController = TextEditingController();

  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _verificationcheck = false;

  void checkvelification(bool verification) {
    setState(() {
      this._verificationcheck = verification;
    });
  }

  bool showSpinner = false;

  final iconColor = const Color(0xff2b3fee);
  final dividerColor = const Color(0xff2b3fee);
  String dropdownValue = _emaillist.first;

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(backKeyInterceptor, context: context);
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

    // return type is true -> run interceptor and return type is false -> don't run the interceptor( back key defaut function work)
    widget.shouldShowLogin(); // go to login page

    return Future(() => true);
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme;
    final theme = Theme.of(context);

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
                    width: MediaQuery.of(context).size.width / 3,
                    height: MediaQuery.of(context).size.width / 3,
                    child: CircleAvatar(
                      backgroundImage: AssetImage('image/ui (6).png'),
                    ),
                  ),
                ]),
                const SizedBox(
                  height: 30,
                ),
                // Login Form
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.0),
                  child: _verificationForm(textColor),
                ),

                // 6
                // Sign Up Button
                Container(
                  height: MediaQuery.of(context).size.height / 6,
                  alignment: Alignment.center,
                  child: TextButton.icon(
                    onPressed: widget.shouldShowLogin,
                    label: Text(
                      '로그인 페이지로 돌아가기',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    style: TextButton.styleFrom(
                        primary: iconColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: theme.primaryColorLight),
                    icon: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  ),
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _verificationForm(TextTheme textColor) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                flex: 5,
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight:
                        double.infinity, // container 길이를 text에 맞게 유연하게 늘릴수 있다.
                  ),
                  // height: MediaQuery.of(context).size.height / 10,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("image/ui (18).png"),
                      // 여기에 배경 이미지 경로를 지정합니다.
                      fit: BoxFit.fill, // 이미지가 전체 화면을 커버하도록 설정합니다.
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 0.0, horizontal: 20),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '이메일을 입력해주세요';
                        }
                        // RegExp emailRegex = RegExp(r'@');
                        // if (!emailRegex.hasMatch(value!))
                        //   return '올바른 이메일 형식을 입력해주세요';
                        return null;
                      },
                      style: textColor.subtitle2,
                      controller: _emailController,
                      decoration: InputDecoration(
                          hintStyle: textColor.subtitle2,
                          labelText: '이메일',
                          labelStyle: textColor.subtitle2,
                          enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: iconColor, width: 2))),
                    ),
                  ),
                ),
              ),
              Text(
                '@',
                style: textColor.subtitle2,
              ),
              Expanded(
                flex: 5,
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight:
                        double.infinity, // container 길이를 text에 맞게 유연하게 늘릴수 있다.
                  ),
                  // height: MediaQuery.of(context).size.height / 10,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("image/ui (18).png"),
                      // 여기에 배경 이미지 경로를 지정합니다.
                      fit: BoxFit.fill, // 이미지가 전체 화면을 커버하도록 설정합니다.
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 3.0, horizontal: 0),
                    child: Center(
                      child: DropdownButton<String>(
                        value: dropdownValue,
                        onChanged: (String? value) {
                          setState(
                            () {
                              dropdownValue = value!;
                            },
                          );
                        },
                        items: _emaillist
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: textColor.subtitle2,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                flex: 3,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: iconColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        )),
                    onPressed: _confirmemail,
                    child: Text(
                      '보내기',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )),
              )
            ],
          ),

          // _verificationcheck == false ? Text('') : Text('${_emailController.text.trim()}로 인증코드가 발송되었습니다.'),
          const SizedBox(
            height: 20,
          ),
          Divider(
            thickness: 1.0,
            color: dividerColor,
          ),
          const SizedBox(height: 10,),
          // Verification Code TextField
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
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 15),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '인증코드를 입력해주세요';
                  }
                  return null;
                },
                style: textColor.subtitle2,
                controller: _verificationCodeController,
                decoration: InputDecoration(
                    icon: Icon(
                      Icons.confirmation_number,
                      color: iconColor,
                    ),
                    labelText: '인증 코드',
                    labelStyle: textColor.subtitle2,
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: iconColor, width: 2))),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
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
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 15),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '새로운 비밀번호을 입력해주세요';
                  }
                  RegExp passwordRegex =
                      RegExp(r'^(?=.*[a-z])(?=.*\d)[a-z\d]{8,}$');
                  if (!passwordRegex.hasMatch(value!))
                    return '반드시 소문자와 숫자를 포함해서 최소 8글자 이상 입력해주세요';
                  return null;
                },
                style: textColor.subtitle2,
                controller: _passwordController,
                decoration: InputDecoration(
                    errorMaxLines: 2,
                    icon: Icon(
                      Icons.lock_open,
                      color: iconColor,
                    ),
                    labelText: '새로운 비밀번호 ',
                    labelStyle: textColor.subtitle2,
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: iconColor, width: 2))),
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          // Verify Button
          const SizedBox(
            height: 30,
          ),
          Center(
            child: InkWell(
              onTap: () {
                _verifycode(textColor);
              },
              child: Container(
                height: MediaQuery.of(context).size.height / 10,
                width: MediaQuery.of(context).size.width / 3,
                child: Image.asset("image/community (18).png"),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _confirmemail() async {
    setState(() {
      showSpinner = true;
    });
    var _email = '${_emailController.text.trim()}@$dropdownValue';
    await widget.resetPassword(_email, checkvelification, context);
    // AnalyticsService.log(VerificationEvent());
    setState(() {
      showSpinner = false;
    });
  }

  void _verifycode(TextTheme textColor) async {
    if (!_verificationcheck) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          '인증번호를 발송해주세요',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigoAccent,
      ));
      return;
    }
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      showSpinner = true;
    });
    final _email = _emailController.text.trim();
    final _newpassword = _passwordController.text.trim();
    final _verificationCode = _verificationCodeController.text.trim();
    await widget.confirmResetPassword(
        _email, _newpassword, _verificationCode, context);
    // AnalyticsService.log(VerificationEvent());
    setState(() {
      showSpinner = false;
    });
  }
}
