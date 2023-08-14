import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../screens/library_detail_screen.dart';
import '../models/podcast_list.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../utils/constants.dart';

class LibraryPodcastCard extends StatelessWidget {

  PodcastList podcastList;

  LibraryPodcastCard({super.key, required this.podcastList});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (ctx) => LibraryDetailScreen(podcastList: podcastList, isFollowing: true,))
          );
        },
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image(
                image: CachedNetworkImageProvider('${Constants.S3_BUCKET_URL}/${podcastList.imageUrl}'),
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
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
                    podcastList.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      CircleAvatar(
                        foregroundImage: podcastList.creator.profilePhotoUrl != null ? CachedNetworkImageProvider('${Constants.S3_BUCKET_URL}/${podcastList.creator.profilePhotoUrl}') : null,
                      ),
                      const SizedBox(width: 10,),
                      Text(
                        podcastList.creator.username,
                        style: TextStyle(
                          color: Colors.white
                        ),
                      ),
                      const Spacer(),
                      SvgPicture.asset(
                        'assets/icons/chevron_right_filled.svg',
                        color: Colors.white,
                        width: 18,
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}