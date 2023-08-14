import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:podcast_app/providers/podcast_lists_provider.dart';
import '../screens/podcast_list_detail_screen.dart';
import '../models/podcast_list.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../utils/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PodcastListItem extends ConsumerWidget {

  PodcastList podcastList;

  PodcastListItem({required this.podcastList, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            backgroundColor: Colors.redAccent,
            icon: Icons.delete_rounded,
            label: 'Delete',
            onPressed: (ctx) async {
              final bool? result = await showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Are you sure?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24
                        ),
                      ),
                      IconButton(
                        icon: SvgPicture.asset(
                          'assets/icons/close.svg',
                          width: 24,
                        ),
                        onPressed: () {
                          Navigator.of(ctx).pop(false);
                        },
                      ),
                    ],
                  ),
                  content: const Text('Are you sure you want to delete this podcast list?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop(true);
                      },
                      child: const Text('Yes'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop(false);
                      },
                      child: const Text('No'),
                    ),
                  ],
                )
              );
              if (result == true) {
               
                bool isDeleted = await ref.read(podcastListsProvider.notifier).deletePodcastList(podcastList.id);
                if (isDeleted && context.mounted) {
                  MotionToast.success(
                    enableAnimation: false,
                    animationType: AnimationType.fromLeft,
                    title: const Text(
                      'Successfull!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    description: const Text('Podcast list successfully deleted!'),
                  ).show(context);
                } else {

                }
              }
            },
          )
        ]
      ),
      child: ListTile(
        leading: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image(
                width: 60,
                height: 60,
                image: CachedNetworkImageProvider('${Constants.S3_BUCKET_URL}/${podcastList.imageUrl}'),
                fit: BoxFit.cover,
              ),
            ),
            // Positioned(
            //   top: 0,
            //   right: 0,
            //   bottom: 0,
            //   left: 0,
            //   child: Container(
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(12.0),
            //       color: Colors.black.withOpacity(0.5)
            //     ),
            //     child: const Center(
            //       child: Text(
            //         '12',
            //         style: TextStyle(
            //           color: Colors.white
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
        title: Text(podcastList.title),
        subtitle: Text(podcastList.description),
        trailing: SvgPicture.asset(
          'assets/icons/chevron_right_filled.svg',
          width: 24,
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (ctx) => PodcastListDetailScreen(podcastList: podcastList,))
          );
        },
      ),
    );
  }
}