import 'package:google_maps_flutter/google_maps_flutter.dart';

class Constants {
  static const String appTitle = 'Wroclaw City Guide App';
  static const String subtitleImage = 'Images: ';
  static const String subtitleVideo = 'Videos: ';
  static const String subtitleMap1 = 'Map: ';
  static const String subtitleMap2 =
      '*directions from the city square (rynek) to the location';
  static const String subtitleMap3 = 'Map of the tour route: ';
  static const String subtitleTourVisits = 'List of places to visit: ';
  static const String subtitleAvgRating = 'Average Rating: ';
  static const String subtitleRating = 'Rating: ';
  static const String subtitleReviews = 'Reviews';

  static const String btnLabelEvents = 'See Upcoming Events';
  static const String btnLabelPlaces = 'See Recommended Places';
  static const String btnLabelAccommodations = 'See Accommodations Offers';
  static const String btnLabelTrips = 'See Guided Tours';
  static const String btnLabelReview = 'See Reviews';
  static const String btnLabelWriteReview = 'Write a Review';
  static const String btnLabelVideoNext = 'Next';
  static const String btnLabelVideoPrev = 'Prev';

  static const String stringTooLongSymbol = '...';
  static const String stringTourRouteSeparator = ' - ';
  static const String avgRatingStringSeparator = " / ";
  static const String avgRatingStringDefault = "- / -";

  static const String imageAssetPath = 'assets/';
  static const String imageAssetDefault = 'default.jpg';

  static const String videoIdDefault = 'lH6lt23FMSg';

  static const String locationStringDefault = 'Wroclaw';
  static const LatLng locationDefault = LatLng(51.1104, 17.0310);
  static const String polylineIdDefault = 'mapPolyline';
  static const String markerId1 = '1';
  static const String markerId2 = '2';
  static const String markerLabel1 = 'City Center';
  static const String markerLabel2 = 'Location';
  static const double mapZoomDefault = 13;

  static const String flutterTTSDefaultLanguage = "en-US";

  static const String gPlaceWriteReviewUri =
      "https://search.google.com/local/writereview?placeid=";

  static const String errorMessageNoReviews = "No reviews available.";
  static const String errorMessageDefault =
      "Something goes wrong. Please try again later.";
}
