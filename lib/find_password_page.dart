import 'package:aws_frame_institution/backey/backKey_dialog.dart';
import 'package:flutter/material.dart';
import 'package:aws_frame_institution/auth_flow/auth_credentials.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

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

  final iconColor = Colors.white;
  final dividerColor = Colors.white;


  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(backKeyInterceptor,
        context: context);
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
    widget.shouldShowLogin();// go to login page

    return Future(() => true);
  }


  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.black87,
      body: ModalProgressHUD(
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
                    backgroundImage: AssetImage('image/frame.png'),
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                        onPressed: widget.shouldShowLogin,
                        label: Text(
                          'return to login',
                          style: textColor.subtitle2,
                        ),
                        style: TextButton.styleFrom(
                            primary: iconColor,
                            minimumSize: Size(155, 40),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            backgroundColor: theme.primaryColorLight),
                        icon: Icon(Icons.arrow_forward),
                      ),
                    ],
                  ))
            ]),
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
                child: TextFormField(
                  style: textColor.subtitle2,
                  controller: _emailController,
                  decoration: InputDecoration(
                      hintStyle: textColor.subtitle2,
                      hintText: 'ex: FRAME@naver.com',
                      icon: Icon(Icons.mail, color: iconColor),
                      labelText: '이메일',
                      labelStyle: textColor.subtitle2,
                      enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: iconColor, width: 2))),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                  onPressed: _confirmemail,
                  child: Text(
                    'send',
                    style: textColor.subtitle2,
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple)),
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
          // Verification Code TextField
          TextFormField(
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
          TextFormField(
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
          const SizedBox(
            height: 20,
          ),
          // Verify Button
          const SizedBox(
            height: 30,
          ),

          Center(
            child: Container(
              padding: EdgeInsets.all(15),
              height: MediaQuery.of(context).size.width / 4.5,
              width: MediaQuery.of(context).size.width / 4.5,
              decoration: BoxDecoration(
                  color: iconColor, borderRadius: BorderRadius.circular(50)),
              child: GestureDetector(
                onTap: () {
                  _verifycode(textColor);
                },
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.deepPurple, Colors.indigo],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: Offset(0, 1))
                      ]),
                  child: Center(
                    child: Text(
                      '인증',
                      style: textColor.subtitle1
                    ),
                  ),
                ),
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
    final _email = _emailController.text.trim();
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
          style: textColor.subtitle2,
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
