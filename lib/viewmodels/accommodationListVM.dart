import 'dart:async';
import 'package:city_guide/models/accommodation.dart';
import 'package:city_guide/storage/json_reader.dart';
import 'package:city_guide/constants.dart';

import 'package:city_guide/util_gplace.dart';

class AccommodationListVM {
  final String _jsonFilename = 'accommodations.json';
  final int _accommodationDescriptionLengthLimit = 45;
  List<Accommodation> accommodations = [];

  /// Private constructor
  AccommodationListVM._create() {
    ;
  }

  /// Private async init
  _asyncInit() async {
    List data = await JSONReader.readFile(_jsonFilename);
    List<Accommodation> loadedAccommodations = List.generate(data.length, (i) {
      return Accommodation.fromMap(data[i]);
    });
    accommodations = List.from(loadedAccommodations);
  }

  /// Public factory, used as the "public constructor"
  static Future<AccommodationListVM> create() async {
    var vm = AccommodationListVM._create();
    await vm._asyncInit();
    return vm;
  }

  int countAllAccommodations() {
    return accommodations.length;
  }

  List<String> getAllNames() {
    return List.generate(accommodations.length, (i) {
      return accommodations[i].name;
    });
  }

  List<String> getAllDescriptions() {
    return List.generate(accommodations.length, (i) {
      if (accommodations[i].description == null) {
        return '';
      }
      if (accommodations[i].description!.length >
          _accommodationDescriptionLengthLimit) {
        return accommodations[i]
                .description!
                .substring(0, (_accommodationDescriptionLengthLimit - 3)) +
            Constants.stringTooLongSymbol;
      }
      return accommodations[i].description!;
    });
  }

  List<int> getAllRatingMaxVals() {
    return List.generate(accommodations.length, (i) {
      return (accommodations[i].ratingMaxVal != null)
          ? accommodations[i].ratingMaxVal!
          : 0;
    });
  }

  List<String> getAllPlaceIds() {
    return List.generate(accommodations.length, (i) {
      if (accommodations[i].placeId == null) {
        return '';
      }
      return accommodations[i].placeId!;
    });
  }

  Future<List<num>> getAllPlaceRatings() async {
    List<num> output = [];
    for (int i = 0; i < accommodations.length; i++) {
      if (accommodations[i].placeId == null) {
        output.add(0);
      } else {
        UtilGPlace placeDetails =
            await UtilGPlace.create(accommodations[i].placeId!);
        if (placeDetails.rating == null) {
          output.add(0);
        } else {
          output.add(placeDetails.rating!);
        }
      }
    }
    return output;
  }

  List<String> getAllLocations() {
    return List.generate(accommodations.length, (i) {
      return (accommodations[i].location != null)
          ? accommodations[i].location!
          : '';
    });
  }

  List<List<String>> getAllImageAssets() {
    return List.generate(accommodations.length, (i) {
      return (accommodations[i].imageAssets != null)
          ? accommodations[i].imageAssets!
          : [];
    });
  }

  List<int> getAllIds() {
    return List.generate(accommodations.length, (i) {
      return (accommodations[i].id != null) ? accommodations[i].id! : 0;
    });
  }
}
