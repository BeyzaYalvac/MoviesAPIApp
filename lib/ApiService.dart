import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String BASE_URL = 'https://api.themoviedb.org/3';
  final String ACCESS_TOKEN =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyN2Y3MjVmZGYwNTI3MWUwYjRlNGZhN2ZjN2RiMmFhMiIsIm5iZiI6MTcyMzIwODMwMC4xODgwMjYsInN1YiI6IjY2YjYxMTZmNDA1OWZhYzQ1NTEyNTM3NSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.KGuZaOiM_0T0l9ZMJ1tmwcNOLC-JRua8zmVMNTwMmgI';

  Future<Map<String, dynamic>> fetchPopularMovies(int currentPage) async {
    final url = Uri.parse('$BASE_URL/movie/popular?language=en-US&page=$currentPage');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $ACCESS_TOKEN',
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
var data=jsonDecode(response.body);
print(data);
      return data;

    } else {

      throw Exception('Failed to load movies: ${response.statusCode}');
    }
  }



  Future<Map<String,dynamic>> searchPopularMovies(String query, int currentPage) async{
    final url=Uri.parse('$BASE_URL/search/movie?query=$query&page=$currentPage');
    final responseSearch=await http.get(url,headers:{
      'Authorization':'Bearer $ACCESS_TOKEN',
      'Content-Type': 'application/json',
    });
    if(responseSearch.statusCode==200) {
      var dataSearch = jsonDecode(responseSearch.body);
      print('search data= $dataSearch');
      return dataSearch;
    }else {

      throw Exception('Failed to search movies: ${responseSearch.statusCode}');
    }
    }
  }

