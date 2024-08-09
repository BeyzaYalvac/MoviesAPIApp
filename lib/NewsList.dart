import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterfilmleruygulamasi/ApiService.dart';
import 'package:flutterfilmleruygulamasi/MovieDetail.dart';

class PopularMoviePage extends StatefulWidget {
  const PopularMoviePage({super.key});

  @override
  State<PopularMoviePage> createState() => _PopularMoviePageState();
}

class _PopularMoviePageState extends State<PopularMoviePage> {
  Future<Map<String, dynamic>>? _moviesFuture;

  @override
  void initState() {
    super.initState();
    final api = ApiService();
    _moviesFuture = api.fetchPopularMovies();
  }

  @override
  Widget build(BuildContext context) {
    const String BASE_IMAGE = 'https://image.tmdb.org/t/p/w500';

    return Scaffold(

      body:
      Container(decoration: BoxDecoration(color: Colors.black),
        child: FutureBuilder(
          future: _moviesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              final popularMovies = snapshot.data?['results'] as List<dynamic>?;
              if (popularMovies == null || popularMovies.isEmpty) {
                return Center(child: Text('No movies available'));
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 6.0,
                      childAspectRatio: 0.70,
                      mainAxisSpacing: 6.0),
                  itemCount: popularMovies.length,
                  itemBuilder: (context, index) {
                    final popularMovie = popularMovies[index];
                    final backdropPath = popularMovie['backdrop_path'] ?? '';
                    final imageUrl = '$BASE_IMAGE$backdropPath';

                    return GestureDetector(
                      onTap:()=>Navigator.push(context,MaterialPageRoute(builder: (context)=> MovieDetails(MovieInfos: popularMovie, id: popularMovie['id'],))),
                      child: Card(
                        elevation: 16.0,
                        color: Color(0xffb30000),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      popularMovie['title'] ?? 'No title',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xffffcccc),

                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    popularMovie['overview'] ??
                                        'No overview available',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Color(0xffffcccc)),
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                color: Colors.black54,
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  children: [
                                    Text(
                                      popularMovie['vote_average']
                                          ?.toString() ?? '0.0',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    SizedBox(width: 4.0),
                                    Icon(Icons.star, color: Colors.yellow, size: 16.0),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            } else if (snapshot.hasError) {
              print('Error: ${snapshot.error}');
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return Center(child: Text('No data available'));
            }
          },
        ),
      ),
    );
  }
}
