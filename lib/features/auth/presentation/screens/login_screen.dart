import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/core/widgets/dialogs/snack_messenger.dart';
import 'package:meomulm_frontend/core/widgets/input/text_field_widget.dart';
import 'package:meomulm_frontend/features/auth/data/datasources/auth_service.dart';
import 'package:meomulm_frontend/features/auth/presentation/providers/auth_provider.dart';
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

  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _saveCheckBox = false;

  @override
  void initState() {
    super.initState();
    _loadSaveEmail();
  }

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

    if (email.isEmpty) {
      _showErrorMessage("이메일을 입력해주세요.");
      return;
    }

    if (!email.contains('@')) {
      _showErrorMessage("올바른 이메일 형식이 아닙니다.");
      return;
    }

    if (password.isEmpty) {
      _showErrorMessage("비밀번호를 입력해주세요.");
      return;
    }

    if (password.length < 8 || password.length > 16) {
      _showErrorMessage("비밀번호는 8~16자의 영문 대소문자, 숫자, 특수문자만 가능합니다.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (!mounted) return;
      final loginResponse = await AuthService.login(email, password);

      await context.read<AuthProvider>().login(loginResponse.token);

      context.go('/home');
    } catch (e) {
      if (!mounted) return;

      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('${ButtonLabels.login}에 실패했습니다'),
      //     backgroundColor: AppColors.error,
      //     duration: Duration(seconds: 2),
      //   ),
      // );
      SnackMessenger.showMessage(
          context,
          "${ButtonLabels.login}에 실패했습니다.",
          type: ToastType.error
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorMessage(String message) {
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text(message),
    //     backgroundColor: AppColors.error,
    //     duration: Duration(seconds: 2),
    //   ),
    // );
    SnackMessenger.showMessage(
        context,
        "${message}",
        type: ToastType.error
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
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
                    Image.asset('assets/images/login_logo.png', height: 80),
                    SizedBox(height: 50),

                    // 로그인 바
                    Row(
                      children: [
                        Expanded(child: Divider()),
                        Padding(
                          padding: EdgeInsetsGeometry.symmetric(horizontal: 12),
                          child: Text(
                            "${ButtonLabels.login}",
                            style: TextStyle(
                              color: AppColors.gray2,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),

                    SizedBox(height: AppSpacing.xxl),

                    TextFieldWidget(
                      hintText: "이메일를 입력하세요",
                      style: AppInputStyles.standard,
                      controller: _emailController,
                    ),
                    SizedBox(height: AppSpacing.lg),
                    TextFieldWidget(
                      hintText: "비밀번호를 입력하세요",
                      style: AppInputStyles.password,
                      controller: _passwordController,
                    ),
                    SizedBox(height: AppSpacing.sm),

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

                    // 로그인 버튼
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.main,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: AppColors.gray4,
                          shape: RoundedRectangleBorder(
                            borderRadius: AppBorderRadius.mediumRadius,
                          ),
                        ),
                        child: _isLoading
                            ? CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              )
                            : Text(
                                '${ButtonLabels.login}',
                                style: AppTextStyles.buttonLg,
                              ),
                      ),
                    ),
                    SizedBox(height: AppSpacing.lg),

                    // 카카오로그인 버튼
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.kakaoBg,
                          foregroundColor: AppColors.black,
                          disabledBackgroundColor: AppColors.gray4,
                          shape: RoundedRectangleBorder(
                            borderRadius: AppBorderRadius.mediumRadius,
                          ),
                        ),
                        child: _isLoading
                            ? CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/kakao_logo.png',
                                    height: 20,
                                  ),
                                  const SizedBox(width: 20),
                                  Text('카카오로그인', style: AppTextStyles.buttonLg),
                                ],
                              ),
                      ),
                    ),
                    SizedBox(height: AppSpacing.lg),

                    // 네이버로그인 버튼
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.naverBg,
                          foregroundColor: AppColors.white,
                          disabledBackgroundColor: AppColors.gray4,
                          shape: RoundedRectangleBorder(
                            borderRadius: AppBorderRadius.mediumRadius,
                          ),
                        ),
                        child: _isLoading
                            ? CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/naver_logo.png',
                                    height: 20,
                                  ),
                                  const SizedBox(width: 20),
                                  Text('네이버로그인', style: AppTextStyles.buttonLg),
                                ],
                              ),
                      ),
                    ),
                    SizedBox(height: AppSpacing.lg),

                    // 아이디 찾기 / 비밀번호 찾기 버튼 (색상이랑 사이즈 맞추려면 styles 추가해야함)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () => context.go('/find-id'),
                          style: TextButton.styleFrom(
                            overlayColor: Colors.transparent,
                          ),
                          child: Text(
                            "${ButtonLabels.findId}",
                            style: TextStyle(
                              color: AppColors.main,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        SizedBox(width: 1),
                        Text(
                          "|",
                          style: TextStyle(color: AppColors.main, fontSize: 14),
                        ),
                        SizedBox(width: 1),
                        TextButton(
                          onPressed: () => context.go('/confirm-password'),
                          style: TextButton.styleFrom(
                            overlayColor: Colors.transparent,
                          ),
                          child: Text(
                            "${ButtonLabels.changePassword}",
                            style: TextStyle(
                              color: AppColors.main,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 50),

                    // 회원가입 링크
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '계정이 없으신가요?',
                          style: TextStyle(color: AppColors.main),
                        ),
                        TextButton(
                          onPressed: _isLoading
                              ? null
                              : () => context.go('/signup'),
                          style: TextButton.styleFrom(
                            overlayColor: Colors.transparent,
                          ),
                          child: Text('회원가입하기', style: AppTextStyles.bodyMd),
                        ),
                      ],
                    ),
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
