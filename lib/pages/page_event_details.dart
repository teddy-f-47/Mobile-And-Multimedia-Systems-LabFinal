import 'package:flutter/material.dart';
import 'package:city_guide/styling.dart';
import 'package:city_guide/constants.dart';
import 'package:city_guide/viewmodels/eventVM.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:city_guide/util_gmap.dart';

class PageEventDetails extends StatefulWidget {
  const PageEventDetails({Key? key, required this.id}) : super(key: key);
  final int id;

  @override
  PageEventDetailsState createState() => PageEventDetailsState();
}

class PageEventDetailsState extends State<PageEventDetails> {
  String _name = '';
  String _description = '';
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

  void _updateEventDetail() async {
    var eventVM = await EventVM.create(widget.id);
    String loadedName = eventVM.getName();
    String loadedDescription = eventVM.getDescription();
    String loadedLocation = eventVM.getLocation();
    List<String> loadedImageAssets = eventVM.getImageAssets();

    LatLng loadedMapCenter = await UtilGMap.getLatLng(loadedLocation);

    if (mounted == true) {
      setState(() {
        _name = loadedName;
        _description = loadedDescription;
        _location = loadedLocation;
        _imageAssets = List.from(loadedImageAssets);
        _mapCenter = loadedMapCenter;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _updateEventDetail();
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
    Widget eventMainImage =
        Image.asset(Constants.imageAssetPath + Constants.imageAssetDefault);
    if (_imageAssets.isNotEmpty) {
      eventMainImage = Image.asset(Constants.imageAssetPath + _imageAssets[0]);
    }
    List<Widget> eventAdditionalImages = [];
    if (_imageAssets.length > 1) {
      eventAdditionalImages.add(const Padding(
          padding: EdgeInsets.fromLTRB(0, Styling.paddingMedium, 0, 0),
          child: Text(Constants.subtitleImage)));
      for (int i = 1; i < _imageAssets.length; i++) {
        eventAdditionalImages
            .add(Image.asset(Constants.imageAssetPath + _imageAssets[i]));
      }
    }

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
      eventMainImage,
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
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, Styling.paddingSmall),
        child: Text(_description),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, Styling.paddingSmall),
        child: Text(_location,
            style: const TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            )),
      )
    ];

    List<Widget> columnChildren() {
      return mainChildren + mapChildren + eventAdditionalImages;
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
