import 'package:flutter/material.dart';

/// The real brand mark (assets/icon/sdk-logo.png — the same source used for
/// the app's launcher icon), used in place of the old "SDK Investing" text
/// wordmark wherever the app needs to show its brand.
class AppBrandLogo extends StatelessWidget {
  const AppBrandLogo({super.key, this.size = 34});

  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.asset(
        'assets/icon/sdk-logo.png',
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
    );
  }
}
