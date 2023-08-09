import 'dart:ui';

import 'package:aws_frame_institution/analytics/analytics_events.dart';
import 'package:aws_frame_institution/analytics/analytics_service.dart';
import 'package:aws_frame_institution/auth_flow/auth_credentials.dart';
import 'package:aws_frame_institution/backey/backKey_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

class SignUpPage extends StatefulWidget {
  final VoidCallback shouldShowLogin;

  // final ValueChanged<SignUpCredentials> didProvideCredentials;
  final Future<void> Function(SignUpCredentials value, BuildContext context)
      didProvideCredentials;

  // final AsyncValueSetter<SignUpCredentials> didProvideCredentials;

  Future<bool> Function(String email, BuildContext context) resendConfirmCode;

  SignUpPage(
      {Key? key,
      required this.didProvideCredentials,
      required this.shouldShowLogin,
      required this.resendConfirmCode})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _SignUpPageState();
}

const List<String> _emaillist = [
  'naver.com',
  'gmail.com',
  'kakao.com',
  'daum.net'
];

class _SignUpPageState extends State<SignUpPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordconfirmController = TextEditingController();
  final _phonenumberController = TextEditingController();
  final _institutionnumberController = TextEditingController();
  bool showspiner = false;
  final _formKey = GlobalKey<FormState>();

  bool isChecked_personal = false;
  bool isChecked_market = false;
  bool isChecked_email = false;

  String dropdownValue = _emaillist.first;

  final iconColor = Colors.white;
  final dividerColor = Colors.white;

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

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme;
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.black87,
      body: ModalProgressHUD(
        inAsyncCall: showspiner,
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
                height: 20,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('약관동의', style: textColor.subtitle2),
                    Row(
                      children: [
                        Checkbox(
                            checkColor: iconColor,
                            fillColor:
                                MaterialStateProperty.resolveWith(getColor),
                            value: isChecked_personal,
                            onChanged: null),
                        TextButton(
                            onPressed: () {
                              _showDialog(
                                  '개인정보 동의',
                                  '본인은 행정기관이 보유하고 있는 부동산 전산자료를 한국수출보험공사에게 제공'
                                      " 하는데 대하여 아래와 같이 동의합니다.\n"
                                      "-  아      래  -\n"
                                      "1. 	사용목적 : 구상권 및 소구권의 행사\n"
                                      " 2. 	자료제공의 범위 : 소유 부동산 현황 (전국)\n"
                                      "3. 	동의서의 유효기간 :\n"
                                      "- 수출신용보증의 구상채무 소멸시까지\n"
                                      "- 수출어음보험의 소구채무 소멸시까지\n"
                                      "- 수출보증보험의 구상채무 소멸시까지\n");
                            },
                            child: Text(
                              '(필수) 개인정보 동의',
                              style: textColor.subtitle2,
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                            checkColor: iconColor,
                            fillColor:
                                MaterialStateProperty.resolveWith(getColor),
                            value: isChecked_market,
                            onChanged: null),
                        TextButton(
                            onPressed: () {
                              _showDialog(
                                  '마케팅 동의',
                                  '본인은 행정기관이 보유하고 있는 부동산 전산자료를 한국수출보험공사에게 제공'
                                      " 하는데 대하여 아래와 같이 동의합니다.\n"
                                      "-  아      래  -\n"
                                      "1. 	사용목적 : 구상권 및 소구권의 행사\n"
                                      " 2. 	자료제공의 범위 : 소유 부동산 현황 (전국)\n"
                                      "3. 	동의서의 유효기간 :\n"
                                      "- 수출신용보증의 구상채무 소멸시까지\n"
                                      "- 수출어음보험의 소구채무 소멸시까지\n"
                                      "- 수출보증보험의 구상채무 소멸시까지\n");
                            },
                            child: Text(
                              '(선택) 마케팅 동의',
                              style: textColor.subtitle2,
                            )),
                      ],
                    ),
                  ],
                ),
              ),
              // Sign Up Form
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.0),
                  child: _signUpForm(textColor)),

              // Login Button
              Container(
                height: MediaQuery.of(context).size.height / 6,
                alignment: Alignment.center,
                child: TextButton.icon(
                  onPressed: widget.shouldShowLogin,
                  label: Text(
                    'Already have an account? Login.',
                    style: textColor.subtitle2,
                  ),
                  style: TextButton.styleFrom(
                      primary: iconColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: theme.primaryColorLight),
                  icon: Icon(Icons.arrow_forward),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }

  Widget _signUpForm(TextTheme textColor) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(
            thickness: 1.0,
            color: dividerColor,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            '대표 담당자 정보',
            style: textColor.subtitle2,
          ),
          // Email TextField
          Row(
            children: [
              Expanded(
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
                      icon: Icon(Icons.mail, color: iconColor),
                      labelText: '이메일',
                      labelStyle: textColor.subtitle2,
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: iconColor, width: 2))),
                ),
              ),
              Text(
                '@',
                style: textColor.subtitle2,
              ),
              DropdownButton<String>(
                dropdownColor: Colors.black,
                value: dropdownValue,
                onChanged: (String? value) {
                  setState(
                    () {
                      dropdownValue = value!;
                    },
                  );
                },
                items: _emaillist.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: textColor.subtitle2,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                  onPressed: () async {
                    final email =
                        '${_emailController.text.trim()}@$dropdownValue';
                    isChecked_email =
                        await widget.resendConfirmCode(email, context);
                    setState(() {
                      isChecked_email = isChecked_email;
                    });
                  },
                  child: Text(
                    '인증',
                    style: textColor.subtitle2,
                  ))
            ],
          ),
          isChecked_email
              ? Center(
                  child: Text(
                  '이메일이 인증되었습니다.',
                  style: textColor.subtitle2,
                ))
              : const SizedBox(),
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '이름을 입력해주세요';
              }
              return null;
            },
            style: textColor.subtitle2,
            controller: _usernameController,
            decoration: InputDecoration(
                icon: Icon(
                  Icons.person,
                  color: iconColor,
                ),
                labelText: '이름',
                labelStyle: textColor.subtitle2,
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: iconColor, width: 2))),
          ),
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '전화번호를 입력해주세요';
              }
              RegExp numberRegex = RegExp(r'^[0-9]+$');
              ;
              if (!numberRegex.hasMatch(value!)) return '숫자만 입력해주세요';
              return null;
            },
            style: textColor.subtitle2,
            controller: _phonenumberController,
            decoration: InputDecoration(
                hintStyle: textColor.subtitle2,
                hintText: 'ex: 01012345678',
                icon: Icon(Icons.phone, color: iconColor),
                labelText: '전화번호',
                labelStyle: textColor.subtitle2,
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: iconColor, width: 2))),
          ),

          // Password TextField
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '비밀번호을 입력해주세요';
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
                labelText: '비밀번호',
                labelStyle: textColor.subtitle2,
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: iconColor, width: 2))),
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
          ),
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '비밀번호 확인을 입력해주세요';
              }
              if (value != _passwordController.text) {
                return '비밀번호와 일치하지 않습니다';
              }

              RegExp passwordRegex =
                  RegExp(r'^(?=.*[a-z])(?=.*\d)[a-z\d]{8,}$');

              if (!passwordRegex.hasMatch(value!))
                return '반드시 소문자와 숫자를 포함해서 최소 8글자 이상 입력해주세요';

              return null;
            },
            style: textColor.subtitle2,
            controller: _passwordconfirmController,
            decoration: InputDecoration(
                errorMaxLines: 2,
                icon: Icon(
                  Icons.lock_open,
                  color: iconColor,
                ),
                labelText: '비밀번호 확인',
                labelStyle: textColor.subtitle2,
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: iconColor, width: 2))),
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
          ),
          const SizedBox(
            height: 10,
          ),
          Divider(
            thickness: 1.0,
            color: dividerColor,
          ),
          const SizedBox(
            height: 10,
          ),
          Text('기관 정보', style: textColor.subtitle2),
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '기관번호를 입력해주세요';
              }
              // RegExp numberRegex = RegExp(r'^[0-9]+$');
              //
              // if (!numberRegex.hasMatch(value!)) return '숫자만 입력해주세요';
              return null;
            },
            style: textColor.subtitle2,
            controller: _institutionnumberController,
            decoration: InputDecoration(
                hintStyle: textColor.subtitle2,
                icon: Icon(Icons.account_balance, color: iconColor),
                labelText: '기관 번호',
                labelStyle: textColor.subtitle2,
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: iconColor, width: 2))),
          ),
          SizedBox(
            height: 50,
          ),
          // Sign Up Button
          Center(
            child: Container(
              padding: EdgeInsets.all(15),
              height: MediaQuery.of(context).size.width / 4.5,
              width: MediaQuery.of(context).size.width / 4.5,
              decoration: BoxDecoration(
                  color: iconColor, borderRadius: BorderRadius.circular(50)),
              child: GestureDetector(
                onTap: () {
                  _signUp(textColor);
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
                      '회원가입',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
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

  void _signUp(TextTheme textColor) async {
    if (!isChecked_personal) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          '개인정보 동의를 눌러주세요',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ));
      return;
    }
    if (!isChecked_email) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          '이메일을 인증해주세요.',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ));
      return;
    }

    if (!_formKey.currentState!.validate()) return;
    setState(() {
      showspiner = true;
    });
    final username = _usernameController.text.trim();
    final email = '${_emailController.text.trim()}@$dropdownValue';
    final password = _passwordController.text.trim();
    final phonenumber = '+${_phonenumberController.text.trim()}';
    final institutionphonenumber = _institutionnumberController.text.trim();
    // _formKey.currentState!.validate();
    print('username: $username');
    print('email: $email');
    print('password: $password');
    final credentials = SignUpCredentials(
        username: email,
        name: username,
        password: password,
        phonenumber: phonenumber,
        institutionnumber:
            institutionphonenumber); // username is recognized as user's email by amplify api
    await widget.didProvideCredentials(credentials, context);
    // AnalyticsService.log(SignUpEvent());
    setState(() {
      showspiner = false;
    });
  }

  void _showDialog(String title, String content) {
    final ThemeData theme = Theme.of(context);
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 18),
        titlePadding: EdgeInsets.all(0),
        title: Container(
            height: MediaQuery.of(context).size.height / 8,
            decoration: BoxDecoration(color: theme.primaryColor),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title),
              ],
            ))),
        content: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                content,
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  title == '개인정보 동의'
                      ? setState(() {
                          isChecked_personal = true;
                        })
                      : setState(() {
                          isChecked_market = true;
                        });
                  Navigator.pop(context, 'OK');
                },
                child: const Text('동의'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              ElevatedButton(
                onPressed: () {
                  title == '개인정보 동의'
                      ? setState(() {
                          isChecked_personal = false;
                        })
                      : setState(() {
                          isChecked_market = false;
                        });
                  Navigator.pop(context, 'Cancel');
                },
                child: const Text('동의안함'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
