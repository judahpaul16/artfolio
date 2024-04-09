import 'package:flutter/material.dart';
import 'artwork.dart';

class ArtworkDetailPage extends StatelessWidget {
  final Artwork artwork;

  const ArtworkDetailPage({Key? key, required this.artwork}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(artwork.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(artwork.imageUrl),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                artwork.artistName,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Artwork details or description here...',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
