import 'package:json_annotation/json_annotation.dart';
import './podcast.dart';
import './user.dart';

part 'podcast_list.g.dart';

@JsonSerializable()
class PodcastList {

  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final User creator;

  PodcastList({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.creator
  });

  factory PodcastList.fromJson(Map<String, dynamic> json) => _$PodcastListFromJson(json);

  Map<String, dynamic> toJson() => _$PodcastListToJson(this);


}