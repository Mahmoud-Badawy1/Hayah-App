import 'package:flutter/material.dart';
import '../atoms/atoms.dart';

class AppForm extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final VoidCallback? onSubmit;
  final String submitButtonText;
  final bool isLoading;
  final String? subtitle;

  const AppForm({
    super.key,
    required this.title,
    required this.children,
    this.onSubmit,
    this.submitButtonText = 'Submit',
    this.isLoading = false,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.headlineMedium),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withAlpha(175),
              ),
            ),
          ],
          const SizedBox(height: 24),
          ...children,
          if (onSubmit != null) ...[
            const SizedBox(height: 24),
            AppButton(
              text: submitButtonText,
              onPressed: onSubmit,
              isLoading: isLoading,
            ),
          ],
        ],
      ),
    );
  }
}
