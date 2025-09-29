import 'package:chakan_team/utils/exported_path.dart';

class UpdateTask extends StatefulWidget {
  const UpdateTask({super.key});

  @override
  State<UpdateTask> createState() => _UpdateTaskState();
}

class _UpdateTaskState extends State<UpdateTask> {
  final controller = getIt<TaskController>();

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
      controller.getTaskStatus(),
      controller.getTaskAssignee(),
      controller.getTaskPriority(),
    ]);
    controller.setInitialData();
    controller.isMainLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: CustomAppBar(title: 'Update Task', showBackButton: true),
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
                    key: controller.updateTaskFormKey,
                    child: Column(
                      children: [
                        _buildLabel('Description'.tr),
                        _buildDescriptionField(),
                        SizedBox(height: 12.h),
                        _buildPriority(),
                        SizedBox(height: 12.h),
                        _buildAssignee(),
                        SizedBox(height: 12.h),
                        _buildTaskStatus(),
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
      maxLines: 5,
    );
  }

  Widget _buildPriority() {
    return AppDropdownField(
      isWithColor: true,
      isRequired: true,
      isDynamic: true,
      value: controller.selectedPriority.value,
      title: 'Priority',
      items: controller.priorityList,
      hintText: 'Select Priority',
      validator: (value) => value == null ? 'Please select Priority' : null,
      onChanged: (value) async {
        controller.selectedPriority.value = value;
        // controller.updateOfficers(value!);
      },
    );
  }

  Widget _buildAssignee() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Assignee'.tr),

        DropdownSearchComponent(
          dropdownHeight: Get.height * 0.4.h,
          hintText: 'Select Item',
          showSearchBox: true,
          searchHintText: 'Select Item',
          items: controller.assigneeList,
          preselectedValue: controller.selectedAssigneeName.value,
          onChanged: (value) {
            final selectedItem = controller.assigneeList.firstWhere(
              (item) => item['name'].toString() == value.toString(),
              orElse: () => {},
            );
            controller.selectedAssignee.value = selectedItem['id'].toString();
          },
          validator: (value) => value == null ? 'Select Item' : null,
        ),

        // ButtonTheme(
        //   alignedDropdown: true,
        //   buttonColor: Colors.grey[700],
        //   splashColor: Colors.transparent,
        //   materialTapTargetSize: MaterialTapTargetSize.padded,
        //   child: DropdownButtonFormField(
        //     borderRadius: BorderRadius.circular(12.r),
        //     value: controller.selectedAssignee.value,
        //     icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
        //     isExpanded: true,
        //     padding: EdgeInsets.all(15),
        //     decoration: InputDecoration(
        //       contentPadding: EdgeInsets.all(15),
        //       isDense: true,
        //       filled: true,
        //       fillColor: Colors.white,
        //       focusedBorder: buildOutlineInputBorder(),
        //       enabledBorder: buildOutlineInputBorder(),
        //       errorBorder: OutlineInputBorder(
        //         borderRadius: BorderRadius.circular(12.r),
        //         borderSide: const BorderSide(color: Colors.red),
        //       ),
        //       disabledBorder: buildOutlineInputBorder(),
        //       border: buildOutlineInputBorder(),
        //       hintText: 'Select Assignee',
        //       errorStyle: TextStyle(fontSize: 12.sp),
        //       errorMaxLines: 1,
        //     ),
        //     validator:
        //         (value) => value == null ? 'Please select Assignee' : null,
        //     dropdownColor: Colors.white,
        //     hint: Text(
        //       'Select Assignee',
        //       style: TextStyle(fontSize: 14.sp, color: primaryGrey),
        //     ),
        //     style: Theme.of(context).textTheme.bodyMedium,
        //     elevation: 4,
        //     items:
        //         controller.assigneeList.map((value) {
        //           return DropdownMenuItem(
        //             value: value['id'].toString(),
        //             child: SizedBox(
        //               width: Get.width * 0.8.w,
        //               child: ListTile(
        //                 dense: true,
        //                 tileColor: Colors.red,
        //                 minVerticalPadding: 0,
        //                 visualDensity: VisualDensity(vertical: -4),
        //                 contentPadding: EdgeInsets.zero,
        //                 leading: CircleAvatar(
        //                   backgroundImage: NetworkImage(value['profile_image']),
        //                 ),
        //                 title: Text(value['name'] ?? ''),
        //                 subtitle: Text(value['role_name'] ?? ''),
        //               ),
        //             ),
        //
        //             // Row(
        //             //   spacing: 4,
        //             //   children: [
        //             //     CircleAvatar(
        //             //       backgroundImage: NetworkImage(value['profile_image']),
        //             //     ),
        //             //     Column(
        //             //       mainAxisSize: MainAxisSize.min,
        //             //       crossAxisAlignment: CrossAxisAlignment.start,
        //             //       mainAxisAlignment: MainAxisAlignment.start,
        //             //       children: [
        //             //         CustomText(
        //             //           textAlign: TextAlign.start,
        //             //           title: '${value['name']}',
        //             //           color: Colors.black,
        //             //           fontSize: 13.sp,
        //             //         ),
        //             //         CustomText(
        //             //           textAlign: TextAlign.start,
        //             //           title: '${value['role_name']}',
        //             //           fontSize: 10.sp,
        //             //         ),
        //             //       ],
        //             //     ),
        //             //   ],
        //             // ),
        //           );
        //         }).toList(),
        //     onChanged: (value) async {
        //       controller.selectedStatus.value = value.toString();
        //     },
        //   ),
        // ),
      ],
    );
  }

  Widget _buildTaskStatus() {
    return AppDropdownField(
      isWithColor: true,
      isDynamic: true,
      title: 'Status',
      value: controller.selectedStatus.value,
      items: controller.statusList,
      onChanged: (value) {
        controller.selectedStatus.value = value;
      },
      hintText: 'Select Status',
      validator: (value) => value == null ? 'Please select Status' : null,
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
        height: 50.h,
        decoration: BoxDecoration(
          border: Border.all(width: 0.2),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: CustomText(
          title: 'Upload Documents',
          fontSize: 14.sp,
          color: primaryGrey,
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

  Widget buildUpdateButton() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ).copyWith(bottom: 8),
        child: CustomButton(
          isLoading: controller.isAddingLoading,
          onPressed: () async {
            if (controller.updateTaskFormKey.currentState!.validate()) {
              await controller.addTaskComment(Get.arguments['id'].toString());
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

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w, bottom: 6.h),
      child: buildLabel(text),
    );
  }
}
