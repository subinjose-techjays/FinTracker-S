import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';

class FinTrackerTextFormField extends StatelessWidget {
  const FinTrackerTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureTextValue,
    required this.textInputType,
  });
  final TextEditingController controller;
  final String hintText;
  final bool obscureTextValue;
  final TextInputType textInputType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autocorrect: false,
      controller: controller,
      keyboardType: textInputType,
      obscureText: obscureTextValue,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: AppColors.grey),
        prefixIcon: const Icon(
          Icons.email_outlined,
          color: AppColors.darkGreen,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radius12),
          borderSide: const BorderSide(color: AppColors.darkGreen),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radius12),
          borderSide: const BorderSide(
            color: AppColors.darkGreen,
            width: AppDimens.borderWidth1_5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radius12),
          borderSide: const BorderSide(
            color: AppColors.darkGreen,
            width: AppDimens.borderWidth2,
          ),
        ),
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spacing16,
          vertical: AppDimens.spacing16,
        ),
      ),
    );
  }
}
