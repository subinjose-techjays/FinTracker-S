import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_dimens.dart';

class ChatModelInitialView extends StatelessWidget {
  final VoidCallback onDownload;
  final VoidCallback onPickFile;

  const ChatModelInitialView({
    super.key,
    required this.onDownload,
    required this.onPickFile,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(AppStrings.modelNotFound),
          const SizedBox(height: AppDimens.spacing16),
          ElevatedButton(
            onPressed: onDownload,
            child: const Text(AppStrings.downloadModel),
          ),
          const SizedBox(height: AppDimens.spacing16),
          OutlinedButton(
            onPressed: onPickFile,
            child: const Text(AppStrings.pickModel),
          ),
          const SizedBox(height: AppDimens.spacing16),
          const Text(
            AppStrings.downloadRequirement,
            style: TextStyle(
              fontSize: AppDimens.fontSize12,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class ChatModelDownloadView extends StatelessWidget {
  final double progress;

  const ChatModelDownloadView({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(AppStrings.downloadingModel),
          const SizedBox(height: AppDimens.spacing16),
          LinearProgressIndicator(value: progress),
          const SizedBox(height: AppDimens.spacing8),
          Text('${(progress * 100).toStringAsFixed(1)}%'),
          const SizedBox(height: AppDimens.spacing8),
          const Text(
            AppStrings.downloadTimeWarning,
            style: TextStyle(
              fontSize: AppDimens.fontSize12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
