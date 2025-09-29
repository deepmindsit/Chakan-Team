import 'package:chakan_team/utils/exported_path.dart';

class DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String percentage;
  final Color iconColor;
  final String updateDate;

  const DashboardCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.percentage,
    required this.iconColor,
    required this.updateDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(40),
            spreadRadius: 2.r,
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: iconColor.withAlpha(30),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 20.sp),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: CustomText(
                    title: title,
                    fontSize: 14.sp,
                    maxLines: 2,
                    textAlign: TextAlign.start,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            CustomText(
              title: value,
              fontSize: 24.sp,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            // SizedBox(height: 8.h),
            // Row(
            //   children: [
            //     Icon(Icons.arrow_upward, color: Colors.green, size: 16.sp),
            //     SizedBox(width: 4.w),
            //     CustomText(
            //       title: percentage,
            //       fontSize: 12.sp,
            //       color: Colors.green,
            //       fontWeight: FontWeight.w600,
            //     ),
            //   ],
            // ),
            // const Spacer(),
            // CustomText(
            //   title: "Update: $updateDate",
            //   fontSize: 12.sp,
            //   color: Colors.grey,
            // ),
          ],
        ),
      ),
    );
  }
}
