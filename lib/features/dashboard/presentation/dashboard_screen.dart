import 'package:firebase_auth/firebase_auth.dart';
import 'package:fin_tracker/core/theme/app_colors.dart';
import 'package:fin_tracker/core/theme/app_dimens.dart';
import 'package:fin_tracker/core/constants/app_strings.dart';
import 'package:fin_tracker/features/login/di/login_provider.dart';
import 'package:fin_tracker/features/dashboard/di/dashboard_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsyncValue = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        backgroundColor: AppColors.deepGreen,
        title: const Text(
          AppStrings.dashboardTitle,
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            onPressed: () => _showSignOutDialog(context, ref),
            icon: const Icon(Icons.logout, color: AppColors.white),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/chat'),
        backgroundColor: AppColors.deepGreen,
        child: const Icon(Icons.chat, color: AppColors.white),
      ),
      body: userAsyncValue.when(
        data: (user) {
          if (user == null) {
            return const Center(child: Text(AppStrings.noUserLoggedIn));
          }
          return _buildUserProfile(context, user);
        },
        loading: () => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.deepGreen),
          ),
        ),
        error: (error, stack) =>
            Center(child: Text('${AppStrings.errorLoadingUser}$error')),
      ),
    );
  }

  Widget _buildUserProfile(BuildContext context, User user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimens.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Section
          Container(
            width: double.infinity,
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Picture
                CircleAvatar(
                  radius: AppDimens.radius50,
                  backgroundImage: user.photoURL != null
                      ? NetworkImage(user.photoURL!)
                      : null,
                  backgroundColor: AppColors.oliveGreen,
                  child: user.photoURL == null
                      ? Text(
                          user.displayName?.isNotEmpty == true
                              ? user.displayName![0].toUpperCase()
                              : user.email?[0].toUpperCase() ?? 'U',
                          style: const TextStyle(
                            fontSize: AppDimens.fontSize32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        )
                      : null,
                ),
                const SizedBox(height: AppDimens.spacing16),
                Text(
                  user.displayName ?? AppStrings.welcomeDefault,
                  style: const TextStyle(
                    fontSize: AppDimens.fontSize24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.deepGreen,
                  ),
                ),
                const SizedBox(height: AppDimens.spacing8),
                Text(
                  AppStrings.financialTracker,
                  style: TextStyle(
                    fontSize: AppDimens.fontSize16,
                    color: AppColors.deepGreen.withOpacity(AppDimens.opacity70),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppDimens.spacing24),

          // Account Information Section
          const Text(
            AppStrings.accountInformation,
            style: TextStyle(
              fontSize: AppDimens.fontSize20,
              fontWeight: FontWeight.bold,
              color: AppColors.deepGreen,
            ),
          ),

          const SizedBox(height: AppDimens.spacing16),

          // User Details Cards
          _buildInfoCard(
            AppStrings.emailLabel,
            user.email ?? AppStrings.notProvided,
            Icons.email,
          ),

          const SizedBox(height: AppDimens.spacing12),

          _buildInfoCard(
            AppStrings.userIdLabel,
            user.uid,
            Icons.account_circle,
          ),

          const SizedBox(height: AppDimens.spacing12),

          _buildInfoCard(
            AppStrings.emailVerifiedLabel,
            user.emailVerified ? AppStrings.yes : AppStrings.no,
            user.emailVerified ? Icons.verified : Icons.verified_outlined,
            iconColor: user.emailVerified ? AppColors.deepGreen : Colors.orange,
          ),

          const SizedBox(height: AppDimens.spacing12),

          _buildInfoCard(
            AppStrings.accountCreatedLabel,
            _formatDate(user.metadata.creationTime),
            Icons.calendar_today,
          ),

          const SizedBox(height: AppDimens.spacing12),

          _buildInfoCard(
            AppStrings.lastSignInLabel,
            _formatDate(user.metadata.lastSignInTime),
            Icons.access_time,
          ),

          const SizedBox(height: AppDimens.spacing24),

          // Provider Information
          if (user.providerData.isNotEmpty) ...[
            const Text(
              AppStrings.authProviderLabel,
              style: TextStyle(
                fontSize: AppDimens.fontSize20,
                fontWeight: FontWeight.bold,
                color: AppColors.deepGreen,
              ),
            ),
            const SizedBox(height: AppDimens.spacing16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimens.spacing16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppDimens.radius12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(AppDimens.opacity10),
                    blurRadius: AppDimens.blurRadius8,
                    offset: const Offset(0, AppDimens.offsetY2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.account_balance,
                    color: AppColors.deepGreen,
                    size: AppDimens.iconSize24,
                  ),
                  const SizedBox(width: AppDimens.spacing12),
                  Expanded(
                    child: Text(
                      user.providerData.first.providerId == 'google.com'
                          ? AppStrings.googleAccount
                          : user.providerData.first.providerId,
                      style: const TextStyle(
                        fontSize: AppDimens.fontSize16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.deepGreen,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    String title,
    String value,
    IconData icon, {
    Color? iconColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimens.spacing16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimens.radius12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: AppDimens.blurRadius8,
            offset: const Offset(0, AppDimens.offsetY2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: iconColor ?? AppColors.deepGreen,
            size: AppDimens.iconSize24,
          ),
          const SizedBox(width: AppDimens.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: AppDimens.fontSize14,
                    color: AppColors.deepGreen.withOpacity(AppDimens.opacity70),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppDimens.spacing4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: AppDimens.fontSize16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.deepGreen,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) return AppStrings.unknownDate;
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _showSignOutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.white,
        title: const Text(
          AppStrings.signOutTitle,
          style: TextStyle(
            color: AppColors.deepGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          AppStrings.signOutConfirmation,
          style: TextStyle(color: AppColors.deepGreen),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              AppStrings.cancel,
              style: TextStyle(
                color: AppColors.deepGreen.withOpacity(AppDimens.opacity70),
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                final signOutUseCase = ref.read(
                  dashboardSignOutUseCaseProvider,
                );
                await signOutUseCase.execute();
                if (context.mounted) {
                  context.go('/login');
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${AppStrings.signOutFailed}$e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text(
              AppStrings.signOutButton,
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
