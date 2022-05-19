import 'package:flutter/material.dart';
import 'package:city_guide/styling.dart';
import 'package:city_guide/constants.dart';
import 'package:city_guide/viewmodels/placeListVM.dart';
import 'package:city_guide/pages/page_place_details.dart';

import 'package:city_guide/util_ratingreview.dart';

class PagePlaces extends StatefulWidget {
  const PagePlaces({Key? key}) : super(key: key);

  @override
  PagePlacesState createState() => PagePlacesState();
}

class PagePlacesState extends State<PagePlaces> {
  int _numOfPlaces = 0;
  List<String> _placeNames = [];
  List<String> _placeDescriptions = [];
  List<int> _placeRatingMaxVals = [];
  List<num> _placeRatings = [];
  List<String> _placeLocations = [];
  List<List<String>> _placeImageAssets = [];
  List<int> _placeIds = [];

  void _updatePlaceList() async {
    var placeListVM = await PlaceListVM.create();
    int count = placeListVM.countAllPlaces();
    List<String> names = placeListVM.getAllNames();
    List<String> descriptions = placeListVM.getAllDescriptions();
    List<int> ratingMaxVals = placeListVM.getAllRatingMaxVals();
    List<num> ratings = await placeListVM.getAllPlaceRatings();
    List<String> locations = placeListVM.getAllLocations();
    List<List<String>> imageAssets = placeListVM.getAllImageAssets();
    List<int> ids = placeListVM.getAllIds();
    setState(() {
      _numOfPlaces = count;
      _placeNames = List.from(names);
      _placeDescriptions = List.from(descriptions);
      _placeRatingMaxVals = List.from(ratingMaxVals);
      _placeRatings = List.from(ratings);
      _placeLocations = List.from(locations);
      _placeImageAssets = List.from(imageAssets);
      _placeIds = List.from(ids);
    });
  }

  @override
  void initState() {
    super.initState();
    _updatePlaceList();
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
              // Build a list child as many as X times, where X = _numOfPlaces.
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _numOfPlaces,
              itemBuilder: (BuildContext context, int index) {
                Widget placeMainImage = Image.asset(
                    Constants.imageAssetPath + Constants.imageAssetDefault);
                if (_placeImageAssets[index].isNotEmpty) {
                  placeMainImage = Image.asset(
                      Constants.imageAssetPath + _placeImageAssets[index][0]);
                }
                String placeRatingMerged = UtilRatingReview.averageRatingString(
                    _placeRatings[index], _placeRatingMaxVals[index]);

                //Add the list child element here
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PagePlaceDetails(id: _placeIds[index])),
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
                          child: placeMainImage,
                        ), //Item Image
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  0, 0, 0, Styling.paddingSmall),
                              child: Text(_placeNames[index],
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
                              child: Text(placeRatingMerged,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontStyle: FontStyle.italic,
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  0, 0, 0, Styling.paddingSmall),
                              child: Text(_placeDescriptions[index]),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  0, 0, 0, Styling.paddingSmall),
                              child: Text(_placeLocations[index],
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
