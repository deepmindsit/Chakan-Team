import 'package:chakan_team/utils/exported_path.dart';

@lazySingleton
class ComplaintController extends GetxController {
  final ApiService _apiService = Get.find();
  final complaintList = [].obs;
  final complaintDetails = {}.obs;
  final isLoading = false.obs;
  final isDetailsLoading = false.obs;
  final isSendLoading = false.obs;
  final isDepartmentLoading = false.obs;
  final isWardLoading = false.obs;
  final isMainLoading = false.obs;
  final isComplaintLoading = false.obs;

  //update Complaint
  final formKey = GlobalKey<FormState>();
  final descriptionController = TextEditingController();
  final selectedDepartment = RxnString();
  final selectedStatus = RxnString();
  final selectedWard = RxnString();
  final selectedHOD = RxnString();
  final selectedFieldOfficer = RxnString();
  final newAttachments = [].obs;
  final departmentList = [].obs;
  final wardList = [].obs;
  final hodList = [].obs;
  final fieldOfficerList = [].obs;
  final statusList = [].obs;




  final page = 1.obs;
  final hasNextPage = true.obs;
  final isMoreLoading = false.obs;

  /// Fetches getComplaintInitial
  Future<void> getComplaintInitial({bool showLoading = true}) async {
    if (showLoading) isLoading.value = true;
    page.value = 1;
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final res = await _apiService.getComplaint(userId, page.value.toString());
      if (res['common']['status'] == true) {
        complaintList.value = res['data'] ?? [];
      }
    } catch (e) {
      showToastNormal('Something went wrong. Please try again later.');
      // debugPrint("Login error: $e");
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }

  /// Fetches getComplaintLoadMore
  Future<void> getComplaintLoadMore() async {
    isMoreLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      page.value += 1;
      final res = await _apiService.getComplaint(userId, page.value.toString());
      if (res['common']['status'] == true) {
        final List fetchedPosts = res['data'];
        if (fetchedPosts.isNotEmpty) {
          complaintList.addAll(fetchedPosts);
        } else {
          hasNextPage.value = false;
        }
      }
    } catch (e) {
      showToastNormal('Something went wrong. Please try again later.');
      // debugPrint("Login error: $e");
    } finally {
      isMoreLoading.value = false;
    }
  }







  Future<void> getStatus() async {
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final res = await _apiService.getStatus(userId);
      if (res['common']['status'] == true) {
        statusList.value = res['data'] ?? [];
      } else {
        showToastNormal(res['common']['message'] ?? 'Error fetching status');
      }
    } catch (e) {
      showToastNormal('Something went wrong. Please try again later.');
      // debugPrint("Login error: $e");
    } finally {}
  }

  // Future<void> getComplaint() async {
  //   isLoading.value = true;
  //   final userId = await LocalStorage.getString('user_id') ?? '';
  //   try {
  //     final res = await _apiService.getComplaint(userId);
  //     if (res['common']['status'] == true) {
  //       complaintList.value = res['data'] ?? [];
  //     }
  //   } catch (e) {
  //     showToastNormal('Something went wrong. Please try again later.');
  //     // debugPrint("Login error: $e");
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  Future<void> getComplaintDetails(String complaintId) async {
    isDetailsLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final res = await _apiService.getComplaintDetails(userId, complaintId);
      if (res['common']['status'] == true) {
        complaintDetails.value = res['data'][0] ?? {};
      } else {
        showToastNormal(
          res['common']['message'] ??
              'Something went wrong. Please try again later.',
        );
      }
    } catch (e) {
      showToastNormal('Something went wrong. Please try again later.');
      // debugPrint("Login error: $e");
    } finally {
      isDetailsLoading.value = false;
    }
  }

  Future<void> addComplaintComment(String complaintId) async {
    isComplaintLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final docs = await prepareDocuments(newAttachments);
      final res = await _apiService.addComplaintComment(
        userId,
        complaintId,
        selectedStatus.value!,
        selectedFieldOfficer.value.toString(),
        selectedHOD.value.toString(),
        selectedDepartment.value.toString(),
        descriptionController.text.trim(),
        attachment: docs,
      );
      if (res['common']['status'] == true) {
        showToastNormal(res['common']['message']);
        Get.back();
        if (complaintDetails['department_id']?.toString() !=
            selectedDepartment.value) {
          Get.offAllNamed(Routes.mainScreen);
        }
        await getComplaintDetails(complaintId);
        resetUpdateForm();
      } else {
        showToastNormal(res['common']['message'] ?? '');
      }
    } catch (e) {
      showToastNormal('Something went wrong. Please try again later.');
      // debugPrint("Login error: $e");
    } finally {
      isComplaintLoading.value = false;
    }
  }

  Future<void> getDepartment() async {
    isDepartmentLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';
    // final authKey = await LocalStorage.getString('auth_key') ?? '';
    try {
      final res = await _apiService.getDepartment(userId);
      if (res['common']['status'] == true) {
        departmentList.value = res['data'] ?? [];
      } else {
        showToastNormal(
          res['common']['message'] ??
              'Something went wrong. Please try again later.',
        );
      }
    } catch (e) {
      showToastNormal('Something went wrong. Please try again later.');
      // debugPrint("Login error: $e");
    } finally {
      isDepartmentLoading.value = false;
    }
  }

  Future<void> getWard() async {
    isWardLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final res = await _apiService.getWard(userId);
      print('getWard');
      print(res);
      if (res['common']['status'] == true) {
        wardList.value = res['data'] ?? [];
      } else {
        showToastNormal(
          res['common']['message'] ??
              'Something went wrong. Please try again later.',
        );
      }
    } catch (e) {
      showToastNormal('Something went wrong. Please try again later.');
      debugPrint("Login error: $e");
    } finally {
      isWardLoading.value = false;
    }
  }

  void setInitialData() {
    selectedDepartment.value =
        complaintDetails['department_id']?.toString() ?? '';
    selectedStatus.value = complaintDetails['status_id']?.toString() ?? '';
    selectedWard.value = complaintDetails['ward_id']?.toString() ?? '';
    updateOfficers(
      complaintDetails['department_id']?.toString() ?? '',
      isInitial: true,
    );
  }

  void resetUpdateForm() {
    descriptionController.clear();
    // selectedStatus.value = null;
    newAttachments.clear();
  }

  void updateOfficers(String departmentId, {bool isInitial = false}) {
    final selectedDept = departmentList.firstWhere(
      (element) => element['id'].toString() == departmentId,
      orElse: () => {},
    );

    hodList.value = selectedDept['hod'] ?? [];
    fieldOfficerList.value = selectedDept['field_officer'] ?? [];

    if (isInitial) {
      final hodId = complaintDetails['hod_id']?.toString();
      final fieldId = complaintDetails['field_id']?.toString();

      final hodMatch = hodList.firstWhere(
        (e) => e['id'].toString() == hodId,
        orElse: () => null,
      );

      final fieldMatch = fieldOfficerList.firstWhere(
        (e) => e['id'].toString() == fieldId,
        orElse: () => null,
      );

      if (hodId != null && hodId.isNotEmpty && hodMatch != null) {
        selectedHOD.value = hodId;
      }

      if (fieldId != null && fieldId.isNotEmpty && fieldMatch != null) {
        selectedFieldOfficer.value = fieldId;
      }
    } else {
      selectedHOD.value = null;
      selectedFieldOfficer.value = null;
    }
  }








  // Department
  var departments = ["Water", "Electricity", "Roads"].obs;
  var selectedDepartments = <String>[].obs;

  // Date Range
  var selectedDateRange = "Today".obs;
  DateTime? customStart, customEnd;

  // Status
  var statusListFilter = ["Pending", "In Progress", "Resolved"];
  var selectedStatusFilter = "Pending".obs;

  // Complaint Type
  var typeList = ["Type A", "Type B", "Type C"];
  var selectedType = "Type A".obs;

  // Complaint Source
  var sourceList = ["App", "Website", "Phone"];
  var selectedSource = "App".obs;

  void toggleDepartment(String dept) {
    if (selectedDepartments.contains(dept)) {
      selectedDepartments.remove(dept);
    } else {
      selectedDepartments.add(dept);
    }
  }

  Future<void> pickCustomDateRange() async {
    DateTimeRange? picked = await showDateRangePicker(
      context: Get.context!,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      customStart = picked.start;
      customEnd = picked.end;
    }
  }

  void resetFilters() {
    selectedDepartments.clear();
    selectedDateRange.value = "Today";
    selectedStatus.value = statusList.first;
    selectedType.value = typeList.first;
    selectedSource.value = sourceList.first;
  }

  void applyFilters() {
    // Here you can call API with selected filters
    print("Departments: $selectedDepartments");
    print("Date: ${selectedDateRange.value} $customStart - $customEnd");
    print("Status: ${selectedStatus.value}");
    print("Type: ${selectedType.value}");
    print("Source: ${selectedSource.value}");
    Get.back();
  }
}
