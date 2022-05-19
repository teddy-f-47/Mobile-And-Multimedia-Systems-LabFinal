import 'dart:async';
import 'package:city_guide/models/event.dart';
import 'package:city_guide/storage/json_reader.dart';

class EventVM {
  final String _jsonFilename = 'events.json';
  late int index;

  List<Event> events = [];
  Event? selectedEvent;

  /// Private constructor
  EventVM._create(int id) {
    index = id;
  }

  /// Private async init
  _asyncInit() async {
    List data = await JSONReader.readFile(_jsonFilename);
    List<Event> loadedEvents = List.generate(data.length, (i) {
      return Event.fromMap(data[i]);
    });
    events = List.from(loadedEvents);
    for (int i = 0; i < events.length; i++) {
      if (index == events[i].id) {
        selectedEvent = events[i];
      }
    }
  }

  /// Public factory, used as the "public constructor"
  static Future<EventVM> create(int id) async {
    var vm = EventVM._create(id);
    await vm._asyncInit();
    return vm;
  }

  String getName() {
    return (selectedEvent != null) ? selectedEvent!.name : '';
  }

  String getDescription() {
    if (selectedEvent == null) {
      return '';
    }
    if (selectedEvent!.description == null) {
      return '';
    }
    return selectedEvent!.description!;
  }

  String getLocation() {
    if (selectedEvent == null) {
      return '';
    }
    if (selectedEvent!.location == null) {
      return '';
    }
    return selectedEvent!.location!;
  }

  List<String> getImageAssets() {
    if (selectedEvent == null) {
      return [];
    }
    if (selectedEvent!.imageAssets == null) {
      return [];
    }
    return selectedEvent!.imageAssets!;
  }
}
