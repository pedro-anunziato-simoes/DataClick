import 'package:flutter/material.dart';

class PngLogoWidget extends StatelessWidget {
  final double height;

  const PngLogoWidget({super.key, this.height = 100.0});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('assets/images/Logo DataClick.jpg', height: height),
      ],
    );
  }
}
