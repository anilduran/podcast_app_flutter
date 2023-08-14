import 'package:flutter/material.dart';
import 'package:podcast_app/components/library_podcast_list_card_shimmer.dart';
import 'package:podcast_app/providers/podcasts_provider.dart';
import '../components/liked_podcast_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LikedPodcastListScreen extends ConsumerStatefulWidget {
  const LikedPodcastListScreen({super.key});

  @override
  ConsumerState<LikedPodcastListScreen> createState() => _LikedPodcastListScreenState();
}

class _LikedPodcastListScreenState extends ConsumerState<LikedPodcastListScreen> {


  bool isInit = true;
  bool isLoading = false;

  @override
  void didChangeDependencies() async {  
    super.didChangeDependencies();
    if (isInit) {
      setState(() {
        isLoading = true;
      });
      await ref.read(podcastsProvider.notifier).fetchLikedPocasts();
      setState(() {
        isLoading = false;
      });
    }
    isInit = false;
  }


  @override
  Widget build(BuildContext context) {

    final podcasts = ref.watch(likedPodcastsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Liked Podcasts'),
      ),
      body: isLoading ? const LibraryPodcastListCardShimmer() : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: podcasts.length,
        itemBuilder: (ctx, i) => LikedPodcastCard(podcast: podcasts[i],),
      ),
    );
  }
}