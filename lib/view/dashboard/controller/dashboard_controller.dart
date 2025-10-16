import 'package:chakan_team/utils/exported_path.dart';

@lazySingleton
class DashboardController extends GetxController {
  final ApiService _apiService = Get.find();
  final searchController = TextEditingController();

  final isLoading = false.obs;
  final dashboardData = {}.obs;

  // =================== FETCH dashboard Data ===================
  /// Fetches dashboard
  Future<void> getDashboard({bool load = true}) async {
    if (load) isLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final res = await _apiService.getDashboard(userId);
      if (res['common']['status'] == true) {
        dashboardData.value = res['data'][0] ?? {};
      }
    } catch (e) {
      showToastNormal('Something went wrong. Please try again later.');
      debugPrint("Login error: $e");
    } finally {
      if (load) isLoading.value = false;
    }
  }

  final List<Map<String, dynamic>> data = [
    {
      'department': 'Health',
      'pending': 5,
      'inProgress': 3,
      'complete': 7,
      'rejected': 2,
    },
    {
      'department': 'Town Planning',
      'pending': 2,
      'inProgress': 4,
      'complete': 6,
      'reject': 1,
    },
    {
      'department': 'Electricity',
      'pending': 1,
      'inProgress': 5,
      'complete': 8,
      'reject': 0,
    },
  ];

  final List<Map<String, dynamic>> recentComplaint = [
    {
      'no': 'CNP000',
      'dept': 'Health',
      'status': 'Rejected',
      'created_on': '03-07-2025',
    },
    {
      'no': 'CNP000',
      'dept': 'Computer',
      'status': 'Pending',
      'created_on': '03-07-2025',
    },
    {
      'no': 'CNP000',
      'dept': 'Electricity',
      'status': 'Complete',
      'created_on': '03-07-2025',
    },
  ];

  final Map<String, double> dataMap = {
    'Web': 30,
    'Android': 20,
    'Chat Bot': 25,
    'Inward': 15,
    'Toll Free': 10,
  };
}
