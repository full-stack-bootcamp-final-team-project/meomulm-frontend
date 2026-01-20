import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/core/widgets/appbar/app_bar_widget.dart';
import 'package:meomulm_frontend/core/widgets/input/text_field_widget.dart';


class MapSearchScreen extends StatefulWidget {
  const MapSearchScreen({super.key});

  @override
  State<MapSearchScreen> createState() => _MapSearchScreenState();
}

class _MapSearchScreenState extends State<MapSearchScreen> {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController disabledController =
  TextEditingController(text: '수정 불가');
  final TextEditingController passwordController = TextEditingController();

  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const AppBarWidget(
          title: '테스트',
        ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 16),

              TextFieldWidget(
                style: AppInputStyles.standard,
                decoration: AppInputDecorations.standard(
                  hintText: '기본 입력',
                ),
              ),

              const SizedBox(height: 16),

              TextFieldWidget(
                style: AppInputStyles.underline,
                decoration: AppInputDecorations.underline(
                  hintText: 'Underline 입력',
                ),
              ),

              const SizedBox(height: 16),

              TextFieldWidget(
                style: AppInputStyles.disabled,
                controller: disabledController,
                decoration: AppInputDecorations.disabled(),
              ),

              const SizedBox(height: 16),

              TextFieldWidget(
                style: AppInputStyles.password,
                obscureText: _obscure,
                decoration: AppInputDecorations.password(
                  hintText: '비밀번호',
                  obscureText: _obscure,
                  onToggleVisibility: () {
                    setState(() {
                      _obscure = !_obscure;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
