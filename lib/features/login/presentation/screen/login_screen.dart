import 'dart:async';

import 'package:go_router/go_router.dart';
import 'package:fin_tracker/core/theme/app_colors.dart';
import 'package:fin_tracker/shared/utils/widgets/fin_tracker_text_form_field.dart';
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
  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _passwordController =
      TextEditingController();

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
    final screenHeight = MediaQuery.of(context).size.height;

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
                  // Email Field
                  FinTrackerTextFormField(
                    controller: _emailController,
                    hintText: "Enter your email address",
                    obscureTextValue: false,
                    textInputType: TextInputType.text,
                  ),
                  const SizedBox(height: 24),
                  FinTrackerTextFormField(
                    controller: _passwordController,
                    hintText: "Enter your password",
                    obscureTextValue: true,
                    textInputType: TextInputType.visiblePassword,
                  ),
                  const SizedBox(height: 24),
                  // Login Button or Loading
                  state.maybeWhen(
                    loading: () => Container(
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.green, AppColors.darkGreen],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.green.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.white,
                          strokeWidth: 3,
                        ),
                      ),
                    ),
                    orElse: () => Container(
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.green, AppColors.darkGreen],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.green.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => {
                            ref
                                .read(loginViewModelProvider.notifier)
                                .onEvent(
                                  ValidateValues(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  ),
                                ),
                          },
                          child: const Center(
                            child: Text(
                              "Login",
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
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
