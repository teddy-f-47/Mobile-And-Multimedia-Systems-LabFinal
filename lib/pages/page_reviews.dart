import 'package:flutter/material.dart';
import 'package:city_guide/styling.dart';
import 'package:city_guide/constants.dart';
import 'package:city_guide/util_gplace.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:url_launcher/url_launcher.dart';

class PageReviews extends StatefulWidget {
  const PageReviews({Key? key, required this.name, required this.placeId})
      : super(key: key);
  final String name;
  final String placeId;

  @override
  PageReviewsState createState() => PageReviewsState();
}

class PageReviewsState extends State<PageReviews> {
  List<Review>? _reviews;

  void _updateReviews() async {
    var placeDetails = await UtilGPlace.create(widget.placeId);
    List<Review>? loadedReviews = placeDetails.reviews;
    if (mounted == true) {
      setState(() {
        _reviews = loadedReviews;
      });
    }
  }

  @override
  void initState() {
    _updateReviews();
    super.initState();
  }

  Widget _reviewListBuilder() {
    if (_reviews == null) {
      return const Text(Constants.errorMessageNoReviews);
    }
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _reviews!.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          constraints: BoxConstraints(
            minHeight: Styling.gapLarge,
            minWidth: MediaQuery.of(context).size.width,
          ),
          child: Column(
            children: <Widget>[
              Text(_reviews![index].authorName,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(Constants.subtitleRating +
                  _reviews![index].rating.toStringAsFixed(1)),
              Text(_reviews![index].text),
            ],
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
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
            const Padding(
              padding: EdgeInsets.fromLTRB(0, Styling.paddingSmall, 0, 0),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(widget.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  )),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, Styling.paddingSmall),
            ),
            const Align(
              alignment: Alignment.center,
              child: Text(Constants.subtitleReviews,
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, Styling.paddingSmall),
            ),
            Align(
              alignment: Alignment.center,
              child: InkWell(
                child: const Text(Constants.btnLabelWriteReview,
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                      decoration: TextDecoration.underline,
                    )),
                onTap: () {
                  String urlQry = widget.placeId;
                  String gPlaceUrl = Constants.gPlaceWriteReviewUri + urlQry;
                  Uri uri = Uri.parse(gPlaceUrl);
                  launchUrl(uri);
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, Styling.paddingMedium),
            ),
            _reviewListBuilder(),
          ],
        ),
      ),
    );
  }
}
