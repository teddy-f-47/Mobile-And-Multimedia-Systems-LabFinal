import 'package:flutter/material.dart';
import 'package:city_guide/styling.dart';
import 'package:city_guide/constants.dart';
import 'package:city_guide/viewmodels/accommodationListVM.dart';
import 'package:city_guide/pages/page_accommodation_details.dart';

import 'package:city_guide/util_ratingreview.dart';

class PageAccommodations extends StatefulWidget {
  const PageAccommodations({Key? key}) : super(key: key);

  @override
  PageAccommodationsState createState() => PageAccommodationsState();
}

class PageAccommodationsState extends State<PageAccommodations> {
  int _numOfAccommodations = 0;
  List<String> _accommodationNames = [];
  List<String> _accommodationDescriptions = [];
  List<int> _accommodationRatingMaxVals = [];
  List<num> _accommodationRatings = [];
  List<String> _accommodationLocations = [];
  List<List<String>> _accommodationImageAssets = [];
  List<int> _accommodationIds = [];

  void _updateAccommodationList() async {
    var accommodationListVM = await AccommodationListVM.create();
    int count = accommodationListVM.countAllAccommodations();
    List<String> names = accommodationListVM.getAllNames();
    List<String> descriptions = accommodationListVM.getAllDescriptions();
    List<int> ratingMaxVals = accommodationListVM.getAllRatingMaxVals();
    List<num> ratings = await accommodationListVM.getAllPlaceRatings();
    List<String> locations = accommodationListVM.getAllLocations();
    List<List<String>> imageAssets = accommodationListVM.getAllImageAssets();
    List<int> ids = accommodationListVM.getAllIds();
    setState(() {
      _numOfAccommodations = count;
      _accommodationNames = List.from(names);
      _accommodationDescriptions = List.from(descriptions);
      _accommodationRatingMaxVals = List.from(ratingMaxVals);
      _accommodationRatings = List.from(ratings);
      _accommodationLocations = List.from(locations);
      _accommodationImageAssets = List.from(imageAssets);
      _accommodationIds = List.from(ids);
    });
  }

  @override
  void initState() {
    super.initState();
    _updateAccommodationList();
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
              // Build a list child as many as X times, where X = _numOfAccommodations.
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _numOfAccommodations,
              itemBuilder: (BuildContext context, int index) {
                Widget accommodationMainImage = Image.asset(
                    Constants.imageAssetPath + Constants.imageAssetDefault);
                if (_accommodationImageAssets[index].isNotEmpty) {
                  accommodationMainImage = Image.asset(
                      Constants.imageAssetPath +
                          _accommodationImageAssets[index][0]);
                }
                String accommodationRatingMerged =
                    UtilRatingReview.averageRatingString(
                        _accommodationRatings[index],
                        _accommodationRatingMaxVals[index]);

                //Add the list child element here
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PageAccommodationDetails(
                              id: _accommodationIds[index])),
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
                          child: accommodationMainImage,
                        ), //Item Image
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  0, 0, 0, Styling.paddingSmall),
                              child: Text(_accommodationNames[index],
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
                              child: Text(accommodationRatingMerged,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontStyle: FontStyle.italic,
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  0, 0, 0, Styling.paddingSmall),
                              child: Text(_accommodationDescriptions[index]),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  0, 0, 0, Styling.paddingSmall),
                              child: Text(_accommodationLocations[index],
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
