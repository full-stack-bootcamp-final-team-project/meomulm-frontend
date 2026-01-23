import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/core/theme/app_colors.dart';
import 'package:meomulm_frontend/core/theme/app_dimensions.dart';
import 'package:meomulm_frontend/core/theme/app_input_decorations.dart';
import 'package:meomulm_frontend/core/theme/app_input_styles.dart';
import 'package:meomulm_frontend/core/widgets/appbar/app_bar_widget.dart';
import 'package:meomulm_frontend/core/widgets/buttons/button_widgets.dart';
import 'package:meomulm_frontend/core/widgets/input/text_field_widget.dart';

/*
 * 마이페이지 - 비밀번호 변경 스크린
 */
class MypageChangePasswordScreen extends StatefulWidget {
  const MypageChangePasswordScreen({super.key});

  @override
  State<MypageChangePasswordScreen> createState() => _MypageChangePasswordScreenState();
}

class _MypageChangePasswordScreenState extends State<MypageChangePasswordScreen> {
  // TODO: DB에서 받아온 이메일로 변경
  final String _emailFromDb = 'abc@exam.com';

  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  // 비밀번호 input 필드 작성용 컨트롤러
  final TextEditingController passwordController = TextEditingController();
  bool _obscure = true;

  // ✅ 각 필드 아래 오류 텍스트
  String? _currentErr;
  String? _newErr;
  String? _confirmErr;

  bool _canSubmit = false;

  // (선택) "확인" 버튼 클릭 시 기존 비밀번호 검증 여부 표시용
  bool _currentChecked = false;

  @override
  void initState() {
    super.initState();
    _currentCtrl.addListener(_recalc);
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

  void _recalc() {
    final filled = _currentCtrl.text.trim().isNotEmpty &&
        _newCtrl.text.trim().isNotEmpty &&
        _confirmCtrl.text.trim().isNotEmpty;

    if (filled != _canSubmit) {
      setState(() => _canSubmit = filled);
    }

    // 입력 바뀌면 확인 상태 초기화(선택)
    if (_currentChecked) {
      setState(() => _currentChecked = false);
    }

    // 입력 중에는 실시간으로 confirm mismatch만 가볍게 처리(원치 않으면 제거 가능)
    final newPw = _newCtrl.text;
    final confirmPw = _confirmCtrl.text;
    if (confirmPw.isNotEmpty && newPw.isNotEmpty && confirmPw != newPw) {
      if (_confirmErr != InputMessages.mismatchPassword) {
        setState(() => _confirmErr = InputMessages.mismatchPassword);
      }
    } else {
      if (_confirmErr != null) {
        setState(() => _confirmErr = null);
      }
    }
  }

  // TODO: 현재 비밀번호 일치여부 확인 함수 구현
  Future<void> _checkCurrentPassword() async {
    final currentPw = _currentCtrl.text.trim();
    if (currentPw.isEmpty) {
      setState(() => _currentErr = InputMessages.emptyPassword);
      return;
    }

    // TODO: 서버에 기존 비밀번호 검증 API 호출
    // 예) final ok = await userService.verifyPassword(currentPw);

    // ✅ 데모: 임시로 "1234"만 맞다고 가정
    final ok = currentPw == '1234';

    setState(() {
      _currentChecked = ok;
      _currentErr = ok ? null : InputMessages.mismatchPassword;
    });
  }

  // TODO: 유효성 함수 구현
  bool _validateAll() {
    final currentPw = _currentCtrl.text.trim();
    final newPw = _newCtrl.text.trim();
    final confirmPw = _confirmCtrl.text.trim();

    String? currentPasswordErrorText;
    String? newPasswordErrorText;
    String? confirmPasswordErrorText;

    if (currentPw.isEmpty) currentPasswordErrorText = InputMessages.emptyPassword;
    if (newPw.isEmpty) newPasswordErrorText = InputMessages.emptyPassword;
    if (confirmPw.isEmpty) confirmPasswordErrorText = InputMessages.emptyPassword;

    // TODO: 새 비밀번호 규칙 변경
    if (newPw.isNotEmpty && newPw.length < 8) {
      newPasswordErrorText = InputMessages.invalidPassword;
    }

    // TODO: 빈 값 검사 + 비밀번호 확인 일치 여부 확인 조건 체크
    if (newPw.isNotEmpty && confirmPw.isNotEmpty && newPw != confirmPw) {
      confirmPasswordErrorText = InputMessages.mismatchPassword;
    }

    setState(() {
      _currentErr = currentPasswordErrorText;
      _newErr = newPasswordErrorText;
      _confirmErr = confirmPasswordErrorText;
    });

    return currentPasswordErrorText == null && newPasswordErrorText == null && confirmPasswordErrorText == null;
  }

  // TODO: 제출 함수 구현
  Future<void> _onSubmit() async {
    if (!_canSubmit) return;
    if (!_validateAll()) return;

    // (선택) "확인"을 반드시 누르게 하고 싶으면 아래 조건 사용
    // if (!_currentChecked) {
    //   setState(() => _currentErr = '기존 비밀번호 확인을 먼저 진행해 주세요.');
    //   return;
    // }

    final currentPw = _currentCtrl.text.trim();
    final newPw = _newCtrl.text.trim();

    // TODO: 비밀번호 변경 API 호출
    // 예) await userService.changePassword(currentPw: currentPw, newPw: newPw);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('비밀번호가 수정되었습니다'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(milliseconds: 1200),
      ),
    );

    // TODO: 이전 화면/마이페이지로 이동
    // context.pop();
    context.go('/');  // 추후 마이페이지 경로로 변경
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    // final maxWidth = w >= 600 ? 520.0 : double.infinity;
    final maxWidth = w >= 600 ? w : double.infinity;

    const enabledBtnColor = AppColors.main;
    const disabledBtnColor = AppColors.disabled;

    return Scaffold(
      appBar: AppBarWidget(title: TitleLabels.mypageChangePassword),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
              AppSpacing.xxl,
              AppSpacing.lg,
              AppSpacing.xxl,
              AppSpacing.xl,
            ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFieldWidget(
                    style: AppInputStyles.disabled,
                    decoration: AppInputDecorations.disabled(),
                    label: "이메일",
                    initialValue: _emailFromDb,
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // 기존 비밀번호 + 확인 버튼

                  // const _FieldLabel('기존 비밀번호'),
                  // const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: TextFieldWidget(
                          style: AppInputStyles.password,
                          obscureText: _obscure,
                          label: "기존 비밀번호",
                          decoration: AppInputDecorations.password(
                            hintText: '비밀번호를 입력하세요.',
                            obscureText: _obscure,
                            onToggleVisibility: () {
                              setState(() {
                                _obscure = !_obscure;
                              });
                            },
                          ),
                          errorText: "",  // TODO: 에러텍스트 표시 함수 구현 후 호출
                        ),
                      ),

                      const SizedBox(width: AppSpacing.sm),

                      SmallButton(
                        label: ButtonLabels.confirm,
                        onPressed: () {
                          // TODO: 버튼 클릭 시 기존 비밀번호와 입력값 일치 여부 확인 함수 구현 후 호출
                        },
                        enabled: true
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  TextFieldWidget(
                    style: AppInputStyles.password,
                    obscureText: _obscure,
                    label: "새 비밀번호",
                    decoration: AppInputDecorations.password(
                      hintText: '비밀번호를 입력하세요.',
                      obscureText: _obscure,
                      onToggleVisibility: () {
                        setState(() {
                          _obscure = !_obscure;
                        });
                      },
                    ),
                    errorText: "",  // TODO: 에러텍스트 표시 함수 구현 후 호출
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  TextFieldWidget(
                    style: AppInputStyles.password,
                    obscureText: _obscure,
                    label: "비밀번호 확인",
                    decoration: AppInputDecorations.password(
                      hintText: '비밀번호를 다시 입력하세요.',
                      obscureText: _obscure,
                      onToggleVisibility: () {
                        setState(() {
                          _obscure = !_obscure;
                        });
                      },
                    ),
                    errorText: "",  // TODO: 에러텍스트 표시 함수 구현 후 호출
                  ),

                  const SizedBox(height: AppSpacing.xxxl),

                  LargeButton(
                    label: ButtonLabels.edit,
                    onPressed: () {
                      // TODO: 버튼 클릭 시 백엔드와 연결하는 함수 구현 후 호출 (service)
                    },
                    enabled: false, // TODO: 유효성 검사 후 true로 변경하는 함수 구현 후 호출 
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
