import 'package:flutter/material.dart';
import 'package:ghibli_movies/layers/data/constant/app_color.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            Icon(Icons.menu_book_sharp, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'About App',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
        elevation: 4,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'About Ghibli Movies',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text(
            'This app provides information about Studio Ghibli movies. '
            'Browse, search, and discover details about your favorite films.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 32),
          const Text(
            'Disclaimer',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'This app is not affiliated with Studio Ghibli. '
            'All movie data and images are for informational and educational purposes only.',
            style: TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }
}
