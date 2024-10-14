import 'package:flutter/material.dart';
import 'ApiService.dart';

class BestOfArtists extends StatefulWidget {
  const BestOfArtists({super.key});

  @override
  State<BestOfArtists> createState() => _BestOfArtistsState();
}

class _BestOfArtistsState extends State<BestOfArtists> {
  Future<Map<String, dynamic>>? _artistFuture;
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    _fetchArtists();
  }

  void _fetchArtists() {
    final api = ApiService();
    setState(() {
      _artistFuture = api.getPopularArtist('day', currentPage + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _artistFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final artists = snapshot.data!['results'] as List<dynamic>? ?? [];

              if (artists.isEmpty) {
                return const Center(child: Text('No artists found.'));
              }

              return ListView.builder(
                itemCount: artists.length,
                itemBuilder: (context, index) {
                  final artist = artists[index];
                  return ListTile(
                    title: Text(artist['name']),
                  );
                },
              );
            }
            return const Center(child: Text('No data available.'));
          },
        ),
      ),
    );
  }
}
