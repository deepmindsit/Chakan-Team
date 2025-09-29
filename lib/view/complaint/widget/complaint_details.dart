import 'dart:developer';

import 'package:chakan_team/utils/exported_path.dart';

class ComplaintDetails extends StatefulWidget {
  const ComplaintDetails({super.key});

  @override
  State<ComplaintDetails> createState() => _ComplaintDetailsState();
}

class _ComplaintDetailsState extends State<ComplaintDetails> {
  final controller = getIt<ComplaintController>();
  final _scrollController = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final complaintId = Get.arguments['id'].toString();
      controller.getComplaintDetails(complaintId);
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: CustomAppBar(
        title: 'Complaint Details',
        showBackButton: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, size: 24.w),
            onPressed: () {
              final complaintId = Get.arguments['id'].toString();
              controller.getComplaintDetails(complaintId);
            },
          ),
        ],
      ),
      body: Obx(() {
        final complaints = controller.complaintDetails;

        if (controller.isDetailsLoading.isTrue) {
          return LoadingWidget(color: primaryColor);
        }

        if (complaints.isEmpty) {
          return Center(
            child: CustomText(title: "No details available", fontSize: 14.sp),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            final complaintId = Get.arguments['id'].toString();
            await controller.getComplaintDetails(complaintId);
          },
          child: CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildHeaderSection(),
                    SizedBox(height: 16.h),
                    // _buildStatusTimeline(),
                    // SizedBox(height: 16.h),
                    _buildDescriptionCard(),
                    SizedBox(height: 16.h),
                    _buildDetailsCard(),
                    SizedBox(height: 16.h),
                    if ((controller.complaintDetails['attachments'] as List)
                        .isNotEmpty)
                      _buildAttachmentsSection(),
                    if ((controller.complaintDetails['comments'] as List)
                        .isNotEmpty)
                      _buildUpdatesSection(),
                    SizedBox(height: 80.h), // Space for bottom button
                  ]),
                ),
              ),
            ],
          ),
        );
      }),
      floatingActionButton: _buildUpdateFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildHeaderSection() {
    return Hero(
      tag: 'complaint-${controller.complaintDetails['id']}',
      child: Material(
        type: MaterialType.transparency,
        child: GlassCard(
          // borderRadius: 12.r,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomText(
                    title:
                        controller.complaintDetails['department']?.toString() ??
                        '-',
                    textAlign: TextAlign.start,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    maxLines: 2,
                  ),
                ),
                StatusBadge(
                  status: controller.complaintDetails['status'].toString(),
                  color:
                  int.tryParse(
                    controller.complaintDetails['status_color']?.toString() ?? '',
                  ) ??
                      0xFF898989,
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Icon(
                  HugeIcons.strokeRoundedIdVerified,
                  size: 18.w,
                  color: Colors.grey,
                ),
                SizedBox(width: 8.w),
                CustomText(
                  title:
                      "Track ID: ${controller.complaintDetails['code']?.toString() ?? 'N/A'}",
                  fontSize: 14.sp,
                  color: Colors.grey.shade700,
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(
                  HugeIcons.strokeRoundedCalendar03,
                  size: 18.w,
                  color: Colors.grey,
                ),
                SizedBox(width: 8.w),
                CustomText(
                  title:
                      "Created: ${controller.complaintDetails['created_on_date']?.toString() ?? 'N/A'}",
                  fontSize: 14.sp,
                  color: Colors.grey.shade700,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionCard() {
    return GlassCard(
      children: [
        Row(
          children: [
            Icon(
              HugeIcons.strokeRoundedDocumentValidation,
              size: 20.w,
              color: primaryColor,
            ),
            SizedBox(width: 8.w),
            CustomText(
              title: "Description",
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
        SizedBox(height: 12.h),
        CustomText(
          title:
              controller.complaintDetails['description']?.toString() ??
              'No description provided',
          fontSize: 14.sp,
          textAlign: TextAlign.start,
          maxLines: 12,
        ),
      ],
    );
  }

  Widget _buildDetailsCard() {
    return GlassCard(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  HugeIcons.strokeRoundedInformationCircle,
                  size: 20.w,
                  color: primaryColor,
                ),
                SizedBox(width: 8.w),
                CustomText(
                  title: "Complaint Details",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                launchURL(
                  'tel:${controller.complaintDetails['complainant_mobile_no']}',
                );
              },
              child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: HugeIcon(
                  icon: Icons.call,
                  color: primaryColor,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        _buildDetailItem(
          icon: HugeIcons.strokeRoundedNewOffice,
          label: "Department",
          value: controller.complaintDetails['department']?.toString() ?? 'N/A',
        ),
        _buildDetailItem(
          icon: HugeIcons.strokeRoundedLocation10,
          label: "Ward",
          value: controller.complaintDetails['ward_name']?.toString() ?? 'N/A',
        ),
        _buildDetailItem(
          icon: HugeIcons.strokeRoundedUser02,
          label: "Complainant",
          value:
              controller.complaintDetails['complainant_name']?.toString() ??
              'N/A',
        ),
        _buildDetailItem(
          icon: HugeIcons.strokeRoundedUserAdd02,
          label: "HOD",
          value: controller.complaintDetails['hod_name']?.toString() ?? 'N/A',
        ),
        _buildDetailItem(
          icon: HugeIcons.strokeRoundedShieldUser,
          label: "Field Officer",
          value: controller.complaintDetails['field_name']?.toString() ?? 'N/A',
        ),
      ],
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
    bool showEdit = false,
    VoidCallback? onEdit,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20.w, color: Colors.grey),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (showEdit)
            IconButton(
              icon: Icon(Icons.edit, size: 18.w, color: primaryColor),
              onPressed: onEdit,
            ),
        ],
      ),
    );
  }

  Widget _buildAttachmentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Text(
            "Attachments",
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 8.h),
        AttachmentList(
          attachments: (controller.complaintDetails['attachments'] as List),
        ),
      ],
    );
  }

  Widget _buildUpdatesSection() {
    log('controller.complaintDetails');
    log(controller.complaintDetails['comments'].toString());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Text(
            "Updates History",
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 8.h),
        UpdateHistoryList(
          updateRecords: controller.complaintDetails['comments'],
          title: 'Updates',
        ),
      ],
    );
  }

  Widget _buildUpdateFAB() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: FloatingActionButton.extended(
        onPressed:
            () => Get.toNamed(
              Routes.updateComplaint,
              arguments: {'id': Get.arguments['id'].toString()},
            ),
        backgroundColor: primaryColor,
        elevation: 4,
        icon: Icon(Icons.edit, color: Colors.white),
        label: Text(
          'Update Complaint',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// Helper widget for timeline
class Timeline extends StatelessWidget {
  final List<Widget> children;

  const Timeline({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(children: children);
  }
}

class TimelineEvent extends StatelessWidget {
  final String title;
  final String time;
  final bool isFirst;
  final bool isLast;
  final bool isActive;

  const TimelineEvent({
    super.key,
    required this.title,
    required this.time,
    this.isFirst = false,
    this.isLast = false,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            if (!isFirst)
              Container(width: 1.5, height: 20, color: Colors.grey.shade300),
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? primaryColor : Colors.grey.shade300,
                border: Border.all(
                  color:
                      isActive
                          ? primaryColor.withValues(alpha: 0.5)
                          : Colors.grey.shade400,
                  width: 2,
                ),
              ),
            ),
            if (!isLast)
              Container(width: 1.5, height: 20, color: Colors.grey.shade300),
          ],
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  color: isActive ? Colors.black : Colors.grey.shade700,
                ),
              ),
              SizedBox(height: 2),
              Text(
                time,
                style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
