import 'package:geolocator/geolocator.dart';

class ExternalApiService {
  Future<Position> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw Exception("LOCATION_DISABLED");
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw Exception("LOCATION_DENIED");
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception("LOCATION_DENIED_FOREVER");
    }

    return await Geolocator.getCurrentPosition();
  }
}