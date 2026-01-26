import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String appBarTitle;

  const CustomAppBar({super.key, required this.appBarTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFDDDDDD)),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Text(
                '<-',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Text(
            appBarTitle,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
