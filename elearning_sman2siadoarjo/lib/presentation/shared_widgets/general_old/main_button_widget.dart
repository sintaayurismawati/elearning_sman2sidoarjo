import 'package:flutter/material.dart';

class MainButtonWidget extends StatelessWidget {
  final VoidCallback? btnAction;
  final String btnTitle;

  const MainButtonWidget({
    super.key,
    required this.btnAction,
    required this.btnTitle,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: btnAction,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff016EB3),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5), // 👈 bikin kotak
        ),
      ),
      child: Text(btnTitle, style: TextStyle(color: Colors.white)),
    );
  }
}
