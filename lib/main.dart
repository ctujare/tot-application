import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tot_app/providers/dog_provider.dart';
import 'providers/location_provider.dart';
import 'routes/app_routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DogProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter App',
        theme: ThemeData.light(),
        onGenerateRoute: AppRoutes.generateRoute,
        initialRoute: '/',
      ),
    );
  }
}
