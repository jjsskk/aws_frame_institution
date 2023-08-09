// import 'package:aws_frame_account/auth_service.dart';
// import 'package:aws_frame_account/login_session.dart';
// import 'package:aws_frame_account/globalkey.dart';
// import 'package:aws_frame_account/home_page.dart';
// import 'package:aws_frame_account/login_page.dart';
// import 'package:aws_frame_account/provider_login/login_state.dart';
// import 'package:aws_frame_account/sign_up_page.dart';
// import 'package:aws_frame_account/verification_page.dart';
// import 'package:aws_frame_account/protector_service/protector_service.dart';
// import 'package:flutter/material.dart';
//
// // Amplify Flutter Packages
// import 'package:amplify_flutter/amplify_flutter.dart';
// import 'package:amplify_datastore/amplify_datastore.dart';
//
// // import 'package:amplify_api/amplify_api.dart'; // UNCOMMENT this line after backend is deployed
// import 'package:amplify_api/amplify_api.dart';
// import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
// import 'package:amplify_storage_s3/amplify_storage_s3.dart';
// import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
// import 'package:path/path.dart';
//
// // Generated in previous step
// import 'models/ModelProvider.dart';
// import 'amplifyconfiguration.dart';
// import 'package:provider/provider.dart';
//
// void main() {
//   runApp(ChangeNotifierProvider(
//       create: (context) => LoginState(),
//       builder: (context, child) {
//         return MyApp();
//       }));
// }
//
// class MyApp extends StatefulWidget {
//   const MyApp({super.key});
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   // This widget is the root of your application.
//
//   late var _authService;
//
//   // final _amplify = Amplify;
//
//   @override
//   void initState() {
//     super.initState();
//     // _configureAmplify();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var appState = context.watch<LoginState>();
//     // appState.set(_authService);
//     _authService = appState.get();
//     return MaterialApp(
//       navigatorKey: NavigationService.naviagatorState,
//       title: 'Photo Gallery App',
//       theme: ThemeData(visualDensity: VisualDensity.adaptivePlatformDensity),
//       initialRoute: '/',
//       routes: {
//         '/': (BuildContext context) =>
//             StartPage(shouldShowlogin: _authService.showLogin),
//         '/login': (BuildContext context) => LoginPage(
//             didProvideCredentials: _authService.loginWithCredentials,
//             shouldShowSignUp: _authService.showSignUp,
//             shouldShowstart: _authService.showstart),
//         '/signup': (BuildContext context) => SignUpPage(
//             didProvideCredentials: _authService.signUpWithCredentials,
//             shouldShowLogin: _authService.showLogin,
//             shouldShowstart: _authService.showstart),
//         '/verification': (BuildContext context) => VerificationPage(
//             didProvideVerificationCode:
//                 _authService.verifyCode),
//         '/home': (BuildContext context) =>
//             HomePage(shouldLogOut: _authService.logOut)
//       },
//     );
//   }
//
// // void _configureAmplify() async {
// //   try {
// //     // await _amplify.addPlugin(AmplifyAuthCognito());
// //     // await _amplify.addPlugin(AmplifyStorageS3());
// //     final auth = AmplifyAuthCognito();
// //     final storage = AmplifyStorageS3();
// //     final analytics = AmplifyAnalyticsPinpoint();
// //     await _amplify.addPlugins([auth,storage,analytics]);
// //     await _amplify.configure(amplifyconfig);
// //     _authService.checkAuthStatus();
// //
// //     print('Successfully configured Amplify 🎉');
// //   } catch (e) {
// //     print('Could not configure Amplify ☠️');
// //   }
// // }
// }
