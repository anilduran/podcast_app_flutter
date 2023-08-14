import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcast_app/components/library_podcast_list_card_shimmer.dart';
import 'package:podcast_app/components/podcast_list_tile_shimmer.dart';
import 'package:podcast_app/providers/podcast_lists_provider.dart';
import 'package:podcast_app/screens/library_detail_screen.dart';
import '../utils/constants.dart';
import '../models/user.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  User user;

  UserProfileScreen({super.key, required this.user});

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {

  bool isInit = true;
  bool isLoading = false;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (isInit) {
      setState(() {
         isLoading = true;
      });
      await ref.read(podcastListsProvider.notifier).fetchPodcastListsByUserID(widget.user.id);
      setState(() {
        isLoading = false;
      });
    }
    isInit = false;
  }


  @override
  Widget build(BuildContext context) {

    final podcastLists = ref.watch(podcastListsOfUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.username),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: widget.user.profilePhotoUrl != null ? CachedNetworkImageProvider('${Constants.S3_BUCKET_URL}/${widget.user.profilePhotoUrl}') : null
                ),
                const SizedBox(width: 10,),
                Text(
                  widget.user.username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10,),
            Text(
              'Podcast Lists - ${podcastLists.length}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20
              ),
            ),
            const SizedBox(height: 10,),
            Expanded(
              child: isLoading == false ? ListView.builder(
                itemCount: podcastLists.length,
                itemBuilder: (ctx, i) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => LibraryDetailScreen(podcastList: podcastLists[i], isFollowing: false,)
                        )
                      );
                    },
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Image(
                            image: CachedNetworkImageProvider('${Constants.S3_BUCKET_URL}/${podcastLists[i].imageUrl}'),
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          bottom: 0,
                          left: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(12.0)
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 20,
                          left: 20,
                          right: 20,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    podcastLists[i].title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.white
                                    ),
                                  ),
                                  const Spacer(),
                                  SvgPicture.asset(
                                    'assets/icons/chevron_right_filled.svg',
                                    color: Colors.white,
                                    width: 24,
                                  )
                                ],
                              ),
                            ], 
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ) : const LibraryPodcastListCardShimmer(),
            ),
          ],
        ),
      ),
    );
  }
}