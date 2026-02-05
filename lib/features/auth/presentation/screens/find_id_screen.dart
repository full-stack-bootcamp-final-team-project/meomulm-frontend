import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/core/theme/app_button_styles.dart';
import 'package:meomulm_frontend/core/theme/app_colors.dart';
import 'package:meomulm_frontend/core/theme/app_text_styles.dart';
import 'package:meomulm_frontend/core/utils/regexp_utils.dart';
import 'package:meomulm_frontend/core/widgets/appbar/app_bar_widget.dart';
import 'package:meomulm_frontend/core/widgets/dialogs/snack_messenger.dart';
import 'package:meomulm_frontend/features/auth/data/datasources/auth_service.dart';
import 'package:meomulm_frontend/features/auth/presentation/widget/find_id/find_id_input_fields.dart';

class FindIdScreen extends StatefulWidget {
  const FindIdScreen({super.key});

  @override
  State<FindIdScreen> createState() => _FindIdScreenState();
}

class _FindIdScreenState extends State<FindIdScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // FocusNode
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _nameFocusNode.requestFocus();
    });
  }

  // 유저 정보 확인(이름, 전화번호)
  void _checkUser() async {
    // 입력값 검증
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final nameRegexp = RegexpUtils.validateName(name);
    final phoneRegexp = RegexpUtils.validatePhone(phone);

    if (nameRegexp != null) {
      SnackMessenger.showMessage(
          context,
          nameRegexp,
          type: ToastType.error
      );
      return;
    }

    if (phoneRegexp != null) {
      SnackMessenger.showMessage(
          context,
          phoneRegexp,
          type: ToastType.error
      );
      return;
    }

    try {
      String checkPhone = PhoneNumberCheck(phone);

      final res = await AuthService.userEmailCheck(name, checkPhone);

      if (!mounted) return;
      if (res != null) {
        // 둘 다 null이면 통과 → 모달창 표시
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            contentPadding: EdgeInsetsGeometry.symmetric(horizontal: 10),
            title: Text(
              '고객님의 이메일은',
              style: AppTextStyles.bodyLg,
              textAlign: TextAlign.center,
            ),
            content: Padding(padding: EdgeInsetsGeometry.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      res,
                      style: AppTextStyles.dialogLg,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(
                      '입니다.',
                      style: AppTextStyles.bodyLg,
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed:  () => Navigator.pop(context),
                    child: const Text('확인'),
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(AppButtonStyles.buttonWidthMd, AppButtonStyles.buttonHeightMd),
                        backgroundColor: AppColors.main,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(10)
                        )
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(
              '고객님의 이메일이 존재하지 않습니다.',
              style: AppTextStyles.bodyLg,
              textAlign: TextAlign.center,
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed:  () => Navigator.pop(context),
                    child: const Text('확인'),
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(AppButtonStyles.buttonWidthMd, AppButtonStyles.buttonHeightMd),
                      backgroundColor: AppColors.main,
                      foregroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(10)
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      }

    } catch (e) {
      if(!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('오류 : $e')));
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
      appBar: AppBarWidget(title: TitleLabels.findId),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FindIdInputFields(
                  nameController: _nameController,
                  phoneController: _phoneController,
                  nameFocusNode: _nameFocusNode,
                  phoneFocusNode: _phoneFocusNode,
                  onSubmit: _checkUser
              )
            ],
          ),
        ),
      ),
    );
  }
}