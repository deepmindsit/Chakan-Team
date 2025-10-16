//system
export 'package:flutter/material.dart';
export 'dart:async';
export 'dart:convert';
export 'package:flutter/services.dart';

//screens
export 'package:chakan_team/view/onboarding/view/splash_screen.dart';
export 'package:chakan_team/view/onboarding/view/login.dart';
export 'package:chakan_team/view/navigation/view/navigation_screen.dart';
export 'package:chakan_team/view/home/view/home_screen.dart';
export 'package:chakan_team/view/home/widget/add_file.dart';
export 'package:chakan_team/view/complaint/view/complaint.dart';
export 'package:chakan_team/view/task/view/task_screen.dart';
export 'package:chakan_team/view/knowledge/view/kms.dart';
export 'package:chakan_team/view/complaint/widget/complaint_details.dart';
export 'package:chakan_team/view/complaint/widget/update_complaint.dart';
export 'package:chakan_team/view/dashboard/widget/edit_profile.dart';
export 'package:chakan_team/view/home/widget/file_details.dart';
export 'package:chakan_team/view/task/widget/add_task.dart';
export 'package:chakan_team/view/task/widget/task_details.dart';
export 'package:chakan_team/view/dashboard/view/dashboard.dart';
export 'package:chakan_team/view/task/widget/update_task.dart';
export 'package:chakan_team/common/delete_account.dart';
export 'package:chakan_team/common/notification_list.dart';
export 'package:chakan_team/view/dashboard/widget/help_and_support.dart';

//widget
export 'package:chakan_team/utils/image_path.dart';
export 'package:chakan_team/routes/app_routes.dart';
export 'package:chakan_team/routes/routes_names.dart';
export 'package:chakan_team/network/all_url.dart';
export 'package:chakan_team/utils/color.dart';
export 'package:chakan_team/common/helper.dart';
export 'package:chakan_team/view/knowledge/widget/article.dart';
export 'package:chakan_team/view/knowledge/widget/knowledge.dart';
export 'package:chakan_team/view/complaint/widget/complaint_card.dart';
export 'package:chakan_team/component/custom_card.dart';
export 'package:chakan_team/component/custom_attachment.dart';
export 'package:chakan_team/component/custom_message_input.dart';
export 'package:chakan_team/component/custom_update_history.dart';
export 'package:chakan_team/di/injection.dart';
export 'package:chakan_team/di/injection.config.dart';
export 'package:chakan_team/network/api_service.dart';
export 'package:chakan_team/network/get_dio.dart';
export 'package:chakan_team/utils/initial_bindings.dart';
export 'package:chakan_team/common/documents_preparation.dart';
export 'package:chakan_team/utils/screenutil_config.dart';
export 'package:chakan_team/common/policy_data.dart';
export 'package:chakan_team/common/notification_service.dart';
export 'package:chakan_team/view/home/widget/file_card.dart';
export 'package:chakan_team/view/home/widget/update_file.dart';
export 'package:chakan_team/view/dashboard/widget/dashboard_stats_card.dart';
export 'package:chakan_team/component/error_box.dart';
export 'package:chakan_team/view/task/widget/task_filter.dart';
export 'package:chakan_team/view/home/widget/file_filter.dart';


//component
export 'package:chakan_team/component/custom_textfield.dart';
export 'package:chakan_team/component/custom_text.dart';
export 'package:chakan_team/component/custom_appbar.dart';
export 'package:chakan_team/component/custom_dropdown_normal.dart';
export 'package:chakan_team/component/custom_searchfield.dart';
export 'package:chakan_team/view/dashboard/widget/custom_drawer.dart';
export 'package:chakan_team/view/task/widget/task_card.dart';
export 'package:chakan_team/component/custom_loader.dart';
export 'package:chakan_team/network/local_storage.dart';
export 'package:chakan_team/component/custom_button.dart';
export 'package:chakan_team/component/custom_file_picker.dart';
export 'package:chakan_team/component/dropdown_search_component.dart';
export 'package:chakan_team/component/custom_attachment_preview.dart';
export 'package:chakan_team/common/custom_translated_text.dart';

//controller
export 'package:chakan_team/view/onboarding/controller/onboarding_controller.dart';
export 'package:chakan_team/view/navigation/controller/navigation_controller.dart';
export 'package:chakan_team/view/dashboard/controller/dashboard_controller.dart';
export 'package:chakan_team/view/complaint/controller/complaint_controller.dart';
export 'package:chakan_team/view/task/controller/task_controller.dart';
export 'package:chakan_team/network/network_controller.dart';
export 'package:chakan_team/view/onboarding/controller/user_controller.dart';
export 'package:chakan_team/view/dashboard/controller/profile_controller.dart';
export 'package:chakan_team/view/home/controller/add_file_controller.dart';
export 'package:chakan_team/view/knowledge/controller/kms_controller.dart';
export 'package:chakan_team/view/dashboard/controller/update_firebase_token.dart';
export 'package:chakan_team/common/update_app.dart';
export 'package:chakan_team/view/dashboard/controller/notification_controller.dart';
export 'package:chakan_team/utils/translate_controller.dart';


//plugins
export 'package:get/get.dart';
export 'package:flutter_screenutil/flutter_screenutil.dart';
export 'package:hugeicons/hugeicons.dart';
export 'package:file_picker/file_picker.dart';
export 'package:fl_chart/fl_chart.dart';
export 'package:fluttertoast/fluttertoast.dart';
export 'package:get_it/get_it.dart';
export 'package:injectable/injectable.dart';
export 'package:shared_preferences/shared_preferences.dart';
export 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
export 'package:internet_connection_checker/internet_connection_checker.dart';
export 'package:shimmer/shimmer.dart';
export 'package:url_launcher/url_launcher.dart';
export 'package:webview_flutter/webview_flutter.dart';
export 'package:flutter_local_notifications/flutter_local_notifications.dart';
export 'package:firebase_core/firebase_core.dart';
export 'package:firebase_messaging/firebase_messaging.dart';
export 'package:open_filex/open_filex.dart';
export 'package:flutter_file_downloader/flutter_file_downloader.dart';
export 'package:auto_animated/auto_animated.dart';
export 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
export 'package:widget_zoom/widget_zoom.dart';
export 'package:url_launcher/url_launcher_string.dart';
export 'package:package_info_plus/package_info_plus.dart';
export 'package:icons_plus/icons_plus.dart';
export 'package:dotted_border/dotted_border.dart';