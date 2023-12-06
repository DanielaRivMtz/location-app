import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Location Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ignore: unused_field
  Position? _position;

  void getCurrentLocation() async {
    Position position = await determinePosition();

    setState(() {
      _position = position;
    });
    // ignore: avoid_print
    //print(position.latitude);
    // ignore: avoid_print
    //print(position.longitude);
  }

  Future<Position> determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('error');
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  void refresh() async {
    getCurrentLocation();
    Timer.periodic(const Duration(minutes: 2), (timer) {
      getCurrentLocation();
    });
  }

  Widget buildLocationButtom() => FloatingActionButton.extended(
        icon: const Icon(Icons.location_pin),
        backgroundColor: Colors.blue,
        label: const Text(
          'Localizar',
          style: TextStyle(fontSize: 16),
        ),
        onPressed: () {
          refresh();
        },
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Localización'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      floatingActionButton: buildLocationButtom(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_position != null)
              Text(
                // ignore: prefer_interpolation_to_compose_strings
                'Localización Actual\n\n Latitud:' +
                    _position!.latitude.toString() +
                    '\nLongitud: ' +
                    _position!.longitude.toString() +
                    '\n\n',

                style: const TextStyle(
                  fontSize: 20,
                ),
              )
            else
              const Text('No Location Data', 
              style: TextStyle(
                fontSize: 20
                ),
              )
          ],
        ),
      ),
    );
  }
}
