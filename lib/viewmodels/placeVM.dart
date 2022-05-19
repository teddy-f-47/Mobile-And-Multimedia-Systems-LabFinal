import 'dart:async';
import 'package:city_guide/models/place.dart';
import 'package:city_guide/storage/json_reader.dart';

import 'package:city_guide/util_gplace.dart';

class PlaceVM {
  final String _jsonFilename = 'places.json';
  late int index;

  List<Place> places = [];
  Place? selectedPlace;

  /// Private constructor
  PlaceVM._create(int id) {
    index = id;
  }

  /// Private async init
  _asyncInit() async {
    List data = await JSONReader.readFile(_jsonFilename);
    List<Place> loadedPlaces = List.generate(data.length, (i) {
      return Place.fromMap(data[i]);
    });
    places = List.from(loadedPlaces);
    for (int i = 0; i < places.length; i++) {
      if (index == places[i].id) {
        selectedPlace = places[i];
      }
    }
  }

  /// Public factory, used as the "public constructor"
  static Future<PlaceVM> create(int id) async {
    var vm = PlaceVM._create(id);
    await vm._asyncInit();
    return vm;
  }

  String getName() {
    return (selectedPlace != null) ? selectedPlace!.name : '';
  }

  String getDescription() {
    if (selectedPlace == null) {
      return '';
    }
    if (selectedPlace!.description == null) {
      return '';
    }
    return selectedPlace!.description!;
  }

  int getRatingMaxVal() {
    if (selectedPlace == null) {
      return 0;
    }
    if (selectedPlace!.ratingMaxVal == null) {
      return 0;
    }
    return selectedPlace!.ratingMaxVal!;
  }

  String getPlaceId() {
    if (selectedPlace == null) {
      return '';
    }
    if (selectedPlace!.placeId == null) {
      return '';
    }
    return selectedPlace!.placeId!;
  }

  Future<num> getRating() async {
    if (selectedPlace == null) {
      return 0;
    }
    if (selectedPlace!.placeId == null) {
      return 0;
    }

    UtilGPlace placeDetails = await UtilGPlace.create(selectedPlace!.placeId!);
    if (placeDetails.rating == null) {
      return 0;
    }
    return placeDetails.rating!;
  }

  String getLocation() {
    if (selectedPlace == null) {
      return '';
    }
    if (selectedPlace!.location == null) {
      return '';
    }
    return selectedPlace!.location!;
  }

  List<String> getImageAssets() {
    if (selectedPlace == null) {
      return [];
    }
    if (selectedPlace!.imageAssets == null) {
      return [];
    }
    return selectedPlace!.imageAssets!;
  }

  List<String> getVideoAssets() {
    if (selectedPlace == null) {
      return [];
    }
    if (selectedPlace!.videoAssets == null) {
      return [];
    }
    return selectedPlace!.videoAssets!;
  }
}
