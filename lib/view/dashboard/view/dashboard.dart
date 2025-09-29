import 'package:chakan_team/utils/exported_path.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final controller = getIt<DashboardController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getDashboard();
      getIt<UpdateController>().checkForUpdate();
    });

    getIt<FirebaseTokenController>().updateToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: CustomDrawer(),
      appBar: _buildAppBar(),
      body: Obx(() {
        if (controller.isLoading.isTrue) {
          // return LoadingWidget(color: primaryColor);
          return _infoGridShimmer();
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // _buildSearchField(),
              // SizedBox(height: 16.h),
              _infoGrid(),
              SizedBox(height: 16.h),
              // Obx(() => _pieChartSection()),
              Obx(() => _pieChartComplaint()),
              SizedBox(height: 16.h),
              Obx(() => _pieChartFiles()),
              SizedBox(height: 16.h),
              Obx(() => _pieChartTask()),
            ],
          ),
        );
      }),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      foregroundColor: Colors.white,
      backgroundColor: primaryColor,
      title: Image.asset(Images.logoWhite, width: 0.5.sw),
      centerTitle: true,
      actions: [
        GestureDetector(
          onTap: () => Get.toNamed(Routes.notificationList),
          child: Container(
            padding: EdgeInsets.all(8.w),
            margin: EdgeInsets.all(8.w),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              HugeIcons.strokeRoundedNotification02,
              color: primaryColor,
              size: 20.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoGrid() {
    final items = [
      DashboardCard(
        icon: Icons.task_alt,
        title: "Total Tasks",
        value: controller.dashboardData['total_tasks']?.toString() ?? '',
        percentage: "+15%",
        iconColor: primaryColor,
        updateDate: "20 July 2024",
      ),
      DashboardCard(
        icon: HugeIcons.strokeRoundedTimeSchedule,
        title: "Pending Tasks",
        value: controller.dashboardData['pending_tasks']?.toString() ?? '',
        percentage: "+15%",
        iconColor: primaryColor,
        updateDate: "20 July 2024",
      ),
      DashboardCard(
        icon: HugeIcons.strokeRoundedComplaint,
        title: "Total Complaints",
        value: controller.dashboardData['total_complaints']?.toString() ?? '',
        percentage: "+15%",
        iconColor: primaryColor,
        updateDate: "20 July 2024",
      ),
      DashboardCard(
        icon: HugeIcons.strokeRoundedTimeSchedule,
        title: "Pending Complaints",
        value: controller.dashboardData['pending_complaints']?.toString() ?? '',
        percentage: "+15%",
        iconColor: primaryColor,
        updateDate: "20 July 2024",
      ),
      DashboardCard(
        icon: HugeIcons.strokeRoundedFolder01,
        title: "Total Files",
        value: controller.dashboardData['total_files']?.toString() ?? '',
        percentage: "+15%",
        iconColor: primaryColor,
        updateDate: "20 July 2024",
      ),
      DashboardCard(
        icon: HugeIcons.strokeRoundedTimeSchedule,
        title: "Pending Files",
        value: controller.dashboardData['pending_files']?.toString() ?? '',
        percentage: "+15%",
        iconColor: primaryColor,
        updateDate: "20 July 2024",
      ),
    ];

    return LiveGrid.options(
      options: LiveOptions(
        delay: Duration(milliseconds: 100),
        showItemInterval: Duration(milliseconds: 100),
        showItemDuration: Duration(milliseconds: 300),
        reAnimateOnVisibility: false,
      ),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: 1.3,
      ),
      itemBuilder: (context, index, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.1),
              end: Offset.zero,
            ).animate(animation),
            child: SizedBox(height: 50, child: items[index]),
          ),
        );
      },
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  // Widget _pieChartSection() {
  //   final int totalPending =
  //       int.parse(
  //         controller.dashboardData['pending_tasks']?.toString() ?? '0',
  //       ) +
  //       int.parse(
  //         controller.dashboardData['pending_complaints']?.toString() ?? '0',
  //       ) +
  //       int.parse(controller.dashboardData['pending_files']?.toString() ?? '0');
  //
  //   final int totalItems =
  //       int.parse(controller.dashboardData['total_tasks']?.toString() ?? '0') +
  //       int.parse(
  //         controller.dashboardData['total_complaints']?.toString() ?? '0',
  //       ) +
  //       int.parse(controller.dashboardData['total_files']?.toString() ?? '0');
  //
  //   final int totalCompleted = totalItems - totalPending;
  //
  //   final double completedPercent =
  //       totalItems == 0 ? 0 : (totalCompleted / totalItems) * 100;
  //   final double pendingPercent =
  //       totalItems == 0 ? 0 : (totalPending / totalItems) * 100;
  //
  //   return Container(
  //     padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(16.r),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.grey.withValues(alpha: 0.15),
  //           spreadRadius: 2.r,
  //           blurRadius: 10.r,
  //           offset: Offset(0, 4.h),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           children: [
  //             Icon(
  //               HugeIcons.strokeRoundedAnalytics02,
  //               color: primaryColor,
  //               size: 22.sp,
  //             ),
  //             SizedBox(width: 8.w),
  //             CustomText(
  //               title: "All Summary",
  //               fontSize: 20.sp,
  //               fontWeight: FontWeight.w700,
  //               color: Colors.black,
  //             ),
  //           ],
  //         ),
  //         SizedBox(height: 12.h),
  //         Row(
  //           children: [
  //             Expanded(
  //               flex: 2,
  //               child: SizedBox(
  //                 height: 0.2.sh,
  //                 width: 0.2.sw,
  //                 child: PieChart(
  //                   PieChartData(
  //                     centerSpaceRadius: 45.r,
  //                     borderData: FlBorderData(show: false),
  //                     sections: [
  //                       PieChartSectionData(
  //                         value: totalCompleted.toDouble(),
  //                         radius: 23.r,
  //                         gradient: const LinearGradient(
  //                           colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
  //                           begin: Alignment.topCenter,
  //                           end: Alignment.bottomCenter,
  //                         ),
  //                         title: "${completedPercent.toStringAsFixed(0)}%",
  //                         titleStyle: TextStyle(
  //                           fontSize: 10.sp,
  //                           color: Colors.white,
  //                           fontWeight: FontWeight.bold,
  //                         ),
  //                       ),
  //                       PieChartSectionData(
  //                         value: totalPending.toDouble(),
  //                         radius: 24.r,
  //                         gradient: const LinearGradient(
  //                           colors: [Color(0xFFF44336), Color(0xFFE57373)],
  //                           begin: Alignment.topCenter,
  //                           end: Alignment.bottomCenter,
  //                         ),
  //                         title: "${pendingPercent.toStringAsFixed(0)}%",
  //                         titleStyle: TextStyle(
  //                           fontSize: 10.sp,
  //                           color: Colors.white,
  //                           fontWeight: FontWeight.bold,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   duration: const Duration(milliseconds: 800),
  //                   curve: Curves.easeInOutCubic,
  //                 ),
  //               ),
  //             ),
  //             SizedBox(width: 12.w),
  //             Expanded(
  //               flex: 2,
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   _legendItem(
  //                     "Completed",
  //                     totalCompleted,
  //                     Colors.green,
  //                     completedPercent,
  //                   ),
  //                   SizedBox(height: 20.h),
  //                   _legendItem(
  //                     "Pending",
  //                     totalPending,
  //                     Colors.red,
  //                     pendingPercent,
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _pieChartComplaint() {
    final int totalComplaints = int.parse(
      controller.dashboardData['total_complaints']?.toString() ?? '0',
    );

    final int completed = int.parse(
      controller.dashboardData['completed_complaints']?.toString() ?? '0',
    );
    final int inProgress = int.parse(
      controller.dashboardData['inprogress_complaints']?.toString() ?? '0',
    );
    final int pending = int.parse(
      controller.dashboardData['pending_complaints']?.toString() ?? '0',
    );
    final int rejected = int.parse(
      controller.dashboardData['rejected_complaints']?.toString() ?? '0',
    );

    // Percentages
    double percent(int value) =>
        totalComplaints == 0 ? 0 : (value / totalComplaints) * 100;
    if (totalComplaints == 0) return const SizedBox();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.15),
            spreadRadius: 2.r,
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                HugeIcons.strokeRoundedAnalytics02,
                color: primaryColor,
                size: 22.sp,
              ),
              SizedBox(width: 8.w),
              CustomText(
                title: "Complaint Summary",
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ],
          ),
          SizedBox(height: 12.h),
          totalComplaints == 0
              ? SizedBox(
                height: 120.h,
                child: Center(
                  child: CustomText(
                    title: "No Data Available",
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
              )
              : Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 0.22.sh,
                      width: 0.22.sw,
                      child: PieChart(
                        PieChartData(
                          centerSpaceRadius: 45.r,
                          borderData: FlBorderData(show: false),
                          sections: [
                            PieChartSectionData(
                              value: completed.toDouble(),
                              radius: 28.r,
                              color: Colors.green,
                              title:
                                  "${percent(completed).toStringAsFixed(0)}%",
                              titleStyle: TextStyle(
                                fontSize: 10.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            PieChartSectionData(
                              value: inProgress.toDouble(),
                              radius: 26.r,
                              color: Colors.blue,
                              title:
                                  "${percent(inProgress).toStringAsFixed(0)}%",
                              titleStyle: TextStyle(
                                fontSize: 10.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            PieChartSectionData(
                              value: pending.toDouble(),
                              radius: 24.r,
                              color: Colors.orange,
                              title: "${percent(pending).toStringAsFixed(0)}%",
                              titleStyle: TextStyle(
                                fontSize: 10.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            PieChartSectionData(
                              value: rejected.toDouble(),
                              radius: 22.r,
                              color: Colors.red,
                              title: "${percent(rejected).toStringAsFixed(0)}%",
                              titleStyle: TextStyle(
                                fontSize: 10.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeInOutCubic,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _legendItem(
                          "Completed",
                          completed,
                          Colors.green,
                          percent(completed),
                        ),
                        SizedBox(height: 12.h),
                        _legendItem(
                          "In Progress",
                          inProgress,
                          Colors.blue,
                          percent(inProgress),
                        ),
                        SizedBox(height: 12.h),
                        _legendItem(
                          "Pending",
                          pending,
                          Colors.orange,
                          percent(pending),
                        ),
                        SizedBox(height: 12.h),
                        _legendItem(
                          "Rejected",
                          rejected,
                          Colors.red,
                          percent(rejected),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
        ],
      ),
    );
  }

  Widget _pieChartFiles() {
    final int totalComplaints = int.parse(
      controller.dashboardData['total_files']?.toString() ?? '0',
    );

    final int completed = int.parse(
      controller.dashboardData['completed_files']?.toString() ?? '0',
    );
    final int inProgress = int.parse(
      controller.dashboardData['hold_files']?.toString() ?? '0',
    );
    final int pending = int.parse(
      controller.dashboardData['pending_files']?.toString() ?? '0',
    );
    final int rejected = int.parse(
      controller.dashboardData['rejected_files']?.toString() ?? '0',
    );

    // Percentages
    double percent(int value) =>
        totalComplaints == 0 ? 0 : (value / totalComplaints) * 100;
    if (totalComplaints == 0) return const SizedBox();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.15),
            spreadRadius: 2.r,
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                HugeIcons.strokeRoundedAnalytics02,
                color: primaryColor,
                size: 22.sp,
              ),
              SizedBox(width: 8.w),
              CustomText(
                title: "Files Summary",
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 0.22.sh,
                  width: 0.22.sw,
                  child: PieChart(
                    PieChartData(
                      centerSpaceRadius: 45.r,
                      borderData: FlBorderData(show: false),
                      sections: [
                        PieChartSectionData(
                          value: completed.toDouble(),
                          radius: 28.r,
                          color: Colors.green,
                          title: "${percent(completed).toStringAsFixed(0)}%",
                          titleStyle: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        PieChartSectionData(
                          value: inProgress.toDouble(),
                          radius: 26.r,
                          color: Colors.blue,
                          title: "${percent(inProgress).toStringAsFixed(0)}%",
                          titleStyle: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        PieChartSectionData(
                          value: pending.toDouble(),
                          radius: 24.r,
                          color: Colors.orange,
                          title: "${percent(pending).toStringAsFixed(0)}%",
                          titleStyle: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        PieChartSectionData(
                          value: rejected.toDouble(),
                          radius: 22.r,
                          color: Colors.red,
                          title: "${percent(rejected).toStringAsFixed(0)}%",
                          titleStyle: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeInOutCubic,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _legendItem(
                      "Completed",
                      completed,
                      Colors.green,
                      percent(completed),
                    ),
                    SizedBox(height: 12.h),
                    _legendItem(
                      "Hold",
                      inProgress,
                      Colors.purpleAccent,
                      percent(inProgress),
                    ),
                    SizedBox(height: 12.h),
                    _legendItem(
                      "Pending",
                      pending,
                      Colors.orange,
                      percent(pending),
                    ),
                    SizedBox(height: 12.h),
                    _legendItem(
                      "Rejected",
                      rejected,
                      Colors.red,
                      percent(rejected),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pieChartTask() {
    final int totalComplaints = int.parse(
      controller.dashboardData['total_tasks']?.toString() ?? '0',
    );

    final int completed = int.parse(
      controller.dashboardData['completed_tasks']?.toString() ?? '0',
    );
    final int inProgress = int.parse(
      controller.dashboardData['inprogress_tasks']?.toString() ?? '0',
    );
    final int pending = int.parse(
      controller.dashboardData['pending_tasks']?.toString() ?? '0',
    );
    final int rejected = int.parse(
      controller.dashboardData['assignee_tasks']?.toString() ?? '0',
    );

    // Percentages
    double percent(int value) =>
        totalComplaints == 0 ? 0 : (value / totalComplaints) * 100;
    if (totalComplaints == 0) return const SizedBox();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.15),
            spreadRadius: 2.r,
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                HugeIcons.strokeRoundedAnalytics02,
                color: primaryColor,
                size: 22.sp,
              ),
              SizedBox(width: 8.w),
              CustomText(
                title: "Task Summary",
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 0.22.sh,
                  width: 0.22.sw,
                  child: PieChart(
                    PieChartData(
                      centerSpaceRadius: 45.r,
                      borderData: FlBorderData(show: false),
                      sections: [
                        PieChartSectionData(
                          value: completed.toDouble(),
                          radius: 28.r,
                          color: Colors.green,
                          title: "${percent(completed).toStringAsFixed(0)}%",
                          titleStyle: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        PieChartSectionData(
                          value: inProgress.toDouble(),
                          radius: 26.r,
                          color: Colors.blue,
                          title: "${percent(inProgress).toStringAsFixed(0)}%",
                          titleStyle: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        PieChartSectionData(
                          value: pending.toDouble(),
                          radius: 24.r,
                          color: Colors.orange,
                          title: "${percent(pending).toStringAsFixed(0)}%",
                          titleStyle: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        PieChartSectionData(
                          value: rejected.toDouble(),
                          radius: 22.r,
                          color: Colors.red,
                          title: "${percent(rejected).toStringAsFixed(0)}%",
                          titleStyle: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeInOutCubic,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _legendItem(
                      "Completed",
                      completed,
                      Colors.green,
                      percent(completed),
                    ),
                    SizedBox(height: 12.h),
                    _legendItem(
                      "In Progress",
                      inProgress,
                      Colors.blue,
                      percent(inProgress),
                    ),
                    SizedBox(height: 12.h),
                    _legendItem(
                      "Pending",
                      pending,
                      Colors.orange,
                      percent(pending),
                    ),
                    SizedBox(height: 12.h),
                    _legendItem(
                      "Rejected",
                      rejected,
                      Colors.red,
                      percent(rejected),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendItem(String label, int count, Color color, double percent) {
    return Row(
      children: [
        Container(
          width: 14.w,
          height: 14.h,
          margin: EdgeInsets.only(right: 10.w),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.4),
                blurRadius: 4.r,
                offset: Offset(0, 2.h),
              ),
            ],
          ),
        ),
        Expanded(
          child: CustomText(
            title: "$label ($count)",
            fontSize: 12.sp,
            textAlign: TextAlign.start,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: CustomText(
            title: "${percent.toStringAsFixed(0)}%",
            fontSize: 12.sp,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _infoGridShimmer() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(6, (index) => const DashboardCardShimmer()),
      ),
    );
  }

  Widget _departmentWiseComplaint() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.15),
            spreadRadius: 2.r,
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                HugeIcons.strokeRoundedAnalytics02,
                color: primaryColor,
                size: 22.sp,
              ),
              SizedBox(width: 8.w),
              CustomText(
                title: "Department Wise Complaint",
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ],
          ),
          SizedBox(height: 12.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Table(
              border: TableBorder.all(
                width: 0.5,
                color: Colors.grey,
                borderRadius: BorderRadius.circular(8.r),
              ),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: {
                0: IntrinsicColumnWidth(), // Department column adapts to text size
                1: IntrinsicColumnWidth(), // Pending
                2: IntrinsicColumnWidth(), // In Progress
                3: IntrinsicColumnWidth(), // Complete
                4: IntrinsicColumnWidth(), // Reject
                5: IntrinsicColumnWidth(), // Total
                6: IntrinsicColumnWidth(), // Total
              },
              children: [
                // Header Row
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey[300]),
                  children: [
                    tableCell('#', isHeader: true),
                    tableCell('Department', isHeader: true),
                    tableCell('Pending', isHeader: true),
                    tableCell('In Progress', isHeader: true),
                    tableCell('Completed', isHeader: true),
                    tableCell('Rejected', isHeader: true),
                    tableCell('Total', isHeader: true),
                  ],
                ),
                // Data Rows
                ...controller.data.asMap().entries.map((entry) {
                  int index = entry.key + 1;
                  Map<String, dynamic> dept = entry.value;
                  int total =
                      dept['pending'] +
                      dept['inProgress'] +
                      dept['complete'] +
                      dept['reject'];
                  return TableRow(
                    children: [
                      tableCell(index.toString()),
                      tableCell(dept['department']),
                      tableCell(dept['pending'].toString()),
                      tableCell(dept['inProgress'].toString()),
                      tableCell(dept['complete'].toString()),
                      tableCell(dept['reject'].toString()),
                      tableCell(total.toString()),
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComplaintType() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.15),
            spreadRadius: 2.r,
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                HugeIcons.strokeRoundedAnalytics02,
                color: primaryColor,
                size: 22.sp,
              ),
              SizedBox(width: 8.w),
              CustomText(
                title: "Complaint Type",
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 0.2.sh,
                  width: 0.2.sw,
                  child: PieChart(
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeInOutCubic,
                    PieChartData(
                      sections:
                          controller.dataMap.entries.map((entry) {
                            final color = getColor(entry.key);
                            return PieChartSectionData(
                              color: color,
                              value: entry.value,
                              title: "${entry.value.toInt()}%",
                              radius: 24.r,
                              titleStyle: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            );
                          }).toList(),
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                flex: 2,
                child: Column(
                  spacing: 8,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      controller.dataMap.entries.map((entry) {
                        final color = getColor(entry.key);
                        return _legendItem(
                          entry.key,
                          entry.value.toInt(),
                          color,
                          entry.value,
                        );
                      }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentComplaints() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.15),
            spreadRadius: 2.r,
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                HugeIcons.strokeRoundedAnalytics02,
                color: primaryColor,
                size: 22.sp,
              ),
              SizedBox(width: 8.w),
              CustomText(
                title: "Recent Complaints",
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ],
          ),
          SizedBox(height: 12.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Table(
              border: TableBorder.all(
                width: 0.5,
                color: Colors.grey,
                borderRadius: BorderRadius.circular(8.r),
              ),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: {
                0: IntrinsicColumnWidth(),
                1: IntrinsicColumnWidth(),
                2: IntrinsicColumnWidth(),
                3: IntrinsicColumnWidth(),
              },
              children: [
                // Header Row
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey[300]),
                  children: [
                    tableCell('Complaint No', isHeader: true),
                    tableCell('Department', isHeader: true),
                    tableCell('Status', isHeader: true),
                    tableCell('Created On', isHeader: true),
                  ],
                ),
                // Data Rows
                ...controller.recentComplaint.asMap().entries.map((entry) {
                  int index = entry.key + 1;
                  Map<String, dynamic> dept = entry.value;
                  return TableRow(
                    children: [
                      tableCell('${dept['no']}$index'),
                      tableCell(dept['dept']),
                      tableCell(dept['status'].toString()),
                      tableCell(dept['created_on'].toString()),
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeadComplaints() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.15),
            spreadRadius: 2.r,
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                HugeIcons.strokeRoundedAnalytics02,
                color: primaryColor,
                size: 22.sp,
              ),
              SizedBox(width: 8.w),
              CustomText(
                title: "Dead Complaints",
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ],
          ),
          SizedBox(height: 12.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Table(
              border: TableBorder.all(
                width: 0.5,
                color: Colors.grey,
                borderRadius: BorderRadius.circular(8.r),
              ),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: {
                0: IntrinsicColumnWidth(),
                1: IntrinsicColumnWidth(),
                2: IntrinsicColumnWidth(),
                3: IntrinsicColumnWidth(),
              },
              children: [
                // Header Row
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey[300]),
                  children: [
                    tableCell('Complaint No', isHeader: true),
                    tableCell('Department', isHeader: true),
                    tableCell('Status', isHeader: true),
                    tableCell('Created On', isHeader: true),
                  ],
                ),
                // Data Rows
                ...controller.recentComplaint.asMap().entries.map((entry) {
                  int index = entry.key + 1;
                  Map<String, dynamic> dept = entry.value;
                  return TableRow(
                    children: [
                      tableCell('${dept['no']}$index'),
                      tableCell(dept['dept']),
                      tableCell(dept['status'].toString()),
                      tableCell(dept['created_on'].toString()),
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardCardShimmer extends StatelessWidget {
  const DashboardCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        padding: const EdgeInsets.all(12),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon placeholder
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 16),
            // Title placeholder
            Container(width: 80, height: 12, color: Colors.grey[300]),
            const SizedBox(height: 8),
            // Value placeholder
            Container(width: 50, height: 20, color: Colors.grey[300]),
            const SizedBox(height: 8),
            // Percentage placeholder
            Container(width: 40, height: 12, color: Colors.grey[300]),
            const Spacer(),
            // Update date placeholder
            Container(width: 100, height: 10, color: Colors.grey[300]),
          ],
        ),
      ),
    );
  }
}
