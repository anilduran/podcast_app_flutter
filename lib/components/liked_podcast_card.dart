import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:podcast_app/models/podcast.dart';
import 'package:podcast_app/providers/podcasts_provider.dart';
import 'package:podcast_app/screens/listen_podcast_screen.dart';
import 'package:podcast_app/utils/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LikedPodcastCard extends ConsumerWidget {
  Podcast podcast;

  LikedPodcastCard({super.key, required this.podcast});

  void unlikePodcast(BuildContext context, WidgetRef ref) async {
    try {

      bool result = await ref.read(podcastsProvider.notifier).unlikePodcast(podcast.id);
      if (result && context.mounted) {
        MotionToast.success(
          animationType: AnimationType.fromLeft,
          enableAnimation: false,
          title: const Text(
            'Successfully!',
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
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => ListenPodcastScreen(podcast: podcast)
            )
          );
        },
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image(
                image: CachedNetworkImageProvider('${Constants.S3_BUCKET_URL}/${podcast.imageUrl}'),
                fit: BoxFit.cover,
                width: double.infinity,
                height: 180,
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
                  Text(
                    podcast.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    ),
                  ),
                  Text(
                    podcast.description,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                onPressed: () => unlikePodcast(context, ref),
                icon: SvgPicture.asset(
                  'assets/icons/favorite_filled.svg',
                  width: 24,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}