import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLockScreen extends StatefulWidget {
  final Widget child;

  const AppLockScreen({super.key, required this.child});

  @override
  _AppLockScreenState createState() => _AppLockScreenState();
}

class _AppLockScreenState extends State<AppLockScreen>
    with WidgetsBindingObserver {
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _isLocked = true;
  bool _isSupported = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkAppLockStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkIfShouldLock();
    }
  }

  Future<void> _checkAppLockStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isEnabled = prefs.getBool('app_lock_enabled') ?? false;

    if (!isEnabled) {
      setState(() {
        _isLocked = false;
        _isLoading = false;
      });
      return;
    }

    // Check if biometric auth is available
    final canAuthenticateWithBiometrics = await _localAuth.canCheckBiometrics;
    final availableBiometrics = await _localAuth.getAvailableBiometrics();

    setState(() {
      _isSupported =
          canAuthenticateWithBiometrics && availableBiometrics.isNotEmpty;
      _isLoading = false;
    });

    if (_isSupported) {
      await _authenticate();
    } else {
      // Fall back to PIN or disable lock
      setState(() => _isLocked = false);
    }
  }

  Future<void> _checkIfShouldLock() async {
    final prefs = await SharedPreferences.getInstance();
    final isEnabled = prefs.getBool('app_lock_enabled') ?? false;

    if (!isEnabled) return;

    final lastActive = prefs.getInt('last_active') ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;
    final inactiveDuration = now - lastActive;

    // Lock after 30 seconds of inactivity
    if (inactiveDuration > 30000) {
      setState(() => _isLocked = true);
      if (_isSupported) {
        await _authenticate();
      }
    }
  }

  Future<void> _authenticate() async {
    try {
      final authenticated = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to access Dracula',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );

      if (authenticated) {
        setState(() => _isLocked = false);
        _updateLastActive();
      }
    } catch (e) {
      // Authentication failed or cancelled
      // Keep locked or show error
    }
  }

  Future<void> _updateLastActive() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('last_active', DateTime.now().millisecondsSinceEpoch);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!_isLocked) {
      return widget.child;
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.lock,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 24),
            const Text(
              'Dracula is locked',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Use biometric authentication to unlock',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _authenticate,
              child: const Text('Unlock'),
            ),
          ],
        ),
      ),
    );
  }
}
