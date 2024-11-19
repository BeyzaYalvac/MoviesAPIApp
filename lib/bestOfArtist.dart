import 'package:flutter/material.dart';
import 'ApiService.dart';

class BestOfArtists extends StatefulWidget {
  const BestOfArtists({super.key});

  @override
  State<BestOfArtists> createState() => _BestOfArtistsState();
}

class _BestOfArtistsState extends State<BestOfArtists> {
  Future<Map<String, dynamic>>? _artistFuture;


  @override
  void initState() {
    super.initState();
    _fetchArtists();
  }

  void _fetchArtists() {
    final api = ApiService();
    setState(() {
      _artistFuture = api.getPopularArtist('day');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Best of Artists')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _artistFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}\nPlease try again later.'),
            );
          } else if (snapshot.hasData) {
            final artists = snapshot.data!['results'] as List<dynamic>? ?? [];

            if (artists.isEmpty) {
              return const Center(child: Text('No artists found.'));
            }

            return ListView.builder(
              itemCount: artists.length,
              itemBuilder: (context, index) {

                final artist = artists[index];
                if(index<10){
                return ListTile(
                  leading: Text((index+1).toString()),
                  tileColor: Colors.orangeAccent[100],
                  trailing:Text(artist['gender']==0 ? 'Woman' : 'Boy',style: artist['gender']==0?TextStyle(color: Colors.pink):TextStyle(color: Colors.blue),),
                  title: Text(artist['name'] ?? 'Unknown Artist'),
                );}
                else{
                  return ListTile(
                    leading: Text((index+1).toString()),
                    tileColor: Colors.orange,
                    trailing:Text(artist['gender']==0 ? 'Woman' : 'Boy',style: artist['gender']==0?TextStyle(color: Colors.pink):TextStyle(color: Colors.blue),),
                    title: Text(artist['name'] ?? 'Unknown Artist'),
                  );}
                }

            );
          }
          return const Center(child: Text('No data available.'));
        },
      ),
    );
  }
}
