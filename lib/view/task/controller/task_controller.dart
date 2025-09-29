import 'package:chakan_team/utils/exported_path.dart';

@lazySingleton
class TaskController extends GetxController {
  final ApiService _apiService = Get.find();

  // Task Data
  final taskList = [].obs;
  final taskDetails = {}.obs;

  // Loaders
  final isLoading = false.obs;
  final isDetailsLoading = false.obs;
  final isMainLoading = false.obs;
  final isAddingLoading = false.obs;

  // Dropdown Lists
  final priorityList = [].obs;
  final statusList = [].obs;
  final assigneeList = [].obs;

  // Form Selections
  final selectedStatus = RxnString();
  final selectedPriority = RxnString();
  final selectedAssignee = RxnString();
  final selectedAssigneeName = RxnString();
  final descriptionController = TextEditingController();
  final newAttachments = [].obs;

  //add Task
  final addTaskFormKey = GlobalKey<FormState>();
  final updateTaskFormKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final addTaskDescController = TextEditingController();
  Rxn<DateTime> endDate = Rxn<DateTime>();
  RxList<bool> isSelected = [true, false, false, false].obs;
  final selectedEndDate = RxnString();

  void selectPriority(int index) {
    for (int i = 0; i < isSelected.length; i++) {
      isSelected[i] = i == index;
    }
  }

  @override
  void onClose() {
    descriptionController.dispose();
    newAttachments.clear();
    super.onClose();
  }

  /// Initializes the dropdown selections from task details
  void setInitialData() {
    selectedPriority.value = taskDetails['priority_id']?.toString() ?? '';
    selectedStatus.value = taskDetails['status_id']?.toString() ?? '';
    selectedAssignee.value = taskDetails['assignee_id']?.toString() ?? '';
    selectedAssigneeName.value = taskDetails['assignee']?.toString() ?? '';
    descriptionController.clear();
    newAttachments.clear();
  }

  /// Fetches all tasks for the logged-in user
  Future<void> getTask() async {
    isLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final res = await _apiService.getTask(userId);
      if (res['common']['status'] == true) {
        taskList.value = res['data'] ?? [];
      }
    } catch (e) {
      showToastNormal('Something went wrong. Please try again later.');
      debugPrint("Login error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetches task details by [taskId]
  Future<void> getTaskDetails(String taskId) async {
    isDetailsLoading.value = true;
    taskDetails.clear();
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final res = await _apiService.getTaskDetails(userId, taskId);
      if (res['common']['status'] == true) {
        taskDetails.value = res['data'][0] ?? {};
      }
    } catch (e) {
      showToastNormal('Something went wrong. Please try again later.');
      debugPrint("Login error: $e");
    } finally {
      isDetailsLoading.value = false;
    }
  }

  /// Fetches list of available priorities
  Future<void> getTaskPriority() async {
    await _fetchDropdownData(_apiService.getPriority, priorityList);
  }

  /// Fetches list of available statuses
  Future<void> getTaskStatus() async {
    await _fetchDropdownData(_apiService.getTaskStatus, statusList);
  }

  /// Fetches list of assignees
  Future<void> getTaskAssignee() async {
    await _fetchDropdownData(_apiService.getAssignee, assigneeList);
  }

  /// Adds a task comment with optional attachments
  Future<void> addTaskComment(String taskId) async {
    isAddingLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final attachment = await prepareDocuments(newAttachments);
      final res = await _apiService.addTaskComment(
        userId,
        taskId,
        selectedStatus.value!,
        descriptionController.text.trim(),
        attachment: attachment,
      );
      if (res['common']['status'] == true) {
        showToastNormal(res['common']['message'] ?? 'Comment added');
        Get.back();
        await getTaskDetails(taskId);
      }
    } catch (e) {
      showToastNormal('Something went wrong. Please try again later.');
      debugPrint("Login error: $e");
    } finally {
      isAddingLoading.value = false;
    }
  }

  /// Utility to fetch dropdown list data
  Future<void> _fetchDropdownData(
    dynamic Function(String userId) fetchFn,
    RxList<dynamic> targetList,
  ) async {
    isLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final res = await fetchFn(userId);
      if (res['common']['status'] == true) {
        targetList.value = res['data'] ?? [];
      }
    } catch (e) {
      _handleError('Failed to fetch dropdown data', e);
    } finally {
      isLoading.value = false;
    }
  }

  /// Adds a task with optional attachments
  Future<void> addTask() async {
    isAddingLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';

    try {
      final attachment = await prepareDocuments(newAttachments);
      final res = await _apiService.addNewTask(
        userId,
        titleController.text.trim(),
        selectedStatus.value!,
        selectedPriority.value!,
        selectedAssignee.value!,
        selectedEndDate.value!,
        addTaskDescController.text.trim(),
        attachment: attachment,
      );
      // print('res===============>$res');
      if (res['common']['status'] == true) {
        showToastNormal(res['common']['message'] ?? 'New Task added');
        resetForm();
        getTask();
        Get.back();
        // await getTaskDetails(taskId);
      }
    } catch (e) {
      showToastNormal('Something went wrong. Please try again later.');
      // debugPrint("Login error: $e");
    } finally {
      isAddingLoading.value = false;
    }
  }

  void _handleError(String message, Object error) {
    showToastNormal('$message. Please try again later.');
    // debugPrint('$message: $error');
  }

  void resetForm() {
    // Clear text fields
    titleController.clear();
    addTaskDescController.clear();

    // Reset dropdown/selections
    selectedStatus.value = null;
    selectedPriority.value = null;
    selectedAssignee.value = null;
    selectedEndDate.value = null;
    endDate.value = null;

    // Clear attachments
    newAttachments.clear();

    // Reset form validation state
    addTaskFormKey.currentState?.reset();
  }
}

// Future<void> getTaskPriority() async {
//   isLoading.value = true;
//   final userId = await LocalStorage.getString('user_id') ?? '';
//   try {
//     final res = await _apiService.getPriority(userId);
//     if (res['common']['status'] == true) {
//       priorityList.value = res['data'] ?? [];
//     }
//   } catch (e) {
//     showToastNormal('Something went wrong. Please try again later.');
//     debugPrint("Login error: $e");
//   } finally {
//     isLoading.value = false;
//   }
// }
//
// Future<void> getTaskStatus() async {
//   isLoading.value = true;
//   final userId = await LocalStorage.getString('user_id') ?? '';
//   try {
//     final res = await _apiService.getTaskStatus(userId);
//     if (res['common']['status'] == true) {
//       statusList.value = res['data'] ?? [];
//     }
//   } catch (e) {
//     showToastNormal('Something went wrong. Please try again later.');
//     debugPrint("Login error: $e");
//   } finally {
//     isLoading.value = false;
//   }
// }
//
// Future<void> getTaskAssignee() async {
//   isLoading.value = true;
//   final userId = await LocalStorage.getString('user_id') ?? '';
//   try {
//     final res = await _apiService.getAssignee(userId);
//     if (res['common']['status'] == true) {
//       assigneeList.value = res['data'] ?? [];
//     }
//   } catch (e) {
//     showToastNormal('Something went wrong. Please try again later.');
//     debugPrint("Login error: $e");
//   } finally {
//     isLoading.value = false;
//   }
// }
