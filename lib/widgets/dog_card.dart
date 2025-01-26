import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tot_app/providers/dog_provider.dart';

import '../models/dog_model.dart';

class DogCard extends StatelessWidget {
  final Dog dog;
  final bool isFavorite;

  const DogCard({
    super.key,
    required this.dog,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(
        '/details',
        arguments: dog,
      ),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  dog.image!,
                  width: MediaQuery.of(context).size.width,
                  height: 80,
                  fit: BoxFit.cover,
                ),
                SizedBox(
                  height: 8,
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Name: ${dog.name}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              "Breed: ${dog.breedGroup}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Consumer<DogProvider>(
                        builder: (context, dogProvider, child) {
                          return IconButton(
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.grey,
                            ),
                            onPressed: () {
                              if (isFavorite) {
                                dogProvider.removeFromFavorites(dog.id!);
                              } else {
                                dogProvider.saveToFavorites(dog);
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
