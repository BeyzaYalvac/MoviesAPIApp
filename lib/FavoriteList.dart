import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterfilmleruygulamasi/NewsList.dart';
import 'package:flutterfilmleruygulamasi/askAI.dart';
import 'package:lottie/lottie.dart';

class FavoriteListPage extends StatefulWidget {
  const FavoriteListPage({super.key});

  @override
  State<FavoriteListPage> createState() => _FavoriteListPageState();
}

class _FavoriteListPageState extends State<FavoriteListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favorite Movies',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.black,
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red, Colors.black],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Text(
                  "Movie IT",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            ListTile(
              tileColor: Colors.red,
              leading: const Icon(Icons.moving_sharp, color: Colors.black),
              title: const Center(
                child: Text(
                  "Popular Films",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PopularMoviePage()),
                );
              },
            ),
            const SizedBox(height: 16.0),
            ListTile(
              tileColor: Colors.white,
              leading: const Icon(Icons.moving_sharp, color: Colors.black),
              title: const Center(
                child: Text(
                  "Your Favorite Films",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FavoriteListPage()),
                );
              },
            ),
            const SizedBox(height: 16.0),
            ListTile(
              tileColor: Colors.white,
              leading: const Icon(Icons.moving_sharp, color: Colors.black),
              title: const Center(
                child: Text(
                  "Ask AI",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChatBotPage()),
                );
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('SavedMovies').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.network(
                      'https://lottie.host/88af4fc2-181b-48c8-b6e3-29d04302433f/lVxc9O7EMx.json'),
                  const SizedBox(
                      height: 20), // Add space between animation and text
                  const Text(
                    'You don\'t have any favorite movie :(',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Text(
                    'Maybe you should look some popular movies or Tv Series',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PopularMoviePage()));
                    },
                    style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: const LinearBorder(side: BorderSide.none)),
                    child: const Text(
                      'Popular Movies',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            );
          }

          final documents = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final document = documents[index];
              final favoriteMovies = document.data() as Map<String, dynamic>;

              return Dismissible(
                key: Key(favoriteMovies['original_title'] ?? 'title'),
                onDismissed: (direction) async {
                  FirebaseFirestore favMovieDbObj = FirebaseFirestore.instance;
                  CollectionReference favmovieColRef =
                      favMovieDbObj.collection('SavedMovies');
                  await favmovieColRef
                      .doc(favoriteMovies['original_title'] ?? 'title')
                      .delete();
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    tileColor: Colors.red,
                    title: Center(
                        child: Text(
                      favoriteMovies['original_title'] ?? 'title',
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    )),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
