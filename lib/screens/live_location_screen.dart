import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../providers/location_provider.dart';

class LiveLocationScreen extends StatefulWidget {
  const LiveLocationScreen({super.key});

  @override
  _LiveLocationScreenState createState() => _LiveLocationScreenState();
}

class _LiveLocationScreenState extends State<LiveLocationScreen> {
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final locationProvider =
          Provider.of<LocationProvider>(context, listen: false);
      locationProvider.getCurrentLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Live Location Tracking'),
      ),
      body: Stack(
        children: [
          Consumer<LocationProvider>(
              builder: (context, locationProvider, child) {
            _mapController?.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: locationProvider.currentLocation,
                  zoom: 15,
                ),
              ),
            );
            return GoogleMap(
              initialCameraPosition: CameraPosition(
                target: locationProvider.currentLocation,
                zoom: 15,
              ),
              myLocationEnabled: true,
              markers: {
                if (locationProvider.sourceLocation != null)
                  Marker(
                    markerId: MarkerId('source'),
                    position: locationProvider.sourceLocation!,
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueGreen),
                    infoWindow: InfoWindow(title: 'Source'),
                  ),
                if (locationProvider.destinationLocation != null)
                  Marker(
                    markerId: MarkerId('destination'),
                    position: locationProvider.destinationLocation!,
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueRed),
                    infoWindow: InfoWindow(title: 'Destination'),
                  ),
              },
              polylines: {
                Polyline(
                  polylineId: PolylineId('route'),
                  color: Colors.blue,
                  width: 5,
                  points: locationProvider.routePoints,
                ),
              },
              onMapCreated: (controller) => _mapController = controller,
            );
          }),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!locationProvider.isTracking)
                  ElevatedButton(
                    onPressed: locationProvider.startTracking,
                    child: Text('Start Tracking'),
                  ),
                if (locationProvider.isTracking)
                  ElevatedButton(
                    onPressed: locationProvider.stopTracking,
                    child: Text('Stop Tracking'),
                  ),
                if (locationProvider.destinationLocation != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      'Distance: ${locationProvider.totalDistance.toStringAsFixed(2)} meters\n'
                      'Duration: ${locationProvider.getJourneyDuration().inMinutes} minutes',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
