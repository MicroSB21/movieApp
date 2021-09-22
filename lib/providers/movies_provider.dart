import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movies/helpers/debouncer.dart';
import 'package:movies/models/models.dart';

class MoviesProvider extends ChangeNotifier {

  String _baseUrl   = 'api.themoviedb.org';
  String _apiKey    = '407365db77e8c3569f766c65aa15bfdc';
  String _language  = 'es-ES';

  List<Movie> onDisplayMovies = [];
  List<Movie> popularmovies = [];
  List<Movie> topRatedMovies = [];

  Map<int,List<Cast>> moviesCast = {};
  Map<int,List<VideoMovie>> movieVideos = {};

  int _popularPage = 0;
  int _topRatedPage = 0;

  final debouncer = Debouncer(
    duration: Duration(milliseconds: 500)
  );

  final StreamController<List<Movie>> _suggestionStremController = new StreamController.broadcast();

  Stream<List<Movie>> get suggestionStream => this._suggestionStremController.stream;


  MoviesProvider(){
    print('MoviesProvider inicializado');
    this.getonDisplayMovies();
    this.getPopularMovies();
    this.getBestRatingMovies();
  }

  Future<String> _getJsonData( String endpoint, [int page = 1] ) async{
    final url = Uri.https(_baseUrl, endpoint, {
      'api_key' : _apiKey,
      'language' : _language,
      'page' : '$page'
    });
    
    final response = await http.get(url);
    return response.body;
  }



  getonDisplayMovies() async{
    final jsonData = await this._getJsonData('3/movie/now_playing');
    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);
    
    onDisplayMovies = nowPlayingResponse.results;

    notifyListeners();
  }

  getPopularMovies() async {
    _popularPage++;
    final jsonData = await this._getJsonData('3/movie/popular', _popularPage);
    final popularResponse = PopularResponse.fromJson(jsonData);
    popularmovies = [...popularmovies, ...popularResponse.results ];
    notifyListeners();
  }

  getBestRatingMovies() async {
    _topRatedPage++;
    final jsonData = await this._getJsonData('3/movie/top_rated', _topRatedPage);
    final topRatedResponse = PopularResponse.fromJson(jsonData);
    topRatedMovies = [...topRatedMovies, ...topRatedResponse.results];
    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int movieId) async {

    if ( moviesCast.containsKey(movieId) ) return moviesCast[movieId]!;
    
    final jsonData = await this._getJsonData('3/movie/$movieId/credits');
    final creditsResponse = CreditsResponse.fromJson( jsonData );

    moviesCast[movieId] = creditsResponse.cast;
    return creditsResponse.cast;
  }

  Future<List<VideoMovie>> getMovieVideos(int movieId) async {

    if ( movieVideos.containsKey(movieId) ) return movieVideos[movieId]!;
    
    final jsonData = await this._getJsonData('3/movie/$movieId/videos');
    final movieResponse = VideoResponse.fromJson( jsonData );
    movieVideos[movieId] = movieResponse.results;

    return movieResponse.results;
  }

  Future<List<Movie>> searchMovies( String query ) async{
    final url = Uri.https(_baseUrl, '3/search/movie', {
      'api_key': _apiKey,
      'language': _language,
      'query': '$query'
    });

    final response = await http.get(url);
    final searchResponse = SearchResponse.fromJson( response.body );

    return searchResponse.results;
  }

  void getSuggestionByQuery( String searchTerm ){
    debouncer.value = '';
    debouncer.onValue = ( value ) async {
      print('Tenemos valor a buscar: $value');
      final results = await this.searchMovies(value);
      this._suggestionStremController.add(results);
    };

    final timer = Timer.periodic(Duration(milliseconds: 300), (_) { 
      debouncer.value = searchTerm;
    });

    Future.delayed(Duration(milliseconds: 301)).then((_) => timer.cancel());
  }
  
}