import 'package:flutter/material.dart';
import 'artwork.dart';

class ArtWorkDetails extends StatelessWidget {
  final ArtWork artWork;

  ArtWorkDetails({required this.artWork});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de l\'œuvre sélectionnée'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Selected size for the image :
            Container(
              width: double.infinity, // Takes the full width
              child: Image.asset('${artWork.image}', height: 500),
            ),
            Text(artWork.title, style: TextStyle(fontSize: 24)),
            Text('Artiste: ${artWork.artist}'),
            Text('Année: ${artWork.year.toString()}'),
          ],
        ),
      ),
    );
  }
}
