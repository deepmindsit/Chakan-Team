import 'package:chakan_team/utils/exported_path.dart';

@lazySingleton
class AddFileController extends GetxController {
  final ApiService _apiService = Get.find();

  // =================== UPDATE FILE  ===================
  final descriptionController = TextEditingController();
  final newAttachments = [].obs;
  final updateFormKey = GlobalKey<FormState>();

  void resetUpdateForm() {
    descriptionController.clear();
    selectedStatus.value = null;
    newAttachments.clear();
  }

  final List<Map<String, dynamic>> statusList = [
    {'id': '0', 'name': 'Initialized'},
    {'id': '1', 'name': 'Hold'},
    {'id': '2', 'name': 'Inprogress'},
    {'id': '3', 'name': 'Completed'},
    {'id': '4', 'name': 'Reject'},
  ];

  // =================== ADD FILE COMMENT ===================
  Future<void> addFileComment(String fileId) async {
    isUpdateLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final docs = await prepareDocuments(newAttachments);
      final res = await _apiService.addFileComment(
        userId,
        fileId,
        selectedStatus.value!,
        descriptionController.text.trim(),
        attachment: docs,
      );
      if (res['common']['status'] == true) {
        showToastNormal(res['common']['message']);
        Get.back();
        await getFileDetails(fileId);
        resetUpdateForm();
      } else {
        showToastNormal(res['common']['message'] ?? '');
      }
    } catch (e) {
      showToastNormal('Something went wrong. Please try again later.');
      debugPrint("Login error: $e");
    } finally {
      isUpdateLoading.value = false;
    }
  }

  // =================== FILE DATA ===================
  final fileList = [].obs;
  final fileDetails = {}.obs;

  // =================== LOADERS ===================
  final isLoading = false.obs;
  final isDetailsLoading = false.obs;
  final isUpdateLoading = false.obs;

  // =================== FORM CONTROLLERS ===================
  final formKey = GlobalKey<FormState>();
  final fileNumberController = TextEditingController();
  final organizationController = TextEditingController();
  final designationController = TextEditingController();
  final contactInfoController = TextEditingController();
  final subjectController = TextEditingController();

  // =================== DROPDOWN VALUES ===================
  Rxn<String> selectedType = Rxn<String>();
  Rxn<String> selectedStatus = Rxn<String>();
  Rxn<String> selectedDepartment = Rxn<String>();
  Rxn<String> selectedCategory = Rxn<String>();
  Rxn<String> selectedSubCategory = Rxn<String>();
  Rxn<String> selectedMember = Rxn<String>();

  // =================== DATE PICKERS ===================
  Rx<DateTime?> startDate = Rx<DateTime?>(null);
  Rx<DateTime?> endDate = Rx<DateTime?>(null);

  // =================== REMINDER OPTIONS ===================
  RxInt selectedReminderValue = 1.obs;
  final List<Map<String, dynamic>> options = [
    {'label': '1 Day', 'value': 1},
    {'label': '1 Week', 'value': 2},
    {'label': '15 Days', 'value': 3},
  ];

  // =================== PRIORITY SELECTION ===================
  RxList<bool> isSelected = <bool>[true, false, false, false].obs;

  void selectPriority(int index) {
    for (int i = 0; i < isSelected.length; i++) {
      isSelected[i] = i == index;
    }
  }

  // =================== FETCH FILE LIST ===================
  /// Fetches all tasks for the logged-in user
  Future<void> getFiles() async {
    isLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final res = await _apiService.getFiles(userId);
      if (res['common']['status'] == true) {
        fileList.value = res['data'] ?? [];
      }
    } catch (e) {
      showToastNormal('Something went wrong. Please try again later.');
      debugPrint("Login error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // =================== FETCH FILE DETAILS ===================
  /// Fetches task details by [fileId]
  Future<void> getFileDetails(String fileId, {bool isLoading = true}) async {
    if (isLoading) isDetailsLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final res = await _apiService.getFileDetails(userId, fileId);
      if (res['common']['status'] == true) {
        fileDetails.value = res['data'][0] ?? {};
      }
    } catch (e) {
      showToastNormal('Something went wrong. Please try again later.');
      debugPrint("Login error: $e");
    } finally {
      if (isLoading) isDetailsLoading.value = false;
    }
  }

  // =================== FORM SUBMIT ===================
  void submitForm() {
    if (formKey.currentState!.validate()) {
      if (selectedType.value == null || selectedStatus.value == null) {
        Get.snackbar('Error', 'Please select Type and Status');
        return;
      }
      if (startDate.value == null || endDate.value == null) {
        Get.snackbar('Error', 'Please select both dates');
        return;
      }
      showToastNormal('File submitted successfully!');
      resetForm();
      // Perform API call or form submission here
      // Get.offAllNamed('/main');
    }
  }

  // =================== RESET FORM ===================
  void resetForm() {
    fileNumberController.clear();
    organizationController.clear();
    designationController.clear();
    contactInfoController.clear();
    subjectController.clear();

    selectedType.value = null;
    selectedStatus.value = null;
    selectedDepartment.value = null;
    selectedCategory.value = null;
    selectedSubCategory.value = null;
    selectedMember.value = null;

    startDate.value = null;
    endDate.value = null;
    selectedReminderValue.value = 1;
    isSelected.value = [true, false, false, false];
  }

  @override
  void onClose() {
    fileNumberController.dispose();
    organizationController.dispose();
    designationController.dispose();
    contactInfoController.dispose();
    subjectController.dispose();
    super.onClose();
  }
}
