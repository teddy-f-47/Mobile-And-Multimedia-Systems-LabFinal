import 'dart:async';
import 'package:city_guide/models/accommodation.dart';
import 'package:city_guide/storage/json_reader.dart';

import 'package:city_guide/util_gplace.dart';

class AccommodationVM {
  final String _jsonFilename = 'accommodations.json';
  late int index;

  List<Accommodation> accommodations = [];
  Accommodation? selectedAccommodation;

  /// Private constructor
  AccommodationVM._create(int id) {
    index = id;
  }

  /// Private async init
  _asyncInit() async {
    List data = await JSONReader.readFile(_jsonFilename);
    List<Accommodation> loadedAccommodations = List.generate(data.length, (i) {
      return Accommodation.fromMap(data[i]);
    });
    accommodations = List.from(loadedAccommodations);
    for (int i = 0; i < accommodations.length; i++) {
      if (index == accommodations[i].id) {
        selectedAccommodation = accommodations[i];
      }
    }
  }

  /// Public factory, used as the "public constructor"
  static Future<AccommodationVM> create(int id) async {
    var vm = AccommodationVM._create(id);
    await vm._asyncInit();
    return vm;
  }

  String getName() {
    return (selectedAccommodation != null) ? selectedAccommodation!.name : '';
  }

  String getDescription() {
    if (selectedAccommodation == null) {
      return '';
    }
    if (selectedAccommodation!.description == null) {
      return '';
    }
    return selectedAccommodation!.description!;
  }

  int getRatingMaxVal() {
    if (selectedAccommodation == null) {
      return 0;
    }
    if (selectedAccommodation!.ratingMaxVal == null) {
      return 0;
    }
    return selectedAccommodation!.ratingMaxVal!;
  }

  String getPlaceId() {
    if (selectedAccommodation == null) {
      return '';
    }
    if (selectedAccommodation!.placeId == null) {
      return '';
    }
    return selectedAccommodation!.placeId!;
  }

  Future<num> getRating() async {
    if (selectedAccommodation == null) {
      return 0;
    }
    if (selectedAccommodation!.placeId == null) {
      return 0;
    }

    UtilGPlace placeDetails =
        await UtilGPlace.create(selectedAccommodation!.placeId!);
    if (placeDetails.rating == null) {
      return 0;
    }
    return placeDetails.rating!;
  }

  String getLocation() {
    if (selectedAccommodation == null) {
      return '';
    }
    if (selectedAccommodation!.location == null) {
      return '';
    }
    return selectedAccommodation!.location!;
  }

  List<String> getImageAssets() {
    if (selectedAccommodation == null) {
      return [];
    }
    if (selectedAccommodation!.imageAssets == null) {
      return [];
    }
    return selectedAccommodation!.imageAssets!;
  }
}
