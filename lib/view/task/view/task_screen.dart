import 'package:chakan_team/utils/exported_path.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final controller = getIt<TaskController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getTask();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Tasks',
        showBackButton: false,
        titleSpacing: null,
      ),
      floatingActionButton:
          getIt<UserService>().rollId.value != '5'
              ? FloatingActionButton(
                backgroundColor: primaryColor,
                mini: true,
                elevation: 0,
                shape: CircleBorder(),
                onPressed: () => Get.toNamed(Routes.addTask),
                child: Icon(Icons.add, color: Colors.white),
              )
              : SizedBox.shrink(),
      body: Obx(() {
        final task = controller.taskList;

        if (controller.isLoading.isTrue) {
          // return LoadingWidget(color: primaryColor);
          return taskShimmer();
        }

        if (task.isEmpty) {
          return const Center(child: Text("No task available."));
        }

        return LiveList.options(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          options: LiveOptions(
            delay: Duration.zero,
            showItemInterval: Duration(milliseconds: 100),
            showItemDuration: Duration(milliseconds: 250),
            reAnimateOnVisibility: false,
          ),
          itemCount: task.length,
          itemBuilder: (context, index, animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(0, 0.1),
                  end: Offset.zero,
                ).animate(animation),
                child: TaskCard(
                  data: task[index],
                  onTap:
                      () => Get.toNamed(
                        Routes.taskDetails,
                        arguments: {'id': task[index]['id'].toString()},
                      ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

Widget taskShimmer() {
  return ListView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    itemCount: 6,
    itemBuilder: (context, index) => TaskCardShimmer(),
  );
}

class TaskCardShimmer extends StatelessWidget {
  const TaskCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: 180.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
          padding: EdgeInsets.all(16.w).copyWith(left: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(width: 150.w, height: 16.h, color: Colors.white),
                  Container(width: 60.w, height: 16.h, color: Colors.white),
                ],
              ),

              SizedBox(height: 8.h),

              /// Code
              Container(width: 100.w, height: 14.h, color: Colors.white),

              SizedBox(height: 16.h),

              /// Assigned by
              Row(
                children: [
                  Icon(
                    HugeIcons.strokeRoundedUser03,
                    size: 18.sp,
                    color: Colors.white,
                  ),
                  SizedBox(width: 6.w),
                  Container(width: 120.w, height: 14.h, color: Colors.white),
                ],
              ),

              SizedBox(height: 16.h),

              /// Assigned date & Deadline
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(width: 100.w, height: 14.h, color: Colors.white),
                  Container(width: 100.w, height: 14.h, color: Colors.white),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
