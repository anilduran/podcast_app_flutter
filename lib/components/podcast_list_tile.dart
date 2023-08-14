import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:podcast_app/providers/podcasts_provider.dart';
import '../models/podcast.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../utils/constants.dart';
import '../screens/listen_podcast_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PodcastListTile extends ConsumerWidget {

  Podcast podcast;

  PodcastListTile({super.key, required this.podcast});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          // SlidableAction(
          //   backgroundColor: Colors.yellow,
          //   icon: Icons.edit_rounded,
          //   label: 'Update',
          //   onPressed: (ctx) {


          //     showModalBottomSheet(
          //       context: context, 
          //       shape: const RoundedRectangleBorder(
          //         borderRadius: BorderRadius.only(
          //           topLeft: Radius.circular(16.0),
          //           topRight: Radius.circular(16.0)
          //         )
          //       ),
          //       isScrollControlled: true,
          //       builder: (ctx) => Container(
          //         padding: EdgeInsets.only(
          //           top: 16,
          //           right: 16,
          //           bottom: MediaQuery.of(context).viewInsets.bottom,
          //           left: 16
          //         ),
          //         child: Column(
          //           mainAxisSize: MainAxisSize.min,
          //           crossAxisAlignment: CrossAxisAlignment.stretch,
          //           children: [
          //             Align(
          //               alignment: Alignment.center,
          //               child: Container(
          //                 height: 5,
          //                 width: 100,
          //                 decoration: BoxDecoration(
          //                   borderRadius: BorderRadius.circular(12.0),
          //                   color: Colors.grey
          //                 ),
          //               ),
          //             ),
          //             const SizedBox(height: 10,),
          //             Align(
          //               alignment: Alignment.centerRight,
          //               child: IconButton(
          //                 onPressed: () {
          //                   Navigator.of(ctx).pop();
          //                 },
          //                 icon: SvgPicture.asset(
          //                   'assets/icons/close.svg',
          //                   width: 24,
          //                 ),
          //               ),
          //             ),
          //             TextFormField(
          //               decoration: const InputDecoration(
          //                 label: Text('Title'),
          //                 hintText: 'Enter a title'
          //               ),
          //             ),
          //             const SizedBox(height: 10,),
          //             TextFormField(
          //               decoration: const InputDecoration(
          //                 label: Text('Description'),
          //                 hintText: 'Enter a description'
          //               ),
          //             ),
          //             const SizedBox(height: 10,),
          //             ElevatedButton(
          //               onPressed: () {

          //               }, 
          //               child: const Text('Save')
          //             )
          //           ],
          //         ),
          //       )
          //     );
          //   },
          // ),
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
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(ctx).pop(false);
                        },
                        icon: SvgPicture.asset(
                          'assets/icons/close.svg',
                          width: 24,
                        ),
                      )
                    ],
                  ),
                  content: const Text('Are you sure you want to delete this podcast?'),
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
                    )
                  ],
                )
              );

              if (result == true) {
                final isDeleted = await ref.read(podcastsProvider.notifier).deletePodcast(podcast.id);
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
                    description: const Text('This podcast successfully deleted!'),
                  ).show(context);
                }
              }
            },
          )
        ],
      ),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Image(
            width: 60,
            height: 60,
            image: CachedNetworkImageProvider('${Constants.S3_BUCKET_URL}/${podcast.imageUrl}'),
          ),
        ),
        title: Text(podcast.title),
        subtitle: Text(podcast.description),
        trailing: SvgPicture.asset(
          'assets/icons/chevron_right_filled.svg',
          width: 24,
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (ctx) => ListenPodcastScreen(podcast: podcast))
          );
        },
      ),
    );
  }
}