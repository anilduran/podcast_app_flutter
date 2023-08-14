import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:podcast_app/providers/podcasts_provider.dart';
import '../screens/listen_podcast_screen.dart';
import '../models/podcast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../utils/constants.dart';
import 'package:like_button/like_button.dart';

class PodcastCard extends ConsumerStatefulWidget {

  Podcast podcast;

  PodcastCard({super.key, required this.podcast});

  @override
  ConsumerState<PodcastCard> createState() => _PodcastCardState();
}

class _PodcastCardState extends ConsumerState<PodcastCard> {

  bool isLiked = false;

  Future<void> likePodcast() async {
    try {
      bool result = await ref.read(podcastsProvider.notifier).likePodcast(widget.podcast.id);
      if (result && mounted) {
        // setState(() {
        //   isLiked = true;
        // });
        MotionToast.success(
          animationType: AnimationType.fromLeft,
          enableAnimation: false,
          title: const Text(
            'Successfully',
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
          description: const Text('Podcast successfully liked!'),
        ).show(context);
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
    }
  }

 
  Future<void> unlikePodcast() async {
    try {
       
      bool result = await ref.read(podcastsProvider.notifier).unlikePodcast(widget.podcast.id);

      if (result && context.mounted) {
        MotionToast.success(
          animationType: AnimationType.fromLeft,
          enableAnimation: false,
          title: const Text(
            'Successfull!',
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
          description: const Text('Podcast successfully unliked!'),
        ).show(context);

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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (ctx) => ListenPodcastScreen(podcast: widget.podcast,))
          );
        },
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image(
                image: CachedNetworkImageProvider('${Constants.S3_BUCKET_URL}/${widget.podcast.imageUrl}'),
                width: 180,
                height: 240,
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
              right: 10,
              bottom: 10,
              left: 10,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.podcast.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                    ),
                  ),
                ],
              )
            ),
            Positioned(
              top: 5,
              right: 5,
              child: LikeButton(
                onTap: (isLiked) async {
                  
                  if (isLiked) {
                    await unlikePodcast();
                  } else {
                    await likePodcast();
                  }

                  return !isLiked;
                },
                size: 30,
                circleColor: const CircleColor(
                  start: Colors.red, 
                  end: Colors.green
                ),
                bubblesColor: const BubblesColor(
                  dotPrimaryColor: Colors.orange,
                  dotSecondaryColor: Colors.yellow,
                ),
                likeBuilder: (bool isLiked) {
                  return isLiked ? SvgPicture.asset(
                    'assets/icons/favorite_filled.svg',
                    //width: 16,
                    color: Colors.white,
                  ) : SvgPicture.asset(
                    'assets/icons/favorite.svg',
                    //width: 16,
                    color: Colors.white,
                  );
                },
                likeCount: null,
                countBuilder: null
              ),
            ),
          ],
        ),
      ),
    );
  }
}