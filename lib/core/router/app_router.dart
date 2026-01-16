import 'package:go_router/go_router.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/screens/product_list_screen.dart';
import 'package:meomulm_frontend/features/my_page/presentation/screens/favorite_screen.dart';

import '../../features/accommodation/presentation/screens/accommodation_detail_screen.dart';
import '../../features/accommodation/presentation/screens/accommodation_list_screen.dart';
import '../../features/accommodation/presentation/screens/accommodation_review_screen.dart';
import '../../features/accommodation/presentation/screens/search_accommodation_screen.dart';
import '../../features/auth/presentation/screens/confirm_password_screen.dart';
import '../../features/auth/presentation/screens/find_id_screen.dart';
import '../../features/auth/presentation/screens/login_change_password_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/intro/presentation/intro_screen.dart';
import '../../features/map/presentation/screens/map_result_screen.dart';
import '../../features/map/presentation/screens/map_search_screen.dart';
import '../../features/map/presentation/screens/search_region_screen.dart';
import '../../features/my_page/presentation/screens/edit_profile_screen.dart';
import '../../features/my_page/presentation/screens/my_reservations_screen.dart';
import '../../features/my_page/presentation/screens/my_review_screen.dart';
import '../../features/my_page/presentation/screens/my_review_write_screen.dart';
import '../../features/my_page/presentation/screens/mypage_change_password_screen.dart';
import '../../features/my_page/presentation/screens/mypage_screen.dart';
import '../../features/reservation/presentation/screens/payment_screen.dart';
import '../../features/reservation/presentation/screens/payment_success_screen.dart';
import '../../features/reservation/presentation/screens/reservation_screen.dart';
import '../constants/paths/route_paths.dart';

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
        path: RoutePaths.searchAccommodation,
        name: "searchAccommodation",
        builder: (context, state) => const SearchAccommodationScreen(),
      ),
      GoRoute(
          path: RoutePaths.accommodationList,
          name: "accommodationList",
          builder: (context, state) => const AccommodationListScreen(),
      ),
      GoRoute(
          path: RoutePaths.accommodationReview,
          name: "accommodationReview",
          builder: (context, state) => const AccommodationReviewScreen(),
      ),
      GoRoute(
          path: RoutePaths.accommodationDetail,
          name: "accommodationDetail",
          builder: (context, state) => const AccommodationDetailScreen(),
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
        name: "mapSearch",
        builder: (context, state) => const MapSearchScreen(),
      ),
      GoRoute(
        path: RoutePaths.mapResult,
        name: "mapResult",
        builder: (context, state) => const MapResultScreen(),
      ),
      GoRoute(
        path: RoutePaths.searchRegion,
        name: "searchRegion",
        builder: (context, state) => const SearchRegionScreen(),
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
