import 'dart:async';
import 'package:city_guide/models/event.dart';
import 'package:city_guide/storage/json_reader.dart';
import 'package:city_guide/constants.dart';

class EventListVM {
  final String _jsonFilename = 'events.json';
  final int _eventDescriptionLengthLimit = 45;
  List<Event> events = [];

  /// Private constructor
  EventListVM._create() {
    ;
  }

  /// Private async init
  _asyncInit() async {
    List data = await JSONReader.readFile(_jsonFilename);
    List<Event> loadedEvents = List.generate(data.length, (i) {
      return Event.fromMap(data[i]);
    });
    events = List.from(loadedEvents);
  }

  /// Public factory, used as the "public constructor"
  static Future<EventListVM> create() async {
    var vm = EventListVM._create();
    await vm._asyncInit();
    return vm;
  }

  int countAllEvents() {
    return events.length;
  }

  List<String> getAllNames() {
    return List.generate(events.length, (i) {
      return events[i].name;
    });
  }

  List<String> getAllDescriptions() {
    return List.generate(events.length, (i) {
      if (events[i].description == null) {
        return '';
      }
      if (events[i].description!.length > _eventDescriptionLengthLimit) {
        return events[i]
                .description!
                .substring(0, (_eventDescriptionLengthLimit - 3)) +
            Constants.stringTooLongSymbol;
      }
      return events[i].description!;
    });
  }

  List<String> getAllLocations() {
    return List.generate(events.length, (i) {
      return (events[i].location != null) ? events[i].location! : '';
    });
  }

  List<List<String>> getAllImageAssets() {
    return List.generate(events.length, (i) {
      return (events[i].imageAssets != null) ? events[i].imageAssets! : [];
    });
  }

  List<int> getAllIds() {
    return List.generate(events.length, (i) {
      return (events[i].id != null) ? events[i].id! : 0;
    });
  }
}
