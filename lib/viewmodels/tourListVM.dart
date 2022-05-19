import 'dart:async';
import 'package:city_guide/models/tour.dart';
import 'package:city_guide/storage/json_reader.dart';
import 'package:city_guide/constants.dart';

class TourListVM {
  final String _jsonFilename = 'tours.json';
  final int _tourDescriptionLengthLimit = 45;
  List<Tour> tours = [];

  /// Private constructor
  TourListVM._create() {
    ;
  }

  /// Private async init
  _asyncInit() async {
    List data = await JSONReader.readFile(_jsonFilename);
    List<Tour> loadedTours = List.generate(data.length, (i) {
      return Tour.fromMap(data[i]);
    });
    tours = List.from(loadedTours);
  }

  /// Public factory, used as the "public constructor"
  static Future<TourListVM> create() async {
    var vm = TourListVM._create();
    await vm._asyncInit();
    return vm;
  }

  int countAllTours() {
    return tours.length;
  }

  List<String> getAllNames() {
    return List.generate(tours.length, (i) {
      return tours[i].name;
    });
  }

  List<String> getAllDescriptions() {
    return List.generate(tours.length, (i) {
      if (tours[i].description == null) {
        return '';
      }
      if (tours[i].description!.length > _tourDescriptionLengthLimit) {
        return tours[i]
                .description!
                .substring(0, (_tourDescriptionLengthLimit - 3)) +
            Constants.stringTooLongSymbol;
      }
      return tours[i].description!;
    });
  }

  List<List<String>> getAllVisitPoints() {
    return List.generate(tours.length, (i) {
      return (tours[i].visitPoints != null) ? tours[i].visitPoints! : [];
    });
  }

  List<int> getAllIds() {
    return List.generate(tours.length, (i) {
      return (tours[i].id != null) ? tours[i].id! : 0;
    });
  }
}
