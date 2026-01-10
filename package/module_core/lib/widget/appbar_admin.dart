import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:module_core/common/logo.dart';
import 'package:module_core/common/color.dart';

class AppbarAdmin extends StatelessWidget{
  final VoidCallback? onLogout;
  const AppbarAdmin({super.key, this.onLogout});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          SvgPicture.asset(
            Mylogo.logo,
            height: 40,
            width: 40,
            colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          
         
          // Icons Row
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.show_chart, color: Colors.white, size: 28),
                onPressed: () {},
              ),
              SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.shopping_cart, color: Colors.white, size: 28),
                onPressed: () {},
              ),
              SizedBox(width: 8),
              PopupMenuButton<String>(
                icon: Icon(Icons.person, color: Colors.white, size: 28),
                offset: Offset(0, 50),
                onSelected: (value) {
                  if (value == 'logout' && onLogout != null) {
                    onLogout!();
                  }
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem<String>(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout, color: MyColor.merah),
                        SizedBox(width: 8),
                        Text('Logout'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}