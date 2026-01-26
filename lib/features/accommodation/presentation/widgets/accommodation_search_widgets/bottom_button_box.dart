import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomButtonBox extends StatelessWidget {
  final String buttonName;
  final VoidCallback? onPressed;
  const BottomButtonBox({super.key, required this.buttonName, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: width * 0.9,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFF9D96CA),
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            buttonName,
            style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
