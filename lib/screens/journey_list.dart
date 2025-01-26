import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tot_app/models/saved_jorney.dart';

import '../providers/location_provider.dart';

class JourneyList extends StatefulWidget {
  const JourneyList({super.key});

  @override
  State<JourneyList> createState() => _JourneyListState();
}

class _JourneyListState extends State<JourneyList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final locationProvider =
          Provider.of<LocationProvider>(context, listen: false);
      locationProvider.fetchAndSetLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journey List'),
      ),
      body: Consumer<LocationProvider>(
        builder: (context, locationProvider, child) {
          if (locationProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (locationProvider.savedJourneys.isEmpty) {
            return const Center(
              child: Text('No saved journeys!!!'),
            );
          } else {
            return ListView.builder(
              itemCount: locationProvider.savedJourneys.length,
              itemBuilder: (context, index) {
                final SavedJourney journey =
                    locationProvider.savedJourneys[index];
                return GestureDetector(
                  onTap: () {
                    locationProvider.setSourceLocation(
                        journey.sourceLat, journey.sourceLng);
                    locationProvider.setDestinationLocation(
                        journey.destinationLat, journey.destinationLng);
                    Navigator.of(context).pushNamed('/live-location');
                  },
                  child: ListTile(
                    leading: IconButton(
                      onPressed: () {
                        locationProvider.deleteJourney(journey.id!);
                      },
                      icon: Icon(
                        Icons.delete_forever_outlined,
                        color: Colors.red,
                      ),
                    ),
                    title: Text(
                        "${journey.sourceLat.toString()} - ${journey.sourceLng.toString()}"),
                    subtitle: Text(
                        "${journey.destinationLat} - ${journey.destinationLng}"),
                    trailing: Text(journey.distance.toStringAsFixed(2)),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
