import 'package:dropdown_search/dropdown_search.dart';
import '../../../utils/exported_path.dart';

class ComplaintFilter extends StatefulWidget {
  const ComplaintFilter({super.key});

  @override
  State<ComplaintFilter> createState() => _ComplaintFilterState();
}

class _ComplaintFilterState extends State<ComplaintFilter> {
  final controller = getIt<ComplaintController>();

  @override
  void initState() {
    controller.loadInitialData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SizedBox(
        height: Get.height * 0.8.h,
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child:
              controller.mainLoader.isTrue
                  ? LoadingWidget(color: primaryColor)
                  : SingleChildScrollView(
                    child: Column(
                      spacing: 16.h,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Department Filter

                        // _buildDepartment(),
                        multiSelectionItem(),

                        /// Date Range
                        _buildDateRange(),

                        /// Complaint Status
                        _buildStatus(),

                        // /// Complaint Type
                        // _buildComplaintType(),

                        /// Complaint Source
                        _buildSource(),

                        /// Apply / Reset
                        _buildButtons(),
                      ],
                    ),
                  ),
        ),
      );
    });
  }

  // Widget _buildDepartment() {
  //   // If only one department, auto-select it
  //   if (controller.departments.length == 1) {
  //     controller.selectedDepartmentFilter.value =
  //         controller.departments.first['id'].toString();
  //   }
  //
  //   return AppDropdownField(
  //     isDynamic: true,
  //     title: 'Department',
  //     value: controller.selectedDepartmentFilter.value,
  //     items: controller.departments,
  //     hintText: 'Select Department',
  //     validator: (value) => value == null ? 'Please select Department' : null,
  //     onChanged: (val) => controller.selectedDepartmentFilter.value = val!,
  //   );
  // }

  Widget _buildDateRange() {
    return AppDropdownField(
      title: 'Date Range',
      value: controller.selectedDateRange.value,
      items: ["Today", "Yesterday", "This Week", "This Month", "Custom"],
      hintText: 'Select Date Range',
      validator: (value) => value == null ? 'Please select Date Range' : null,
      onChanged: (val) async {
        controller.selectedDateRange.value = val!;
        // if (val == "Custom") controller.pickCustomDateRange();
        if (val == "Custom") {
          controller.pickCustomDateRange();
        } else {
          controller.setDateRange(val);
        }
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
      onChanged: (val) => controller.selectedStatus.value = val!,
    );
  }



  Widget _buildSource() {
    return AppDropdownField(
      isDynamic: true,
      title: 'Source',
      value: controller.selectedSource.value,
      items: controller.sourceList,
      hintText: 'Select Source',
      validator: (value) => value == null ? 'Please select Source' : null,
      onChanged: (val) => controller.selectedSource.value = val!,
    );
  }

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Reset -> OutlinedButton
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              side: BorderSide(color: primaryColor), // outline color
            ),
            onPressed: controller.resetFilters,
            child: Text("Reset", style: TextStyle(color: primaryColor)),
          ),
        ),
        SizedBox(width: 12.w), // space between buttons
        // Apply -> ElevatedButton
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            onPressed: controller.applyFilters,
            child: Text("Apply"),
          ),
        ),
      ],
    );
  }

  Widget multiSelectionItem() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 8.0, bottom: 6),
          child: buildLabel('Department'),
        ),
        DropdownSearch<String>.multiSelection(
          decoratorProps: DropDownDecoratorProps(
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              border: buildOutlineInputBorder(),
              enabledBorder: buildOutlineInputBorder(),
              focusedBorder: buildOutlineInputBorder(),
              contentPadding: const EdgeInsets.all(12),
              hintText: 'Select department',
              hintStyle: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          items:
              (filter, infiniteScrollProps) =>
                  controller.departments
                      .map((item) => item['name'].toString())
                      .toList(),
          selectedItems: controller.selectedDepartmentName.cast<String>(),

          popupProps: PopupPropsMultiSelection.menu(
            menuProps: MenuProps(
              backgroundColor: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            constraints: const BoxConstraints(maxHeight: 300),
          ),
          onChanged: (List<String> selectedItems) {
            // print('selectedItems');
            // print(selectedItems);
            // collect only IDs
            final selectedIds =
                controller.departments
                    .map((item) => item['id'].toString())
                    .toList();

            // print("Selected IDs: $selectedIds");
            // print(
            //   "Selected Names: ${controller.departments.map((e) => e['name']).toList()}",
            // );

            // store in controller if needed
            controller.selectedDepartmentIds.value = selectedIds;
            controller.selectedDepartmentName.value =
                controller.departments.map((e) => e['name']).toList();
          },
        ),
      ],
    );
  }
}
