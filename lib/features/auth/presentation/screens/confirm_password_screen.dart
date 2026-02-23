import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/core/utils/regexp_utils.dart';
import 'package:meomulm_frontend/core/widgets/appbar/app_bar_widget.dart';
import 'package:meomulm_frontend/core/widgets/buttons/button_widgets.dart';
import 'package:meomulm_frontend/core/widgets/dialogs/snack_messenger.dart';
import 'package:meomulm_frontend/core/widgets/input/custom_text_field.dart';
import 'package:meomulm_frontend/features/auth/data/datasources/auth_service.dart';
import 'package:meomulm_frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:meomulm_frontend/features/auth/presentation/widget/signup/birth_date_selector.dart';
import 'package:provider/provider.dart';

class ConfirmPasswordScreen extends StatefulWidget {
  const ConfirmPasswordScreen({super.key});

  @override
  State<ConfirmPasswordScreen> createState() => _ConfirmPasswordScreenState();
}

class _ConfirmPasswordScreenState extends State<ConfirmPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _birthController = TextEditingController();
  final TextEditingController _emailCheckController = TextEditingController();

  // FocusNode
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _emailCheckFocusNode = FocusNode();

  bool _isCheckEmail = false;
  bool _isLoading = false;

  int _remainingSeconds = 180;
  Timer? _timer;

  void _startTimer() {
    _remainingSeconds = 180;

    _timer?.cancel();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _resendCode() async {
    await AuthService.sendEmailCode(
      _emailController.text.trim(),
    );
    SnackMessenger.showMessage(
      context,
      "재발송했습니다.",
      type: ToastType.success,
    );
    _startTimer();
  }

  // 이메일 인증
  void _confirmEmail() async {
    if(_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final email = _emailController.text.trim();
      final code = _emailCheckController.text.trim();

      final isUser = await AuthService.verifyEmailCode(
        email: email,
        code: code,
      );

      if(!mounted) return;

      if (isUser) {

        await context.read<AuthProvider>().saveVerifiedEmail(email);

        SnackMessenger.showMessage(
          context,
          "본인 인증에 성공했습니다.",
          type: ToastType.success,
        );
        context.push('${RoutePaths.loginChangePassword}');

      } else {
        SnackMessenger.showMessage(
          context,
          "인증번호가 올바르지 않거나 만료되었습니다.",
          type: ToastType.error,
        );
      }
    } catch (e) {
      if(!mounted) return;
      SnackMessenger.showMessage(
        context,
        "인증 실패 ${e}",
        type: ToastType.error,
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
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_){
      _emailFocusNode.requestFocus();
    });
  }

  // 본인 인증
  void _confirmPassword() async {
    // 입력값 검증
    final email = _emailController.text.trim();
    final birth = _birthController.text.trim();
    final emailRegexp = RegexpUtils.validateEmail(email);

    if(emailRegexp != null) {
      SnackMessenger.showMessage(
          context,
          emailRegexp,
          type: ToastType.error
      );
      return;
    }

    if(birth.isEmpty) {
      SnackMessenger.showMessage(
          context,
          InputMessages.emptyBirth,
          type: ToastType.error
      );
      return;
    }

    try {
      final result = await AuthService.confirmPassword(email, birth);

      if(!mounted) return;

      if(result == 1){
        await AuthService.sendEmailCode(email);
        print("sendEmailCode 호출됨");
        SnackMessenger.showMessage(
            context,
            "인증번호가 발송되었습니다.",
            type: ToastType.success
        );

        setState(() {
          _isCheckEmail = true;
        });
        _startTimer();

      } else {
        SnackMessenger.showMessage(
            context,
            "일치하는 정보가 없습니다.",
            type: ToastType.error
        );
      }

    } catch(e) {
      if (!mounted) return;
        SnackMessenger.showMessage(
            context,
            '오류 : $e',
            type: ToastType.error
        );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: TitleLabels.verifyIdentity),
      body: Stack(
        children: [
          Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              // 이메일 입력
              CustomTextField(
                label: "이메일",
                isRequired: true,
                hintText: "abc@exam.com",
                controller: _emailController,
                focusNode: _emailFocusNode,
                keyboardType: TextInputType.emailAddress,
                validator: (email) => RegexpUtils.validateEmail(email),
                enabled: !_isCheckEmail
              ),
              const SizedBox(height: 24),

              // 생년월일 입력
              BirthDateSelector(
                birthController: _birthController,
                  enabled: !_isCheckEmail
              ),


              if(_isCheckEmail)
                buildFieldWithButton(
                    field: CustomTextField(
                        hintText: "인증번호를 입력하세요",
                        controller: _emailCheckController,
                        focusNode: _emailCheckFocusNode,
                        enabled: true
                    ),
                    onPressed: _resendCode,
                    label: "재전송"
                ),

              if(_isCheckEmail)
                Text(
                  "남은시간: ${_remainingSeconds ~/ 60}:${(_remainingSeconds % 60).toString().padLeft(2, '0')}",
                  style: TextStyle(color: Colors.red),
                ),

              const SizedBox(height: 40),

              // 비밀번호 변경 버튼
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: !_isCheckEmail ? _confirmPassword : _confirmEmail,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: AppColors.gray6,
                    foregroundColor: AppColors.gray2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: AppColors.gray4),
                    ),
                  ),
                  child:Text(
                    !_isCheckEmail ? ButtonLabels.confirmUser : "확인",
                    style:  AppTextStyles.inputTextMd,
                  ),
                ),
              ),
            ],
          ),
        ),
          if(_isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.white.withOpacity(0.1), // 재 터치 방지용
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            )
        ]
      )
    );
  }
}