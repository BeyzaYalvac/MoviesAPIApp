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
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu, color: Colors.white),
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
            DrawerHeader(
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
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            ListTile(
              tileColor: Colors.red,
              leading: Icon(Icons.moving_sharp, color: Colors.black),
              title: Center(
                child: Text(
                  "Popular Films",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PopularMoviePage()),
                );
              },
            ),
            SizedBox(height: 16.0),
            ListTile(
              tileColor: Colors.white,
              leading: Icon(Icons.moving_sharp, color: Colors.black),
              title: Center(
                child: Text(
                  "Your Favorite Films",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FavoriteListPage()),
                );
              },
            ),
            SizedBox(height: 16.0),
            ListTile(
              tileColor: Colors.white,
              leading: Icon(Icons.moving_sharp, color: Colors.black),
              title: Center(
                child: Text(
                  "Ask AI",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatBotPage()),
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
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.network(
                      'https://lottie.host/88af4fc2-181b-48c8-b6e3-29d04302433f/lVxc9O7EMx.json'),
                  SizedBox(height: 20), // Add space between animation and text
                  Text(
                    'You don\'t have any favorite movie :(',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Maybe you should look some popular movies or Tv Series',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PopularMoviePage()));
                      },
                      child: Text('Popular Movies',style: TextStyle(color:Colors.white),),
                  style: OutlinedButton.styleFrom(backgroundColor: Colors.red,shape:LinearBorder(side: BorderSide.none) ),)
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
                child: Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

                  child: ListTile(
                    tileColor: Colors.red,

                    title: Center(child: Text(favoriteMovies['original_title'] ?? 'title',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)),
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
