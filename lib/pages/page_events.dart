import 'package:flutter/material.dart';
import 'package:city_guide/styling.dart';
import 'package:city_guide/constants.dart';
import 'package:city_guide/viewmodels/eventListVM.dart';
import 'package:city_guide/pages/page_event_details.dart';

class PageEvents extends StatefulWidget {
  const PageEvents({Key? key}) : super(key: key);

  @override
  PageEventsState createState() => PageEventsState();
}

class PageEventsState extends State<PageEvents> {
  int _numOfEvents = 0;
  List<String> _eventNames = [];
  List<String> _eventDescriptions = [];
  List<String> _eventLocations = [];
  List<List<String>> _eventImageAssets = [];
  List<int> _eventIds = [];

  void _updateEventList() async {
    var eventListVM = await EventListVM.create();
    int count = eventListVM.countAllEvents();
    List<String> names = eventListVM.getAllNames();
    List<String> descriptions = eventListVM.getAllDescriptions();
    List<String> locations = eventListVM.getAllLocations();
    List<List<String>> imageAssets = eventListVM.getAllImageAssets();
    List<int> ids = eventListVM.getAllIds();
    setState(() {
      _numOfEvents = count;
      _eventNames = List.from(names);
      _eventDescriptions = List.from(descriptions);
      _eventLocations = List.from(locations);
      _eventImageAssets = List.from(imageAssets);
      _eventIds = List.from(ids);
    });
  }

  @override
  void initState() {
    super.initState();
    _updateEventList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Constants.appTitle),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListView.separated(
              // Build a list child as many as X times, where X = _numOfEvents.
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _numOfEvents,
              itemBuilder: (BuildContext context, int index) {
                Widget eventMainImage = Image.asset(
                    Constants.imageAssetPath + Constants.imageAssetDefault);
                if (_eventImageAssets[index].isNotEmpty) {
                  eventMainImage = Image.asset(
                      Constants.imageAssetPath + _eventImageAssets[index][0]);
                }
                //Add the list child element here
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PageEventDetails(id: _eventIds[index])),
                    );
                  },
                  child: Container(
                    constraints: BoxConstraints(
                      minHeight: Styling.gapLarge,
                      minWidth: MediaQuery.of(context).size.width,
                    ),
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: Styling.listItemImageWidth,
                          height: Styling.listItemImageHeight,
                          child: eventMainImage,
                        ), //Item Image
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  0, 0, 0, Styling.paddingSmall),
                              child: Text(_eventNames[index],
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepOrange,
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  0, 0, 0, Styling.paddingSmall),
                              child: Text(_eventDescriptions[index]),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  0, 0, 0, Styling.paddingSmall),
                              child: Text(_eventLocations[index],
                                  style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                          ],
                        ), //Title and Desc
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            ),
            const SizedBox(height: Styling.gapMedium),
          ],
        ),
      ),
    );
  }
}
