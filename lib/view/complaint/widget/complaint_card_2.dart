import 'package:chakan_team/utils/exported_path.dart';

class ComplaintCard2 extends StatelessWidget {
  final String title;
  final String location;
  final String date;
  final String status;
  final String statusColor;
  final String ticketNo;

  const ComplaintCard2({
    super.key,
    required this.title,
    required this.location,
    required this.date,
    required this.status,
    required this.statusColor,
    required this.ticketNo,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      child: Container(
        decoration: _buildCardDecoration(),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16.r),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  SizedBox(height: 12.h),
                  _buildLocationSection(),
                  if (location.isNotEmpty) SizedBox(height: 12.h),
                  _buildFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16.r),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 12.r,
          offset: const Offset(0, 4),
          spreadRadius: 0,
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.02),
          blurRadius: 4.r,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TranslatedText(
                maxLines: 2,
                textAlign: TextAlign.start,
                title: title,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A1A1A),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Container(
                    width: 4.w,
                    height: 4.w,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  CustomText(
                    title: "Ticket #$ticketNo",
                    color: Colors.grey.shade600,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(width: 12.w),
        StatusBadge(status: status, color: int.parse(statusColor)),
      ],
    );
  }

  Widget _buildLocationSection() {
    if (location.isEmpty) return SizedBox.shrink();
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          SizedBox(width: 12.w),
          Icon(
            HugeIcons.strokeRoundedPinLocation01,
            size: 16.sp,
            color: Colors.grey.shade600,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: TranslatedText(
              textAlign: TextAlign.start,
              maxLines: 1,
              title: location,
              color: Colors.grey.shade700,
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDateChip(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText(
                title: "View Details",
                color: const Color(0xFF2563EB),
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(width: 4.w),
              Icon(
                Icons.arrow_forward_rounded,
                color: const Color(0xFF2563EB),
                size: 16.sp,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateChip() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200, width: 1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            HugeIcons.strokeRoundedCalendar03,
            size: 14.sp,
            color: Colors.grey.shade600,
          ),
          SizedBox(width: 6.w),
          CustomText(
            title: _formatDate(date),
            color: Colors.grey.shade700,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }

  String _formatDate(String date) {
    // Add date formatting logic here if needed
    // For now, return the original date
    return date;
  }
}
