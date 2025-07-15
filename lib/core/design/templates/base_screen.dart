import 'package:flutter/material.dart';
import '../molecules/loading_overlay.dart';

class BaseScreen extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final bool isLoading;
  final String? loadingText;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final bool showBackButton;

  const BaseScreen({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.isLoading = false,
    this.loadingText,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: actions,
        automaticallyImplyLeading: showBackButton,
      ),
      body: LoadingOverlay(
        isLoading: isLoading,
        loadingText: loadingText,
        child: SafeArea(child: body),
      ),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
