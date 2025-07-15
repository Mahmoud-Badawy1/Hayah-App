import 'package:flutter/material.dart';
import '../atoms/atoms.dart';

class AppFormField extends StatelessWidget {
  final String label;
  final String? hint;
  final String? errorText;
  final bool obscureText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final bool isRequired;
  final IconData? prefixIcon;
  final Widget? suffixIcon;

  const AppFormField({
    super.key,
    required this.label,
    this.hint,
    this.errorText,
    this.obscureText = false,
    this.controller,
    this.keyboardType,
    this.onChanged,
    this.validator,
    this.isRequired = false,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            if (isRequired) ...[
              const SizedBox(width: 4),
              Text(
                '*',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        AppTextInput(
          label: '',
          hint: hint,
          errorText: errorText,
          obscureText: obscureText,
          controller: controller,
          keyboardType: keyboardType,
          onChanged: onChanged,
          validator: validator != null
              ? (value) {
                  if (isRequired && (value == null || value.isEmpty)) {
                    return 'This field is required';
                  }
                  return validator!(value);
                }
              : null,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
        ),
      ],
    );
  }
}
