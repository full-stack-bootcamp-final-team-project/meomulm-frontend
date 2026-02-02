import 'package:flutter/material.dart';
import 'package:meomulm_frontend/features/accommodation/data/models/search_accommodation_response_model.dart';
import 'package:meomulm_frontend/features/map/presentation/widgets/map_search_result_widgets/map_search_result_card.dart';

class AccommodationList extends StatelessWidget {
  final List<SearchAccommodationResponseModel> accommodations;
  final Function(double latitude, double longitude) onAccommodationTap;

  const AccommodationList({
    super.key,
    required this.accommodations,
    required this.onAccommodationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 180,
        margin: const EdgeInsets.only(bottom: 16),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: accommodations.length,
          itemBuilder: (context, index) {
            final acc = accommodations[index];
            return MapSearchResultCard(
              accommodation: acc,
              onTap: () => onAccommodationTap(
                acc.accommodationLatitude,
                acc.accommodationLongitude,
              ),
            );
          },
        ),
      ),
    );
  }
}