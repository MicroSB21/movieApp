import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/models/models.dart';
import 'package:movies/providers/movies_provider.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
class VideosCards extends StatelessWidget {

  final int movieId;

  const VideosCards(this.movieId);


  @override
  Widget build(BuildContext context) {

    final moviesProvider = Provider.of<MoviesProvider>(context,listen: false);
    return FutureBuilder(
      future: moviesProvider.getMovieVideos(movieId),
      builder: ( _ , AsyncSnapshot<List<VideoMovie>> snapshot ){
        if (!snapshot.hasData) {
          return Container(
            height: 180,
            child: CupertinoActivityIndicator(),
          );
        }
        final videos = snapshot.data!;
        return Container(
          width: double.infinity,
          height: 300,
          margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: ListView.builder(
            itemCount: videos.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, int index) =>  _VideoCard(videos[index])
          ),
        );
      }
    );
  }
}

class _VideoCard extends StatelessWidget {
  final VideoMovie video;

  const _VideoCard(this.video); 
  
  @override
  Widget build(BuildContext context) {
    YoutubePlayerController _controller = YoutubePlayerController(
       initialVideoId: video.key,
       flags: YoutubePlayerFlags(
         autoPlay: false,
         mute: false,
       )
    );
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           YoutubePlayer(
             controller: _controller,
             showVideoProgressIndicator: true,
             progressIndicatorColor: Colors.blueAccent,
           )
        ],
      ),
    );
  }
  
}