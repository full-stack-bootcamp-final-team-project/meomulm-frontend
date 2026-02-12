import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/core/constants/app_constants.dart';
import 'package:meomulm_frontend/core/constants/paths/route_paths.dart' as AppRouter;
import 'package:meomulm_frontend/core/theme/app_styles.dart';
import 'package:meomulm_frontend/core/utils/regexp_utils.dart';
import 'package:meomulm_frontend/core/widgets/appbar/app_bar_widget.dart';
import 'package:meomulm_frontend/core/widgets/buttons/bottom_action_button.dart';
import 'package:meomulm_frontend/core/widgets/dialogs/snack_messenger.dart';
import 'package:meomulm_frontend/core/widgets/input/custom_underline_text_field.dart';
import 'package:meomulm_frontend/core/widgets/input/phone_number_formatter.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/providers/accommodation_provider.dart';
import 'package:meomulm_frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:meomulm_frontend/features/my_page/presentation/providers/user_profile_provider.dart';
import 'package:meomulm_frontend/features/reservation/data/datasources/reservation_api_service.dart';
import 'package:meomulm_frontend/features/reservation/presentation/providers/reservation_provider.dart';
import 'package:provider/provider.dart';

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  bool isLoading = false;

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();

  bool _canSubmit = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _nameFocusNode.requestFocus();
    });

    final reservationProvider = context.read<ReservationProvider>();
    _nameController = TextEditingController(text: reservationProvider.bookerName ?? '');
    _emailController = TextEditingController(text: reservationProvider.bookerEmail ?? '');
    _phoneController = TextEditingController(text: reservationProvider.bookerPhone ?? '');

    Future.microtask(() {
      final token = context.read<AuthProvider>().token;
      if (token != null) {
        context.read<UserProfileProvider>().loadUserProfile(token);
      } else {
        context.go(AppRouter.RoutePaths.login);
      }
    });

    _nameController.addListener(_validateForm);
    _emailController.addListener(_validateForm);
    _phoneController.addListener(_validateForm);
    _validateForm();
  }

  Future<void> _makeReservation() async {
    final reservationProvider = context.read<ReservationProvider>();
    final accommodationProvider = context.read<AccommodationProvider>();
    final reservationInfo = reservationProvider.reservation;

    if (reservationInfo == null) {
      debugPrint('예약 정보 또는 체크인/체크아웃 정보가 없습니다.');
      return;
    }

    setState(() {
      isLoading = true;
    });

    if (!_canSubmit) {
      SnackMessenger.showMessage(context, "값을 정확히 입력해주세요.", type: ToastType.error);
      return;
    }

    try {
      final token = context.read<AuthProvider>().token;
      if (token == null) {
        debugPrint('토큰이 없습니다. 로그인 필요');
        return;
      }

      final int reservationId = await ReservationApiService.postReservation(
        token,
        reservationInfo.roomId,
        _nameController.text,
        _emailController.text,
        _phoneController.text,
        accommodationProvider.checkIn,
        accommodationProvider.checkOut,
        accommodationProvider.guestNumber,
        reservationInfo.totalPrice,
      );

      reservationProvider.setReservationId(reservationId);

      reservationProvider.setBookerInfo(
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
      );

      debugPrint('[ReservationScreen] 예약 완료 | reservationId=$reservationId');

      if (!mounted) return;
      GoRouter.of(context).push(AppRouter.RoutePaths.payment);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('예약 실패: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _validateForm() {
    final isValid = RegexpUtils.validateName(_nameController.text) == null &&
        RegexpUtils.validateEmail(_emailController.text) == null &&
        RegexpUtils.validatePhone(_phoneController.text) == null;

    if (_canSubmit != isValid) {
      setState(() {
        _canSubmit = isValid;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  Future<void> _deleteBookerInfo() async {
    final reservationProvider = context.read<ReservationProvider>();
    reservationProvider.clearBookerInfo();
    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final accommodation = context.watch<AccommodationProvider>();
    final reservationInfo = context.watch<ReservationProvider>().reservation;

    final checkInDate = accommodation.checkIn != null
        ? '${accommodation.checkIn!.year}.${accommodation.checkIn!.month.toString().padLeft(2, '0')}.${accommodation.checkIn!.day.toString().padLeft(2, '0')}'
        : '체크인 정보 없음';

    final checkOutDate = accommodation.checkOut != null
        ? '${accommodation.checkOut!.year}.${accommodation.checkOut!.month.toString().padLeft(2, '0')}.${accommodation.checkOut!.day.toString().padLeft(2, '0')}'
        : '체크아웃 정보 없음';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWidget(
        title: TitleLabels.booking,
        onBack: _deleteBookerInfo,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 80), // 버튼 높이만큼 패딩
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg, AppSpacing.xl, AppSpacing.lg, AppSpacing.xxxl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(accommodation.selectedAccommodationName ?? '숙소 이름 없음',
                        style: AppTextStyles.bodyXl),
                    const SizedBox(height: AppSpacing.sm),
                    Text(reservationInfo?.productName ?? '객실 이름 없음',
                        style: AppTextStyles.subTitle),
                    const SizedBox(height: AppSpacing.xs),
                    Text(reservationInfo?.peopleInfo ?? '인원 정보 없음',
                        style: AppTextStyles.bodySm),
                    const SizedBox(height: AppSpacing.xl),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 108,
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: AppColors.selectedLight,
                              borderRadius: BorderRadius.circular(AppBorderRadius.md),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('체크인', style: AppTextStyles.bodySm),
                                const SizedBox(height: AppSpacing.sm),
                                Text(
                                  '$checkInDate\n${reservationInfo != null ? reservationInfo.checkInfo.split('~')[0].replaceFirst('체크인 ', '') : '체크인 정보 없음'}',
                                  style: AppTextStyles.bodyMd,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Container(
                            height: 108,
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: AppColors.selectedLight,
                              borderRadius: BorderRadius.circular(AppBorderRadius.md),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('체크아웃', style: AppTextStyles.bodySm),
                                const SizedBox(height: AppSpacing.sm),
                                Text(
                                  '$checkOutDate\n${reservationInfo != null ? reservationInfo.checkInfo.split('~')[1].trimLeft().replaceFirst('체크아웃 ', '') : '체크아웃 정보 없음'}',
                                  style: AppTextStyles.bodyMd,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    const Text('예약자 정보', style: AppTextStyles.cardTitle),
                    const SizedBox(height: AppSpacing.xl),
                    CustomUnderlineTextField(
                      label: "이름",
                      isRequired: true,
                      hintText: InputMessages.emptyName,
                      controller: _nameController,
                      focusNode: _nameFocusNode,
                      validator: (value) => RegexpUtils.validateName(value),
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_emailFocusNode);
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    CustomUnderlineTextField(
                      label: "이메일",
                      isRequired: true,
                      hintText: InputMessages.emptyEmail,
                      controller: _emailController,
                      focusNode: _emailFocusNode,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => RegexpUtils.validateEmail(value),
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_phoneFocusNode);
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    CustomUnderlineTextField(
                      label: "휴대폰 번호",
                      isRequired: true,
                      hintText: InputMessages.emptyPhone,
                      controller: _phoneController,
                      focusNode: _phoneFocusNode,
                      onFieldSubmitted: (_) => _makeReservation(),
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        PhoneNumberFormatter(),
                      ],
                      validator: (value) => RegexpUtils.validatePhone(value),
                    ),
                    const SizedBox(height: AppSpacing.xxxl),
                    const Text('결제 정보', style: AppTextStyles.cardTitle),
                    const SizedBox(height: AppSpacing.xl),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('총 객실 가격', style: AppTextStyles.bodyLg),
                        Text(reservationInfo?.totalCommaPrice ?? '가격 정보 없음',
                            style: AppTextStyles.bodyXl),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              child: BottomActionButton(
                label: ButtonLabels.register,
                onPressed: (_canSubmit && !isLoading) ? _makeReservation : null,
              ),
              ),
            ),

        ],
      ),
    );
  }
}
