import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/core/utils/keyboard_converter.dart';
import 'package:meomulm_frontend/features/auth/data/datasources/auth_service.dart';
import 'package:meomulm_frontend/features/auth/presentation/widgets/signup_form_fields.dart';
import 'package:meomulm_frontend/features/auth/presentation/widgets/birth_date_selector.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _checkPasswordController =
  TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _birthController = TextEditingController();

  // FocusNode들을 생성
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _checkPasswordFocusNode = FocusNode();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // 실시간 검증이 autovalidateMode로 처리되므로
    // FocusNode 리스너는 필요 없음
  }

  void _handleSignup() async {
    // 빈 필드 체크
    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("이메일을 입력하세요."),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("비밀번호를 입력하세요."),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_checkPasswordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("비밀번호 확인을 입력하세요."),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("이름을 입력하세요."),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("연락처를 입력하세요."),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Form validation 체크 (정규식 검증)
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("입력 정보를 다시 확인해주세요."),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // 생년월일 확인
    if (_birthController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("생년월일을 선택해주세요."),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 비밀번호에 한글이 있으면 영어로 변환
      String password = _passwordController.text.trim();
      String checkPassword = _checkPasswordController.text.trim();

      if (KeyboardConverter.containsKorean(password)) {
        password = KeyboardConverter.convertToEnglish(password);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("비밀번호가 한글 키보드로 입력되어 자동 변환되었습니다."),
            duration: Duration(seconds: 2),
          ),
        );
      }

      if (KeyboardConverter.containsKorean(checkPassword)) {
        checkPassword = KeyboardConverter.convertToEnglish(checkPassword);
      }

      // 회원가입 요청
      final user = await AuthService.signup(
        userEmail: _emailController.text.trim(),
        userPassword: password,
        userName: _nameController.text.trim(),
        userPhone: _phoneController.text.trim().isNotEmpty
            ? _phoneController.text.trim()
            : null,
        userBirth: _birthController.text.trim().isNotEmpty
            ? _birthController.text.trim()
            : null,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("회원가입이 완료되었습니다.")),
      );

      // 회원가입 후 로그인 페이지로 이동
      context.go('/login');
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '회원가입에 실패했습니다: ${e.toString().replaceAll('Exception: ', '')}',
          ),
          backgroundColor: AppColors.error,
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

  void _checkEmail() async {
    // TODO: 이메일 중복 확인 API 호출
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("이메일 중복 확인 기능 구현 예정")),
    );
  }

  void _checkPhone() {
    // TODO: 전화번호 중복 확인 API 호출
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("전화번호 중복 확인 기능 구현 예정")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text(TitleLabels.signUp),
        leading: IconButton(
          onPressed: () => context.go('/login'),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Form(
                key: _formKey,
                // Form 레벨에서는 autovalidateMode 제거
                // 각 필드가 독립적으로 실시간 검증
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 분리된 폼 필드 위젯 ~!
                    SignupFormFields(
                      emailController: _emailController,
                      passwordController: _passwordController,
                      checkPasswordController: _checkPasswordController,
                      nameController: _nameController,
                      phoneController: _phoneController,
                      emailFocusNode: _emailFocusNode,
                      passwordFocusNode: _passwordFocusNode,
                      checkPasswordFocusNode: _checkPasswordFocusNode,
                      nameFocusNode: _nameFocusNode,
                      phoneFocusNode: _phoneFocusNode,
                      onCheckEmail: _checkEmail,
                      onCheckPhone: _checkPhone,
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // 분리된 생년월일 선택 위젯
                    BirthDateSelector(
                      birthController: _birthController,
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // 회원가입 버튼
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleSignup,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.main,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: AppColors.gray4,
                          shape: RoundedRectangleBorder(
                            borderRadius: AppBorderRadius.mediumRadius,
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        )
                            : const Text(ButtonLabels.signUp),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // 로그인 링크
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('이미 계정이 있으신가요?'),
                        TextButton(
                          onPressed: _isLoading
                              ? null
                              : () => context.go('/login'),
                          child: const Text('로그인하기'),
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
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _checkPasswordFocusNode.dispose();
    _nameFocusNode.dispose();
    _phoneFocusNode.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _checkPasswordController.dispose();
    _phoneController.dispose();
    _birthController.dispose();
    super.dispose();
  }
}