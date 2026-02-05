import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/core/constants/config/app_config.dart';
import 'package:meomulm_frontend/core/constants/paths/route_paths.dart';
import 'package:meomulm_frontend/core/constants/ui/labels_constants.dart';
import 'package:meomulm_frontend/core/theme/app_colors.dart';
import 'package:meomulm_frontend/core/theme/app_dimensions.dart';
import 'package:meomulm_frontend/core/theme/app_input_decorations.dart';
import 'package:meomulm_frontend/core/theme/app_input_styles.dart';
import 'package:meomulm_frontend/core/utils/regexp_utils.dart';
import 'package:meomulm_frontend/core/widgets/appbar/app_bar_widget.dart';
import 'package:meomulm_frontend/core/widgets/buttons/bottom_action_button.dart';
import 'package:meomulm_frontend/core/widgets/buttons/button_widgets.dart';
import 'package:meomulm_frontend/core/widgets/dialogs/snack_messenger.dart';
import 'package:meomulm_frontend/core/widgets/input/custom_text_field.dart';
import 'package:meomulm_frontend/core/widgets/input/phone_number_formatter.dart';
import 'package:meomulm_frontend/core/widgets/input/text_field_widget.dart';
import 'package:meomulm_frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:meomulm_frontend/features/my_page/data/datasources/edit_profile_service.dart';
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
  final editProfileService = EditProfileService();
  bool isLoading = false;
  // 중복 확인 + 입력값 검증
  bool _isPhoneChecked = false;
  bool _isPhoneUnique = false;
  bool isSubmittable = false;

  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;

  // FocusNode 생성
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();


  @override
  void initState() {
    super.initState();

    _nameCtrl = TextEditingController(text: widget.user.userName);
    _phoneCtrl = TextEditingController(text: widget.user.userPhone);

    _nameCtrl.addListener(_recalc);
    _phoneCtrl.addListener(() {
      if(_isPhoneChecked) {
        setState(() => _isPhoneChecked = false);
      }
    });
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
    final nameText = _nameCtrl.text.trim();
    final phoneText = _phoneCtrl.text.trim();

    final isFilled =
        nameText.isNotEmpty && phoneText.isNotEmpty;

    final isRegexpPassed =
        RegexpUtils.validateName(nameText) == null &&
        RegexpUtils.validatePhone(phoneText) == null;

    final _canSubmit = isFilled && isRegexpPassed;

    // 제출 가능 여부 확인해서 상태 변경
    if (_canSubmit != isSubmittable) {
      setState(() => isSubmittable = _canSubmit);
    }
  }

  // 연락처 중복 확인 함수
  Future<void> _isDuplicatePhone() async {
    if(_phoneCtrl.text.trim() == widget.user.userPhone) {
      SnackMessenger.showMessage(
        context,
        '현재 연락처와 동일한 연락처는 사용할 수 없습니다.',
        type: ToastType.error
      );
      setState(() => isSubmittable = false);
      return;
    }
    setState(() => isLoading = true);
    try {
      final request = _phoneCtrl.text.trim();
      final response = await editProfileService.checkPhoneDuplicate(request);

      setState(() {
        _isPhoneUnique = response;
        _isPhoneChecked = response;
      });  // 연락처 검사
      if(!_isPhoneUnique) {
        SnackMessenger.showMessage(
          context,
          "이미 사용 중인 연락처입니다.",
          type: ToastType.error,
        );
      }
    } catch (e) {
      SnackMessenger.showMessage(
        context,
        "이미 사용 중인 연락처입니다",
        type: ToastType.error,
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  // 제출 함수
  Future<void> _onSubmit() async {
    if (!isSubmittable) return;

    final name = _nameCtrl.text.trim();
    final phone = _phoneCtrl.text.trim();  // 대시(-) 붙여서 보내기
    final token = context.read<AuthProvider>().token;
    if (token == null) return;

    final request = EditProfileRequestModel(userName: name, userPhone: phone);

    try {
      await MypageService().uploadEditProfile(token, request);

      context.read<UserProfileProvider>().loadUserProfile(
        token,
      ); // 성공 시 다시 조회해서 갱신

      SnackMessenger.showMessage(
          context,
          '회원정보가 수정되었습니다',
          type: ToastType.success
      );
      context.pop(true);
    } catch (e) {
      SnackMessenger.showMessage(
        context,
        "회원정보 수정에 실패했습니다.",
        type: ToastType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final maxWidth = w >= 600 ? w : double.infinity;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWidget(title: "회원정보 수정"),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xxl,
                AppSpacing.lg,
                AppSpacing.xxl,
                AppSpacing.xl,
              ),
              children: [
                Column(
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

                    CustomTextField(
                      label: "이름",
                      hintText: "이름을 입력하세요.",
                      controller: _nameCtrl,
                      focusNode: _nameFocusNode,
                      validator: (value) {
                        if(value == null || value.isEmpty)
                          return InputMessages.emptyName;
                        return null;
                      },
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // 연락처
                    buildFieldWithButton(
                        field: CustomTextField(
                          label: "연락처",
                          hintText: "연락처를 입력하세요. (- 제외)",
                          controller: _phoneCtrl,
                          focusNode: _phoneFocusNode,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            PhoneNumberFormatter(),
                          ],
                          validator: (phone) => RegexpUtils.validatePhone(phone),
                          helperText: _isPhoneUnique
                              ? '사용 가능한 전화번호입니다.'
                              : null,
                          helperStyle: TextStyle(color: AppColors.success),
                        ),
                        onPressed: _isDuplicatePhone,
                        label: "중복확인",
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
                            initialValue: widget.user.birthYear,
                          ),
                        ),
                        SizedBox(width: AppSpacing.sm),
                        Expanded(
                          flex: 1,
                          child: TextFieldWidget(
                            label: " ",
                            style: AppInputStyles.disabled,
                            initialValue: widget.user.birthMonth,
                          ),
                        ),
                        SizedBox(width: AppSpacing.sm),
                        Expanded(
                          flex: 1,
                          child: TextFieldWidget(
                            label: " ",
                            style: AppInputStyles.disabled,
                            initialValue: widget.user.birthDay,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),
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
          ),
        ),
      ),
    );
  }
}
