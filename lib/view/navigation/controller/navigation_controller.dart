import '../../../utils/exported_path.dart';

@lazySingleton
class NavigationController extends GetxController {
  final currentIndex = 0.obs;

  static final List<Widget> widgetOptions = <Widget>[
    DashboardPage(),
    HomeScreen(),
    TaskScreen(),
    ComplaintScreen(),
    KnowledgeScreen(),
  ];

  void updateIndex(int index) {
    currentIndex.value = index;
  }
}
