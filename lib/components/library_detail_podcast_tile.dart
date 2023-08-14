import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:podcast_app/models/podcast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:podcast_app/screens/listen_podcast_screen.dart';
import 'package:podcast_app/utils/constants.dart';

class LibraryDetailPodcastTile extends StatelessWidget {
  Podcast podcast;

  LibraryDetailPodcastTile({super.key, required this.podcast});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => ListenPodcastScreen(podcast: podcast)
          )
        );
      },
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Image(
          image: CachedNetworkImageProvider('${Constants.S3_BUCKET_URL}/${podcast.imageUrl}'),
          fit: BoxFit.cover,
          width: 50,
          height: 50,
        ),
      ),
      title: Row(
        children: [
          Text(
            podcast.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
        ],
      ),
      subtitle: Text(podcast.description),
      trailing: SvgPicture.asset(
        'assets/icons/chevron_right_filled.svg',
        width: 24,
      ),
    );
  }
}