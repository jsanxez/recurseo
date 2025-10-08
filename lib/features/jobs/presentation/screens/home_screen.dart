import 'package:flutter/material.dart';

/// Pantalla principal temporal - será reemplazada por JobFeedScreen
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recurseo - Construcción'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction, size: 80, color: Colors.orange),
            SizedBox(height: 24),
            Text(
              'En Construcción',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('JobFeedScreen próximamente'),
          ],
        ),
      ),
    );
  }
}
