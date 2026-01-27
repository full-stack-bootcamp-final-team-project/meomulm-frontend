import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/core/constants/config/app_config.dart';
import 'package:meomulm_frontend/core/constants/ui/labels_constants.dart';
import 'package:meomulm_frontend/core/theme/app_dimensions.dart';
import 'package:meomulm_frontend/core/theme/app_input_decorations.dart';
import 'package:meomulm_frontend/core/theme/app_input_styles.dart';
import 'package:meomulm_frontend/core/widgets/appbar/app_bar_widget.dart';
import 'package:meomulm_frontend/core/widgets/buttons/button_widgets.dart';
import 'package:meomulm_frontend/core/widgets/input/text_field_widget.dart';

/*
 * 마이페이지 - 회원정보 수정 스크린
 */
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // ✅ DB에서 받아온 값(예시) - 실제로는 API/Provider로 주입
  final String _emailFromDb = 'gangster@exam.com';
  final String _birthYearFromDb = "2000";
  final String _birthMonthFromDb = "11";
  final String _birthDayFromDb = "22";

  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;

  bool _canSubmit = false;

  @override
  void initState() {
    super.initState();

    // ✅ DB에서 받아온 값(예시) - 이름/연락처도 초기값 세팅 가능
    _nameCtrl = TextEditingController(text: '김철훈');
    _phoneCtrl = TextEditingController(text: '010-1234-1234');

    _nameCtrl.addListener(_recalc);
    _phoneCtrl.addListener(_recalc);
    _recalc();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _recalc() {
    final ok = _nameCtrl.text.trim().isNotEmpty && _phoneCtrl.text.trim().isNotEmpty;
    if (ok != _canSubmit) {
      setState(() => _canSubmit = ok);
    }
  }

  Future<void> _onSubmit() async {
    if (!_canSubmit) return;

    final name = _nameCtrl.text.trim();
    final phone = _phoneCtrl.text.trim();

    // TODO: 회원정보 수정 API 호출 - service
    // 예) await userService.updateProfile(name: name, phone: phone);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('회원정보가 수정되었습니다'),
        behavior: SnackBarBehavior.floating,
        duration: AppDurations.snackbar,
      ),
    );

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    // final maxWidth = w >= 600 ? 520.0 : double.infinity;
    final maxWidth = w >= 600 ? w : double.infinity;

    const enabledBtnColor = Color(0xFF9B93CF); // ✅ 기존 스크린 계열 보라색
    const disabledBtnColor = Color(0xFFE6E6E6);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWidget(title: "회원정보 수정"),
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
                  SizedBox(height: AppSpacing.md),
                  // 이메일 (Disabled)
                  TextFieldWidget(
                    label: "이메일",
                    style: AppInputStyles.disabled,
                    initialValue: _emailFromDb,
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // 이름 (Editable)
                  TextFieldWidget(
                    label: "이름",
                    style: AppInputStyles.standard,
                    controller: _nameCtrl,
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // 연락처 (Editable)
                  TextFieldWidget(
                    label: "연락처",
                    style: AppInputStyles.standard,
                    controller: _phoneCtrl,
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // 생년월일 (Disabled - 3칸)
                  Row(
                    children: [
                      Expanded(
                          flex: 2,
                          child: TextFieldWidget(
                            label: "생년월일",
                            style: AppInputStyles.disabled,
                            initialValue: _birthYearFromDb,
                          )
                      ),
                      SizedBox(width: AppSpacing.sm),
                      Expanded(
                          flex: 1,
                          child: TextFieldWidget(
                            label: " ",
                            style: AppInputStyles.disabled,
                            initialValue: _birthMonthFromDb,
                          )
                      ),
                      SizedBox(width: AppSpacing.sm),
                      Expanded(
                          flex: 1,
                          child: TextFieldWidget(
                            label: " ",
                            style: AppInputStyles.disabled,
                            initialValue: _birthDayFromDb,
                          )
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // 버튼
                  LargeButton(
                      label: ButtonLabels.edit,
                      onPressed: () {
                        // TODO: 버튼 클릭 시 백엔드로 데이터 보내는 로직 작성
                        // TODO: 백엔드에서 정상 처리 시(200) 마이페이지로 이동하는 로직 작성
                      },
                      enabled: false // TODO: 유효성 검사 후 모든 항목이 채워졌을 때 true로 만들기
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