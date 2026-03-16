import 'package:chakan_team/utils/exported_path.dart';
import 'package:flutter/cupertino.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  final controller = getIt<OnboardingController>();
  String? token;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    controller.expanded.value = true;

    await Future.delayed(const Duration(seconds: 2));

    await _loadPreferences();

    final List<ConnectivityResult> connectivityResult = await (Connectivity()
        .checkConnectivity());

    if (!connectivityResult.contains(ConnectivityResult.none)) {
      token != null
          ? Get.offAllNamed(Routes.mainScreen)
          : Get.offAllNamed(Routes.login);
    } else {
      _showNoInternetDialog();
    }
  }

  // Future<void> _initialize() async {
  //   await _loadPreferences();
  //   await Future.delayed(
  //     const Duration(seconds: 2),
  //   ).then((value) => setState(() => controller.expanded = true));
  //   bool isConnected = await InternetConnectionChecker.instance.hasConnection;
  //
  //   if (isConnected) {
  //     token != null
  //         ? Get.offAllNamed(Routes.mainScreen)
  //         : Get.offAllNamed(Routes.login);
  //   } else {
  //     _showNoInternetDialog();
  //   }
  // }

  Future<void> _loadPreferences() async {
    token = await LocalStorage.getString('auth_key');
  }

  void _showNoInternetDialog() {
    if (GetPlatform.isIOS) {
      // iOS Dialog
      Get.dialog(
        CupertinoAlertDialog(
          title: const Text(
            'No Internet Connection',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            children: [
              SizedBox(height: 10),
              Image.asset(
                'assets/images/no_internet_connection.png',
                width: Get.width * 0.5,
              ),
              const SizedBox(height: 10),
              const Text('Check your Internet Connection'),
            ],
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Get.offAll(() => const SplashScreen()),
              isDefaultAction: true,
              child: const Text(
                'Retry',
                style: TextStyle(color: CupertinoColors.activeBlue),
              ),
            ),
          ],
        ),
        barrierDismissible: false,
      );
    } else {
      // Android Dialog
      Get.dialog(
        AlertDialog(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.white,
          title: const Text(
            'No Internet Connection',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/no_internet_connection.png',
                width: Get.height * 0.3,
              ),
              const SizedBox(height: 10),
              const Text('Check your Internet Connection'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.offAll(() => const SplashScreen()),
              style: TextButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Retry', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
        barrierDismissible: false,
      );
    }
  }

  // Future<void> _initialize() async {
  //   // Wait for the first frame to complete before navigating
  //   WidgetsBinding.instance.addPostFrameCallback((_) async {
  //     await Future.delayed(const Duration(seconds: 3));
  //     controller.expanded = true;
  //
  //     final token = await LocalStorage.getString('auth_key');
  //     // print('token---->$token');
  //     token == null
  //         ? Get.offAllNamed(Routes.login)
  //         : Get.offAllNamed(Routes.mainScreen);
  //
  //     // Perform your navigation here
  //     // Get.offAll(() => LoginScreen());
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Material(
      surfaceTintColor: Colors.white,
      color: Colors.white,
      child: Container(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(()=>
               AnimatedCrossFade(
                firstCurve: Curves.fastOutSlowIn,
                crossFadeState:
                    !controller.expanded.value
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                duration: controller.transitionDuration,
                firstChild: Container(),
                secondChild: _logoRemainder(),
                alignment: Alignment.centerLeft,
                sizeCurve: Curves.easeInOut,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _logoRemainder() {
    return Image.asset(Images.logo, height: Get.width * 0.5.h);
  }
}
