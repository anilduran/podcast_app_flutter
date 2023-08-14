import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LibraryPodcastListCardShimmer extends StatelessWidget {
  const LibraryPodcastListCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {

    Widget card() => Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(12.0)
      ),
    );

    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300, 
      highlightColor: Colors.grey.shade100,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            card(),
            const SizedBox(height: 10,),
            card(),
            const SizedBox(height: 10,),
            card(),
            const SizedBox(height: 10,),
            card(),
            const SizedBox(height: 10,),
            card(),
            const SizedBox(height: 10,),
            card(),
            const SizedBox(height: 10,),
            card(),
          ],
        ),
      )
    );
  }
}