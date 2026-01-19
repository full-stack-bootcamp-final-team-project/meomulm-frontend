import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/features/auth/data/datasources/auth_service.dart';

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
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _birthController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;


  void _handleSignup() async {

    setState(() {
      _isLoading = true;
    });

    try {
      // 회원가입 요청
      final user = await AuthService.signup(
        userEmail: _emailController.text.trim(),
        userPassword: _passwordController.text.trim(),
        userName: _nameController.text.trim(),
        userPhone: _phoneController.text.trim().isNotEmpty
            ? _phoneController.text.trim()
            : null,
        userBirth: _birthController.text.trim().isNotEmpty
            ? _birthController.text.trim()
            : null,
      );

      if (!mounted) return;

      // 회원가입 후 로그인 페이지로 이동
      context.go('/login');
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('회원가입에 실패했습니다: ${e.toString().replaceAll('Exception: ', '')}'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입', ),
        leading: IconButton(
          onPressed: () => context.go('/'),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: EdgeInsets.all(AppSpacing.xxl),
            constraints: BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_add, size: 100, color: AppColors.main),
                  SizedBox(height: AppSpacing.xxl),

                  // 이름 입력
                  TextField(
                    controller: _nameController,
                    enabled: !_isLoading,
                    decoration: AppInputDecorations.standard(
                      hintText: '이름을 입력하세요',
                    ),

                  ),
                  SizedBox(height: AppSpacing.xl),

                  // 이메일 입력
                  TextField(
                    controller: _emailController,
                    enabled: !_isLoading,
                    keyboardType: TextInputType.emailAddress,
                    decoration: AppInputDecorations.standard(
                      hintText: '이메일을 입력하세요',
                    ),

                  ),
                  SizedBox(height: AppSpacing.xl),

                  // 비밀번호 입력
                  TextField(
                    controller: _passwordController,
                    enabled: !_isLoading,
                    obscureText: _obscurePassword,
                    decoration: AppInputDecorations.password(
                      hintText: '비밀번호를 입력하세요',
                      obscureText: _obscurePassword,
                      onToggleVisibility: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),

                  ),
                  SizedBox(height: AppSpacing.xl),

                  // 전화번호 입력
                  TextField(
                    controller: _phoneController,
                    enabled: !_isLoading,
                    keyboardType: TextInputType.phone,
                    decoration: AppInputDecorations.standard(
                      hintText: '전화번호',
                    ),
                  ),
                  SizedBox(height: AppSpacing.xl),

                  // 생년월일 입력
                  TextField(
                    controller: _birthController,
                    enabled: !_isLoading,
                    keyboardType: TextInputType.datetime,
                    decoration: AppInputDecorations.standard(
                      hintText: '생년월일 (YYYY-MM-DD)',
                    ),
                  ),
                  SizedBox(height: AppSpacing.xxl),

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
                          ? CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      )
                          : Text(
                        '회원가입하기',

                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacing.lg),

                  // 로그인 링크
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '이미 계정이 있으신가요?',

                      ),
                      TextButton(
                        onPressed: _isLoading ? null : () => context.go('/login'),
                        child: Text(
                          '로그인하기',

                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _birthController.dispose();
    super.dispose();
  }
}