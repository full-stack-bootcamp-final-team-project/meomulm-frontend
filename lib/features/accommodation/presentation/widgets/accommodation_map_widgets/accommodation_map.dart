import 'package:flutter/cupertino.dart';

class AccommodationMap extends StatelessWidget {
  const AccommodationMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Image.network(
        'https://th.bing.com/th/id/OIP.HzdMx7fDTGB1mMOvHyx43wHaES?w=326&h=189&c=7&r=0&o=7&pid=1.7&rm=3',
        fit: BoxFit.cover,
      ),
    );
  }
}
