import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profilo Utente'),
      ),
      body: const Center(
        child: Text('Informazioni utente e impostazioni.'),
      ),
    );
  }
}
