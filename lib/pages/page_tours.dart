import 'package:city_guide/util_gmap.dart';
import 'package:flutter/material.dart';
import 'package:city_guide/styling.dart';
import 'package:city_guide/constants.dart';
import 'package:city_guide/viewmodels/tourListVM.dart';
import 'package:city_guide/pages/page_tour_details.dart';

class PageTours extends StatefulWidget {
  const PageTours({Key? key}) : super(key: key);

  @override
  PageToursState createState() => PageToursState();
}

class PageToursState extends State<PageTours> {
  int _numOfTours = 0;
  List<String> _tourNames = [];
  List<String> _tourDescriptions = [];
  List<List<String>> _tourVisitPoints = [];
  List<int> _tourIds = [];

  void _updateTourList() async {
    var tourListVM = await TourListVM.create();
    int count = tourListVM.countAllTours();
    List<String> names = tourListVM.getAllNames();
    List<String> descriptions = tourListVM.getAllDescriptions();
    List<List<String>> visitPoints = tourListVM.getAllVisitPoints();
    List<int> ids = tourListVM.getAllIds();
    setState(() {
      _numOfTours = count;
      _tourNames = List.from(names);
      _tourDescriptions = List.from(descriptions);
      _tourVisitPoints = List.from(visitPoints);
      _tourIds = List.from(ids);
    });
  }

  @override
  void initState() {
    super.initState();
    _updateTourList();
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
              // Build a list child as many as X times, where X = _numOfTours.
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _numOfTours,
              itemBuilder: (BuildContext context, int index) {
                String tourRoute =
                    UtilGMap.getTourRouteString(_tourVisitPoints[index]);

                //Add the list child element here
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PageTourDetails(id: _tourIds[index])),
                    );
                  },
                  child: Container(
                    constraints: BoxConstraints(
                      minHeight: Styling.gapLarge,
                      minWidth: MediaQuery.of(context).size.width,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                              0, 0, 0, Styling.paddingSmall),
                          child: Text(_tourNames[index],
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
                          child: Text(_tourDescriptions[index]),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                              0, 0, 0, Styling.paddingSmall),
                          child: Text(tourRoute,
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
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
