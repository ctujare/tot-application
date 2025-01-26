import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/dog_model.dart';
import '../providers/dog_provider.dart';
import '../widgets/dog_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<DogProvider>(context, listen: false);
      provider.fetchDogs();
      provider.loadFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Center(
                child: Text(
                  'TOT App',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            ListTile(
              title: const Text('Favourite Dogs'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed('/favourite-dogs');
              },
            ),
            ListTile(
              title: const Text('New Journey'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed('/live-location');
              },
            ),
            ListTile(
              title: const Text('All Journeys'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed('/journey-list');
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Home Screen'),
        actions: [
          // IconButton(
          //   onPressed: () {
          //     Navigator.of(context).pushNamed('/journey-list');
          //   },
          //   icon: Icon(Icons.pin_drop_outlined),
          // ),
          // IconButton(
          //   onPressed: () {
          //     Navigator.of(context).pushNamed('/live-location');
          //   },
          //   icon: Icon(Icons.map),
          // ),
          Consumer<DogProvider>(builder: (context, dogProvider, child) {
            return IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                dogProvider.fetchDogs();
              },
            );
          }),
        ],
      ),
      body: Consumer<DogProvider>(builder: (context, dogProvider, child) {
        if (dogProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (dogProvider.error != null) {
          return Center(child: Text("Error : ${dogProvider.error}"));
        } else {
          // Add Serach bar here

          return Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: FormField(
                  builder: (field) => TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Search',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onChanged: (value) {
                      dogProvider.query = value;
                    },
                  ),
                ),
              ),
              Expanded(
                child: (dogProvider.query != "" &&
                        dogProvider.filteredDogs.isEmpty)
                    ? Center(
                        child: Text("No Dogs Found!!!"),
                      )
                    : GridView.builder(
                        padding: EdgeInsets.all(8.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // 2 columns
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                          // childAspectRatio: 3 / 2, // Adjust card aspect ratio
                        ),
                        itemCount: dogProvider.query != ""
                            ? dogProvider.filteredDogs.length
                            : dogProvider.dogs.length,
                        itemBuilder: (context, index) {
                          final Dog dog = dogProvider.query != ""
                              ? dogProvider.filteredDogs[index]
                              : dogProvider.dogs[index];
                          final isFavorite = dogProvider.favoriteDogs
                              .any((favDog) => favDog.id == dog.id);
                          return DogCard(dog: dog, isFavorite: isFavorite);
                        },
                      ),
              ),
            ],
          );
        }
      }),
    );
  }
}
