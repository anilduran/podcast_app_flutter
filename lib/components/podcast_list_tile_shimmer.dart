import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PodcastListTileShimmer extends StatelessWidget {
  const PodcastListTileShimmer({super.key});

  Widget listTile() => Row(
    // crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(12.0)
        ),
      ),
      const SizedBox(width: 10,),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 130,
            height: 10,
            decoration: const BoxDecoration(
              color: Colors.grey
            ),
          ),
          const SizedBox(height: 5,),
          Container(
            width: 200,
            height: 10,
            decoration: const BoxDecoration(
              color: Colors.grey
            ),
          ),
          const SizedBox(height: 5,),
          Container(
            width: 100,
            height: 10,
            decoration: const BoxDecoration(
              color: Colors.grey
            ),
          ),
        ],
      )
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300, 
      highlightColor: Colors.grey.shade100,
      enabled: true,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            listTile(),
            const SizedBox(height: 10,),
            listTile(),
            const SizedBox(height: 10,),
            listTile(),
            const SizedBox(height: 10,),
            listTile(),
            const SizedBox(height: 10,),
            listTile(),
            const SizedBox(height: 10,),
            listTile(),
            const SizedBox(height: 10,),
            listTile(),
          ],
        ),
      )
    );
  }
}