// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:chakan_team/camera_service.dart' as _i743;
import 'package:chakan_team/common/update_app.dart' as _i244;
import 'package:chakan_team/network/api_service.dart' as _i22;
import 'package:chakan_team/network/network_controller.dart' as _i371;
import 'package:chakan_team/network/register_module.dart' as _i405;
import 'package:chakan_team/utils/translate_controller.dart' as _i667;
import 'package:chakan_team/view/complaint/controller/complaint_controller.dart'
    as _i1003;
import 'package:chakan_team/view/dashboard/controller/dashboard_controller.dart'
    as _i280;
import 'package:chakan_team/view/dashboard/controller/notification_controller.dart'
    as _i444;
import 'package:chakan_team/view/dashboard/controller/profile_controller.dart'
    as _i290;
import 'package:chakan_team/view/dashboard/controller/update_firebase_token.dart'
    as _i478;
import 'package:chakan_team/view/home/controller/add_file_controller.dart'
    as _i863;
import 'package:chakan_team/view/knowledge/controller/kms_controller.dart'
    as _i1034;
import 'package:chakan_team/view/navigation/controller/navigation_controller.dart'
    as _i413;
import 'package:chakan_team/view/onboarding/controller/onboarding_controller.dart'
    as _i58;
import 'package:chakan_team/view/onboarding/controller/user_controller.dart'
    as _i689;
import 'package:chakan_team/view/task/controller/task_controller.dart' as _i88;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.factory<_i371.NetworkController>(() => _i371.NetworkController());
    gh.lazySingleton<_i743.CameraService>(() => _i743.CameraService());
    gh.lazySingleton<_i244.UpdateController>(() => _i244.UpdateController());
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i667.TranslateController>(
      () => _i667.TranslateController(),
    );
    gh.lazySingleton<_i1003.ComplaintController>(
      () => _i1003.ComplaintController(),
    );
    gh.lazySingleton<_i280.DashboardController>(
      () => _i280.DashboardController(),
    );
    gh.lazySingleton<_i444.NotificationController>(
      () => _i444.NotificationController(),
    );
    gh.lazySingleton<_i290.ProfileController>(() => _i290.ProfileController());
    gh.lazySingleton<_i478.FirebaseTokenController>(
      () => _i478.FirebaseTokenController(),
    );
    gh.lazySingleton<_i863.AddFileController>(() => _i863.AddFileController());
    gh.lazySingleton<_i1034.KmsController>(() => _i1034.KmsController());
    gh.lazySingleton<_i413.NavigationController>(
      () => _i413.NavigationController(),
    );
    gh.lazySingleton<_i58.OnboardingController>(
      () => _i58.OnboardingController(),
    );
    gh.lazySingleton<_i689.UserService>(() => _i689.UserService());
    gh.lazySingleton<_i88.TaskController>(() => _i88.TaskController());
    gh.factory<_i22.ApiService>(() => _i22.ApiService(gh<_i361.Dio>()));
    return this;
  }
}

class _$RegisterModule extends _i405.RegisterModule {}
