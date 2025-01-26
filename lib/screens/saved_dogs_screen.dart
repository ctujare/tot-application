import 'package:flutter/material.dart';

class SavedDogsScreen extends StatefulWidget {
  const SavedDogsScreen({super.key});

  @override
  State<SavedDogsScreen> createState() => _SavedDogsScreenState();
}

class _SavedDogsScreenState extends State<SavedDogsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Dogs Screen'),
      ),
      body: const Center(
        child: Text('Saved Dogs Screen'),
      ),
    );
  }
}
