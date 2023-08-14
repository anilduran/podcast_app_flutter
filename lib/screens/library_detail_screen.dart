import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:podcast_app/components/library_detail_podcast_tile.dart';
import 'package:podcast_app/components/podcast_list_tile_shimmer.dart';
import 'package:podcast_app/providers/podcast_lists_provider.dart';
import 'package:podcast_app/providers/podcasts_provider.dart';
import './user_profile_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/me_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../utils/constants.dart';
import '../models/podcast_list.dart';

class LibraryDetailScreen extends ConsumerStatefulWidget {
  
  PodcastList podcastList;
  bool isFollowing;

  LibraryDetailScreen({super.key, required this.podcastList, required this.isFollowing});

  @override
  ConsumerState<LibraryDetailScreen> createState() => _LibraryDetailScreenState();
}

class _LibraryDetailScreenState extends ConsumerState<LibraryDetailScreen> {

  bool isInit = true;
  bool isLoading = false;
  bool isFollowing = false;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (isInit) {
      setState(() {
        isLoading = true;
      });
      await ref.watch(podcastsProvider.notifier).fetchPodcastsByPodcastListID(widget.podcastList.id);
      setState(() {
        isLoading = false;
      });
    }
    isInit = false;
  }

  void follow() async {
    try {
      final result = await ref.read(podcastListsProvider.notifier).followPodcast(widget.podcastList.id);
      
      if (result && mounted) {
        MotionToast.success(
          animationType: AnimationType.fromLeft,
          enableAnimation: false,
          title: const Text(
            'Successfull!',
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
          description: const Text('You successfully followed podcast list!'),
        ).show(context);
        setState(() {
          widget.isFollowing = true;
        });
      } else {
        MotionToast.error(
          animationType: AnimationType.fromLeft,
          enableAnimation: false,
          title: const Text(
            'Error!',
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
          description: const Text('Unexpected error!'),
        ).show(context);
      }
    } catch(error) {
      print(error);
      MotionToast.error(
        animationType: AnimationType.fromLeft,
        enableAnimation: false,
        title: const Text(
          'Error!',
          style: TextStyle(
            fontWeight: FontWeight.bold
          ),
        ),
        description: const Text('Unexpected error!'),
      ).show(context);
    }
  }

  void unfollow() async {
    try {
      final result = await ref.read(podcastListsProvider.notifier).unfollowPodcast(widget.podcastList.id);
      if (result && mounted) {
        MotionToast.success(
          animationType: AnimationType.fromLeft,
          enableAnimation: false,
          title: const Text(
            'Successfull!',
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
          description: const Text('You successfully unfollowed podcast list!'),
        ).show(context);
        setState(() {
          widget.isFollowing = false;
        });
      } else {
        MotionToast.error(
          animationType: AnimationType.fromLeft,
          enableAnimation: false,
          title: const Text(
            'Error!',
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
          description: const Text('Unexpected error!'),
        ).show(context);
      }
    } catch(error) {
      MotionToast.error(
        animationType: AnimationType.fromLeft,
        enableAnimation: false,
        title: const Text(
          'Error!',
          style: TextStyle(
            fontWeight: FontWeight.bold
          ),
        ),
        description: const Text('Unexpected error!'),
      ).show(context);
    }
  }


  @override
  Widget build(BuildContext context) {
    final me = ref.watch(meProvider);
    final podcasts = ref.watch(podcastsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.podcastList.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20.0), 
                  bottomRight: Radius.circular(20.0)),
                child: Image(
                  image: CachedNetworkImageProvider('${Constants.S3_BUCKET_URL}/${widget.podcastList.imageUrl}'),
                  height: 300,
                  width: double.infinity,
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
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0)
                    )
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                right: 20,
                left: 20,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.podcastList.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: widget.podcastList.creator.profilePhotoUrl != null ? CachedNetworkImageProvider('${Constants.S3_BUCKET_URL}/${widget.podcastList.creator.profilePhotoUrl}') : null,
                        ),
                        const SizedBox(width: 10,),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (ctx) => UserProfileScreen(user: widget.podcastList.creator,))
                            );
                          },
                          child: Text(
                            widget.podcastList.creator.username,
                            style: const TextStyle(
                              color: Colors.white
                            ),
                          ),
                        ),
                        const Spacer(),
                        if (me != null && me.id != widget.podcastList.creator.id)
                          ElevatedButton(
                            onPressed: widget.isFollowing ? unfollow : follow,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)
                              )
                            ),
                            child: Text(widget.isFollowing ? 'Unfollow' : 'Follow'),
                          ),
                          
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(widget.podcastList.description)
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Podcasts - ${podcasts.length}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20
              ),
            ),
          ),
          Expanded(
            child: isLoading ? const PodcastListTileShimmer() : ListView.builder(
              itemCount: podcasts.length,
              itemBuilder: (ctx, i) => LibraryDetailPodcastTile(podcast: podcasts[i]),
            ),
          )


        ],
      ),
    );
  }
}