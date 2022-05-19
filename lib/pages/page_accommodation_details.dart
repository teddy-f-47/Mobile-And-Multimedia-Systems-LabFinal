import 'package:flutter/material.dart';
import 'package:city_guide/styling.dart';
import 'package:city_guide/constants.dart';
import 'package:city_guide/viewmodels/accommodationVM.dart';
import 'package:city_guide/pages/page_reviews.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:city_guide/util_gmap.dart';
import 'package:city_guide/util_ratingreview.dart';

class PageAccommodationDetails extends StatefulWidget {
  const PageAccommodationDetails({Key? key, required this.id})
      : super(key: key);
  final int id;

  @override
  PageAccommodationDetailsState createState() =>
      PageAccommodationDetailsState();
}

class PageAccommodationDetailsState extends State<PageAccommodationDetails> {
  String _name = '';
  String _description = '';
  String _placeId = '';
  int _ratingMaxVal = 0;
  num _rating = 0;
  String _location = '';
  List<String> _imageAssets = [];

  late GoogleMapController _mapController;
  LatLng _mapCenter = Constants.locationDefault;
  Map<PolylineId, Polyline> _mapPolyline = {};

  void _createPolylines(
    double startLat,
    double startLng,
    double destinationLat,
    double destinationLng,
  ) async {
    Map<PolylineId, Polyline> currentPolylines = await UtilGMap.createPolylines(
        startLat, startLng, destinationLat, destinationLng);

    if (mounted == true) {
      setState(() {
        _mapPolyline.clear();
        _mapPolyline.addAll(currentPolylines);
      });
    }
  }

  void _updateAccommodationDetail() async {
    var accommodationVM = await AccommodationVM.create(widget.id);
    String loadedName = accommodationVM.getName();
    String loadedDescription = accommodationVM.getDescription();
    String loadedPlaceId = accommodationVM.getPlaceId();
    int loadedRatingMaxVal = accommodationVM.getRatingMaxVal();
    num loadedRating = await accommodationVM.getRating();
    String loadedLocation = accommodationVM.getLocation();
    List<String> loadedImageAssets = accommodationVM.getImageAssets();

    LatLng loadedMapCenter = await UtilGMap.getLatLng(loadedLocation);

    if (mounted == true) {
      setState(() {
        _name = loadedName;
        _description = loadedDescription;
        _placeId = loadedPlaceId;
        _ratingMaxVal = loadedRatingMaxVal;
        _rating = loadedRating;
        _location = loadedLocation;
        _imageAssets = List.from(loadedImageAssets);
        _mapCenter = loadedMapCenter;
      });
    }
  }

  @override
  void initState() {
    _updateAccommodationDetail();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _mapController.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    Widget accommodationMainImage =
        Image.asset(Constants.imageAssetPath + Constants.imageAssetDefault);
    if (_imageAssets.isNotEmpty) {
      accommodationMainImage =
          Image.asset(Constants.imageAssetPath + _imageAssets[0]);
    }
    List<Widget> accommodationAdditionalImages = [];
    if (_imageAssets.length > 1) {
      accommodationAdditionalImages.add(const Padding(
          padding: EdgeInsets.fromLTRB(0, Styling.paddingSmall, 0, 0),
          child: Text(Constants.subtitleImage)));
      for (int i = 1; i < _imageAssets.length; i++) {
        accommodationAdditionalImages
            .add(Image.asset(Constants.imageAssetPath + _imageAssets[i]));
      }
    }

    String accommodationRatingMerged =
        UtilRatingReview.averageRatingString(_rating, _ratingMaxVal);

    Set<Marker> markers = {
      Marker(
        markerId: const MarkerId(Constants.markerId1),
        position: Constants.locationDefault,
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueRed,
        ),
        infoWindow: const InfoWindow(
          title: Constants.markerLabel1,
          snippet: Constants.locationStringDefault,
        ),
        draggable: false,
      ),
      Marker(
        markerId: const MarkerId(Constants.markerId2),
        position: LatLng(_mapCenter.latitude, _mapCenter.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueRed,
        ),
        infoWindow: InfoWindow(
          title: Constants.markerLabel2,
          snippet: _location,
        ),
        draggable: false,
      ),
    };
    List<Widget> mapChildren = [
      const Text(Constants.subtitleMap1),
      const Text(Constants.subtitleMap2),
      Container(
          height: Styling.mapContainerHeight,
          padding: const EdgeInsets.all(Styling.gapSmall),
          width: MediaQuery.of(context).size.width,
          child: GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _mapCenter,
              zoom: Constants.mapZoomDefault,
            ),
            markers: Set<Marker>.from(markers),
            polylines: Set<Polyline>.of(_mapPolyline.values),
          )),
    ];
    _createPolylines(
        Constants.locationDefault.latitude,
        Constants.locationDefault.longitude,
        _mapCenter.latitude,
        _mapCenter.longitude);

    List<Widget> mainChildren = [
      accommodationMainImage,
      Padding(
        padding: const EdgeInsets.fromLTRB(
            0, Styling.paddingSmall, 0, Styling.paddingSmall),
        child: Text(_name,
            style: const TextStyle(
              fontSize: 20,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              color: Colors.deepOrange,
            )),
      ),
      Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(
                0, 0, Styling.paddingMedium, Styling.paddingSmall),
            child: Text(accommodationRatingMerged,
                style: const TextStyle(
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                )),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
                0, 0, Styling.paddingMedium, Styling.paddingSmall),
            child: InkWell(
              child: const Text(Constants.btnLabelReview,
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                    decoration: TextDecoration.underline,
                  )),
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PageReviews(name: _name, placeId: _placeId)),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, Styling.paddingSmall),
            child: Align(
              alignment: Alignment.center,
              child: InkWell(
                child: const Text(Constants.btnLabelWriteReview,
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                      decoration: TextDecoration.underline,
                    )),
                onTap: () async {
                  String urlQry = _placeId;
                  String gPlaceUrl = Constants.gPlaceWriteReviewUri + urlQry;
                  Uri uri = Uri.parse(gPlaceUrl);
                  await launchUrl(uri);
                },
              ),
            ),
          ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, Styling.paddingSmall),
        child: Text(_description),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(
            0, Styling.paddingSmall, 0, Styling.paddingSmall),
        child: Text(_location,
            style: const TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            )),
      )
    ];

    List<Widget> columnChildren() {
      return mainChildren + mapChildren + accommodationAdditionalImages;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(Constants.appTitle),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: columnChildren(),
        ),
      ),
    );
  }
}
