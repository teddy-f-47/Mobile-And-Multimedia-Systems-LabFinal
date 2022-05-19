import 'dart:async';
import 'package:city_guide/models/tour.dart';
import 'package:city_guide/storage/json_reader.dart';

class TourVM {
  final String _jsonFilename = 'tours.json';
  late int index;

  List<Tour> tours = [];
  Tour? selectedTour;

  /// Private constructor
  TourVM._create(int id) {
    index = id;
  }

  /// Private async init
  _asyncInit() async {
    List data = await JSONReader.readFile(_jsonFilename);
    List<Tour> loadedTours = List.generate(data.length, (i) {
      return Tour.fromMap(data[i]);
    });
    tours = List.from(loadedTours);
    for (int i = 0; i < tours.length; i++) {
      if (index == tours[i].id) {
        selectedTour = tours[i];
      }
    }
  }

  /// Public factory, used as the "public constructor"
  static Future<TourVM> create(int id) async {
    var vm = TourVM._create(id);
    await vm._asyncInit();
    return vm;
  }

  String getName() {
    return (selectedTour != null) ? selectedTour!.name : '';
  }

  String getDescription() {
    if (selectedTour == null) {
      return '';
    }
    if (selectedTour!.description == null) {
      return '';
    }
    return selectedTour!.description!;
  }

  List<String> getVisitPoints() {
    if (selectedTour == null) {
      return [];
    }
    if (selectedTour!.visitPoints == null) {
      return [];
    }
    return selectedTour!.visitPoints!;
  }
}
