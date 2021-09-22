// To parse this JSON data, do
//
//     final videoResponse = videoResponseFromMap(jsonString);

import 'dart:convert';

import 'package:movies/models/videos_movie.dart';

class VideoResponse {
    VideoResponse({
        required this.id,
        required this.results,
    });

    int id;
    List<VideoMovie> results;

    factory VideoResponse.fromJson(String str) => VideoResponse.fromMap(json.decode(str));

   

    factory VideoResponse.fromMap(Map<String, dynamic> json) => VideoResponse(
        id: json["id"],
        results: List<VideoMovie>.from(json["results"].map((x) => VideoMovie.fromMap(x))),
    );

}





