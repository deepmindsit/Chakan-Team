import 'package:chakan_team/utils/exported_path.dart';

class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  final Color? baseColor;
  final Color? highlightColor;

  const ShimmerWidget({
    super.key,
    required this.width,
    required this.height,
    this.radius = 8,
    this.baseColor,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? Colors.grey.shade300,
      highlightColor: highlightColor ?? Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius.r),
        ),
      ),
    );
  }
}

// Optional: Circular shimmer for avatars or icons
class ShimmerCircle extends StatelessWidget {
  final double size;
  final Color? baseColor;
  final Color? highlightColor;

  const ShimmerCircle({
    super.key,
    required this.size,
    this.baseColor,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? Colors.grey.shade300,
      highlightColor: highlightColor ?? Colors.grey.shade100,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

// Optional: Custom shimmer for text lines
class ShimmerText extends StatelessWidget {
  final double width;
  final double height;
  final int lines;
  final double spacing;

  const ShimmerText({
    super.key,
    required this.width,
    this.height = 16,
    this.lines = 1,
    this.spacing = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(lines, (index) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: index < lines - 1 ? spacing.h : 0,
          ),
          child: ShimmerWidget(
            width: width * (1 - (index * 0.1)), // Gradually decrease width for each line
            height: height.h,
          ),
        );
      }),
    );
  }
}

// Optional: Full card shimmer with multiple elements
class ShimmerCard extends StatelessWidget {
  const ShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12.r,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header shimmer
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerWidget(
                          height: 20.h,
                          width: double.infinity,
                        ),
                        SizedBox(height: 8.h),
                        ShimmerWidget(
                          height: 12.h,
                          width: 120.w,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  ShimmerWidget(
                    height: 28.h,
                    width: 70.w,
                    radius: 14.r,
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              // Location shimmer
              ShimmerWidget(
                height: 40.h,
                width: double.infinity,
                radius: 12.r,
              ),
              SizedBox(height: 12.h),

              // Footer shimmer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ShimmerWidget(
                    height: 28.h,
                    width: 100.w,
                    radius: 14.r,
                  ),
                  ShimmerWidget(
                    height: 28.h,
                    width: 100.w,
                    radius: 14.r,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}