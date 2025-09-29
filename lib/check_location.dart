
import 'package:chakan_team/utils/exported_path.dart';

import 'package:map_camera_flutter/map_camera_flutter.dart';
import 'camera_service.dart';


class CapturePage extends StatelessWidget {
  const CapturePage({super.key});

  @override
  Widget build(BuildContext context) {
    final camera = getIt<CameraService>().backCamera;

    return Scaffold(
      appBar: AppBar(title: Text('Capture with Map')),
      body: MapCameraLocation(
        camera: camera,
        onImageCaptured: (data) {
          Get.snackbar('Captured', 'Path: ${data.imagePath}');
          // print('Location: ${data.latitude}, ${data.longitude}');
        },
      ),
    );
  }
}
