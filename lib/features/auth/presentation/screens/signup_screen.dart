import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/core/utils/keyboard_converter.dart';
import 'package:meomulm_frontend/core/utils/regexp_utils.dart';
import 'package:meomulm_frontend/core/widgets/appbar/app_bar_widget.dart';
import 'package:meomulm_frontend/core/widgets/dialogs/snack_messenger.dart';
import 'package:meomulm_frontend/features/auth/data/datasources/auth_service.dart';
import 'package:meomulm_frontend/features/auth/presentation/widget/signup/birth_date_selector.dart';
import 'package:meomulm_frontend/features/auth/presentation/widget/signup/signup_form_fields.dart';

class SignupScreen extends StatefulWidget {
  final Map<String, dynamic>? kakaoUser;
  const SignupScreen({super.key, this.kakaoUser});


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

  // 중복확인 체크 + 입력값 검증
  bool _isEmailChecked = false;
  bool _isPasswordChecked = false;
  bool _isCheckPasswordChecked = false;
  bool _isNameChecked = false;
  bool _isPhoneChecked = false;

  // 카카오로 회원가입인지 검증
  late final bool _isKakaoSignup;

  // 앱 시작하고 입력값 검증
  @override
  void initState() {
    super.initState();

    _isKakaoSignup = widget.kakaoUser != null;

    final kakaoUser = widget.kakaoUser;
    if (kakaoUser != null) {

      _emailController.text = (kakaoUser['userEmail'] ?? '').toString();
      _nameController.text  = (kakaoUser['userName'] ?? '').toString();

      _isEmailChecked = true;
      _isNameChecked = true;
    }

    if(_emailController.text.isEmpty){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _emailFocusNode.requestFocus();
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _passwordFocusNode.requestFocus();
      });
    }


    _passwordController.addListener(() {
      final password = _passwordController.text.trim();
      setState(() {
        _isPasswordChecked = RegexpUtils.validatePassword(password) == null;
      });
    });

    _checkPasswordController.addListener(() {
      final password = _passwordController.text.trim();
      final checkPassword = _checkPasswordController.text.trim();
      setState(() {
        _isCheckPasswordChecked = RegexpUtils.validateCheckPassword(password, checkPassword) == null;
      });
    });

    _nameController.addListener(() {
      final name = _nameController.text.trim();
      setState(() {
        _isNameChecked = RegexpUtils.validateName(name) == null;
      });
    });
  }

  // 회원가입
  void _handleSignup() async {
    // 빈 필드 체크
    if (_emailController.text.trim().isEmpty) {
      SnackMessenger.showMessage(
          context,
          "이메일을 입력하세요.",
          type: ToastType.error
      );
      return;
    }

    if (_passwordController.text.trim().isEmpty) {
      SnackMessenger.showMessage(
          context,
          "비밀번호를 입력하세요.",
          type: ToastType.error
      );
      return;
    }

    if (_checkPasswordController.text.trim().isEmpty) {
      SnackMessenger.showMessage(
          context,
          "비밀번호 확인을 입력하세요.",
          type: ToastType.error
      );
      return;
    }

    if (_nameController.text.trim().isEmpty) {
      SnackMessenger.showMessage(
          context,
          "이름을 입력하세요.",
          type: ToastType.error
      );
      return;
    }

    if (_phoneController.text.trim().isEmpty) {
      SnackMessenger.showMessage(
          context,
          "연락처를 입력하세요.",
          type: ToastType.error
      );
      return;
    }

    // Form validation 체크 (정규식 검증)
    if (!_formKey.currentState!.validate()) {
      SnackMessenger.showMessage(
          context,
          "입력 정보를 다시 확인해주세요.",
          type: ToastType.error
      );
      return;
    }

    if (_birthController.text.isEmpty) {
      SnackMessenger.showMessage(
          context,
          "생년월일을 선택해주세요.",
          type: ToastType.error
      );
      return;
    }

    if (!_isKakaoSignup && !_isEmailChecked) {
      SnackMessenger.showMessage(
          context,
          '이메일 중복 확인을 해주세요.',
          type: ToastType.error
      );
      return;
    }

    if (!_isPhoneChecked) {
      SnackMessenger.showMessage(
          context,
          '전화번호 중복 확인을 해주세요.',
          type: ToastType.error
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
      String phone = _phoneController.text.trim();

      if (KeyboardConverter.containsKorean(password)) {
        password = KeyboardConverter.convertToEnglish(password);
        SnackMessenger.showMessage(
            context,
            "비밀번호가 한글 키보드로 입력되어 자동 변환되었습니다.",
        );
      }

      if (KeyboardConverter.containsKorean(checkPassword)) {
        checkPassword = KeyboardConverter.convertToEnglish(checkPassword);
      }

      // 전화번호 - 여부 확인
      String checkPhone = PhoneNumberCheck(phone);

      // 회원가입 요청
      final user = await AuthService.signup(
        userEmail: _emailController.text.trim(),
        userPassword: password,
        userName: _nameController.text.trim(),
        userPhone: checkPhone,
        userBirth: _birthController.text.trim()
      );

      if (!mounted) return;
      SnackMessenger.showMessage(
          context,
          "회원가입이 완료되었습니다.",
          type: ToastType.success
      );

      // 회원가입 후 로그인 페이지로 이동
      context.push('${RoutePaths.login}');

    } catch (e) {
      if (!mounted) return;
      SnackMessenger.showMessage(
          context,
          '회원가입에 실패했습니다: ${e.toString().replaceAll('Exception: ', '')}',
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

  // 이메일 중복 확인
  void _checkEmail() async {
    final email = _emailController.text.trim();

    final checkEmail = RegexpUtils.validateEmail(email);

    if(checkEmail != null){
      SnackMessenger.showMessage(
          context,
          checkEmail,
          type: ToastType.error
      );
      return;
    }

    try {
      final isAvailable = await AuthService.checkEmailDuplicate(email);

      setState(() {
        _isEmailChecked = isAvailable;
      });

      SnackMessenger.showMessage(
          context,
          isAvailable ? '사용 가능한 이메일입니다.' : '이미 사용 중인 이메일입니다.',
          type: isAvailable ? ToastType.success : ToastType.error
      );


    } catch (e) {
      SnackMessenger.showMessage(
          context,
          '이메일 중복 확인에 실패했습니다.',
          type: ToastType.error
      );
    }
  }

  // 전화번호 중복 확인
  void _checkPhone() async {
    final phone = _phoneController.text.trim();

    final checkPhone = RegexpUtils.validatePhone(phone);

    if(checkPhone != null){
      SnackMessenger.showMessage(
          context,
          checkPhone,
          type: ToastType.error
      );
      return;
    }

    try {
      final isAvailable = await AuthService.checkPhoneDuplicate(phone);

      setState(() {
        _isPhoneChecked = isAvailable;
      });

      SnackMessenger.showMessage(
          context,
          isAvailable ? '사용 가능한 전화번호입니다.' : '이미 사용 중인 전화번호입니다.',
          type: isAvailable ? ToastType.success : ToastType.error
      );

    } catch (e) {
      SnackMessenger.showMessage(
          context,
          '전화번호 중복 확인에 실패했습니다.',
          type: ToastType.error
      );
    }
  }

  // 전화번호 - 확인 (없으면 추가)
  String PhoneNumberCheck(String phone) {
    if (phone.length == 10) {
      return '${phone.substring(0, 2)}-'
          '${phone.substring(2, 6)}-'
          '${phone.substring(6)}';
    }

    if (phone.length == 11) {
      return '${phone.substring(0, 3)}-'
          '${phone.substring(3, 7)}-'
          '${phone.substring(7)}';
    }

    return phone; // 형식이 다르면 원본 반환
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: "회원가입"),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 분리된 폼 필드 위젯 ~!
                    SignupFormFields(
                      isKakaoSignup: _isKakaoSignup,
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
                      onCheckEmail: _isKakaoSignup ? null : _checkEmail,
                      onCheckPhone: _checkPhone,
                      isEmailChecked: _isKakaoSignup ? true : _isEmailChecked,
                      isPasswordChecked: _isPasswordChecked,
                      isCheckPasswordChecked: _isCheckPasswordChecked,
                      isPhoneChecked: _isPhoneChecked,
                      isNameChecked: _isKakaoSignup ? true : _isNameChecked,
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
                              : () => context.push('${RoutePaths.login}'),
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