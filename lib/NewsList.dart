import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterfilmleruygulamasi/ApiService.dart';
import 'package:flutterfilmleruygulamasi/MovieDetail.dart';
import 'package:number_paginator/number_paginator.dart';

class PopularMoviePage extends StatefulWidget {
  const PopularMoviePage({super.key});

  @override
  State<PopularMoviePage> createState() => _PopularMoviePageState();
}

class _PopularMoviePageState extends State<PopularMoviePage> {
  Future<Map<String, dynamic>>? _moviesFuture;
  String searchData = '';
  int currentPage=1;
  @override
  @override
  void initState() {
    super.initState();
    _fetchMovies();
  }

  void _fetchMovies() {
    final api = ApiService();
    setState(() {
      if (searchData.isEmpty) {
        _moviesFuture = api.fetchPopularMovies(currentPage + 1);
      } else {
        _moviesFuture = api.searchPopularMovies(searchData,currentPage+1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const String BASE_IMAGE = 'https://image.tmdb.org/t/p/w500';

    final NumberPaginatorController _controller = NumberPaginatorController();

    return Scaffold(
      body: Column(
        children: [

          Container(
            decoration: BoxDecoration(color: Colors.black),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: SearchBar(
                leading: Icon(Icons.search),
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.red[100]!),
                onChanged: (search) {
                  setState(() {
                    searchData = search.toLowerCase();
                    print(searchData);
                    _fetchMovies();
                  });
                },
              ),
            ),
          ),
          Container(width:MediaQuery.of(context).size.width,
          child: Center(child: Text("Popular Movies",
            style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 26),)),
              decoration: BoxDecoration(color: Colors.black,)),


          Expanded(
            child: Container(
              decoration: BoxDecoration(color: Colors.black),
              child: FutureBuilder(
                future: _moviesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasData) {
                    final popularMovies =
                        snapshot.data?['results'] as List<dynamic>?;
                    final filteredMovies = popularMovies?.where((movie) {
                          final title = (movie['title'] ?? '').toLowerCase();
                          return title.contains(searchData);
                        }).toList() ??
                        [];

                    if (filteredMovies.isEmpty) {
                      return Center(child: Text('No movies match your search'));
                    }

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 6.0,
                          childAspectRatio: 0.70,
                          mainAxisSpacing: 6.0,
                        ),
                        itemCount: filteredMovies.length,
                        itemBuilder: (context, index) {
                          final popularMovie = filteredMovies[index];
                          final backdropPath =
                              popularMovie['backdrop_path'] ?? '';
                          final imageUrl = '$BASE_IMAGE$backdropPath';

                          return GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MovieDetails(
                                          MovieInfos: popularMovie,
                                          id: popularMovie['id'],
                                        ))),
                            child: Card(
                              elevation: 16.0,
                              color: Color(0xffb30000),
                              child: Stack(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          style: TextStyle(
                                              color: Color(0xffffcccc)),
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
                                                    ?.toString() ??
                                                '0.0',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          SizedBox(width: 4.0),
                                          Icon(Icons.star,
                                              color: Colors.yellow, size: 16.0),
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
          ),
          NumberPaginator(
            numberPages: 200,
            controller: _controller,
config: NumberPaginatorUIConfig(height: 50,buttonSelectedBackgroundColor: Colors.red[100],
    buttonSelectedForegroundColor: Colors.black,
    buttonUnselectedForegroundColor: Colors.red,buttonTextStyle: TextStyle(fontWeight: FontWeight.w600) ),
            onPageChange: (_pagenumber) {
              setState(() {
                currentPage =_pagenumber;
                _fetchMovies();
              });
            },
            showNextButton: true,
            showPrevButton: true,
          )
        ],
      ),
    );
  }
}
