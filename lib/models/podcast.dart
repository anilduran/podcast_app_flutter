import 'package:json_annotation/json_annotation.dart';

part 'podcast.g.dart';

@JsonSerializable()
class Podcast {

  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String podcastUrl;

  Podcast({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.podcastUrl
  });

  factory Podcast.fromJson(Map<String, dynamic> json) => _$PodcastFromJson(json);

  Map<String, dynamic> toJson() => _$PodcastToJson(this);


}