import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfilmleruygulamasi/FavoriteList.dart';
import 'package:flutterfilmleruygulamasi/NewsList.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'askAI.dart';

class MovieDetails extends StatefulWidget {
  final Map<String, dynamic> MovieInfos;
  final int id;

  MovieDetails({super.key, required this.MovieInfos, required this.id});

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {

  bool isFavorite = false;
  @override
  void initState() {
    super.initState();
    getFavorite();
  }

  Future<void> _setFavoriteState(bool isFavorite) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('favorite_${widget.id}', isFavorite);

  }

  Future<void> getFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final bool? getfav = prefs.getBool('favorite_${widget.id}');
    setState(() {
      isFavorite = getfav ?? false;
    });
  }

  Widget build(BuildContext context) {

    final movieInfo = widget.MovieInfos;

    Future<void> addFavoriteMoviesToDB() async {
      FirebaseFirestore favMovieDbObj = FirebaseFirestore.instance;
      CollectionReference favmovieColRef =
      favMovieDbObj.collection('SavedMovies');

      await favmovieColRef.doc(movieInfo['title']).set(widget.MovieInfos);
    }

    Future<void> deleteFavoriteMoviesToDB() async {
      FirebaseFirestore favMovieDbObj = FirebaseFirestore.instance;
      CollectionReference favmovieColRef =
      favMovieDbObj.collection('SavedMovies');
      await favmovieColRef.doc(movieInfo['title']).delete();
    }
    Future<void> _toggleFavorite() async {

      setState(() {
        isFavorite = !isFavorite;
      });

      await _setFavoriteState(isFavorite);

      if (isFavorite) {
        await addFavoriteMoviesToDB();
      } else {
        await deleteFavoriteMoviesToDB();
      }
    }
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Colors.black,
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
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                      'https://image.tmdb.org/t/p/w500${movieInfo['backdrop_path']}',
                    ),
                    fit: BoxFit.fitHeight),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.44,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.56,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 60),
                    Row(
                      children: [
                        Text(
                          'Rating: ${movieInfo['vote_average'] ?? '0.0'}', // Show movie rating
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          icon: isFavorite
                              ? Icon(
                                  Icons.favorite_rounded,
                                  color: Colors.red,
                                )
                              : Icon(
                                  Icons.favorite_border,
                                  color: Colors.red,
                                ),
                          onPressed: () {
                            _toggleFavorite();
                          },
                        )
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Release Date: ${movieInfo['release_date'] ?? 'Unknown'}', // Show release date
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Overview',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(height: 16),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          movieInfo['overview'] ??
                              'No overview available', // Show movie overview
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.4,
            left: MediaQuery.of(context).size.width * 0.1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      movieInfo['title'] ?? 'No title',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
