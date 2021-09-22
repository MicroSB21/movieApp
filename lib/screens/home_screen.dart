import 'package:flutter/material.dart';
import 'package:movies/Widgets/widgets.dart';
import 'package:movies/providers/movies_provider.dart';
import 'package:movies/search/search_delegate.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
   Widget build(BuildContext context) {

     final moviesProvider = Provider.of<MoviesProvider>(context);
       return Scaffold(
         appBar: AppBar(
           title: Text('Peliculas en cines'),
           elevation: 0,
           actions: [
             IconButton(
              onPressed: () => showSearch(context: context, delegate: MovieSearchDelegate()), 
              icon: Icon(Icons.search_outlined)
             )
           ],
         ),
         body: SingleChildScrollView(
           child: Column(
           children: [
             //Tarjetas Principales
             CardSwiper(movies: moviesProvider.onDisplayMovies ),

             //Slider de peliculas
             MovieSlider(
               movies: moviesProvider.popularmovies,
               title: 'Populares',
               onNextPage: ()=> moviesProvider.getPopularMovies()
             ),
             SizedBox(height: 10),
             MovieSlider(
               movies: moviesProvider.topRatedMovies,
               title: 'Mejor votadas',
               onNextPage: ()=> moviesProvider.getBestRatingMovies()
             ),
           ],
         )
         ),
       );
  }
}