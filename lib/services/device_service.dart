import 'package:flutter/services.dart';

class DeviceService {
  static const _channel = MethodChannel('mf_customer/device');
  Future<Uint8List?> pickPhoto() =>
      _channel.invokeMethod<Uint8List>('pickPhoto');
  Future<String?> transcribe(bool hindi) => _channel.invokeMethod<String>(
    'transcribe',
    {'language': hindi ? 'hi-IN' : 'en-IN'},
  );
}
