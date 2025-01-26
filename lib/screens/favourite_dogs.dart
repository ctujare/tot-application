import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/dog_model.dart';
import '../providers/dog_provider.dart';

class FavouriteDogs extends StatefulWidget {
  const FavouriteDogs({super.key});

  @override
  State<FavouriteDogs> createState() => _FavouriteDogsState();
}

class _FavouriteDogsState extends State<FavouriteDogs> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<DogProvider>(context, listen: false);
      provider.loadFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favourite Dogs Screen'),
      ),
      body: Consumer<DogProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (provider.favoriteDogs.isEmpty) {
            return const Center(
              child: Text('No favourite dogs!!!'),
            );
          } else {
            return ListView.builder(
              itemCount: provider.favoriteDogs.length,
              itemBuilder: (context, index) {
                final Dog dog = provider.favoriteDogs[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('/details', arguments: dog);
                  },
                  child: ListTile(
                    leading: IconButton(
                      onPressed: () {
                        provider.removeFromFavorites(dog.id!);
                      },
                      icon: Icon(
                        Icons.delete_forever_outlined,
                        color: Colors.red,
                      ),
                    ),
                    title: Text(dog.name!),
                    subtitle: Text(dog.breedGroup!),
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
