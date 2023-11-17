import 'package:flutter/material.dart';
import 'artwork.dart';
import 'artwork_details.dart';
import 'todo_list.dart';
import 'chrono.dart';
import 'animations.dart';

// Widget principal de l'application
class ArtGalleryApp extends StatefulWidget {
  @override
  _ArtGalleryAppState createState() => _ArtGalleryAppState();
}

class _ArtGalleryAppState extends State<ArtGalleryApp> {
  // Variable pour contenir l'état du thème (jour/nuit)
  bool isNightMode = false;

  // Liste des œuvres d'art à afficher dans la galerie
  final List<ArtWork> artWorks = [
    ArtWork(
        title: 'Voiture Taxi Grenouille',
        artist: 'Minunn',
        image: 'prof1.png',
        year: 2023),
    ArtWork(
        title: 'Personne qui joue au billard',
        artist: 'Starquad',
        image: 'prof2.png',
        year: 2022),
    ArtWork(
        title: 'Spooky Night (Halloween 2023)',
        artist: 'TRICKLASH',
        image: 'prof3.png',
        year: 2023),
  ];

  // Variable pour contenir l'état de l'effet de survol sur le bouton de changement de thème
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Art Gallery',
      theme: isNightMode
          ? ThemeData.dark()
          : ThemeData.light(), // Changement de thème basé sur isNightMode
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: Text('The test app !'),
            bottom: TabBar(
              tabs: [
                Tab(text: 'Art Gallery'),
                Tab(text: 'Todo List'),
                Tab(text: 'Chrono'),
                Tab(text: 'Animations'),
              ],
            ),
          ),
          body: Stack(
            children: [
              TabBarView(
                children: [
                  // Onglet Galerie d'art
                  CustomScrollView(
                    slivers: <Widget>[
                      SliverAppBar(
                        pinned: true,
                        flexibleSpace: FlexibleSpaceBar(
                          title: Text('Art Gallery'),
                        ),
                      ),
                      // Liste des œuvres d'art
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            final artWork = artWorks[index];
                            // Affichage de l'œuvre d'art dans un Hero pour l'animation de transition
                            return Hero(
                              tag: 'artwork$index',
                              child: InkWell(
                                onTap: () {
                                  // Navigation vers ArtWorkDetails au clic
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          ArtWorkDetails(artWork: artWork),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        const begin = Offset(1.0, 0.0);
                                        const end = Offset.zero;
                                        const curve = Curves.easeInOut;
                                        var tween = Tween(
                                                begin: begin, end: end)
                                            .chain(CurveTween(curve: curve));
                                        var offsetAnimation =
                                            animation.drive(tween);
                                        // Animation de transition Slide
                                        return SlideTransition(
                                            position: offsetAnimation,
                                            child: child);
                                      },
                                    ),
                                  );
                                },
                                // Affichage des détails de l'œuvre d'art dans un ListTile
                                child: ListTile(
                                  leading: Image.asset(
                                    '${artWork.image}',
                                    height: 300.0,
                                  ),
                                  title: Text(artWork.title),
                                  subtitle: Text(
                                      '${artWork.artist}, ${artWork.year.toString()}'),
                                ),
                              ),
                            );
                          },
                          childCount: artWorks.length,
                        ),
                      ),
                    ],
                  ),
                  // Onglet Liste de tâches
                  TodoList(),
                  // Onglet Chronomètre
                  Chronometer(),
                  AnimationsWidget(),
                ],
              ),
              // Bouton de changement de thème
              Positioned(
                bottom: 16.0,
                right: 16.0,
                child: MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      isHovered = true;
                    });
                  },
                  onExit: (_) {
                    setState(() {
                      isHovered = false;
                    });
                  },
                  child: AnimatedTheme(
                    duration: Duration(milliseconds: 200),
                    data: isNightMode ? ThemeData.dark() : ThemeData.light(),
                    child: InkWell(
                      onTap: () {
                        // Changement de thème au clic
                        setState(() {
                          isNightMode = !isNightMode;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Icon(
                          Icons.brightness_6,
                          color: isNightMode
                              ? Colors.deepPurple
                              : (isHovered
                                  ? Colors.blue.withOpacity(0.8)
                                  : Colors.blue),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
