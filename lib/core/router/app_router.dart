import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/screens/accommodation_filter_screen.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/screens/accommodation_result_screen.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/screens/accommodation_search_screen.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/screens/notification_list_screen.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/screens/product_list_screen.dart';
import 'package:meomulm_frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:meomulm_frontend/features/chat/presentation/screens/chat_screen.dart';
import 'package:meomulm_frontend/features/map/presentation/screens/search/map_search_result_screen.dart';
import 'package:meomulm_frontend/features/map/presentation/screens/search/map_search_screen.dart';
import 'package:meomulm_frontend/features/my_page/data/models/reservation_share_model.dart';
import 'package:meomulm_frontend/features/my_page/data/models/user_profile_model.dart';
import 'package:meomulm_frontend/features/my_page/presentation/screens/favorite_screen.dart';

import 'package:meomulm_frontend/features/accommodation/presentation/screens/accommodation_detail_screen.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/screens/accommodation_review_screen.dart';
import 'package:meomulm_frontend/features/auth/presentation/screens/confirm_password_screen.dart';
import 'package:meomulm_frontend/features/auth/presentation/screens/find_id_screen.dart';
import 'package:meomulm_frontend/features/auth/presentation/screens/login_change_password_screen.dart';
import 'package:meomulm_frontend/features/auth/presentation/screens/login_screen.dart';
import 'package:meomulm_frontend/features/auth/presentation/screens/signup_screen.dart';
import 'package:meomulm_frontend/features/home/presentation/screens/home_screen.dart';
import 'package:meomulm_frontend/features/intro/presentation/screens/intro_screen.dart';
import 'package:meomulm_frontend/features/map/presentation/screens/map_screen.dart';
import 'package:meomulm_frontend/features/map/presentation/screens/search/map_search_region_screen.dart';
import 'package:meomulm_frontend/features/my_page/presentation/screens/edit_profile_screen.dart';
import 'package:meomulm_frontend/features/my_page/presentation/screens/my_reservations_screen.dart';
import 'package:meomulm_frontend/features/my_page/presentation/screens/my_review_screen.dart';
import 'package:meomulm_frontend/features/my_page/presentation/screens/my_review_write_screen.dart';
import 'package:meomulm_frontend/features/my_page/presentation/screens/mypage_change_password_screen.dart';
import 'package:meomulm_frontend/features/my_page/presentation/screens/mypage_screen.dart';
import 'package:meomulm_frontend/features/reservation/presentation/screens/payment_screen.dart';
import 'package:meomulm_frontend/features/reservation/presentation/screens/payment_success_screen.dart';
import 'package:meomulm_frontend/features/reservation/presentation/screens/reservation_screen.dart';
import 'package:meomulm_frontend/core/constants/paths/route_paths.dart';
import 'package:provider/provider.dart';

class AppRouter {

  // ✅ 전역 navigatorKey 추가
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // ---------------------------------------------------------------
  // deeplink에서 받은 초기 경로를 저장하는 정적 변수
  // main.dart → app.dart → AppRouter 순으로 전달됨
  // ---------------------------------------------------------------
  static String? pendingDeepLink;

  /// Custom-Scheme URI(meomulm://...)를 GoRouter 경로로 변환
  /// 지원하지 않는 경로이면 null 반환 → 기본 initialLocation 사용
  static String? parseDeepLinkUri(Uri uri) {
    // uri.path 예시: /accommodation-detail/42
    final path = uri.path;

    // ── accommodation-detail/:id ──
    final detailRegex = RegExp(r'^/accommodation-detail/(\d+)$');
    final detailMatch = detailRegex.firstMatch(path);
    if (detailMatch != null) {
      final id = detailMatch.group(1);
      return '${RoutePaths.accommodationDetail}/$id';
    }

    // ── 향후 추가할 deeplink 패턴은 여기에 계속 추가 ──
    // 예:
    // final reviewRegex = RegExp(r'^/accommodation-review/(\d+)$');
    // ...

    return null; // 매칭되지 않는 경로
  }











  static final GoRouter router = GoRouter(

    navigatorKey: navigatorKey, // ✅ Key 등록


    // ----------------------------------------------------------------
    // initialLocation: pendingDeepLink가 있으면 그것을 사용, 아니면 /intro
    // ----------------------------------------------------------------
    initialLocation: pendingDeepLink ?? '/intro',



    redirect: (context, state) {
      final auth = context.read<AuthProvider>();
      final loggedIn = auth.token != null;

      final loc = state.uri.toString();

      // ✅ 보호가 필요한 경로: /mypage 로 시작하는 모든 경로
      final needsAuth = loc.startsWith('/mypage');

      // 로그인 안 했는데 보호 경로 접근 → 로그인으로
      if (!loggedIn && needsAuth) return RoutePaths.login;

      // 로그인 했는데 로그인 페이지 접근 → 기본 진입 화면으로
      if (loggedIn && loc == RoutePaths.login) return RoutePaths.myPage;

      return null;
    },
    // initialLocation: '/intro',
    routes: [
      /// =====================
      /// intro 라우팅
      /// =====================
      GoRoute(
        path: RoutePaths.intro,
        name: "intro",
        builder: (context, state) => const IntroScreen(),
      ),
      GoRoute(
        path: RoutePaths.home,
        name: "home",
        builder: (context, state) => const HomeScreen(),
      ),

      /// =====================
      /// auth 라우팅
      /// =====================
      GoRoute(
        path: RoutePaths.login,
        name: "login",
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: RoutePaths.findId,
        name: "findId",
        builder: (context, state) => const FindIdScreen(),
      ),
      GoRoute(
        path: RoutePaths.signup,
        name: "signup",
        builder: (context, state) {
          final kakaoUser = state.extra as Map<String, dynamic>?;
          return SignupScreen(kakaoUser: kakaoUser);
        },
      ),
      GoRoute(
        path: RoutePaths.confirmPassword,
        name: "confirmPassword",
        builder: (context, state) => const ConfirmPasswordScreen(),
      ),
      GoRoute(
        path: '${RoutePaths.loginChangePassword}/:userId',
        name: "loginChangePassword",
        builder: (context, state) {
          final idString = state.pathParameters['userId'];
          final userId = int.tryParse(idString ?? '');
          return LoginChangePasswordScreen(userId: userId!);
        }
      ),

      /// =====================
      /// accommodation 라우팅
      /// =====================
      GoRoute(
        path: RoutePaths.notificationList,
        name: "notificationList",
        builder: (context, state) => const NotificationListScreen(),
      ),
      GoRoute(
        path: RoutePaths.accommodationSearch,
        name: "accommodationSearch",
        builder: (context, state) => const AccommodationSearchScreen(),
      ),
      GoRoute(
        path: RoutePaths.accommodationFilter,
        name: "accommodationFilter",
        builder: (context, state) => const AccommodationFilterScreen(),
      ),
      GoRoute(
        path: RoutePaths.accommodationResult,
        name: "accommodationResult",
        builder: (context, state) => const AccommodationResultScreen(),
      ),
      GoRoute(
        path: '${RoutePaths.accommodationReview}/:id',
        name: "accommodationReview",
        builder: (context, state) {
          final idString = state.pathParameters['id'];
          final accommodationId = int.tryParse(idString ?? '');
          if (accommodationId == null) {
            return const Scaffold(
              body: Center(child: Text('숙소 ID가 유효하지 않습니다')),
            );
          }
          return AccommodationReviewScreen(
            accommodationId: accommodationId,
          );
        },
      ),
      GoRoute(
        path: '${RoutePaths.accommodationDetail}/:id',
        name: "accommodationDetail",
        builder: (context, state) {
          final idString = state.pathParameters['id'];
          final accommodationId = int.tryParse(idString ?? '');
          if (accommodationId == null) {
            return const Scaffold(
              body: Center(child: Text('숙소 ID가 유효하지 않습니다')),
            );
          }
          return AccommodationDetailScreen(
            accommodationId: accommodationId,
          );
        },
      ),
      GoRoute(
        path: RoutePaths.productList,
        name: "productList",
        builder: (context, state) => const ProductListScreen(),
      ),

      /// =====================
      /// map 라우팅
      /// =====================
      GoRoute(
        path: RoutePaths.map,
        name: 'map',
        builder: (context, state) => const MapScreen(),
      ),

      GoRoute(
        path: RoutePaths.mapSearch,
        name: 'mapSearch',
        builder: (context, state) => const MapSearchScreen(),
      ),

      GoRoute(
        path: RoutePaths.mapSearchRegion,
        name: 'mapSearchRegion',
        builder: (context, state) => const MapSearchRegionScreen(),
      ),


      GoRoute(
        path: RoutePaths.mapSearchResult,
        builder: (context, state) {
          final region = state.extra as String;
          return MapSearchResultScreen(
            region: region,
          );
        },
      ),

      /// =====================
      /// mypage 라우팅
      /// =====================
      GoRoute(
        path: RoutePaths.myPage,
        name: "mypage",
        builder: (context, state) => const MypageScreen(),
        routes: [
          GoRoute(
            path: RoutePaths.editProfile,
            name: "editProfile",
            builder: (context, state) {
              final user = state.extra as UserProfileModel;
              return EditProfileScreen(user: user);
            },
          ),
          // GoRoute(
          //   path: RoutePaths.myReservation,
          //   name: "myReservation",
          //   builder: (context, state) => const MyReservationsScreen(),
          // ),
          GoRoute(
            path: RoutePaths.myReservation,
            name: "myReservation",
            builder: (context, state) {
              // URL에서 tab 파라미터 추출
              final tabIndex = int.tryParse(state.uri.queryParameters['tab'] ?? '0') ?? 0;
              return MyReservationsScreen(initialTab: tabIndex); // initialTab 추가
            },
          ),
          GoRoute(
            path: RoutePaths.myReview,
            name: "myReview",
            builder: (context, state) => const MyReviewScreen(),
          ),
          GoRoute(
            path: RoutePaths.myReviewWrite,
            name: "myReviewWrite",
            builder: (context, state) {
              final reservation = state.extra as ReservationShareModel;
              return MyReviewWriteScreen(reservationShare: reservation,);
            },
          ),
          GoRoute(
            path: RoutePaths.myPageChangePassword,
            name: "myPageChangePassword",
            builder: (context, state) {
              final user = state.extra as UserProfileModel;
              return MypageChangePasswordScreen(user: user);
            },
          ),
          GoRoute(
            path: RoutePaths.favorite,
            name: "favorite",
            builder: (context, state) => const FavoriteScreen(),
          ),
        ],
      ),

      /// =====================
      /// reservation 라우팅
      /// =====================
      GoRoute(
        path: RoutePaths.payment,
        name: "payment",
        builder: (context, state) => PaymentScreen(),
      ),
      GoRoute(
        path: RoutePaths.reservation,
        name: "reservation",
        builder: (context, state) => ReservationScreen(),
      ),
      GoRoute(
        path: RoutePaths.paymentSuccess,
        name: "paymentSuccess",
        builder: (context, state) => PaymentSuccessScreen(),
      ),

      /// =====================
      /// chatbot 라우팅
      /// =====================
      GoRoute(
        path: RoutePaths.chat,
        name: "chat",
        builder: (context, state) => ChatScreen(),
      ),
    ],
  );
}
