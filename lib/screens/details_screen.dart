import 'package:flutter/material.dart';
import 'package:movies/Widgets/videos_card.dart';
import 'package:movies/Widgets/widgets.dart';
import 'package:movies/models/movie.dart';

class DetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _CustomAppBar(movie: movie),
          SliverList(
            delegate: SliverChildListDelegate([
              _PosterAndTittle(movie: movie),
              _Overview(movie: movie),           
              CastingCards( movie.id ),
              VideosCards( movie.id ),
            ]),
          )
        ],
      )
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  final Movie movie;
  _CustomAppBar({required this.movie});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.indigo,
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.all(0),
        centerTitle: true,
        title: Container(
          width: double.infinity,
          padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
          alignment: Alignment.bottomCenter,
          color : Colors.black12,
          child:  Text(
            movie.title,
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
        background: FadeInImage(
          placeholder: AssetImage('assets/loading.gif'), 
          image: NetworkImage(movie.fullBackDropPath),
          fit: BoxFit.cover
        ),
      ),

    );
  }
}

class _PosterAndTittle extends StatelessWidget {

   final Movie movie;
  _PosterAndTittle( {required this.movie} );

  @override
  Widget build(BuildContext context) {

    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Hero(
            tag: movie.heroId!,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: AssetImage('assets/no-image.jpg'), 
                image: NetworkImage(movie.fullPosterImg),
                height: 150,
              ),
            ),
          ),
          SizedBox(width: 20),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: size.width -190),
            child: Column(
              children: [
                Text(movie.title, style: textTheme.headline6, overflow: TextOverflow.ellipsis,maxLines: 2,),
                Text(movie.originalTitle, style: textTheme.subtitle1, overflow: TextOverflow.ellipsis,maxLines: 2,),
                Row(
                  children: [
                    Icon(Icons.star_outline, size: 15, color: Colors.grey,),
                    SizedBox(width: 5),
                    Text('${movie.voteAverage}', style: textTheme.caption,)
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _Overview extends StatelessWidget {

   final Movie movie;
  _Overview({ required this.movie });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Text(movie.overview,
      textAlign: TextAlign.justify,
      style: Theme.of(context).textTheme.subtitle1,
      ),
    );
  }
}

