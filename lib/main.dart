import 'package:flutter/material.dart';
import 'package:city_guide/styling.dart';
import 'package:city_guide/constants.dart';

import 'package:city_guide/pages/page_events.dart';
import 'package:city_guide/pages/page_places.dart';
import 'package:city_guide/pages/page_accommodations.dart';
import 'package:city_guide/pages/page_tours.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Constants.appTitle,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: const MyHomePage(title: Constants.appTitle),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Main Image
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height *
                  Styling.imageHeightRelative,
              child: Image.asset(
                  Constants.imageAssetPath + Constants.imageAssetDefault),
            ),
            // Events
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: Styling.buttonHeight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PageEvents()),
                  );
                },
                child: const Text(Constants.btnLabelEvents),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: Styling.gapSmall,
            ),
            // Places
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: Styling.buttonHeight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PagePlaces()),
                  );
                },
                child: const Text(Constants.btnLabelPlaces),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: Styling.gapSmall,
            ),
            // Accommodations
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: Styling.buttonHeight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PageAccommodations()),
                  );
                },
                child: const Text(Constants.btnLabelAccommodations),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: Styling.gapSmall,
            ),
            // Trips
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: Styling.buttonHeight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PageTours()),
                  );
                },
                child: const Text(Constants.btnLabelTrips),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: Styling.gapSmall,
            ),
          ],
        ),
      ),
    );
  }
}
