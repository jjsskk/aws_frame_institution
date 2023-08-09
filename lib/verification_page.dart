import 'package:aws_frame_institution/analytics/analytics_events.dart';
import 'package:aws_frame_institution/analytics/analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

class VerificationPage extends StatefulWidget {
  // final ValueChanged<String> didProvideVerificationCode;
  final Future<bool> Function(String value, BuildContext context)
      didProvideVerificationCode;
  final VoidCallback shouldShowSignUp;

  VerificationPage({
    Key? key,
    required this.didProvideVerificationCode,
    required this.shouldShowSignUp,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final _verificationCodeController = TextEditingController();
  bool showspiner = false;

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

    widget.shouldShowSignUp(); // go to signup page

    return Future(() => true);
  }

  final iconColor = Colors.white;
  final dividerColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colors.black87,
      body: ModalProgressHUD(
        inAsyncCall: showspiner,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SafeArea(
            minimum: EdgeInsets.symmetric(horizontal: 40),
            child: _verificationForm(textColor),
          ),
        ),
      ),
    );
  }

  Widget _verificationForm(TextTheme textColor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Verification Code TextField
        TextField(
          style: textColor.subtitle2,
          controller: _verificationCodeController,
          decoration: InputDecoration(
              icon: Icon(
                Icons.confirmation_number,
                color: iconColor,
              ),
              labelText: '인증코드',
              labelStyle: textColor.subtitle2,
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: iconColor, width: 2))),
        ),
        SizedBox(
          height: 20,
        ),
        // Verify Button
        ElevatedButton(
            onPressed: _verify,
            child: Text(
              '인증',
              style: textColor.subtitle1,
            ),
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor))
      ],
    );
  }

  void _verify() async {
    setState(() {
      showspiner = true;
    });
    final verificationCode = _verificationCodeController.text.trim();
    bool check = false;
    check = await widget.didProvideVerificationCode(verificationCode, context);
    // AnalyticsService.log(VerificationEvent());
    if (check)
      setState(() {
        showspiner = false;
      });
  }
}
