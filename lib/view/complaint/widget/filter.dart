import 'package:chakan_team/utils/exported_path.dart';

class ComplaintFilter extends StatefulWidget {
  const ComplaintFilter({super.key});

  @override
  State<ComplaintFilter> createState() => _ComplaintFilterState();
}

class _ComplaintFilterState extends State<ComplaintFilter> {
  final controller = getIt<ComplaintController>();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Department Filter
            Text("Department", style: TextStyle(fontWeight: FontWeight.bold)),
            Obx(
              () => Wrap(
                spacing: 8,
                children:
                    controller.departments.map((dept) {
                      return FilterChip(
                        label: Text(dept),
                        selected: controller.selectedDepartments.contains(dept),
                        onSelected: (val) {
                          controller.toggleDepartment(dept);
                        },
                      );
                    }).toList(),
              ),
            ),

            SizedBox(height: 16),

            /// Date Range
            Text("Date Range", style: TextStyle(fontWeight: FontWeight.bold)),
            Obx(
              () => DropdownButton<String>(
                value: controller.selectedDateRange.value,
                items:
                    ["Today", "Yesterday", "This Week", "This Month", "Custom"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                onChanged: (val) {
                  controller.selectedDateRange.value = val!;
                  if (val == "Custom") controller.pickCustomDateRange();
                },
              ),
            ),

            SizedBox(height: 16),

            /// Complaint Status
            Text("Status", style: TextStyle(fontWeight: FontWeight.bold)),
            Obx(
              () => DropdownButton<String>(
                value: controller.selectedStatus.value,
                items:
                    controller.statusListFilter
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                onChanged: (val) => controller.selectedStatus.value = val!,
              ),
            ),

            SizedBox(height: 16),

            /// Complaint Type
            Text(
              "Complaint Type",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Obx(
              () => DropdownButton<String>(
                value: controller.selectedType.value,
                items:
                    controller.typeList
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                onChanged: (val) => controller.selectedType.value = val!,
              ),
            ),

            SizedBox(height: 16),

            /// Complaint Source
            Text("Source", style: TextStyle(fontWeight: FontWeight.bold)),
            Obx(
              () => DropdownButton<String>(
                value: controller.selectedSource.value,
                items:
                    controller.sourceList
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                onChanged: (val) => controller.selectedSource.value = val!,
              ),
            ),

            SizedBox(height: 20),

            /// Apply / Reset
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: controller.resetFilters,
                  child: Text("Reset"),
                ),
                ElevatedButton(
                  onPressed: controller.applyFilters,
                  child: Text("Apply"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
