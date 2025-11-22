import 'dart:async';

import 'package:fin_tracker/features/login/presentation/state/login_state/login_state.dart';
import 'package:go_router/go_router.dart';
import 'package:fin_tracker/core/theme/app_colors.dart';
import 'package:fin_tracker/core/theme/app_dimens.dart';
import 'package:fin_tracker/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/login_provider.dart';
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.spacing24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: AppDimens.spacing60),

                // Logo/App Icon Section
                Container(
                  width: AppDimens.logoSize,
                  height: AppDimens.logoSize,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(AppDimens.opacity10),
                        blurRadius: AppDimens.blurRadius20,
                        offset: const Offset(0, AppDimens.offsetY8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet,
                    size: AppDimens.iconSize60,
                    color: AppColors.deepGreen,
                  ),
                ),

                const SizedBox(height: AppDimens.spacing32),

                // App Title
                const Text(
                  AppStrings.appName,
                  style: TextStyle(
                    fontSize: AppDimens.fontSize32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.deepGreen,
                  ),
                ),

                const SizedBox(height: AppDimens.spacing8),

                // Subtitle
                Text(
                  AppStrings.appSubtitle,
                  style: TextStyle(
                    fontSize: AppDimens.fontSize16,
                    color: AppColors.deepGreen.withOpacity(AppDimens.opacity70),
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: AppDimens.spacing48),

                // Welcome Message
                Container(
                  padding: const EdgeInsets.all(AppDimens.spacing24),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppDimens.radius16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(AppDimens.opacity10),
                        blurRadius: AppDimens.blurRadius10,
                        offset: const Offset(0, AppDimens.offsetY4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        AppStrings.welcomeBack,
                        style: TextStyle(
                          fontSize: AppDimens.fontSize24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.deepGreen,
                        ),
                      ),
                      const SizedBox(height: AppDimens.spacing8),
                      Text(
                        AppStrings.loginSubtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: AppDimens.fontSize14,
                          color: AppColors.deepGreen.withOpacity(
                            AppDimens.opacity70,
                          ),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppDimens.spacing32),

                // Google Sign In Button
                Container(
                  width: double.infinity,
                  height: AppDimens.buttonHeight,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppDimens.radius16),
                    border: Border.all(color: AppColors.lightGrey, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(AppDimens.opacity10),
                        blurRadius: AppDimens.blurRadius12,
                        offset: const Offset(0, AppDimens.offsetY6),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(AppDimens.radius16),
                      onTap: state.maybeWhen(
                        loading: () => null, // Disable button when loading
                        orElse: () => () {
                          ref
                              .read(loginViewModelProvider.notifier)
                              .onEvent(GoogleSignInEvent());
                        },
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimens.spacing20,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Google Logo Placeholder (you can replace with actual Google logo)
                            Container(
                              width: AppDimens.googleLogoSize,
                              height: AppDimens.googleLogoSize,
                              decoration: BoxDecoration(
                                color: AppColors.deepGreen.withOpacity(
                                  AppDimens.opacity10,
                                ),
                                borderRadius: BorderRadius.circular(
                                  AppDimens.radius4,
                                ),
                              ),
                              child: const Icon(
                                Icons.g_mobiledata,
                                size: AppDimens.iconSize20,
                                color: AppColors.deepGreen,
                              ),
                            ),
                            const SizedBox(width: AppDimens.spacing12),
                            state.maybeWhen(
                              loading: () => const SizedBox(
                                width: AppDimens.iconSize20,
                                height: AppDimens.iconSize20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.deepGreen,
                                  ),
                                ),
                              ),
                              orElse: () => const Text(
                                AppStrings.continueWithGoogle,
                                style: TextStyle(
                                  color: AppColors.deepGreen,
                                  fontSize: AppDimens.fontSize16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppDimens.spacing24),

                // Terms and Privacy
                Text(
                  AppStrings.termsAndPrivacy,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppDimens.fontSize12,
                    color: AppColors.deepGreen.withOpacity(AppDimens.opacity50),
                  ),
                ),

                const SizedBox(height: AppDimens.spacing32),

                // Error Message Display
                state.maybeWhen(
                  miscError: (errorMessage) => Container(
                    padding: const EdgeInsets.all(AppDimens.spacing16),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(AppDimens.opacity10),
                      borderRadius: BorderRadius.circular(AppDimens.radius12),
                      border: Border.all(
                        color: Colors.red.withOpacity(AppDimens.opacity30),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: AppDimens.iconSize20,
                        ),
                        const SizedBox(width: AppDimens.spacing12),
                        Expanded(
                          child: Text(
                            errorMessage,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: AppDimens.fontSize14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  orElse: () => const SizedBox.shrink(),
                ),

                const SizedBox(height: AppDimens.spacing24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(AppDimens.spacing24),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppDimens.radius20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: AppDimens.bottomSheetHandleWidth,
              height: AppDimens.bottomSheetHandleHeight,
              decoration: BoxDecoration(
                color: AppColors.oliveGreen,
                borderRadius: BorderRadius.circular(AppDimens.radius2),
              ),
            ),
            const SizedBox(height: AppDimens.spacing20),
            const Text(
              AppStrings.bottomSheetDisplayed,
              style: TextStyle(
                fontSize: AppDimens.fontSize16,
                color: AppColors.deepGreen,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: AppDimens.spacing20),
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
