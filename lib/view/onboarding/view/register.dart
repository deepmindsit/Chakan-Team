import 'package:chakan_team/utils/exported_path.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final controller = getIt<OnboardingController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Form(
          key: controller.registerFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Get.height * 0.1.h),
              Center(
                child: Image.asset(Images.fevicon, height: 180.h, width: 180.w),
              ),
              SizedBox(height: 20.h),
              Center(
                child: CustomText(
                  title: 'Sign Up',
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              Center(
                child: CustomText(
                  title: 'Please enter your details to proceed further.',
                  fontSize: 14.sp,
                  maxLines: 2,
                  color: primaryGrey,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 30.h),
              _buildLabel('Username'.tr),
              _buildEmailField(),
              SizedBox(height: 16.h),
              _buildLabel('Mobile'.tr),
              _buildNumberField(),
              SizedBox(height: 16.h),

              _buildLabel('Password'.tr),
              _buildPasswordField(),
              SizedBox(height: 24.h),
              buildLoginButton(),
              SizedBox(height: 40.h),
              _termsAndCdn(),
            ],
          ),
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

  Widget _buildEmailField() {
    return buildTextField(
      prefixIcon: HugeIcon(
        icon: HugeIcons.strokeRoundedUser,
        color: primaryGrey,
      ),
      controller: controller.regUsernameController,
      keyboardType: TextInputType.text,
      validator:
          (value) => value!.trim().isEmpty ? 'Please enter username'.tr : null,
      hintText: 'Enter your username'.tr,
    );
  }

  Widget _buildNumberField() {
    return buildTextField(
      prefixIcon: HugeIcon(
        icon: HugeIcons.strokeRoundedCall02,
        color: primaryGrey,
      ),

      controller: controller.numberController,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your mobile number'.tr;
        } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value.trim())) {
          return 'Please enter a valid 10-digit mobile number'.tr;
        }
        return null;
      },
      hintText: 'Enter your number'.tr,
    );
  }

  Widget _buildPasswordField() {
    return Obx(
      () => buildTextField(
        obscureText: controller.isObscure.value,
        prefixIcon: HugeIcon(
          icon: HugeIcons.strokeRoundedLockPassword,
          color: primaryGrey,
        ),
        controller: controller.regPasswordController,
        validator:
            (value) =>
                value!.trim().isEmpty ? 'Please enter password'.tr : null,
        hintText: 'Enter password'.tr,
        suffixIcon: GestureDetector(
          onTap: () {
            controller.isObscure.value = !controller.isObscure.value;
          },
          child: HugeIcon(
            icon:
                controller.isObscure.isTrue
                    ? HugeIcons.strokeRoundedViewOff
                    : HugeIcons.strokeRoundedView,
            color: primaryGrey,
          ),
        ),
      ),
    );
  }

  Widget buildLoginButton() {
    return Center(
      child: Obx(
        () => ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 12.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          onPressed:
              controller.isLoading.isTrue
                  ? null
                  : () async {
                    if (controller.registerFormKey.currentState!.validate()) {
                      await controller.register();
                    }
                  },
          child:
              controller.isLoading.isTrue
                  ? SizedBox(
                    height: 24.h,
                    width: 24.w,
                    child: LoadingWidget(color: Colors.white),
                  )
                  : Text(
                    'Register',
                    style: TextStyle(fontSize: 16.sp, color: Colors.white),
                  ),
        ),
      ),
    );
  }

  Widget _termsAndCdn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => Get.offAllNamed(Routes.login),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                title: "Already have account?".tr,
                fontSize: Get.width * 0.035.sp,
                color: primaryGrey,
                fontWeight: FontWeight.w500,
              ),
              GestureDetector(
                child: CustomText(
                  title: "  Login".tr,
                  fontSize: Get.width * 0.035.sp,
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        CustomText(
          title: "By logging in you accept our ".tr,
          fontSize: Get.width * 0.035.sp,
          maxLines: 2,
          color: Theme.of(Get.context!).textTheme.titleMedium!.color,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              child: CustomText(
                title: "Terms & Conditions ".tr,
                fontSize: Get.width * 0.035.sp,
                color: primaryColor,
                fontWeight: FontWeight.w500,
              ),
              onTap: () {
                Get.to(() => const PolicyData(slug: 'terms-and-condition'));
              },
            ),
            CustomText(
              title: "and ",
              fontSize: Get.width * 0.035.sp,
              color: Theme.of(Get.context!).textTheme.titleMedium!.color,
            ),
            GestureDetector(
              child: CustomText(
                title: "Privacy Policy".tr,
                fontSize: Get.width * 0.035.sp,
                color: primaryColor,
                fontWeight: FontWeight.w500,
              ),
              onTap: () {
                Get.to(() => const PolicyData(slug: 'privacy-policy'));
                // controller.launchPrivacyPolicyURL();
              },
            ),
          ],
        ),
      ],
    );
  }
}
