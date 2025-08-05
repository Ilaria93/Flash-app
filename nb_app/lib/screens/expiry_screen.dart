import 'package:flutter/material.dart';

class ExpiryScreen extends StatelessWidget {
  const ExpiryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scadenze Ingredienti'),
      ),
      body: const Center(
        child: Text('Gestisci le scadenze dei tuoi ingredienti.'),
      ),
    );
  }
}
