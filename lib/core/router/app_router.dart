import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/screens/accommodation_filter_screen.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/screens/accommodation_map_screen.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/screens/accommodation_result_screen.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/screens/accommodation_search_screen.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/screens/product_list_screen.dart';
import 'package:meomulm_frontend/features/map/presentation/screens/search/map_search_result_screen.dart';
import 'package:meomulm_frontend/features/map/presentation/screens/search/map_search_screen.dart';
import 'package:meomulm_frontend/features/my_page/presentation/screens/favorite_screen.dart';

import 'package:meomulm_frontend/features/accommodation/presentation/screens/accommodation_detail_screen.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/screens/accommodation_review_screen.dart';
import 'package:meomulm_frontend/features/auth/presentation/screens/confirm_password_screen.dart';
import 'package:meomulm_frontend/features/auth/presentation/screens/find_id_screen.dart';
import 'package:meomulm_frontend/features/auth/presentation/screens/login_change_password_screen.dart';
import 'package:meomulm_frontend/features/auth/presentation/screens/login_screen.dart';
import 'package:meomulm_frontend/features/auth/presentation/screens/signup_screen.dart';
import 'package:meomulm_frontend/features/home/presentation/screens/home_screen.dart';
import 'package:meomulm_frontend/features/intro/presentation/intro_screen.dart';
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

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/intro',
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
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: RoutePaths.confirmPassword,
        name: "confirmPassword",
        builder: (context, state) => const ConfirmPasswordScreen(),
      ),
      GoRoute(
        path: RoutePaths.loginChangePassword,
        name: "loginChangePassword",
        builder: (context, state) => const LoginChangePasswordScreen(),
      ),

      /// =====================
      /// accommodation 라우팅
      /// =====================
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
        path: RoutePaths.accommodationReview,
        name: "accommodationReview",
        builder: (context, state) => const AccommodationReviewScreen(),
      ),
      GoRoute(
        path: RoutePaths.accommodationDetail,
        name: "accommodationDetail",
        builder: (context, state) {
          // path parameter 꺼내기
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
        name: 'mapSearchResult',
        builder: (context, state) => const MapSearchResultScreen(),
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
            builder: (context, state) => const EditProfileScreen(),
          ),
          GoRoute(
            path: RoutePaths.myReservation,
            name: "myReservation",
            builder: (context, state) => const MyReservationsScreen(),
          ),
          GoRoute(
            path: RoutePaths.myReview,
            name: "myReview",
            builder: (context, state) => const MyReviewScreen(),
          ),
          GoRoute(
            path: RoutePaths.myReviewWrite,
            name: "myReviewWrite",
            builder: (context, state) => const MyReviewWriteScreen(),
          ),
          GoRoute(
            path: RoutePaths.myPageChangePassword,
            name: "myPageChangePassword",
            builder: (context, state) => const MypageChangePasswordScreen(),
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
    ],
  );
}
