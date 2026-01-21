import 'package:flutter/material.dart';
import 'package:meomulm_frontend/core/widgets/appbar/app_bar_widget.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: const AppBarWidget(
        title: '찜 목록',
      ),
      body: Center(
        child: Text('FavoriteScreen is working'),
      ),
    );
  }
}