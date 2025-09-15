import 'package:get/get.dart';

import '../middlewares/authenticate_middleware.dart';
import '../modules/detail-page/bindings/detail_page_binding.dart';
import '../modules/detail-page/views/detail_page_view.dart';
import '../modules/home/bindings/history_binding.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/bindings/rekap_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/rekap_detail/bindings/rekap_detail_binding.dart';
import '../modules/rekap_detail/views/rekap_detail_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
      bindings: [HomeBinding(), RekapBinding(), HistoryBinding()],
      middlewares: [AuthenticateMiddleware()],
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_PAGE,
      page: () => const DetailPageView(),
      binding: DetailPageBinding(),
    ),
    GetPage(
      name: _Paths.REKAP_DETAIL,
      page: () => const RekapDetailView(),
      binding: RekapDetailBinding(),
    ),
  ];
}
