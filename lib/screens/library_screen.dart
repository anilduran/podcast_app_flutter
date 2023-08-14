import 'package:flutter/material.dart';
import '../components/library_podcast_card.dart';
import '../components/library_podcast_list_card_shimmer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/podcast_lists_provider.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {

  bool isLoading = false;
  bool isInit = true;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (isInit) {
      setState(() {
        isLoading = true;
      });
      await ref.read(podcastListsProvider.notifier).fetchFollowingPodcastLists();
      setState(() {
        isLoading = false;
      });
    }
    isInit = false;
  }

  @override
  Widget build(BuildContext context) {

    final podcastLists = ref.watch(followingPodcastListsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Library Screen'),
      ),
      body: isLoading ? const LibraryPodcastListCardShimmer() : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: podcastLists.length,
        itemBuilder: (ctx, i) => LibraryPodcastCard(podcastList: podcastLists[i]),
      )
    );
  }
}