import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/core/widgets/input/text_field_widget.dart';
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
  final TextEditingController _checkPasswordController =
  TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _birthController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  final List<String> _year = List.generate(2020 - 1950 + 1, (i) => (1950 + i).toString());
  final List<String> _month = List.generate(12, (i) => (i + 1).toString());
  final List<String> _day = List.generate(31, (i) => (i + 1).toString());
  String _selectYear = '';
  String _selectMonth = '';
  String _selectDay = '';

  @override
  void initState() {
    super.initState();
  }

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
        userPhone: _phoneController.text
            .trim()
            .isNotEmpty
            ? _phoneController.text.trim()
            : null,
        userBirth: _birthController.text
            .trim()
            .isNotEmpty
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

  void _checkEmail() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(TitleLabels.signUp),
        leading: IconButton(
          onPressed: () => context.go('/login'),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              padding: EdgeInsets.all(AppSpacing.xl),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 이메일 입력 위젯
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextFieldWidget(
                            label: "이메일",
                            isRequired: true,
                            style: AppInputStyles.standard,
                            controller: _emailController,
                            decoration: AppInputDecorations.standard(
                              hintText: "abc@exam.com",
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () => _checkEmail,
                          child: Text("중복확인"),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(0, 55),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            backgroundColor: AppColors.main,
                            foregroundColor: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.xl),

                    // 비밀번호 입력 위젯
                    TextFieldWidget(
                      label: "비밀번호",
                      isRequired: true,
                      style: AppInputStyles.password,
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: AppInputDecorations.password(
                        hintText: "비밀번호를 입력하세요",
                        obscureText: _obscurePassword,
                        onToggleVisibility: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: AppSpacing.xl),

                    // 비밀번호 확인 입력 위젯
                    TextFieldWidget(
                      label: "비밀번호 확인",
                      isRequired: true,
                      style: AppInputStyles.password,
                      controller: _checkPasswordController,
                      obscureText: _obscurePassword,
                      decoration: AppInputDecorations.password(
                        hintText: "비밀번호를 다시 입력하세요",
                        obscureText: _obscurePassword,
                        onToggleVisibility: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: AppSpacing.xl),

                    // 이름 입력 위젯
                    TextFieldWidget(
                      label: "이름",
                      isRequired: true,
                      style: AppInputStyles.standard,
                      controller: _nameController,
                      decoration: AppInputDecorations.standard(
                        hintText: "이름을 입력하세요.",
                      ),
                      validator: (value) {
                          if(RegExp(r'[0-9]').hasMatch(value!)){
                            return '숫자는 입력할 수 없습니다.';
                          } else if(RegExp(r'[^가-힣a-zA-Z]').hasMatch(value)){
                            return '이름은 영어와 한글만 가능합니다.';
                          } else {
                            return null;
                          }
                      },
                    ),
                    SizedBox(height: AppSpacing.xl),

                    // 연락처 입력 위젯
                    TextFieldWidget(
                      label: "연락처",
                      isRequired: true,
                      style: AppInputStyles.standard,
                      controller: _phoneController,
                      decoration: AppInputDecorations.standard(
                        hintText: "연락처를 입력하세요.",
                      ),
                    ),
                    SizedBox(height: AppSpacing.xl),


                    // 생년 선택 위젯
                    Row(
                      children: [
                        Text(
                          "생년월일",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 2),
                        const Text(
                          "*",
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: dropdownField(
                            hint: 'YYYY',
                            items: _year,
                            value: _selectYear.isEmpty ? null : _selectYear,
                            onChanged: (y) => setState(() => _selectYear = y!),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: dropdownField(
                            hint: 'MM',
                            items: _month,
                            value: _selectMonth.isEmpty ? null : _selectMonth,
                            onChanged: (m) => setState(() => _selectMonth = m!),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: dropdownField(
                            hint: 'DD',
                            items: _day,
                            value: _selectDay.isEmpty ? null : _selectDay,
                            onChanged: (d) => setState(() => _selectDay = d!),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.lg),

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
                            : Text('회원가입하기'),
                      ),
                    ),
                    SizedBox(height: AppSpacing.lg),

                    // 로그인 링크
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('이미 계정이 있으신가요?'),
                        TextButton(
                          onPressed: _isLoading
                              ? null
                              : () => context.go('/login'),
                          child: Text('로그인하기'),
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
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _birthController.dispose();
    super.dispose();
  }
}

Widget dropdownField({
  required String hint,
  required List<String> items,
  required String? value,
  required ValueChanged<String?> onChanged,
}) {
  return InputDecorator(
    decoration: InputDecoration(
      filled: true,
      fillColor: const Color(0xFFFFFFFF),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFCACACA)),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        isExpanded: true,
        hint: Text(hint),
        value: value,
        items: items
            .map((e) => DropdownMenuItem<String>(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
      ),
    ),
  );
}
