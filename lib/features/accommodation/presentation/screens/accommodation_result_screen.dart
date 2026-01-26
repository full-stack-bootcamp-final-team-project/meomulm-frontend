import 'package:flutter/material.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/widgets/accommodation_result_widgets/hotel_card.dart';
import 'package:meomulm_frontend/features/accommodation/presentation/widgets/accommodation_result_widgets/result_topBar.dart';


class AccommodationResultScreen extends StatelessWidget {
  const AccommodationResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const ResultTopBar(),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: const [
                HotelCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
