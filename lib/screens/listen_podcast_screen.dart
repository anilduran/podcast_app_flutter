import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:podcast_app/providers/me_provider.dart';
import 'package:podcast_app/providers/podcasts_provider.dart';
import '../models/podcast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../utils/constants.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import '../utils/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:like_button/like_button.dart';

class ListenPodcastScreen extends ConsumerStatefulWidget {

  Podcast podcast;

  ListenPodcastScreen({super.key, required this.podcast});

  @override
  ConsumerState<ListenPodcastScreen> createState() => _ListenPodcastScreenState();
}

class _ListenPodcastScreenState extends ConsumerState<ListenPodcastScreen> {


  final player = AudioPlayer();
  bool isInit = true;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (isInit) {
      try { 
        await player.setUrl('${Constants.S3_BUCKET_URL}/${widget.podcast.podcastUrl}');
        player.play();
      } catch(error) {
        print(error);
      }
    }
    isInit = false;
  }

  @override
  void dispose() {
    super.dispose();
    player.dispose();
  }

  Future<void> likePodcast() async {
    try {

      final me = ref.read(meProvider);
      if (me != null) {
        bool result = await ref.read(podcastsProvider.notifier).likePodcast(widget.podcast.id);

        if (result && mounted) {
          MotionToast.success(
            enableAnimation: false,
            animationType: AnimationType.fromLeft,
            title: const Text(
              'Successfully!',
              style: TextStyle(
                fontWeight: FontWeight.bold
              ),
            ),
            description: const Text('You successfully liked podcast!'),
          ).show(context);
        } else {
          MotionToast.error(
            enableAnimation: false,
            animationType: AnimationType.fromLeft,
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

    } catch(error) {
      MotionToast.error(
        enableAnimation: false,
        animationType: AnimationType.fromLeft,
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

  Future<void> unlikePodcast() async {
    try {
      final me = ref.read(meProvider);

      if (me != null) {
        bool result = await ref.read(podcastsProvider.notifier).unlikePodcast(widget.podcast.id);

        if (result && mounted) {
          MotionToast.success(
            enableAnimation: false,
            animationType: AnimationType.fromLeft,
            title: const Text(
              'Successfull!',
              style: TextStyle(
                fontWeight: FontWeight.bold
              ),
            ),
            description: const Text('You successfully unliked podcast!'),
          ).show(context);
        } else {
          MotionToast.error(
            enableAnimation: false,
            animationType: AnimationType.fromLeft,
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

    } catch(error) {
      MotionToast.error(
        enableAnimation: false,
        animationType: AnimationType.fromLeft,
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.podcast.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image(
                    width: double.infinity,
                    height: 300,
                    image: CachedNetworkImageProvider('${Constants.S3_BUCKET_URL}/${widget.podcast.imageUrl}'),
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
                      borderRadius: BorderRadius.circular(12.0),
                      color: Colors.black.withOpacity(0.5)
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
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
                )
              ],
            ),
            const SizedBox(height: 10,),
            StreamBuilder(
              stream: player.positionStream,
              builder: (ctx, snapshot) => ProgressBar(
                thumbColor: Color.fromRGBO(34, 40, 49, 1),
                baseBarColor: Colors.grey,
                progressBarColor: Color.fromRGBO(34, 40, 49, 1),
                progress: snapshot.data ?? Duration.zero, 
                total: player.duration ?? Duration.zero,
                onSeek: (duration) {
                  player.seek(duration);
                },
                onDragStart: (d) async {
                  await player.stop();
                },
                onDragEnd: () async {
                  await player.play();
                }
              ),
            ),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {

                  },
                  icon: SvgPicture.asset(
                    'assets/icons/skip_previous_filled.svg',
                    width: 48,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (player.position.inSeconds - 10 < 0) {
                      player.seek(Duration.zero);
                    } else {
                      player.seek(Duration(seconds: player.position.inSeconds - 10));
                    }
                  },
                  icon: SvgPicture.asset(
                    'assets/icons/replay_filled.svg',
                    width: 48,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    if (player.playing) {
                      await player.stop();
                    } else {
                      await player.play();
                    }
                  },
                  icon: StreamBuilder(
                    stream: player.playingStream,
                    builder: (ctx, snapshot) => snapshot.data == true ? SvgPicture.asset(
                      'assets/icons/pause_filled.svg',
                      width: 48,
                    ) : SvgPicture.asset(
                      'assets/icons/play_arrow_filled.svg',
                      width: 48,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (player.position.inSeconds + 10 > player.duration!.inSeconds) {
                      player.seek(player.duration);
                    } else {
                      player.seek(Duration(seconds: player.position.inSeconds + 10));
                    }
                  },
                  icon: SvgPicture.asset(
                    'assets/icons/forward_filled.svg',
                    width: 48,
                  ),
                ),
                IconButton(
                  onPressed: null,
                  icon: SvgPicture.asset(
                    'assets/icons/skip_next_filled.svg',
                    width: 48,
                  ),
                )
              ],
            ),
            Text(widget.podcast.description),
          ],
        ),
      ),
    );
  }
}