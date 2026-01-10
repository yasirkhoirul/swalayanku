import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:module_core/common/color.dart';
import 'package:module_core/widget/appbar_admin.dart';
import 'package:module_core/widget/layout_background.dart';

class MainScaffold extends StatelessWidget {
  final VoidCallback onLogout;
  final StatefulNavigationShell statefulNavigationShell;
  const MainScaffold({super.key, required this.statefulNavigationShell, required this.onLogout});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: Container(
            color: MyColor.hijau,
            child: AppbarAdmin(
              onLogout: onLogout,
            ),
          ),
        ),
        body: LayoutBackground(widget: statefulNavigationShell),
      );
  }
}
