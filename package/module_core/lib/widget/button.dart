import 'package:flutter/material.dart';
import 'package:module_core/common/color.dart';
class MyButton extends StatelessWidget {
  final VoidCallback? ontap;
  final Widget child;
  const MyButton({super.key, required this.child,this.ontap});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: MyColor.hijau,
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        minimumSize: Size(90, 60),
        shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(15)),
        elevation: 0,
      ),
      onPressed: ontap,
      child: child,
    );
  }
}
