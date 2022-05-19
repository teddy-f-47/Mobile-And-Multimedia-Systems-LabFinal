import 'package:flutter/material.dart';
import 'package:city_guide/constants.dart';

import 'package:city_guide/auth/secrets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_geocoding/google_geocoding.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class UtilGMap {
  static final GoogleGeocoding _googleGeocoding =
      GoogleGeocoding(Secrets.gMapSdkApiKey);

  static Future<LatLng> getLatLng(String location) async {
    if (location.isEmpty) {
      location = Constants.locationStringDefault;
    }
    LatLng output = Constants.locationDefault;
    GeocodingResponse? googleGeocodingResult =
        await _googleGeocoding.geocoding.get(location, []);
    if (googleGeocodingResult == null ||
        googleGeocodingResult.results == null) {
      return output;
    }
    if (googleGeocodingResult.results!.isEmpty ||
        googleGeocodingResult.results![0].geometry == null) {
      return output;
    }
    if (googleGeocodingResult.results![0].geometry!.location == null) {
      return output;
    }
    if (googleGeocodingResult.results![0].geometry!.location!.lat == null ||
        googleGeocodingResult.results![0].geometry!.location!.lng == null) {
      return output;
    }
    output = LatLng(googleGeocodingResult.results![0].geometry!.location!.lat!,
        googleGeocodingResult.results![0].geometry!.location!.lng!);
    return output;
  }

  static Future<Map<PolylineId, Polyline>> createPolylines(double startLat,
      double startLng, double destinationLat, double destinationLng,
      [String polyLineId = Constants.polylineIdDefault]) async {
    PolylinePoints polylinePoints = PolylinePoints();
    List<LatLng> polylineLatsLngs = [];
    Map<PolylineId, Polyline> currentPolylines = {};

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      Secrets.gMapSdkApiKey,
      PointLatLng(startLat, startLng),
      PointLatLng(destinationLat, destinationLng),
      travelMode: TravelMode.transit,
    );

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineLatsLngs.add(LatLng(point.latitude, point.longitude));
      }
    }

    PolylineId id = PolylineId(polyLineId);
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineLatsLngs,
      width: 2,
    );
    currentPolylines[id] = polyline;

    return currentPolylines;
  }

  static String getTourRouteString(List<String> visitPoints) {
    String tourRoute = "";
    for (int i = 0; i < visitPoints.length; i++) {
      tourRoute =
          tourRoute + Constants.stringTourRouteSeparator + visitPoints[i];
    }
    return tourRoute;
  }
}
