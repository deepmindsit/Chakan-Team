import '../../../utils/exported_path.dart';

@lazySingleton
class NavigationController extends GetxController {
  final currentIndex = 0.obs;
  final fromDashboard = false.obs;
  // static final List<Widget> widgetOptions = <Widget>[
  //   DashboardPage(),
  //   if (getIt<UserService>().rollId.value != '9') HomeScreen(),
  //   if (getIt<UserService>().rollId.value != '9') TaskScreen(),
  //   ComplaintScreen(),
  //   if (getIt<UserService>().rollId.value != '9') KnowledgeScreen(),
  // ];

  List<Widget> get widgetOptions {
    final roleId = getIt<UserService>().rollId.value;

    if (roleId == '9') {
      return [DashboardPage(), ComplaintScreen()];
    }

    return [
      DashboardPage(),
      HomeScreen(),
      TaskScreen(),
      ComplaintScreen(),
      KnowledgeScreen(),
    ];
  }

  void updateIndex(int index, {bool isFromDashboard = false}) {
    fromDashboard.value = isFromDashboard;
    currentIndex.value = index;
  }
}
