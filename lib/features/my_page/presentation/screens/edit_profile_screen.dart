import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/core/constants/config/app_config.dart';
import 'package:meomulm_frontend/core/constants/paths/route_paths.dart';
import 'package:meomulm_frontend/core/constants/ui/labels_constants.dart';
import 'package:meomulm_frontend/core/theme/app_dimensions.dart';
import 'package:meomulm_frontend/core/theme/app_input_decorations.dart';
import 'package:meomulm_frontend/core/theme/app_input_styles.dart';
import 'package:meomulm_frontend/core/widgets/appbar/app_bar_widget.dart';
import 'package:meomulm_frontend/core/widgets/buttons/bottom_action_button.dart';
import 'package:meomulm_frontend/core/widgets/buttons/button_widgets.dart';
import 'package:meomulm_frontend/core/widgets/input/text_field_widget.dart';
import 'package:meomulm_frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:meomulm_frontend/features/my_page/data/datasources/mypage_service.dart';
import 'package:meomulm_frontend/features/my_page/data/models/edit_profile_request_model.dart';
import 'package:meomulm_frontend/features/my_page/data/models/user_profile_model.dart';
import 'package:meomulm_frontend/features/my_page/presentation/providers/user_profile_provider.dart';
import 'package:provider/provider.dart';

/*
 * 마이페이지 - 회원정보 수정 스크린
 */
class EditProfileScreen extends StatefulWidget {
  final UserProfileModel user;
  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // TODO: 백엔드에서 불러온 생년월일 분리
  final String _birthYearFromDb = "2000";
  final String _birthMonthFromDb = "11";
  final String _birthDayFromDb = "22";

  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;

  bool _canSubmit = false;

  @override
  void initState() {
    super.initState();

    _nameCtrl = TextEditingController(text: widget.user.userName);
    _phoneCtrl = TextEditingController(text: widget.user.userPhone);

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

  // 제출 가능여부 확인
  void _recalc() {
    final isSubmittable = _nameCtrl.text.trim().isNotEmpty && _phoneCtrl.text.trim().isNotEmpty;
    // 제출 가능 여부 확인해서 상태 변경
    if (isSubmittable != _canSubmit) {
      setState(() => _canSubmit = isSubmittable);
    }
  }

  // TODO: 이름 유효성검사

  Future<void> _isDuplicatePhone() async {
    // TODO: 연락처 중복확인 메서드 구현
  }

  Future<void> _onSubmit() async {
    if (!_canSubmit) return;

    final name = _nameCtrl.text.trim();
    final phone = _phoneCtrl.text.trim();
    final token = context.read<AuthProvider>().token;
    if(token == null) {
      // TODO: 로그인 만료 처리
      return;
    }

    final request = EditProfileRequestModel(userName: name, userPhone: phone);

    try {
      await MypageService().uploadEditProfile(token, request);
      context.read<UserProfileProvider>().loadUserProfile(token);  // 성공 시 다시 조회해서 갱신
      context.pop(true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("회원정보 수정에 실패했습니다."))
      );
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('회원정보가 수정되었습니다'),
        behavior: SnackBarBehavior.floating,
        duration: AppDurations.snackbar,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final maxWidth = w >= 600 ? w : double.infinity;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWidget(title: "회원정보 수정"),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
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
                      // 이메일
                      TextFieldWidget(
                        label: "이메일",
                        style: AppInputStyles.disabled,
                        initialValue: widget.user.userEmail,
                      ),

                      const SizedBox(height: AppSpacing.lg),

                      // 이름
                      TextFieldWidget(
                        label: "이름",
                        style: AppInputStyles.standard,
                        controller: _nameCtrl,
                        validator: (value) {
                          if(value == null || value.isEmpty)
                            return InputMessages.emptyName;
                          return null;
                        },
                      ),

                      const SizedBox(height: AppSpacing.lg),

                      // 연락처
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: TextFieldWidget(
                              label: "연락처",
                              style: AppInputStyles.standard,
                              controller: _phoneCtrl,
                              validator: (value) {
                                if(value == null || value.isEmpty)
                                  return InputMessages.emptyPhone;
                                // TODO: 중복확인 통과 여부 메서드 구현 후 해당하는 메세지 return
                                // if()
                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: AppSpacing.sm),
                          SmallButton(
                              label: "중복확인",
                              onPressed: () {
                                // TODO: 버튼 클릭 시 현재 회원이 아닌 회원 중 중복값이 있는지 확인하는 함수 구현 (백엔드 연결)
                              },
                              enabled: true
                          ),
                        ],
                      ),

                      const SizedBox(height: AppSpacing.lg),

                      // 생년월일
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
                    ],
                  ),
                ),

                // 버튼
                BottomActionButton(
                  label: ButtonLabels.edit,
                  onPressed: _onSubmit,
                )
              ],
            )
          ),
        ),
      ),
    );
  }
}