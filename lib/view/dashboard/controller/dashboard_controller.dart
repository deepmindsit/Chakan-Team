import 'package:chakan_team/utils/exported_path.dart';

@lazySingleton
class DashboardController extends GetxController {
  final ApiService _apiService = Get.find();
  final searchController = TextEditingController();

  final isLoading = false.obs;
  final dashboardData = {}.obs;
  final monthlyData = {}.obs;
  final chartData = [].obs;
  final deadComplaints = [].obs;
  final recentComplaints = [].obs;
  final complaintTypeData = {}.obs;

  // =================== FETCH dashboard Data ===================
  /// Fetches dashboard
  Future<void> getDashboard({bool load = true}) async {
    if (load) isLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final res = await _apiService.getDashboard(userId);
      if (res['common']['status'] == true) {
        dashboardData.value = res['data'][0] ?? {};
        monthlyData.value = dashboardData['monthly_complaint'] ?? {};
        if (monthlyData.isNotEmpty) setChartData(monthlyData);
        complaintTypeData.value = dashboardData['complaint_statistics'] ?? {};
        deadComplaints.value = dashboardData['dead_complaint_list'] ?? [];
        recentComplaints.value = dashboardData['recent_complaint_list'] ?? [];
      }
    } catch (e) {
      // showToastNormal('Something went wrong. Please try again later.');
      debugPrint("Login error: $e");
    } finally {
      if (load) isLoading.value = false;
    }
  }

  void setChartData(dynamic data) {
    List temp = [];

    data.forEach((month, value) {
      temp.add({
        "month": month,
        "pending": value["pending"]["value"],
        "inProgress": value["in-progress"]["value"],
        "completed": value["completed"]["value"],
        "rejected": value["rejected"]["value"],
      });
    });

    chartData.value = temp.toList();
  }

  double getMaxComplaintCount() {
    double maxValue = 0;

    for (var item in chartData) {
      double total =
          ((item["pending"] ?? 0) +
                  (item["inProgress"] ?? 0) +
                  (item["completed"] ?? 0) +
                  (item["rejected"] ?? 0))
              .toDouble();

      if (total > maxValue) {
        maxValue = total.toDouble();
      }
    }

    return maxValue + 5; // spacing above bars
  }
}
