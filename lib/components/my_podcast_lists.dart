import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './podcast_list_item.dart';
import '../providers/podcast_lists_provider.dart';

class MyPodcastLists extends ConsumerWidget {
  const MyPodcastLists({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final podcastLists = ref.watch(myPodcastListsProvider);

    return ListView.builder(
      itemCount: podcastLists.length,
      itemBuilder: (ctx, i) => PodcastListItem(podcastList: podcastLists[i])
    );
  }
}