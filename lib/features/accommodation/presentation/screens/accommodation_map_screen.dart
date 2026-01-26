import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/widgets/accommodation_map_widgets/accommodation_map.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/widgets/accommodation_map_widgets/common_back_button.dart';


class AccommodationMapScreen extends StatelessWidget {
  const AccommodationMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const AccommodationMap(),
          CommonBackButton(),
        ],
      ),
    );
  }
}
