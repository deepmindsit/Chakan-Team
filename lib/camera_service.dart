import 'package:camera/camera.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class CameraService {
  late final List<CameraDescription> _cameras;

  Future<void> init() async {
    _cameras = await availableCameras();
  }

  CameraDescription get defaultCamera => _cameras.first;

  CameraDescription get frontCamera =>
      _cameras.firstWhere((cam) => cam.lensDirection == CameraLensDirection.front);

  CameraDescription get backCamera =>
      _cameras.firstWhere((cam) => cam.lensDirection == CameraLensDirection.back);
}
