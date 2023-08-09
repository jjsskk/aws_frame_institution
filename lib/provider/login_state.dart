import 'package:aws_frame_institution/bottomappbar/globalkey.dart';
import 'package:aws_frame_institution/login_page.dart';
import 'package:aws_frame_institution/sign_up_page.dart';
import 'package:aws_frame_institution/verification_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:aws_frame_institution/auth_flow/auth_service.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
import 'package:aws_frame_institution/amplifyconfiguration.dart';
import 'package:flutter/material.dart';
import 'package:aws_frame_institution/home/home_page.dart';

class LoginState extends ChangeNotifier {
  // final _authService = AuthService();
  // final _amplify = Amplify;
  late var _authService;

  set authService(value) {
    _authService = value;
  }

  get authService => _authService;

  // protector's attribute info
  String _managerEmail = '';
  String _managerName = '';
  String _managerPhonenumber = '';
  String _institutionNumber = '';



  void resetVariables() {
    print("provider!!!");
    // protector's attribute info
    _managerEmail = '';
    _managerName = '';
    _managerPhonenumber = '';
    _institutionNumber = '';


    // notifyListeners(); // don't use ->error occur
  }


  String get managerEmail => _managerEmail;

  set managerEmail(String value) {
    _managerEmail = value;
  }

  String get managerName => _managerName;

  set managerName(String value) {
    _managerName = value;
  }

  String get managerPhonenumber => _managerPhonenumber;

  set managerPhonenumber(String value) {
    _managerPhonenumber = value;
  }

  String get institutionNumber => _institutionNumber;

  set institutionNumber(String value) {
    _institutionNumber = value;
  }





  // LoginState() {
    // _configureAmplify();
    // _authService.authStateController.stream.listen((snapshot) {
    //   final context = NavigationService.naviagatorState.currentState!.overlay!.context;
    //   if (snapshot!.authFlowStatus == AuthFlowStatus.start)
    //     {
    //       Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
    //           builder: (BuildContext context) =>
    //               StartPage(shouldShowlogin: _authService.showLogin)), (route) => false);
    //
    //       // Navigator.push(
    //       //   context,
    //       //   MaterialPageRoute(
    //       //       builder: (context) =>
    //       //           StartPage(shouldShowlogin: _authService.showLogin)));
    //     }
    //
    //   // Show Login Page
    //   if (snapshot!.authFlowStatus == AuthFlowStatus.login)
    //     Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //             builder: (context) => LoginPage(
    //                   shouldShowstart: _authService.showstart,
    //                   didProvideCredentials: _authService.loginWithCredentials,
    //                   shouldShowSignUp: _authService.showSignUp,
    //                 )));
    //
    //   // Show Sign Up Page
    //   if (snapshot!.authFlowStatus == AuthFlowStatus.signUp)
    //     Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //             builder: (context) => SignUpPage(
    //                   shouldShowstart: _authService.showstart,
    //                   didProvideCredentials: _authService.signUpWithCredentials,
    //                   shouldShowLogin: _authService.showLogin,
    //                 )));
    //
    //   // Show Verification Code Page
    //   if (snapshot!.authFlowStatus == AuthFlowStatus.verification)
    //     Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //             builder: (context) => VerificationPage(
    //                 didProvideVerificationCode: _authService.verifyCode)));
    //
    //   // Show Camera Flow
    //   if (snapshot!.authFlowStatus == AuthFlowStatus.session)
    //     Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //             builder: (context) =>
    //                 HomePage(shouldLogOut: _authService.logOut)));
    //
    //   //   MaterialPage(
    //   //   child: CameraFlow(shouldLogOut: _authService.logOut))
    //   // });
    // }
    // );
  // }

// void init(){
//   _configureAmplify();
// }

// void _configureAmplify() async {
//   try {
//     // await _amplify.addPlugin(AmplifyAuthCognito());
//     // await _amplify.addPlugin(AmplifyStorageS3());
//     final auth = AmplifyAuthCognito();
//     final storage = AmplifyStorageS3();
//     final analytics = AmplifyAnalyticsPinpoint();
//     await _amplify.addPlugins([auth, storage, analytics]);
//     await _amplify.configure(amplifyconfig);
//     _authService.checkAuthStatus();
//     print('Successfully configured Amplify 🎉');
//   } catch (e) {
//     print('Could not configure Amplify ☠️');
//   }
// }
}
