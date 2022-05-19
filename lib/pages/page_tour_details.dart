import 'package:flutter/material.dart';
import 'package:city_guide/styling.dart';
import 'package:city_guide/constants.dart';
import 'package:city_guide/viewmodels/tourVM.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:city_guide/util_gmap.dart';

class PageTourDetails extends StatefulWidget {
  const PageTourDetails({Key? key, required this.id}) : super(key: key);
  final int id;

  @override
  PageTourDetailsState createState() => PageTourDetailsState();
}

class PageTourDetailsState extends State<PageTourDetails> {
  String _name = '';
  String _description = '';
  List<String> _visitPoints = [];
  List<LatLng> _visitCoordinates = [];

  late GoogleMapController _mapController;
  LatLng _mapCenter = Constants.locationDefault;
  Map<PolylineId, Polyline> _mapPolyline = {};

  void _addPolylines(double startLat, double startLng, double destinationLat,
      double destinationLng, String idMarkerAndPolyline) async {
    Map<PolylineId, Polyline> currentPolylines = await UtilGMap.createPolylines(
        startLat,
        startLng,
        destinationLat,
        destinationLng,
        idMarkerAndPolyline);

    if (mounted == true) {
      setState(() {
        _mapPolyline.addAll(currentPolylines);
      });
    }
  }

  void _updateTourDetail() async {
    var tourVM = await TourVM.create(widget.id);
    String loadedName = tourVM.getName();
    String loadedDescription = tourVM.getDescription();
    List<String> loadedVisitPoints = tourVM.getVisitPoints();

    String firstPoint = "";
    List<LatLng> loadedVisitCoordinates = [];
    if (loadedVisitPoints.isNotEmpty) {
      firstPoint = loadedVisitPoints.first;
      for (int i = 0; i < loadedVisitPoints.length; i++) {
        LatLng c = await UtilGMap.getLatLng(loadedVisitPoints[i]);
        loadedVisitCoordinates.add(c);
      }
    }
    LatLng loadedMapCenter = await UtilGMap.getLatLng(firstPoint);

    if (mounted == true) {
      setState(() {
        _name = loadedName;
        _description = loadedDescription;
        _visitPoints = List.from(loadedVisitPoints);
        _visitCoordinates = List.from(loadedVisitCoordinates);
        _mapCenter = loadedMapCenter;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _updateTourDetail();
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
    List<Widget> visitPointWidgets = [];
    Set<Marker> markers = {};

    for (int i = 0; i < _visitCoordinates.length; i++) {
      String idMarkerAndPolyline = (i + 1).toString();
      String visitPointLabel = idMarkerAndPolyline +
          Constants.stringTourRouteSeparator +
          _visitPoints[i];

      visitPointWidgets.add(Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, Styling.paddingSmall),
        child: Text(visitPointLabel,
            style: const TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            )),
      ));

      markers.add(Marker(
        markerId: MarkerId(idMarkerAndPolyline),
        position: LatLng(
            _visitCoordinates[i].latitude, _visitCoordinates[i].longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueRed,
        ),
        infoWindow: InfoWindow(
          title: visitPointLabel,
        ),
        draggable: false,
      ));

      if (i > 0) {
        _addPolylines(
            _visitCoordinates[i - 1].latitude,
            _visitCoordinates[i - 1].longitude,
            _visitCoordinates[i].latitude,
            _visitCoordinates[i].longitude,
            idMarkerAndPolyline);
      }
    }

    List<Widget> mapChildren = [
      const Text(Constants.subtitleMap3),
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

    List<Widget> mainChildren = [
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
      const Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, Styling.paddingSmall),
        child: Text(Constants.subtitleTourVisits),
      ),
    ];

    List<Widget> columnChildren() {
      return mainChildren + visitPointWidgets + mapChildren;
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
