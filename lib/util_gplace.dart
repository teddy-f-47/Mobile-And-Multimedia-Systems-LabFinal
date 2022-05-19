import 'package:city_guide/auth/secrets.dart';
import 'package:google_maps_webservice/places.dart';

class UtilGPlace {
  String? placeId;
  num? rating;
  List<Review>? reviews;

  /// Private constructor
  UtilGPlace._create(String placeId) {
    this.placeId = placeId;
  }

  /// Private async init
  _asyncInit() async {
    GoogleMapsPlaces _gPlaces = GoogleMapsPlaces(
      apiKey: Secrets.gMapSdkApiKey,
    );
    PlacesDetailsResponse details =
        await _gPlaces.getDetailsByPlaceId(placeId!);
    rating = details.result.rating;
    reviews = details.result.reviews;
  }

  /// Public factory, used as the "public constructor"
  static Future<UtilGPlace> create(String placeId) async {
    var util = UtilGPlace._create(placeId);
    await util._asyncInit();
    return util;
  }
}
