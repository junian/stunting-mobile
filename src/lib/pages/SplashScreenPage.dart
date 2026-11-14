import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:growthtracker/controller/AuthController.dart';
import 'package:growthtracker/theme/app_theme.dart';
import 'package:growthtracker/widget/BottomNavbar.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  final authController = Get.put(AuthController());
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _boot();
  }

  Future<void> _boot() async {
    // The splash is a brand moment, not a loading screen: local data loads in
    // milliseconds, so a short, fixed beat keeps the transition calm.
    await Future.wait([
      authController.checkAuthentication(),
      Future<void>.delayed(const Duration(milliseconds: 850)),
    ]);
    if (!mounted) return;
    setState(() => _ready = true);
    await Future<void>.delayed(const Duration(milliseconds: 120));
    if (!mounted) return;
    Get.offAll(
      () => const BottomNavbar(),
      transition: Transition.fadeIn,
      duration: const Duration(milliseconds: 320),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF3157D5),
        body: Container(
          decoration: const BoxDecoration(gradient: AppColors.splashGradient),
          child: Stack(
            children: [
              Positioned(
                top: -size.width * 0.3,
                right: -size.width * 0.35,
                child: _Bubble(size: size.width * 0.9, opacity: 0.08),
              ),
              Positioned(
                bottom: -size.height * 0.15,
                left: -size.width * 0.4,
                child: _Bubble(size: size.width * 1.1, opacity: 0.10),
              ),
              Positioned(
                top: size.height * 0.22,
                left: size.width * 0.12,
                child: _Bubble(size: 26, opacity: 0.16),
              ),
              Positioned(
                top: size.height * 0.32,
                right: size.width * 0.16,
                child: _Bubble(size: 12, opacity: 0.22),
              ),
              SafeArea(
                child: Column(
                  children: [
                    const Spacer(flex: 5),
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 700),
                      curve: Curves.easeOutBack,
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value.clamp(0.0, 1.0),
                          child: Transform.scale(
                            scale: 0.82 + 0.18 * value,
                            child: child,
                          ),
                        );
                      },
                      child: Container(
                        width: 132,
                        height: 132,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(38),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF06265C)
                                  .withValues(alpha: 0.28),
                              blurRadius: 50,
                              offset: const Offset(0, 24),
                            ),
                          ],
                        ),
                        child: Image.asset('images/logo.png'),
                      ),
                    ),
                    const SizedBox(height: 30),
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeOut,
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value.clamp(0.0, 1.0),
                          child: Transform.translate(
                            offset: Offset(0, 16 * (1 - value)),
                            child: child,
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Text(
                            'STANTAPP',
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 3.2,
                                  fontSize: 30,
                                ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'app_tagline'.tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.2,
                              height: 1.5,
                              color: Colors.white.withValues(alpha: 0.82),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(flex: 6),
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: _ready ? 0 : 1,
                      child: SizedBox(
                        width: 26,
                        height: 26,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.4,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white.withValues(alpha: 0.9),
                          ),
                          backgroundColor: Colors.white.withValues(alpha: 0.18),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'version'.tr,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.55),
                      ),
                    ),
                    const SizedBox(height: 18),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.size, required this.opacity});

  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: opacity),
      ),
    );
  }
}
