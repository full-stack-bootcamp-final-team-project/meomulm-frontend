import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/core/theme/app_colors.dart';
import 'package:meomulm_frontend/core/theme/app_dimensions.dart';
import 'package:meomulm_frontend/core/theme/app_input_decorations.dart';
import 'package:meomulm_frontend/core/theme/app_input_styles.dart';
import 'package:meomulm_frontend/core/utils/keyboard_converter.dart';
import 'package:meomulm_frontend/core/utils/regexp_utils.dart';
import 'package:meomulm_frontend/core/widgets/appbar/app_bar_widget.dart';
import 'package:meomulm_frontend/core/widgets/buttons/bottom_action_button.dart';
import 'package:meomulm_frontend/core/widgets/buttons/button_widgets.dart';
import 'package:meomulm_frontend/core/widgets/dialogs/snack_messenger.dart';
import 'package:meomulm_frontend/core/widgets/input/custom_text_field.dart';
import 'package:meomulm_frontend/core/widgets/input/text_field_widget.dart';
import 'package:meomulm_frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:meomulm_frontend/features/my_page/data/datasources/mypage_service.dart';
import 'package:meomulm_frontend/features/my_page/data/models/user_profile_model.dart';
import 'package:provider/provider.dart';

/*
 * 마이페이지 - 비밀번호 변경 스크린
 */
class MypageChangePasswordScreen extends StatefulWidget {
  final UserProfileModel user;

  const MypageChangePasswordScreen({super.key, required this.user});

  @override
  State<MypageChangePasswordScreen> createState() =>
      _MypageChangePasswordScreenState();
}

class _MypageChangePasswordScreenState
    extends State<MypageChangePasswordScreen> {
  final mypageService = MypageService();
  bool isLoading = false;
  String _currentErr = '';
  // 유효성 검사 통과 여부 & 제출 가능 여부
  bool _isCurrentPwChecked = false;  // 확인 버튼 클릭 여부
  bool _isCurrentPwIdentical = false;  // 현재 비밀번호 일치 여부
  bool _isNewPwAvailable = false;      // 새 비밀번호 사용 가능 여부
  bool _isConfirmPwIdentical = false;  // 비밀번호 확인 일치 여부
  bool isSubmittable = false;

  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  // FocusNode 생성
  final FocusNode _currentPwFocusNode = FocusNode();
  final FocusNode _newPwFocusNode = FocusNode();
  final FocusNode _confirmPwFocusNode = FocusNode();

  // 비밀번호 input 필드 작성용 컨트롤러
  final TextEditingController passwordController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _currentCtrl.addListener(() {
      if (_isCurrentPwChecked) {
        setState(() => _isCurrentPwChecked = false);  // 현재 비밀번호 다시 입력 시 확인 여부 초기화
      }
      _recalc();
    });
    _newCtrl.addListener(_recalc);
    _confirmCtrl.addListener(_recalc);
    _recalc();
  }

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  // 실시간 유효성 검증 함수
  void _recalc() {
    String currentPassword = _currentCtrl.text.trim();
    String newPassword = _newCtrl.text.trim();
    String confirmPassword = _confirmCtrl.text.trim();

    // 한글 입력 시 영어로 자동 변환
    if(KeyboardConverter.containsKorean(currentPassword)) {
      currentPassword = KeyboardConverter.convertToEnglish(currentPassword);
    }
    if(KeyboardConverter.containsKorean(newPassword)) {
      newPassword = KeyboardConverter.convertToEnglish(newPassword);
    }
    if(KeyboardConverter.containsKorean(confirmPassword)) {
      confirmPassword = KeyboardConverter.convertToEnglish(confirmPassword);
    }

    setState(() => _isNewPwAvailable = RegexpUtils.validatePassword(newPassword) == null);
    setState(() => _isConfirmPwIdentical =
        RegexpUtils.validateCheckPassword(confirmPassword, newPassword) == null);

    final isRegexpOk = _isNewPwAvailable && _isConfirmPwIdentical;

    if (isSubmittable != isRegexpOk) {
      setState(() => isSubmittable = isRegexpOk);
    }
  }

  // 비밀번호 확인 함수
  Future<void> _checkCurrentPassword() async {
    final currentPassword = _currentCtrl.text.trim();
    if (currentPassword.isEmpty) {
      SnackMessenger.showMessage(
        context,
        "현재 비밀번호를 입력하세요.",
        type: ToastType.error
      );
      return;
    }
    setState(() => isLoading = true);
    try {
      final token = context.read<AuthProvider>().token;
      if (token == null) return;
      final response = await mypageService.checkCurrentPassword(
        token,
        currentPassword,
      );
      setState(() {
        _isCurrentPwChecked = response;
        _isCurrentPwIdentical = response;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("비밀번호 확인에 실패했습니다: $e")));
      return;
    } finally {
      setState(() => isLoading = false);
    }
  }

  // 제출 함수
  Future<void> _onSubmit() async {
    // "확인"을 반드시 눌러야 제출 가능
    if (!_isCurrentPwChecked) {
      SnackMessenger.showMessage(
          context,
          "현재 비밀번호 확인을 먼저 진행해 주세요.",
          type: ToastType.error
      );
      return;
    }

    // 제출 가능 상태인지 확인
    if (!isSubmittable) {
      SnackMessenger.showMessage(
          context,
          "모든 항목이 제대로 입력되었는지 확인해주세요.",
          type: ToastType.error
      );
      return;
    }

    final newPassword = _newCtrl.text.trim();

    setState(() => isLoading = true);

    try {
      final token = context.read<AuthProvider>().token;
      if (token == null) return;

      final response = await mypageService.changePassword(token, newPassword);

      if (!mounted) return;
      SnackMessenger.showMessage(
          context,
          "비밀번호가 수정되었습니다. 다시 로그인하세요.",
          type: ToastType.success
      );
      await context.read<AuthProvider>().logout();
      context.go('/login');
    } catch (e) {
      SnackMessenger.showMessage(
          context,
          "비밀번호 수정에 실패했습니다.",
          type: ToastType.error
      );
      return;
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final maxWidth = w >= 600 ? w : double.infinity;

    const enabledBtnColor = AppColors.main;
    const disabledBtnColor = AppColors.disabled;

    return Scaffold(
      appBar: AppBarWidget(title: TitleLabels.mypageChangePassword),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xxl,
                AppSpacing.lg,
                AppSpacing.xxl,
                // AppSpacing.xl,
                120,
              ),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFieldWidget(
                      label: "이메일",
                      initialValue: widget.user.userEmail,
                      style: AppInputStyles.disabled,
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    buildFieldWithButton(
                      field: CustomTextField(
                        label: "기존 비밀번호",
                        hintText: "비밀번호를 입력하세요.",
                        controller: _currentCtrl,
                        obscureText: true,
                        focusNode: _currentPwFocusNode,
                        validator: (currentPassword) =>
                            RegexpUtils.validatePassword(currentPassword),
                        helperText: _isCurrentPwIdentical ? InputMessages.matchPassword : null,
                        helperStyle: TextStyle(color: AppColors.success),
                      ),
                      onPressed: _checkCurrentPassword,
                      label: ButtonLabels.confirm,
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    CustomTextField(
                      label: "새 비밀번호",
                      hintText: '비밀번호를 입력하세요.',
                      controller: _newCtrl,
                      obscureText: true,
                      focusNode: _newPwFocusNode,
                      validator: (newPassword) =>
                          RegexpUtils.validatePassword(newPassword),
                      helperText: _isNewPwAvailable ? InputMessages.validPassword : null,
                      helperStyle: TextStyle(color: AppColors.success),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    CustomTextField(
                      label: "비밀번호 확인",
                      hintText: '비밀번호를 다시 입력하세요.',
                      controller: _confirmCtrl,
                      obscureText: true,
                      focusNode: _confirmPwFocusNode,
                      validator: (confirmPassword) =>
                          RegexpUtils.validateCheckPassword(
                            confirmPassword,
                            _newCtrl.text.trim(),
                          ),
                      helperText: _isConfirmPwIdentical ? InputMessages.matchPassword : null,
                      helperStyle: TextStyle(color: AppColors.success),
                    ),

                    const SizedBox(height: AppSpacing.xxxl),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: SizedBox(
          height: 100,
          child: BottomActionButton(
            label: ButtonLabels.edit,
            onPressed: _onSubmit,
            // TODO: enabled 표시 - enabled: isSubmittable,
          ),
        )
      ),
    );
  }
}
