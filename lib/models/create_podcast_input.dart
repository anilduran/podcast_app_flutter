import 'dart:io';

class CreatePodcastInput {

  String title;
  String description;
  String imageUrl;
  String podcastUrl;
  String podcastListId;

  CreatePodcastInput({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.podcastUrl,
    required this.podcastListId
  });

}