import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import './create_podcast_list_screen.dart';
import '../components/my_podcast_lists.dart';
import '../providers/podcast_lists_provider.dart';
import '../components/podcast_list_tile_shimmer.dart';

class PodcastsListScreen extends ConsumerStatefulWidget {
  const PodcastsListScreen({super.key});

  @override
  ConsumerState<PodcastsListScreen> createState() => _PodcastsListScreenState();
}

class _PodcastsListScreenState extends ConsumerState<PodcastsListScreen> {

  bool isLoading = false;
  bool isInit = true;

  @override
  void initState() {
    super.initState();
    
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (isInit) {
      setState(() {
      isLoading = true;
      });
      await ref.read(podcastListsProvider.notifier).fetchMyPodcastLists();
      setState(() {
        isLoading = false;
      });
    }
    isInit = false;
  }



  @override
  Widget build(BuildContext context) {



    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Podcast Lists'),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/add.svg',
              color: Colors.white,
              width: 24,
            ),
            onPressed: () async {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const CreatePodcastListScreen()
                )
              );
            },
          )
        ],
      ),
      body: isLoading ? const PodcastListTileShimmer() : const MyPodcastLists()
    );
  }
}