import 'package:flutter/material.dart';

class MovieDetails extends StatefulWidget {
  final Map<String, dynamic> MovieInfos;
  final int id;

  MovieDetails({super.key, required this.MovieInfos, required this.id});

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  @override
  Widget build(BuildContext context) {
    final movieInfo = widget.MovieInfos;

    return Scaffold(
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
                  fit: BoxFit.fitHeight
                ),
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
                    Text(
                      'Rating: ${movieInfo['vote_average'] ?? '0.0'}', // Show movie rating
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
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
                          movieInfo['overview'] ?? 'No overview available', // Show movie overview
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
                      movieInfo['title'] ?? 'No title', // Show movie title
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
