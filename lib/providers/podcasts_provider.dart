import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/podcast.dart';
import '../utils/constants.dart';
import '../providers/auth_provider.dart';
import 'package:dio/dio.dart';
import './podcast_lists_provider.dart';
import '../models/create_podcast_input.dart';
import 'dart:io';

class PodcastsNotifier extends StateNotifier<List<Podcast>> {
  
  Ref ref;

  PodcastsNotifier(this.ref) : super([]);

 
  Future<void> fetchPodcasts() async {
    try {

      final dio = Dio();

      final token = ref.read(authProvider);

      final response = await dio.get('${Constants.BASE_URL}/api/podcasts', options: Options(
        headers: {
          'x-access-token': token
        }
      ));

      if (response.statusCode == 200) {
        final podcasts = <Podcast>[];

        for (final podcast in response.data) {
          podcasts.add(Podcast.fromJson(podcast));
        }

        state = [...podcasts];
      }

    } catch(error) {
      rethrow;
    }
  }

  Future<void> fetchPodcastsByPodcastListID(String podcastListID) async {
    try {
      final dio = Dio();

      final token = ref.read(authProvider);

      final response = await dio.get('${Constants.BASE_URL}/api/podcast-lists/$podcastListID/podcasts', options: Options(
        headers: {
          'x-access-token': token
        }
      ));
      
      if (response.statusCode == 200) {
        final podcasts = <Podcast>[];

        for (final podcast in response.data) {
          podcasts.add(Podcast.fromJson(podcast));
        }

        state = [...podcasts];
      }

    } catch(error) {
      rethrow;
    }
  }

  Future<bool> likePodcast(String podcastID) async {
    try {

      final dio = Dio();
      final token = ref.read(authProvider);
      final response = await dio.post('${Constants.BASE_URL}/api/podcasts/$podcastID/like', options: Options(
        headers: {
          'x-access-token': token
        }
      ));

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }

    } catch(error) {
      rethrow;
    }
  }

  Future<bool> unlikePodcast(String podcastID) async {
    try {

      final dio = Dio();
      final token = ref.read(authProvider);
      final response = await dio.delete('${Constants.BASE_URL}/api/podcasts/$podcastID/unlike', options: Options(
        headers: {
          'x-access-token': token
        }
      ));

      if (response.statusCode == 200) {
        ref.read(likedPodcastsProvider.notifier).state = ref.read(likedPodcastsProvider).where((podcast) => podcast.id != response.data['podcastId']).toList();
        return true;
      } else {
        return false;
      }

    } catch(error) {
      rethrow;
    }
  }

  Future<void> fetchLikedPocasts() async {
    try {

      final dio = Dio();
      final token = ref.read(authProvider);
      final response = await dio.get('${Constants.BASE_URL}/api/podcasts/liked', options: Options(
        headers: {
          'x-access-token': token
        }
      ));


      if (response.statusCode == 200) {
        final podcasts = <Podcast>[];

        for (final podcast in response.data) {
          podcasts.add(Podcast.fromJson(podcast));
        }

        ref.read(likedPodcastsProvider.notifier).state = [...podcasts];
      }

      

    } catch(error) {
      rethrow;
    }
  }

  Future<void> createPodcast(
    String title, 
    String description, 
    String podcastListID, 
    File image,
    File podcast,
    void Function(int progress) imageUploadProgress, 
    void Function(int progress) podcastUploadProgress) async {
    try {

      final dio = Dio();

      final token = ref.read(authProvider);

      final imageResponse = await dio.get(
        '${Constants.BASE_URL}/api/podcast-lists/image-presigned-url',
        options: Options(
          headers: {
            'x-access-token': token
          }
        )
      );

      final imageUrl = imageResponse.data['url'];
      final imageKey = imageResponse.data['key'];

      final podcastResponse = await dio.get(
        '${Constants.BASE_URL}/api/podcast-lists/podcast-presigned-url',
        options: Options(
          headers: {
            'x-access-token': token
          }
        )
      );

      final podcastUrl = podcastResponse.data['url'];
      final podcastKey = podcastResponse.data['key'];

      final response = await Future.wait([
        dio.put(
          imageUrl, 
          data: image.openRead(), 
          options: Options(
            contentType: 'image/jpeg',
            headers: {
              Headers.contentLengthHeader: await image.length()
            }
          ),
          onSendProgress: (count, total) {
            imageUploadProgress(((count / total) * 100).round());
          },
        ),
        dio.put(
          podcastUrl,
          data: podcast.openRead(),
          options: Options(
            contentType: 'audio/mp3',
            headers: {
              Headers.contentLengthHeader: await podcast.length()
            }
          ),
          onSendProgress: (count, total) {
            podcastUploadProgress(((count / total) * 100).round());
          },
        )
      ]);

      final result = await ref.read(podcastListsProvider.notifier).createPodcast(CreatePodcastInput(
        title: title, 
        description: description, 
        imageUrl: imageKey, 
        podcastUrl: podcastKey,
        podcastListId: podcastListID
      ));            
        

    } catch(error) {
      rethrow;
    }
  }

  Future<void> updatePodcast() async {
    try {

    } catch(error) {
      rethrow;
    }
  }

  Future<bool> deletePodcast(String podcastID) async {
    try {
      final dio = Dio();

      final token = ref.read(authProvider);

      final response = await dio.delete('${Constants.BASE_URL}/api/podcasts/$podcastID', options: Options(
        headers: {
          'x-access-token': token
        }
      ));

      if (response.statusCode == 200) {
        state = state.where((podcast) => podcast.id != podcastID).toList();
        return true;
      } else {
        return false;
      }

    } catch(error) {
      rethrow;
    }
  }

}


final podcastsProvider = StateNotifierProvider<PodcastsNotifier, List<Podcast>>((ref) {
  
  return PodcastsNotifier(ref);
});

final likedPodcastsProvider = StateProvider<List<Podcast>>((ref) {
  return [];
});
