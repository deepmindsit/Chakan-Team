import 'package:chakan_team/utils/exported_path.dart';

class UpdateComplaint extends StatefulWidget {
  const UpdateComplaint({super.key});

  @override
  State<UpdateComplaint> createState() => _UpdateComplaintState();
}

class _UpdateComplaintState extends State<UpdateComplaint> {
  final controller = getIt<ComplaintController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchInitialData();
    });
    super.initState();
  }

  void _fetchInitialData() async {
    controller.isMainLoading.value = true;
    await Future.wait([
      controller.getWard(),
      controller.getDepartment(),
      controller.getStatus(),
    ]).then((v) {
      controller.setInitialData();
      controller.resetUpdateForm();
    });
    controller.isMainLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: CustomAppBar(title: 'Update Complaint', showBackButton: true),
      body: Obx(
        () =>
            controller.isMainLoading.isTrue
                ? LoadingWidget(color: primaryColor)
                : SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 12.h,
                  ),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      children: [
                        _buildLabel('Description'.tr),
                        _buildDescriptionField(),
                        SizedBox(height: 12.h),
                        _buildDepartment(),
                        SizedBox(height: 12.h),
                        _buildWard(),

                        SizedBox(height: 12.h),
                        _buildHod(),
                        SizedBox(height: 12.h),
                        _buildFieldOfficer(),
                        SizedBox(height: 12.h),
                        _buildStatus(),
                        SizedBox(height: 12.h),
                        _buildLabel('Attachments'.tr),
                        _buildUploadDocuments(),
                        SizedBox(height: 16.h),
                        _buildSelectedFilesWrap(),
                      ],
                    ),
                  ),
                ),
      ),
      bottomNavigationBar: buildUpdateButton(),
    );
  }

  Widget _buildDescriptionField() {
    return buildTextField(
      keyboardType: TextInputType.text,
      controller: controller.descriptionController,
      validator:
          (value) => value!.isEmpty ? 'Please Enter Description'.tr : null,
      hintText: 'Enter Your Description'.tr,
    );
  }

  Widget _buildDepartment() {
    return AppDropdownField(
      isDynamic: true,
      value: controller.selectedDepartment.value,
      title: 'Department',
      items: controller.departmentList,
      hintText: 'Select Department',
      validator: (value) => value == null ? 'Please select Department' : null,
      onChanged: (value) async {
        controller.selectedDepartment.value = value;
        controller.updateOfficers(value!);
      },
    );
  }

  Widget _buildWard() {
    return AppDropdownField(
      isDynamic: true,
      title: 'Ward',
      value:
          controller.selectedWard.value!.isEmpty
              ? null
              : controller.selectedWard.value,
      items: controller.wardList,
      hintText: 'Select Ward',
      validator: (value) => value == null ? 'Please select Ward' : null,
      onChanged: (value) async {
        controller.selectedWard.value = value;
      },
    );
  }

  Widget _buildHod() {
    return AppDropdownField(
      isDynamic: true,
      title: 'HOD',
      value: controller.selectedHOD.value,
      items: controller.hodList,
      hintText: 'Select HOD',
      validator: (value) => value == null ? 'Please select HOD' : null,
      onChanged: (value) async {
        controller.selectedHOD.value = value;
      },
    );
  }

  Widget _buildFieldOfficer() {
    return AppDropdownField(
      isDynamic: true,
      title: 'Field Officer',
      value: controller.selectedFieldOfficer.value,
      items: controller.fieldOfficerList,
      hintText: 'Select field officer',
      // validator:
      //     (value) => value == null ? 'Please select field officer' : null,
      onChanged: (value) async {
        controller.selectedFieldOfficer.value = value;
      },
    );
  }

  Widget _buildStatus() {
    return AppDropdownField(
      isDynamic: true,
      title: 'Status',
      value: controller.selectedStatus.value,
      items: controller.statusList,
      hintText: 'Select Status',
      validator: (value) => value == null ? 'Please select Status' : null,
      onChanged: (value) async {
        controller.selectedStatus.value = value.toString();
      },
    );
  }

  Widget _buildUploadDocuments() {
    return GestureDetector(
      onTap: () {
        CustomFilePicker.showPickerBottomSheet(
          onFilePicked: (file) {
            controller.newAttachments.add(file);
          },
        );
      },
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(width: 0.2),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: CustomText(
          title: 'Upload Documents',
          fontSize: 14,
          color: primaryGrey,
        ),
      ),
    );
  }

  Widget buildUpdateButton() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ).copyWith(bottom: 8),
        child: CustomButton(
          isLoading: controller.isComplaintLoading,
          onPressed: () async {
            if (controller.formKey.currentState!.validate()) {
              if (controller.isComplaintLoading.isFalse) {
                await controller.addComplaintComment(
                  Get.arguments['id'].toString(),
                );
              }
            }
          },
          backgroundColor: primaryColor,
          text: 'Update',
          width: 0.8.sw,
          height: 48.h,
        ),
      ),
    );
  }

  Widget _buildSelectedFilesWrap() {
    return Obx(
      () => Wrap(
        spacing: 16,
        runSpacing: 8,
        children:
            controller.newAttachments.map((file) {
              final isImage =
                  file.path.endsWith('.jpg') || file.path.endsWith('.png');

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: Get.width * 0.25.w,
                    height: Get.width * 0.25.w,
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child:
                        isImage
                            ? Image.file(file, fit: BoxFit.cover)
                            : Center(
                              child: Icon(
                                HugeIcons.strokeRoundedDocumentAttachment,
                                size: 40.sp,
                                color: Colors.grey,
                              ),
                            ),
                  ),
                  Positioned(
                    top: -10,
                    right: -10,
                    child: InkWell(
                      onTap: () {
                        controller.newAttachments.remove(file);
                      },
                      child: CircleAvatar(
                        radius: 10.r,
                        backgroundColor: Colors.red,
                        child: Icon(
                          Icons.close,
                          size: 12.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w, bottom: 6.h),
      child: buildLabel(text),
    );
  }
}
