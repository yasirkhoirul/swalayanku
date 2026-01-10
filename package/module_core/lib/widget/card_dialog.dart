import 'package:flutter/material.dart';

class MyCardDialog extends StatelessWidget {
  final Widget logo;
  final Text judul;
  final ListView content;
  final ListView contentBottom;
  const MyCardDialog({super.key,required this.logo, required this.judul, required this.content, required this.contentBottom});

  @override
  Widget build(BuildContext context) {
    
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 10,
          children: [
            SizedBox(
              height: 50,
              width: 50,
              child: logo,
            ),
            judul,
            content,
            contentBottom
          ],
        ),
      ),
    );
    
  }


  
}