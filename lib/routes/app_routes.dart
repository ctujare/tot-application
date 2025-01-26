import 'package:flutter/material.dart';
import 'package:tot_app/screens/favourite_dogs.dart';
import 'package:tot_app/screens/journey_list.dart';
import 'package:tot_app/screens/live_location_screen.dart';

import '../models/dog_model.dart';
import '../screens/details_screen.dart';
import '../screens/home_screen.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case '/details':
        // get arguments from settings
        final args = settings.arguments as Dog;

        return MaterialPageRoute(builder: (_) => DetailsScreen(dog: args));

      case '/favourite-dogs':
        return MaterialPageRoute(builder: (_) => FavouriteDogs());

      case '/live-location':
        return MaterialPageRoute(builder: (_) => LiveLocationScreen());

      case '/journey-list':
        return MaterialPageRoute(builder: (_) => JourneyList());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
