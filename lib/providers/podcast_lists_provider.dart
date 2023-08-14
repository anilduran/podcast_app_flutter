import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcast_app/models/create_podcast_input.dart';
import 'package:podcast_app/models/podcast.dart';
import 'package:podcast_app/providers/podcasts_provider.dart';
import '../models/podcast_list.dart';
import 'package:dio/dio.dart';
import '../utils/constants.dart';
import 'dart:io';
import './auth_provider.dart';

class PodcastListsNotifier extends StateNotifier<List<PodcastList>> {

  Ref ref;

  PodcastListsNotifier(this.ref): super([]);

  Future<void> fetchPodcastLists() async {
    try {

      final dio = Dio();

      final token = ref.read(authProvider);

      final response = await dio.get('${Constants.BASE_URL}/api/podcast-lists', options: Options(
        headers: {
          'x-access-token': token
        }
      ));

      if (response.statusCode == 200) {
        final podcastLists = <PodcastList>[];

        for (final podcastList in response.data) {
          podcastLists.add(PodcastList.fromJson(podcastList));
        }

        state = [...podcastLists];
      }


    } catch(error) {
      rethrow;
    }
  }

  Future<void> fetchFollowingPodcastLists() async {
    try {

      final dio = Dio();

      final token = ref.read(authProvider);

      final response = await dio.get('${Constants.BASE_URL}/api/me/following', options: Options(
        headers: {
          'x-access-token': token
        }
      ));

      if (response.statusCode == 200) {
        final podcastLists = [];

        for (final podcastList in response.data) {
          podcastLists.add(PodcastList.fromJson(podcastList));
          ref.read(followingPodcastListsProvider.notifier).state = [...podcastLists];
        } 
      }

    } catch(error) {
      rethrow;
    }
  }

  Future<void> fetchMyPodcastLists() async {
    try {
      final dio = Dio();

      final token = ref.read(authProvider);

      final response = await dio.get('${Constants.BASE_URL}/api/me/podcast-lists', options: Options(
        headers: {
          'x-access-token': token
        }
      ));
    
      if (response.statusCode == 200) {
        final podcastLists = <PodcastList>[];

        for (final podcastList in response.data) {
          podcastLists.add(PodcastList.fromJson(podcastList));
        }

        ref.read(myPodcastListsProvider.notifier).state = [...podcastLists];
      }

      
    } catch(error) {
      rethrow;
    }
  }

  Future<void> fetchPodcastListsByUserID(String userID) async {
    try {

      final dio = Dio();

      final token = ref.read(authProvider);

      final response = await dio.get('${Constants.BASE_URL}/api/users/$userID/podcast-lists', options: Options(
        headers: {
          'x-access-token': token
        }
      ));

      if (response.statusCode == 200) {
        final podcastLists = [];

        for (final podcastList in response.data) {
          podcastLists.add(PodcastList.fromJson(podcastList));
        }
        
        ref.read(podcastListsOfUserProvider.notifier).state = [...podcastLists];
      }

    } catch(error) {
      rethrow;
    }
  }

  Future<bool> createPodcastList(String title, String description, String imageUrl) async {
    try {

      final dio = Dio();
      
      final token = ref.read(authProvider);

      final response = await dio.post('${Constants.BASE_URL}/api/podcast-lists', data: {
        'title': title,
        'description': description,
        'imageUrl': imageUrl
      },options: Options(
          headers: {
            'x-access-token': token
          }
      ));

      if (response.statusCode == 201) {
        final podcastList = PodcastList.fromJson(response.data);
        ref.read(myPodcastListsProvider.notifier).state = [
          ...ref.read(myPodcastListsProvider.notifier).state,
          podcastList
        ];
        return true;

      } else {
        return false;
      }

    } catch(error) {
      rethrow;
    }
  }

  Future<bool> createPodcast(CreatePodcastInput input) async {
    try {

      final dio = Dio();

      final token = ref.read(authProvider);

      final response = await dio.post('${Constants.BASE_URL}/api/podcast-lists/${input.podcastListId}/podcasts', data: {
        'title': input.title,
        'description': input.description,
        'imageUrl': input.imageUrl,
        'podcastUrl': input.podcastUrl,
      }, options: Options(
        headers: {
          'x-access-token': token
        }
      ));

      if (response.statusCode == 201) {
        final podcast = Podcast.fromJson(response.data);
        ref.read(podcastsProvider.notifier).state = [
          ...ref.read(podcastsProvider),
          podcast
        ];
        
        return true;
      } else {
        return false;
      }

    } catch(error) {
      throw Error();
    }
  }

  Future<void> searchPodcastLists(String searchText) async {
    try {
      final dio = Dio();
      
      final token = ref.read(authProvider);

      final response = await dio.get('${Constants.BASE_URL}/api/podcast-lists/search?s=$searchText', options: Options(
        headers: {
          'x-access-token': token
        }
      ));

      if (response.statusCode == 200) {
        final podcastLists = <PodcastList>[];

        for (final podcastList in response.data) {
          podcastLists.add(PodcastList.fromJson(podcastList));
        }

        state = [...podcastLists];
      }

    } catch(error) {
      rethrow;
    }
  }

  Future<bool> followPodcast(String podcastListID) async {
    try {

      final dio = Dio();

      final token = ref.read(authProvider);

      final response = await dio.post('${Constants.BASE_URL}/api/podcast-lists/$podcastListID/follow', options: Options(
        headers: {
          'x-access-token': token
        }
      ));

      if (response.statusCode == 200) {
        ref.read(followingPodcastListsProvider.notifier).state = [
          ...ref.read(followingPodcastListsProvider.notifier).state,
          PodcastList.fromJson(response.data),
        ];
        return true;
      }
      return false;

    } catch(error) {
      rethrow;
    } 
  }

  Future<bool> unfollowPodcast(String podcastListID) async {
    try {
      final dio = Dio();

      final token = ref.read(authProvider);

      final response = await dio.delete('${Constants.BASE_URL}/api/podcast-lists/$podcastListID/unfollow', options: Options(
        headers: {
          'x-access-token': token
        }
      ));

      if (response.statusCode == 200) {

        ref.read(followingPodcastListsProvider.notifier).state = ref.read(followingPodcastListsProvider.notifier).state.where((podcastList) => podcastList.id != podcastListID).toList();

        return true;
      } 
      return false;

    } catch(error) {
      rethrow;
    }
  }

  Future<void> updatePodcastList() async {

  }

  Future<bool> deletePodcastList(String podcastListID) async {
    try {

      final dio = Dio();

      final token = ref.read(authProvider);

      final response = await dio.delete('${Constants.BASE_URL}/api/podcast-lists/$podcastListID', options: Options(
        headers: {
          'x-access-token': token
        }
      ));

      if (response.statusCode == 200) {
        ref.read(myPodcastListsProvider.notifier).state = ref.read(myPodcastListsProvider.notifier).state.where((podcastList) => podcastList.id != podcastListID).toList();
        return true;
      } else {
        return false;
      }

    } catch(error) {
      rethrow;
    }
  } 


}

final podcastListsProvider = StateNotifierProvider<PodcastListsNotifier, List<PodcastList>>((ref) {
  return PodcastListsNotifier(ref);
});

final myPodcastListsProvider = StateProvider<List<PodcastList>>((ref) {
  return [];
});

final followingPodcastListsProvider = StateProvider<List<PodcastList>>((ref) {
  return [];
});

final podcastListsOfUserProvider = StateProvider<List<PodcastList>>((ref) {
  return [];
});