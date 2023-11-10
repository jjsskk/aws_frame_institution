import 'package:aws_frame_institution/auth_flow/auth_service.dart';
import 'package:aws_frame_institution/find_password_page.dart';
import 'package:aws_frame_institution/loading_page/loading_page.dart';
import 'package:aws_frame_institution/login_session.dart';
import 'package:aws_frame_institution/login_page.dart';
import 'package:aws_frame_institution/provider/login_state.dart';
import 'package:aws_frame_institution/sign_up_page.dart';
import 'package:aws_frame_institution/verification_page.dart';
import 'package:flutter/material.dart';

// Amplify Flutter Packages
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_datastore/amplify_datastore.dart';

// import 'package:amplify_api/amplify_api.dart'; // UNCOMMENT this line after backend is deployed
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Generated in previous step
import 'models/ModelProvider.dart';
import 'amplifyconfiguration.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(ChangeNotifierProvider(
      create: (context) => LoginState(),
      builder: (context, child) {
        return MyApp();
      })));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  final _authService = AuthService();
  final _amplify = Amplify;
  bool _cacheautologin = true;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _loadautologin();
    _configureAmplify();
  }

  _loadautologin() async {
    _prefs = await SharedPreferences.getInstance(); // 캐시에 저장되어있는 값을 불러온다.
    setState(() {
      // 캐시에 저장된 값을 반영하여 현재 상태를 설정한다.
      // SharedPreferences에 id, pw로 저장된 값을 읽어 필드에 저장. 없을 경우 0으로 대입
      _cacheautologin = (_prefs.getBool('autologin') ?? false);
      print(
          'cache autologin :$_cacheautologin'); // Run 기록으로 id와 pw의 값을 확인할 수 있음.
    });
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<LoginState>();
    appState.authService = _authService;
    return MaterialApp(
      title: 'protector app for showing brain signal',
      theme: ThemeData(
        // colorScheme: ColorScheme(brightness: brightness, primary: primary, onPrimary: onPrimary, secondary: secondary, onSecondary: onSecondary, error: error, onError: onError, background: background, onBackground: onBackground, surface: surface, onSurface: onSurface),
          // dividerColor: Colors.white,
          // scaffoldBackgroundColor: Colors.black87,
        primaryColorLight: const Color(0xff2b3fee),
          primarySwatch: Colors.indigo,
          snackBarTheme: SnackBarThemeData(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
          textTheme: const TextTheme(
              subtitle1:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              //textstyle used for login and signup and resetpassword page
              subtitle2: TextStyle(
                color: Colors.black,
              )),
          //textstyle used for login and signup and resetpassword page

          // useMaterial3: true,
          visualDensity: VisualDensity.adaptivePlatformDensity),

      // 1 AuthState를 전송하는 스트림을 관찰할 StreamBuilder로 Navigator를 래핑했습니다
      home: StreamBuilder<AuthState>(
          // 2 AuthService 인스턴스의 authStateController에서 AuthState 스트림에 액세스합니다.
          stream: _authService.authStateController.stream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingPage();
            }

            // 3스트림에 데이터가 있을 수도 있고 없을 수도 있습니다.
            // AuthState 유형의 데이터에서 authFlowStatus에 안전하게 액세스하기 위해 여기에서는 먼저 검사를 구현합니다
            if (snapshot.hasData) {
              return Navigator(
                pages: [
                  // 4 스트림이 AuthFlowStatus.login을 전송하면 LoginPage가 표시됩니다
                  // Show Login Page
                  if (snapshot.data!.authFlowStatus == AuthFlowStatus.login)
                    MaterialPage(
                        child: LoginPage(
                      didProvideCredentials: _authService.loginWithCredentials,
                      shouldShowSignUp: _authService.showSignUp,
                      shouldShowsresetpassword: _authService.showresetpassword,
                    )),

                  // 5 스트림이 AuthFlowStatus.signUp을 전송하면 SignUpPage가 표시됩니다.
                  // Show Sign Up Page
                  if (snapshot.data!.authFlowStatus == AuthFlowStatus.signUp)
                    MaterialPage(
                        child: SignUpPage(
                      didProvideCredentials: _authService.signUpWithCredentials,
                      shouldShowLogin: _authService.showLogin,
                          resendConfirmCode: _authService.resendConfirmCode,
                    )),

                  // Show Verification Code Page
                  if (snapshot.data!.authFlowStatus ==
                      AuthFlowStatus.verification)
                    MaterialPage(
                        child: VerificationPage(
                      didProvideVerificationCode: _authService.verifyCode,
                      shouldShowSignUp: _authService.showSignUp,
                    )),

                  if (snapshot.data!.authFlowStatus ==
                      AuthFlowStatus.resetpassward)
                    MaterialPage(
                        child: Find_Password_Page(
                      shouldShowLogin: _authService.showLogin,
                      resetPassword: _authService.resetPassword,
                      confirmResetPassword: _authService.confirmResetPassword,
                    )),

                  // Show homepage
                  if (snapshot.data!.authFlowStatus == AuthFlowStatus.session)
                    MaterialPage(
                        child: LoginSession(shouldLogOut: _authService.logOut))
                ],
                onPopPage: (route, result) => route.didPop(result),
              );
            } else {
              // 6 스트림에 데이터가 없으면 CircularProgressIndicator가 표시됩니다
              return LoadingPage();
            }
          }),
    );
  }

  void _configureAmplify() async {
    try {
      // await _amplify.addPlugin(AmplifyAuthCognito());
      // await _amplify.addPlugin(AmplifyStorageS3());
      final auth = AmplifyAuthCognito();
      final storage = AmplifyStorageS3();
      final api = AmplifyAPI(modelProvider: ModelProvider.instance);
      // final analytics = AmplifyAnalyticsPinpoint();
      await _amplify.addPlugins([auth, storage, api]);
      await _amplify.configure(amplifyconfig);
      // mutateByApiName();
      _authService.checkAuthStatus(_cacheautologin);

      print('Successfully configured Amplify 🎉');
    } catch (e) {
      print('Could not configure Amplify ☠️');
    }
  }

  Future<void> mutateByApiName() async {
    final operation = Amplify.API.mutate<String>(
      request: GraphQLRequest(
        document: 'schemaTest.graphql',
        apiName: 'awsamplify',
      ),
    );
    final response = await operation.response;
    final data = response.data;
    safePrint('data: $data');
  }
}
