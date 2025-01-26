// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tot_app/providers/dog_provider.dart';

import '../models/dog_model.dart';

class DetailsScreen extends StatefulWidget {
  final Dog dog;
  // final bool isFavorite;

  const DetailsScreen({
    super.key,
    required this.dog,
    // required this.isFavorite,
  });

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.dog.name}'),
        actions: [
          // Consumer<DogProvider>(builder: (context, dogProvider, child) {
          //   return IconButton(
          //     onPressed: () {
          //       dogProvider.toggleFavorite(widget.dog);
          //     },
          //     icon: (widget.isFavorite)
          //         ? const Icon(Icons.favorite_outlined)
          //         : const Icon(Icons.favorite_border),
          //   );
          // }),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                widget.dog.image!,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.dog.name!,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Breed Group: ${widget.dog.breedGroup!}",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Life Span: ${widget.dog.lifespan.toString()}",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Size: ${widget.dog.size!}",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(height: 10),
                    Text(
                      widget.dog.origin!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Temperament: ${widget.dog.temperament!}",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Description: ${widget.dog.description}",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
