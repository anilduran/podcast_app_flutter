import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:podcast_app/providers/podcast_lists_provider.dart';
import 'package:podcast_app/utils/constants.dart';
import './library_detail_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchResultsScreen extends ConsumerStatefulWidget {
  const SearchResultsScreen({super.key});

  @override
  ConsumerState<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends ConsumerState<SearchResultsScreen> {

  bool isInit = true;
  bool isLoading = false;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (isInit) {
      setState(() {
        isLoading = true;
      });
      await ref.read(podcastListsProvider.notifier).fetchPodcastLists();
      setState(() {
        isLoading = false;
      });
    }
    isInit = false;
  }


  @override
  Widget build(BuildContext context) {

    final podcastLists = ref.watch(podcastListsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Results'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          // childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20
        ),
        itemCount: podcastLists.length,
        itemBuilder: (ctx, i) => InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => LibraryDetailScreen(podcastList: podcastLists[i], isFollowing: false,)
              )
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image(
                  width: double.infinity,
                  image: CachedNetworkImageProvider('${Constants.S3_BUCKET_URL}/${podcastLists[i].imageUrl}'),
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 10,),
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: podcastLists[i].creator.profilePhotoUrl != null 
                    ? CachedNetworkImageProvider('${Constants.S3_BUCKET_URL}/${podcastLists[i].creator.profilePhotoUrl}') : null,
                  ),
                  const SizedBox(width: 5,),
                  Text(podcastLists[i].creator.username)
                ],
              ),
              const SizedBox(height: 10,),
              Text(
                podcastLists[i].title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}