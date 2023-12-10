import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geocoding/geocoding.dart';

class IntentUtils {
  IntentUtils._();

  static Future<void> launchGoogleMaps({
    required String sourceAddress,
    required String destinationAddress,
  }) async {
    try {
      List<Location> sourceLocations = await locationFromAddress(sourceAddress);
      List<Location> destinationLocations = await locationFromAddress(destinationAddress);

      if (sourceLocations.isNotEmpty && destinationLocations.isNotEmpty) {
        final sourceLatitude = sourceLocations.first.latitude;
        final sourceLongitude = sourceLocations.first.longitude;
        final destinationLatitude = destinationLocations.first.latitude;
        final destinationLongitude = destinationLocations.first.longitude;

        final uri = Uri(
          scheme: "google.navigation",
          queryParameters: {
            'saddr': '$sourceLatitude, $sourceLongitude',
            'daddr': '$destinationLatitude, $destinationLongitude',
          },
        );

        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        } else {
          debugPrint('An error occurred');
        }
      } else {
        debugPrint('Could not find location for the provided addresses');
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }
}
