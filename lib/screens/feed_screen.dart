import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:podcast_app/components/feed_screen_podcast_list_card_shimmer.dart';
import 'package:podcast_app/components/feed_screen_slider_shimmer.dart';
import 'package:podcast_app/providers/podcast_lists_provider.dart';
import 'package:podcast_app/screens/library_detail_screen.dart';
import 'package:podcast_app/screens/liked_podcast_list_screen.dart';
import 'package:podcast_app/utils/constants.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import './podcast_lists_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../components/podcast_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/podcasts_provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {

  final carouselController = CarouselController();
  int activeIndex = 0;
  bool isInit = true;
  bool isPodcastListsLoading = false;
  bool isPodcastsLoading = false;
  bool isLiked = false;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (isInit) {
      setState(() {
        isPodcastListsLoading = true;
        isPodcastsLoading = true;
      });
      await Future.wait([
        ref.read(podcastListsProvider.notifier).fetchPodcastLists(),
        ref.read(podcastListsProvider.notifier).fetchMyPodcastLists(),
        ref.read(podcastsProvider.notifier).fetchPodcasts()
      ]);
      setState(() {
        isPodcastListsLoading = false;
        isPodcastsLoading = false;
      });
    }
    isInit = false;
  }

  @override
  Widget build(BuildContext context) {

    final podcasts = ref.watch(podcastsProvider);
    final podcastLists = ref.watch(podcastListsProvider);
    final myPodcastLists = ref.watch(myPodcastListsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed Screen'),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/favorite.svg',
              width: 24,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => const LikedPodcastListScreen())
              );
            },
          ),
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/list_filled.svg',
              width: 24,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => const PodcastsListScreen())
              );
            },
          ),

        ],
      ),
      body: SingleChildScrollView(
        // padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: isPodcastListsLoading == false && podcastLists.isNotEmpty ? Stack(
                children: [
                  CarouselSlider.builder(
                    carouselController: carouselController,
                    options: CarouselOptions(
                      enlargeCenterPage: true,
                      onPageChanged: ((index, reason) {
                        setState(() {
                          activeIndex = index;
                        });
                      })
                    ),
                    itemCount: podcastLists.length,
                    itemBuilder: (ctx, i, i2) => GestureDetector(
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
                              width: double.infinity,
                              image: CachedNetworkImageProvider('${Constants.S3_BUCKET_URL}/${podcastLists[i].imageUrl}'),
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
                            bottom: 10,
                            left: 20,
                            child: Text(
                              podcastLists[i].title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 80,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            carouselController.previousPage();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: SvgPicture.asset(
                              'assets/icons/chevron_left_filled.svg',
                              width: 24,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            carouselController.nextPage();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(30.0)
                            ),
                            child: SvgPicture.asset(
                              'assets/icons/chevron_right_filled.svg',
                              width: 24,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ] 
              ) : const FeedScreenSliderShimmer(),
            ),
            if (isPodcastListsLoading == false && podcastLists.isNotEmpty)
              Align(
                alignment: Alignment.center,
                child: AnimatedSmoothIndicator(
                  activeIndex: activeIndex, 
                  count: podcastLists.length,
                  effect: const JumpingDotEffect(
                    dotWidth: 10,
                    dotHeight: 10
                  ),
                  onDotClicked: (index) {
                    carouselController.jumpToPage(index);
                  },
                ),
              ),
          
            // InkWell(
            //   onTap: () {
            
            //   },
            //   child: Padding(
            //     padding: const EdgeInsets.all(16.0),
            //     child: Row(
            //       children: [
            //         const Text(
            //           'Discover',
            //           style: TextStyle(
            //             fontWeight: FontWeight.bold,
            //             fontSize: 18
            //           ),
            //         ),
            //         const Spacer(),
            //         SvgPicture.asset(
            //           'assets/icons/chevron_right_filled.svg',
            //           width: 24,
            //         )
            //       ],
            //     ),
            //   ),
            // ),
            isPodcastListsLoading ? const FeedScreenPodcastListCardShimmer() : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: podcastLists.map((podcastList) => InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => LibraryDetailScreen(podcastList: podcastList, isFollowing: false,)
                      )
                    );
                  },
                  child: Container(
                    width: 180,
                    padding: const EdgeInsets.only(right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6.0),
                          child: Image(
                            image: CachedNetworkImageProvider('${Constants.S3_BUCKET_URL}/${podcastList.imageUrl}'),
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          children: [
                            CircleAvatar(
                              foregroundColor: Colors.red,
                              foregroundImage: podcastList.creator.profilePhotoUrl != null ? CachedNetworkImageProvider('${Constants.S3_BUCKET_URL}/${podcastList.creator.profilePhotoUrl}') : null,
                            ),
                            const SizedBox(width: 10,),
                            Text(podcastList.creator.username),
                          ],
                        ),
                        const SizedBox(height: 10,),
                        Text(
                          podcastList.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        // const SizedBox(height: 10,),
                        // Text(
                        //   podcastList.description
                        // )
                      ],
                    ),
                  ),
                )).toList(),
              ),
            ),
            // InkWell(
            //   onTap: () {
            //     ref.read(podcastsProvider.notifier).fetchPodcasts();
            //   },
            //   child: Padding(
            //     padding: const EdgeInsets.all(16.0),
            //     child: Row(
            //       children: [
            //         const Text(
            //           'Following',
            //           style: TextStyle(
            //             fontWeight: FontWeight.bold,
            //             fontSize: 18
            //           ),
            //         ),
            //         const Spacer(),
            //         SvgPicture.asset(
            //           'assets/icons/chevron_right_filled.svg',
            //           width: 24,
            //         )
            //       ],
            //     ),
            //   ),
            // ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: podcasts.map((podcast) => PodcastCard(podcast: podcast,)).toList(),
              ),
            ),
            // InkWell(
            //   onTap: () {
            
            //   },
            //   child: Padding(
            //     padding: const EdgeInsets.all(16.0),
            //     child: Row(
            //       children: [
            //         const Text(
            //           'Discover',
            //           style: TextStyle(
            //             fontWeight: FontWeight.bold,
            //             fontSize: 18
            //           ),
            //         ),
            //         const Spacer(),
            //         SvgPicture.asset(
            //           'assets/icons/chevron_right_filled.svg',
            //           width: 24,
            //         )
            //       ],
            //     ),
            //   ),
            // ),
          
          ],
        ),
      ),
    );
  }
}