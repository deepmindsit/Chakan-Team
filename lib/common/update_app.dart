import 'dart:io';

import 'package:chakan_team/utils/exported_path.dart';
import 'package:flutter/cupertino.dart';

import 'app_under_maintainance.dart';

@lazySingleton
class UpdateController extends GetxController {
  var currentVersion = ''.obs;
  var latestVersion = ''.obs;
  var updateData = {}.obs;
  var updateDataIOS = {}.obs;

  final ApiService _apiService = Get.find();
  final controller = getIt<ProfileController>();

  /// Fetches profile data and initializes package info.
  Future<void> checkForUpdate() async {
    await _getProfileData();
    await _initPackageInfo();
  }

  /// Fetch latest version from API
  Future<void> _getProfileData() async {
    try {
      final userId = await LocalStorage.getString('user_id') ?? '';
      final res = await _apiService.getProfile(userId);
      res['common']['status'] == true
          ? updateData.value = res['android']
          : updateData.value = {};
      res['common']['status'] == true
          ? updateDataIOS.value = res['ios']
          : updateDataIOS.value = {};

      if (Platform.isIOS) {
        res['ios']['is_maintenance'] == true
            ? Get.offAll(
              () => Maintenance(msg: res['ios']['maintenance_msg'] ?? ''),
              transition: Transition.rightToLeftWithFade,
            )
            : null;
      } else {
        res['android']['is_maintenance'] == true
            ? Get.offAll(
              () => Maintenance(msg: res['android']['maintenance_msg'] ?? ''),
              transition: Transition.rightToLeftWithFade,
            )
            : null;
      }
    } finally {}
  }

  /// Get system app version and compare with latest API version.
  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    if (Platform.isIOS) {
      currentVersion.value = info.version;
      latestVersion.value = updateDataIOS['version'];
      bool isNewVersion = isVersionGreaterThan(
        latestVersion.value,
        currentVersion.value,
      );
      if (isNewVersion) {
        updateDataIOS['show_popup'] == true
            ? _showUpdateDialog(updateDataIOS)
            : null;
      }
    } else {
      currentVersion.value = info.version;
      latestVersion.value = updateData['version'];

      int apiVersion = _versionToInt(latestVersion.value);
      int systemVersion = _versionToInt(currentVersion.value);

      if (apiVersion > systemVersion && updateData['show_popup'] == true) {
        _showUpdateDialog(updateData);
      }
    }
  }

  bool isVersionGreaterThan(String newVersion, String oldVersion) {
    List<String> newVersionParts = newVersion.split('.');
    List<String> oldVersionParts = oldVersion.split('.');

    if (int.parse(newVersionParts[0]) > int.parse(oldVersionParts[0])) {
      return true;
    } else if (int.parse(newVersionParts[0]) < int.parse(oldVersionParts[0])) {
      return false;
    }

    if (int.parse(newVersionParts[1]) > int.parse(oldVersionParts[1])) {
      return true;
    } else if (int.parse(newVersionParts[1]) < int.parse(oldVersionParts[1])) {
      return false;
    }
    return false;
  }

  /// Convert version `x.y.z` to integer for comparison.
  int _versionToInt(String version) {
    List<String> parts = version.split('.');
    int major = int.parse(parts[0]);
    int minor = int.parse(parts[1]);
    int patch = int.parse(parts[2]);
    return major * 1000000 + minor * 1000 + patch;
  }

  /// Show Update Dialog
  void _showUpdateDialog(dynamic data) {
    if (GetPlatform.isIOS) {
      // iOS Style Dialog
      Get.dialog(
        CupertinoAlertDialog(
          title: const Text('Update Available'),
          content: const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              'A new version of the app is available. Please update to continue.',
            ),
          ),
          actions: [
            if (data['force_update'] == true)
              CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () => SystemNavigator.pop(),
                child: const Text('Exit App'),
              ),
            if (data['force_update'] == false)
              CupertinoDialogAction(
                onPressed: () => Get.back(),
                child: const Text('Skip'),
              ),
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () => launchURL(data['url']),
              child: const Text('Update'),
            ),
          ],
        ),
        barrierDismissible: false,
      );
    } else {
      // Android Style Dialog
      Get.dialog(
        PopScope(
          canPop: false,
          child: AlertDialog(
            surfaceTintColor: Colors.white,
            backgroundColor: Colors.white,
            title: const Text('Update Available'),
            content: const Text(
              'A new version of the app is available. Please update to continue.',
            ),
            actions: [
              if (data['force_update'] == true)
                TextButton(
                  onPressed: () => SystemNavigator.pop(),
                  child: const Text(
                    'Exit App',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              if (data['force_update'] == false)
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text(
                    'Skip',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              TextButton(
                onPressed: () => launchURL(data['url']),
                child: Text('Update', style: TextStyle(color: primaryColor)),
              ),
            ],
          ),
        ),
        barrierDismissible: false,
      );
    }
  }
}
