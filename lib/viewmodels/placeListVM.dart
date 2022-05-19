import 'dart:async';
import 'package:city_guide/models/place.dart';
import 'package:city_guide/storage/json_reader.dart';
import 'package:city_guide/constants.dart';

import 'package:city_guide/util_gplace.dart';

class PlaceListVM {
  final String _jsonFilename = 'places.json';
  final int _placeDescriptionLengthLimit = 45;
  List<Place> places = [];

  /// Private constructor
  PlaceListVM._create() {
    ;
  }

  /// Private async init
  _asyncInit() async {
    List data = await JSONReader.readFile(_jsonFilename);
    List<Place> loadedPlaces = List.generate(data.length, (i) {
      return Place.fromMap(data[i]);
    });
    places = List.from(loadedPlaces);
  }

  /// Public factory, used as the "public constructor"
  static Future<PlaceListVM> create() async {
    var vm = PlaceListVM._create();
    await vm._asyncInit();
    return vm;
  }

  int countAllPlaces() {
    return places.length;
  }

  List<String> getAllNames() {
    return List.generate(places.length, (i) {
      return places[i].name;
    });
  }

  List<String> getAllDescriptions() {
    return List.generate(places.length, (i) {
      if (places[i].description == null) {
        return '';
      }
      if (places[i].description!.length > _placeDescriptionLengthLimit) {
        return places[i]
                .description!
                .substring(0, (_placeDescriptionLengthLimit - 3)) +
            Constants.stringTooLongSymbol;
      }
      return places[i].description!;
    });
  }

  List<int> getAllRatingMaxVals() {
    return List.generate(places.length, (i) {
      return (places[i].ratingMaxVal != null) ? places[i].ratingMaxVal! : 0;
    });
  }

  List<String> getAllPlaceIds() {
    return List.generate(places.length, (i) {
      if (places[i].placeId == null) {
        return '';
      }
      return places[i].placeId!;
    });
  }

  Future<List<num>> getAllPlaceRatings() async {
    List<num> output = [];
    for (int i = 0; i < places.length; i++) {
      if (places[i].placeId == null) {
        output.add(0);
      } else {
        UtilGPlace placeDetails = await UtilGPlace.create(places[i].placeId!);
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
    return List.generate(places.length, (i) {
      return (places[i].location != null) ? places[i].location! : '';
    });
  }

  List<List<String>> getAllImageAssets() {
    return List.generate(places.length, (i) {
      return (places[i].imageAssets != null) ? places[i].imageAssets! : [];
    });
  }

  List<int> getAllIds() {
    return List.generate(places.length, (i) {
      return (places[i].id != null) ? places[i].id! : 0;
    });
  }
}
