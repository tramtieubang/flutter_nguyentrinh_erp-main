import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/foundation.dart';

enum BiometricResult {
  success,
  failed,
  notAvailable,
}

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> canCheckBiometric() async {
    try {
      final supported = await _auth.isDeviceSupported();
      final canCheck = await _auth.canCheckBiometrics;

      debugPrint('🔐 supported=$supported, canCheck=$canCheck');

      return supported && canCheck;
    } catch (e) {
      debugPrint('❌ canCheckBiometric error: $e');
      return false;
    }
  }

  Future<BiometricResult> authenticate() async {
    debugPrint('👉 authenticate() CALLED');

    try {
      final canCheck = await canCheckBiometric();
      if (!canCheck) {
        debugPrint('❌ Biometric NOT AVAILABLE');
        return BiometricResult.notAvailable;
      }

      final success = await _auth.authenticate(
        localizedReason: 'Xác thực để đăng nhập',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: false, // MIUI bắt buộc
          useErrorDialogs: true,
        ),
      );

      debugPrint('✅ authenticate result = $success');

      return success
          ? BiometricResult.success
          : BiometricResult.failed;
    } on PlatformException catch (e) {
      debugPrint('❌ PlatformException: ${e.code} - ${e.message}');
      return BiometricResult.failed;
    }
  }
}
