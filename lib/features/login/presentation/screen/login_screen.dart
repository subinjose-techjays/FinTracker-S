import 'dart:async';

import 'package:go_router/go_router.dart';
import 'package:fin_tracker/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/providers.dart';
import '../event/login_events.dart';
import '../state/login_state/login_effect.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late final StreamSubscription<LoginEffect> _effectSubscription;

  @override
  void initState() {
    super.initState();
    final notifier = ref.read(loginViewModelProvider.notifier);
    _effectSubscription = notifier.effectStream.listen((effect) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (effect is ShowBottomSheetEffect) {
          _openBottomSheet();
        } else if (effect is NavigateToDashBoard) {
          _navigateToDashBoard();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  // Google Sign In Button
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.lightGrey),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: state.maybeWhen(
                          loading: () => null, // Disable button when loading
                          orElse: () => () {
                            ref
                                .read(loginViewModelProvider.notifier)
                                .onEvent(GoogleSignInEvent());
                          },
                        ),
                        child: const Center(
                          child: Text(
                            "Sign in with Google",
                            style: TextStyle(
                              color: AppColors.deepGreen,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.oliveGreen,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "bottom_sheet_displayed",
              style: TextStyle(
                fontSize: 16,
                color: AppColors.deepGreen,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _navigateToDashBoard() {
    context.go('/dashboard');
  }

  @override
  void dispose() {
    _effectSubscription.cancel();
    super.dispose();
  }
}
