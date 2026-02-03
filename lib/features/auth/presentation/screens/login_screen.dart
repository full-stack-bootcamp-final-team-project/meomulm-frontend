import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/core/utils/regexp_utils.dart';
import 'package:meomulm_frontend/features/auth/data/datasources/auth_service.dart';
import 'package:meomulm_frontend/features/auth/data/datasources/kakao_login_service.dart';
import 'package:meomulm_frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:meomulm_frontend/features/auth/presentation/widget/login/login_button_fields.dart';
import 'package:meomulm_frontend/features/auth/presentation/widget/login/login_input_fields.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _saveCheckBox = false;

  @override
  void initState() {
    super.initState();
    _loadSaveEmail();
    
    // 중복여부에 따른 이메일 표기
    _emailController.addListener(() {
      if (_saveCheckBox) {
        _saveOrRemoveEmail(_emailController.text);
      }
    });
  }

  // 이메일
  void _loadSaveEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final saveEmail = prefs.getString("saveEmail");
    if (saveEmail != null) {
      setState(() {
        _emailController.text = saveEmail;
        _saveCheckBox = true;
      });
    }
  }

  void _saveOrRemoveEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    if (_saveCheckBox) {
      await prefs.setString("saveEmail", email);
    } else {
      await prefs.remove("saveEmail");
    }
  }

  void _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final emailRegexp = RegexpUtils.validateEmail(email);
    final passwordRegexp = RegexpUtils.validatePassword(password);


    if(emailRegexp != null){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(emailRegexp),
          duration: const Duration(seconds: 2),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if(passwordRegexp != null){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(passwordRegexp),
          duration: const Duration(seconds: 2),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (!mounted) return;
      final loginResponse = await AuthService.login(email, password);

      _saveOrRemoveEmail(email);

      await context.read<AuthProvider>().login(loginResponse.token);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(SnackBarMessages.loginCompleted),
          backgroundColor: AppColors.success,
          duration: Duration(seconds: 2),
        ),
      );

      context.push('${RoutePaths.home}');

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('아아디 또는 비밀번호가 일치하지 않습니다.'),
          backgroundColor: AppColors.error,
          duration: Duration(seconds: 2),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _kakaoLogin() async {
    print('========== 카카오 로그인 시작 ==========');
    // 해시 키 확인
    final keyHash = await KakaoSdk.origin;
    print('KAKAO KEY HASH => $keyHash');

    setState(() {
      _isLoading = true;
    });

    try {
      print('1️⃣ 카카오 로그인 시도...');

      OAuthToken token;

      // 카카오톡 설치 여부 확인
      if (await isKakaoTalkInstalled()) {
        try {
          print('   📱 카카오톡 앱으로 로그인 시도');
          token = await UserApi.instance.loginWithKakaoTalk();
          print('   ✅ 카카오톡 앱 로그인 성공');
        } catch (error) {
          print('   ❌ 카카오톡 앱 로그인 실패: $error');

          if (error is PlatformException && error.code == 'CANCELED') {
            throw Exception('로그인이 취소되었습니다.');
          }

          print('   🌐 카카오 계정으로 재시도');
          token = await UserApi.instance.loginWithKakaoAccount();
          print('   ✅ 카카오 계정 로그인 성공');
        }
      } else {
        print('   🌐 카카오톡 미설치 - 카카오 계정으로 로그인');
        token = await UserApi.instance.loginWithKakaoAccount();
        print('   ✅ 카카오 계정 로그인 성공');
      }

      print('2️⃣ 액세스 토큰 획득');
      print('   토큰 앞 20자: ${token.accessToken.substring(0, 20)}...');

      print('3️⃣ 백엔드로 토큰 전송 중...');
      final kakaoService = KakaoLoginService();
      final response = await kakaoService.sendTokenToBackend(token.accessToken);

      print('4️⃣ 백엔드 응답 처리');

      if (!mounted) return;

      if (response.containsKey('token')) {
        // 로그인 성공
        print('5️⃣ JWT 토큰 저장 및 로그인 처리');
        await context.read<AuthProvider>().login(response['token']);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('카카오 로그인 성공!'),
            backgroundColor: AppColors.success,
            duration: Duration(seconds: 2),
          ),
        );

        context.go(RoutePaths.home);

      } else if (response['message'] == 'need_signup') {
        // 미가입 회원
        print('5️⃣ 미가입 회원 - 회원가입 페이지로 이동');

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('추가 정보를 입력해주세요'),
            backgroundColor: AppColors.error,
            duration: Duration(seconds: 2),
          ),
        );

        // 회원가입 페이지로 카카오 정보 전달
        context.push(
          RoutePaths.signup,
          extra: response['kakaoUser'],
        );
      }

      print('========== 카카오 로그인 완료 ==========');

    } on PlatformException catch (e) {
      print('========== ❌ PlatformException ==========');
      print('코드: ${e.code}');
      print('메시지: ${e.message}');

      if (!mounted) return;

      String errorMessage = '카카오 로그인 실패';
      if (e.code == 'CANCELED') {
        errorMessage = '로그인이 취소되었습니다.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: AppColors.error,
          duration: Duration(seconds: 2),
        ),
      );

    } catch (e, stackTrace) {
      print('========== ❌ 기타 에러 ==========');
      print('에러: $e');
      print('스택: $stackTrace');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('로그인 중 오류가 발생했습니다.'),
          backgroundColor: AppColors.error,
          duration: Duration(seconds: 2),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _naverLogin() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => context.push('${RoutePaths.home}'),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.xl),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LoginInputFields(
                      emailController: _emailController,
                      passwordController: _passwordController,
                    ),

                    // 체크박스
                    Row(
                      children: [
                        Checkbox(
                          value: _saveCheckBox,
                          activeColor: AppColors.main,
                          side: BorderSide(color: AppColors.main),
                          onChanged: (bool? value) {
                            setState(() {
                              _saveCheckBox = value!;
                            });
                            _saveOrRemoveEmail(_emailController.text);
                          },
                          splashRadius: 0,
                        ),
                        Text("이메일 저장", style: TextStyle(color: AppColors.main)),
                      ],
                    ),
                    SizedBox(height: AppSpacing.sm),

                    LoginButtonFields(
                        isLoading: _isLoading,
                        onLogin: _handleLogin,
                        onKakaoLogin: _kakaoLogin,
                        onNaverLogin: _naverLogin
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
