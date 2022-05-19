import 'package:flutter/material.dart';
import 'package:city_guide/styling.dart';
import 'package:city_guide/constants.dart';
import 'package:city_guide/viewmodels/placeVM.dart';
import 'package:city_guide/pages/page_reviews.dart';

import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:city_guide/util_gmap.dart';
import 'package:city_guide/util_ratingreview.dart';
import 'package:city_guide/util_FlutterTTS.dart';

class PagePlaceDetails extends StatefulWidget {
  const PagePlaceDetails({Key? key, required this.id}) : super(key: key);
  final int id;

  @override
  PagePlaceDetailsState createState() => PagePlaceDetailsState();
}

class PagePlaceDetailsState extends State<PagePlaceDetails> {
  String _name = '';
  String _description = '';
  String _placeId = '';
  int _ratingMaxVal = 0;
  num _rating = 0;
  String _location = '';
  List<String> _imageAssets = [];
  List<String> _videoAssets = [];

  late YoutubePlayerController _youtubePlayerController;
  bool _isYoutubePlayerReady = false;
  late PlayerState _youtubePlayerState;
  late YoutubeMetaData _youtubeMetaData;

  late FlutterTts _flutterTTS;
  String _flutterTTSLanguage = Constants.flutterTTSDefaultLanguage;
  bool _isFlutterTTSPlaying = false;

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

  void _updatePlaceDetail() async {
    var placeVM = await PlaceVM.create(widget.id);
    String loadedName = placeVM.getName();
    String loadedDescription = placeVM.getDescription();
    String loadedPlaceId = placeVM.getPlaceId();
    int loadedRatingMaxVal = placeVM.getRatingMaxVal();
    num loadedRating = await placeVM.getRating();
    String loadedLocation = placeVM.getLocation();
    List<String> loadedImageAssets = placeVM.getImageAssets();
    List<String> loadedVideoAssets = placeVM.getVideoAssets();
    String loadedInitialVideoId = Constants.videoIdDefault;
    if (loadedVideoAssets.isNotEmpty) {
      loadedInitialVideoId = loadedVideoAssets.first;
    }

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
        _videoAssets = List.from(loadedVideoAssets);
        _youtubePlayerController = YoutubePlayerController(
          initialVideoId: loadedInitialVideoId,
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
          ),
        )..addListener(listener);
        _mapCenter = loadedMapCenter;
      });
    }
  }

  void listener() {
    if (_isYoutubePlayerReady &&
        mounted &&
        !_youtubePlayerController.value.isFullScreen) {
      if (mounted == true) {
        setState(() {
          _youtubePlayerState = _youtubePlayerController.value.playerState;
          _youtubeMetaData = _youtubePlayerController.metadata;
        });
      }
    }
  }

  void _initializeTTS() async {
    _flutterTTS = FlutterTts();
    await _flutterTTS.awaitSpeakCompletion(true);
    await _flutterTTS.getDefaultEngine;
    _flutterTTS.setStartHandler(() {
      if (mounted == true) {
        setState(() {
          _isFlutterTTSPlaying = true;
        });
      }
    });
    _flutterTTS.setCompletionHandler(() {
      if (mounted == true) {
        setState(() {
          _isFlutterTTSPlaying = false;
        });
      }
    });
    _flutterTTS.setCancelHandler(() {
      if (mounted == true) {
        setState(() {
          _isFlutterTTSPlaying = false;
        });
      }
    });
    _flutterTTS.setErrorHandler((msg) {
      if (mounted == true) {
        setState(() {
          _isFlutterTTSPlaying = false;
        });
      }
    });
  }

  void _changeLanguageTTS(String selectedLanguage) async {
    bool available = await _flutterTTS.isLanguageAvailable(selectedLanguage);
    if (available) {
      if (mounted == true) {
        setState(() {
          _flutterTTSLanguage = selectedLanguage;
          _flutterTTS.setLanguage(_flutterTTSLanguage);
        });
      }
    }
  }

  @override
  void initState() {
    _updatePlaceDetail();
    _youtubeMetaData = const YoutubeMetaData();
    _youtubePlayerState = PlayerState.unknown;
    _initializeTTS();
    super.initState();
  }

  @override
  void deactivate() {
    _youtubePlayerController.pause();
    _flutterTTS.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
    _mapController.dispose();
    _youtubePlayerController.dispose();
    _flutterTTS.stop();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    Widget placeMainImage =
        Image.asset(Constants.imageAssetPath + Constants.imageAssetDefault);
    if (_imageAssets.isNotEmpty) {
      placeMainImage = Image.asset(Constants.imageAssetPath + _imageAssets[0]);
    }
    List<Widget> placeAdditionalImages = [];
    if (_imageAssets.length > 1) {
      placeAdditionalImages.add(const Padding(
          padding: EdgeInsets.fromLTRB(0, Styling.paddingSmall, 0, 0),
          child: Text(Constants.subtitleImage)));
      for (int i = 1; i < _imageAssets.length; i++) {
        placeAdditionalImages
            .add(Image.asset(Constants.imageAssetPath + _imageAssets[i]));
      }
    }

    List<Widget> placeVideos = [];
    if (_videoAssets.isNotEmpty) {
      placeVideos.add(const Padding(
          padding: EdgeInsets.fromLTRB(0, Styling.paddingSmall, 0, 0),
          child: Text(Constants.subtitleVideo)));
      placeVideos.add(
        YoutubePlayer(
          controller: _youtubePlayerController,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.amber,
          progressColors: const ProgressBarColors(
            playedColor: Colors.amber,
            handleColor: Colors.amberAccent,
          ),
          onReady: () {
            _isYoutubePlayerReady = true;
          },
          onEnded: (data) {
            _youtubePlayerController.load(_videoAssets[
                (_videoAssets.indexOf(data.videoId) + 1) %
                    _videoAssets.length]);
          },
        ),
      );
      placeVideos.add(const Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, Styling.gapSmall)));
      placeVideos.add(
        Row(
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width *
                  Styling.buttonWidthRelativeHalf,
              height: Styling.buttonHeight,
              child: ElevatedButton(
                onPressed: () {
                  String currentVideoId =
                      _youtubePlayerController.metadata.videoId;
                  int currentVideoIndex = _videoAssets.indexOf(currentVideoId);
                  _youtubePlayerController.load(_videoAssets[
                      (currentVideoIndex - 1) % _videoAssets.length]);
                },
                child: const Text(Constants.btnLabelVideoPrev),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width *
                  Styling.buttonWidthRelativeHalf,
              height: Styling.buttonHeight,
              child: ElevatedButton(
                onPressed: () {
                  String currentVideoId =
                      _youtubePlayerController.metadata.videoId;
                  int currentVideoIndex = _videoAssets.indexOf(currentVideoId);
                  _youtubePlayerController.load(_videoAssets[
                      (currentVideoIndex + 1) % _videoAssets.length]);
                },
                child: const Text(Constants.btnLabelVideoNext),
              ),
            ),
          ],
        ),
      );
      placeVideos.add(const Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, Styling.paddingMedium)));
    }

    String placeRatingMerged =
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
      placeMainImage,
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
            child: Text(placeRatingMerged,
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
      Row(
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width *
                Styling.buttonWidthRelativeHalf,
            height: Styling.buttonHeight,
            child: ElevatedButton(
              onPressed: () {
                UtilFlutterTTS.speak(_flutterTTS, _name, _description);
              },
              child:
                  const Icon(Icons.play_arrow, size: 30, color: Colors.green),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width *
                Styling.buttonWidthRelativeHalf,
            height: Styling.buttonHeight,
            child: ElevatedButton(
              onPressed: () async {
                int TTSStopped = await UtilFlutterTTS.stop(_flutterTTS);
                if (TTSStopped == 1 && mounted == true) {
                  setState(() => _isFlutterTTSPlaying = false);
                }
              },
              child: const Icon(Icons.stop, size: 30, color: Colors.blueGrey),
            ),
          ),
        ],
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
      return mainChildren + mapChildren + placeAdditionalImages + placeVideos;
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
