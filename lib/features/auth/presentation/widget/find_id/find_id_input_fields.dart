import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meomulm_frontend/core/constants/ui/labels_constants.dart';
import 'package:meomulm_frontend/core/theme/app_colors.dart';
import 'package:meomulm_frontend/core/theme/app_text_styles.dart';
import 'package:meomulm_frontend/core/utils/regexp_utils.dart';
import 'package:meomulm_frontend/core/widgets/input/custom_text_field.dart';
import 'package:meomulm_frontend/core/widgets/input/phone_number_formatter.dart';

class FindIdInputFields extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final FocusNode nameFocusNode;
  final FocusNode phoneFocusNode;
  final VoidCallback onSubmit;

  const FindIdInputFields({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.onSubmit,
    required this.nameFocusNode,
    required this.phoneFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),

        // 이름 입력
        CustomTextField(
          label: "이름",
          isRequired: true,
          hintText: "이름을 입력하세요.",
          controller: nameController,
          focusNode: nameFocusNode,
          validator: (name) => RegexpUtils.validateName(name),
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(phoneFocusNode);
          },
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 20),

        // 전화번호 입력
        CustomTextField(
          label: "연락처",
          isRequired: true,
          hintText: "연락처를 입력하세요.(- 제외)",
          controller: phoneController,
          focusNode: phoneFocusNode,
          keyboardType: TextInputType.phone,
          validator: (phone) => RegexpUtils.validatePhone(phone),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            PhoneNumberFormatter(),
          ],
          onFieldSubmitted: (_) => onSubmit(),
        ),
        SizedBox(height: 40),

        // 아이디 찾기 버튼
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: onSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.gray6,
              foregroundColor: AppColors.gray2,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: AppColors.gray4),
              ),
            ),
            child: const Text(
              ButtonLabels.findId,
              style: AppTextStyles.inputTextMd,
            ),
          ),
        ),
      ],
    );
  }
}
