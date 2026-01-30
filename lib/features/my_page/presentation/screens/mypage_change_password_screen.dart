import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/core/theme/app_colors.dart';
import 'package:meomulm_frontend/core/theme/app_dimensions.dart';
import 'package:meomulm_frontend/core/theme/app_input_decorations.dart';
import 'package:meomulm_frontend/core/theme/app_input_styles.dart';
import 'package:meomulm_frontend/core/utils/regexp_utils.dart';
import 'package:meomulm_frontend/core/widgets/appbar/app_bar_widget.dart';
import 'package:meomulm_frontend/core/widgets/buttons/bottom_action_button.dart';
import 'package:meomulm_frontend/core/widgets/buttons/button_widgets.dart';
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
  String _currentErr = "";

  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  // FocusNode 생성
  final FocusNode _currentPwFocusNode = FocusNode();
  final FocusNode _newPwFocusNode = FocusNode();
  final FocusNode _confirmPwFocusNode = FocusNode();

  // 비밀번호 input 필드 작성용 컨트롤러
  final TextEditingController passwordController = TextEditingController();

  bool isSubmittable = false;

  // "확인" 버튼 클릭 시 기존 비밀번호 검증 여부 표시용
  bool _isCurrentChecked = false;

  @override
  void initState() {
    super.initState();
    _currentCtrl.addListener(() {
      if (_isCurrentChecked) {
        setState(() => _isCurrentChecked = false);
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
    final currentPassword = _currentCtrl.text.trim();
    final newPassword = _newCtrl.text.trim();
    final confirmPassword = _confirmCtrl.text.trim();

    final isFilled =
        currentPassword.isNotEmpty &&
        newPassword.isNotEmpty &&
        confirmPassword.isNotEmpty;

    final isRegexpOk =
        RegexpUtils.validatePassword(newPassword) == null &&
        RegexpUtils.validateCheckPassword(confirmPassword, newPassword) == null;

    if (isFilled != isSubmittable && isRegexpOk) {
      setState(() => isSubmittable = isFilled && isRegexpOk);
    }
  }

  // 비밀번호 확인 함수
  Future<void> _checkCurrentPassword() async {
    final currentPassword = _currentCtrl.text.trim();
    if (currentPassword.isEmpty) {
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
      setState(() => _isCurrentChecked = response);
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
    if (!isSubmittable) return;

    // "확인"을 반드시 눌러야 제출 가능
    if (!_isCurrentChecked) {
      setState(() => _currentErr = '기존 비밀번호 확인을 먼저 진행해 주세요.');
      return;
    }

    final newPassword = _newCtrl.text.trim();

    setState(() => isLoading = true);

    try {
      final token = context.read<AuthProvider>().token;
      if (token == null) return;

      final response = await mypageService.changePassword(token, newPassword);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('비밀번호가 수정되었습니다. 다시 로그인하세요.'),
          behavior: SnackBarBehavior.floating,
          duration: AppDurations.snackbar,
        ),
      );
      await context.read<AuthProvider>().logout();
      context.go('/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('비밀번호 수정에 실패했습니다.'),
          behavior: SnackBarBehavior.floating,
          duration: AppDurations.snackbar,
        ),
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
                        focusNode: _currentPwFocusNode,
                        validator: (currentPassword) =>
                            RegexpUtils.validatePassword(currentPassword),
                      ),
                      onPressed: _checkCurrentPassword,
                      label: ButtonLabels.confirm,
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    CustomTextField(
                      label: "새 비밀번호",
                      hintText: '비밀번호를 입력하세요.',
                      controller: _newCtrl,
                      focusNode: _newPwFocusNode,
                      validator: (newPassword) =>
                          RegexpUtils.validatePassword(newPassword),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    CustomTextField(
                      label: "비밀번호 확인",
                      hintText: '비밀번호를 다시 입력하세요.',
                      controller: _confirmCtrl,
                      focusNode: _confirmPwFocusNode,
                      validator: (confirmPassword) =>
                          RegexpUtils.validateCheckPassword(
                            confirmPassword,
                            _newCtrl.text.trim(),
                          ),
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
