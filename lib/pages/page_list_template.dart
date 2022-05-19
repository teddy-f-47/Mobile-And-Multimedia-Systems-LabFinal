import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:city_guide/styling.dart';
import 'package:city_guide/constants.dart';

class PageEvents extends StatefulWidget {
  const PageEvents({Key? key}) : super(key: key);

  @override
  PageEventsState createState() => PageEventsState();
}

class PageEventsState extends State<PageEvents> {
  int _numOfEvents = 0;

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
                //Add the list child element here
                return GestureDetector(
                  onTap: () {
                    ;
                  },
                  child: Container(
                    constraints: BoxConstraints(
                      minHeight: Styling.gapLarge,
                      minWidth: MediaQuery.of(context).size.width,
                    ),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          width: Styling.listItemImageWidth,
                          height: Styling.listItemImageHeight,
                          child: Image.network(
                              'https://picsum.photos/250?image=9'),
                        ), //Item Image
                        Row(
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsets.all(Styling.paddingSmall),
                              child: Text('title'),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(Styling.paddingSmall),
                              child: Text('desc'),
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
