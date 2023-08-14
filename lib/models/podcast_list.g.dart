// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'podcast_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PodcastList _$PodcastListFromJson(Map<String, dynamic> json) => PodcastList(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      creator: User.fromJson(json['creator'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PodcastListToJson(PodcastList instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'creator': instance.creator,
    };
