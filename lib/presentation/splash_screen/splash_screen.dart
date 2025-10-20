import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../core/app_export.dart';
import './widgets/breathing_logo_widget.dart';
import './widgets/gradient_background_widget.dart';
import './widgets/loading_indicator_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  double _loadingProgress = 0.0;
  // ignore: unused_field
  bool _isInitialized = false; // kept for future init state checks
  bool _hasNetworkTimeout = false;
  bool _reduceMotion = false;
  String _loadingMessage = 'Inicializando...';

  // Mock user data for demonstration
  final Map<String, dynamic> _mockUserData = {
    "userId": "user_12345",
    "isAuthenticated": false,
    "isFirstTime": true,
    "lastSyncDate": "2025-10-15T22:43:13.444839",
    "smokingData": {
      "todayCount": 0,
      "weeklyGoal": 10,
      "quitAttempts": 0,
      "lastCigarette": null,
    },
    "preferences": {
      "notifications": true,
      "darkMode": false,
      "language": "es",
      "reduceMotion": false,
    }
  };

  @override
  void initState() {
    super.initState();
    _checkReduceMotion();
    _initializeApp();
  }

  void _checkReduceMotion() {
    // Check for reduced motion preference
    setState(() {
      _reduceMotion = _mockUserData["preferences"]["reduceMotion"] as bool;
    });
  }

  Future<void> _initializeApp() async {
    try {
      // Set system UI overlay style
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: AppTheme.lightTheme.colorScheme.primary,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: AppTheme.lightTheme.colorScheme.primary,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      );

      // Step 1: Check network connectivity (with timeout)
      await _checkConnectivity();
      _updateProgress(0.2, 'Verificando conexión...');

      // Step 2: Load user preferences
      await _loadUserPreferences();
      _updateProgress(0.4, 'Cargando preferencias...');

      // Step 3: Check authentication status
      await _checkAuthenticationStatus();
      _updateProgress(0.6, 'Verificando sesión...');

      // Step 4: Sync offline data
      await _syncOfflineData();
      _updateProgress(0.8, 'Sincronizando datos...');

      // Step 5: Prepare health calculations
      await _prepareHealthCalculations();
      _updateProgress(1.0, 'Completado');

      // Wait for minimum splash duration
      await Future.delayed(const Duration(milliseconds: 500));

      // Navigate based on user state
      _navigateToNextScreen();
    } catch (e) {
      // Handle initialization errors gracefully
      _handleInitializationError(e);
    }
  }

  Future<void> _checkConnectivity() async {
    try {
      final dynamic result = await Connectivity()
          .checkConnectivity()
          .timeout(const Duration(seconds: 5));

      bool noConnection = true;
      if (result is List<ConnectivityResult>) {
        // No connection if list is empty or all are none
        noConnection = result.isEmpty ||
            result.every((r) => r == ConnectivityResult.none);
      } else if (result is ConnectivityResult) {
        noConnection = result == ConnectivityResult.none;
      }

      if (noConnection) {
        setState(() {
          _hasNetworkTimeout = true;
        });
      }
    } on TimeoutException {
      setState(() {
        _hasNetworkTimeout = true;
      });
    } catch (e) {
      setState(() {
        _hasNetworkTimeout = true;
      });
    }
  }

  Future<void> _loadUserPreferences() async {
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      final prefs = await SharedPreferences.getInstance();

      // Load user preferences from local storage
      final bool? isFirstTime = prefs.getBool('isFirstTime');
      final bool? isAuthenticated = prefs.getBool('isAuthenticated');
      final String? lastSyncDate = prefs.getString('lastSyncDate');

      // Update mock data with actual preferences if available
      if (isFirstTime != null) {
        _mockUserData["isFirstTime"] = isFirstTime;
      }
      if (isAuthenticated != null) {
        _mockUserData["isAuthenticated"] = isAuthenticated;
      }
      if (lastSyncDate != null) {
        _mockUserData["lastSyncDate"] = lastSyncDate;
      }
    } catch (e) {
      // Use default preferences if loading fails
      debugPrint('Error loading preferences: $e');
    }
  }

  Future<void> _checkAuthenticationStatus() async {
    await Future.delayed(const Duration(milliseconds: 400));

    // Simulate authentication check
    // In real app, this would validate tokens, check session expiry, etc.
    final bool isAuthenticated = _mockUserData["isAuthenticated"] as bool;

    if (isAuthenticated) {
      // Validate session token (mock)
      await Future.delayed(const Duration(milliseconds: 200));
    }
  }

  Future<void> _syncOfflineData() async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (!_hasNetworkTimeout) {
      // Simulate syncing offline smoking data
      // ignore: unused_local_variable
      final Map<String, dynamic> smokingData =
          _mockUserData["smokingData"] as Map<String, dynamic>;

      // Mock sync operations
      await Future.delayed(const Duration(milliseconds: 300));

      // Update last sync date
      _mockUserData["lastSyncDate"] = DateTime.now().toIso8601String();

      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
            'lastSyncDate', _mockUserData["lastSyncDate"] as String);
      } catch (e) {
        debugPrint('Error saving sync date: $e');
      }
    }
  }

  Future<void> _prepareHealthCalculations() async {
    await Future.delayed(const Duration(milliseconds: 300));

    // Simulate preparing health improvement calculations
  // Use mock for demonstrating background work
  final Map<String, dynamic> smokingData =
    _mockUserData["smokingData"] as Map<String, dynamic>;
  // Simple no-op based on mock to avoid unused warnings
  if ((smokingData["todayCount"] as int) >= 0 &&
    (smokingData["weeklyGoal"] as int) >= 0) {
    // simulated
  }

    // Calculate progress and health metrics
    await Future.delayed(const Duration(milliseconds: 200));
  }

  void _updateProgress(double progress, String message) {
    if (mounted) {
      setState(() {
        _loadingProgress = progress;
        _loadingMessage = message;
      });
    }
  }

  void _navigateToNextScreen() {
    if (!mounted) return;

    final bool isAuthenticated = _mockUserData["isAuthenticated"] as bool;
    final bool isFirstTime = _mockUserData["isFirstTime"] as bool;

    // Determine navigation path
    String nextRoute;

    if (isAuthenticated) {
      // Authenticated users go to dashboard
      nextRoute = '/dashboard-home';
    } else if (isFirstTime) {
      // New users see onboarding (using settings as placeholder)
      nextRoute = '/settings-profile';
    } else {
      // Returning non-authenticated users see login (using craving management as placeholder)
      nextRoute = '/craving-management';
    }

    // Navigate with fade transition
    Navigator.pushReplacementNamed(context, nextRoute);
  }

  void _handleInitializationError(dynamic error) {
    debugPrint('Initialization error: $error');

    // Show error state or navigate to offline mode
    if (mounted) {
      setState(() {
        _loadingProgress = 1.0;
        _loadingMessage = 'Error de inicialización';
      });

      // Navigate to dashboard after error delay
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/dashboard-home');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Background gradient
            const GradientBackgroundWidget(),

            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Breathing logo animation
                  BreathingLogoWidget(
                    reduceMotion: _reduceMotion,
                  ),

                  SizedBox(height: 8.h),

                  // App title
                  Text(
                    'SmokeTracker',
                    style:
                        AppTheme.lightTheme.textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp,
                    ),
                  ),

                  SizedBox(height: 1.h),

                  // Subtitle
                  Text(
                    'Tu compañero para una vida sin humo',
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 14.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 12.h),

                  // Loading indicator
                  LoadingIndicatorWidget(
                    progress: _loadingProgress,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    _loadingMessage,
                    style: AppTheme.lightTheme.textTheme.bodyMedium
                        ?.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Network timeout indicator
            if (_hasNetworkTimeout)
              Positioned(
                bottom: 8.h,
                left: 4.w,
                right: 4.w,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 2.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'wifi_off',
                        color: Colors.white,
                        size: 5.w,
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Text(
                          'Modo sin conexión activado',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: Colors.white,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}