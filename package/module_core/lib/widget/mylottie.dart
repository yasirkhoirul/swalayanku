import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MylottieImpl extends StatelessWidget {
  final String path;
  const MylottieImpl(this.path,{super.key});

  @override
  Widget build(BuildContext context) {
    return LottieBuilder.asset(path, fit: BoxFit.fitWidth, repeat: true);
  }
}
