import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class FeedScreenPodcastListCardShimmer extends StatelessWidget {
  const FeedScreenPodcastListCardShimmer({super.key});

  SizedBox item() {
    return SizedBox(
      width: 180,
      child: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                color: Colors.grey
              ),
            ),
            const SizedBox(height: 10,),
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.grey
                  ),
                ),
                const SizedBox(width: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 100,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Colors.grey
                      ),
                    ),
                    const SizedBox(height: 5,),
                    Container(
                      width: 70,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Colors.grey
                      ),
                    )
                  ],
                )
              ],
            ), 
            const SizedBox(height: 10,),
            Container(
              width: 150,
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
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
        
          // PodcastListTileShimmer()
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300, 
            highlightColor: Colors.grey.shade100,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  item(),
                  item(),
                  item(),
                  item(),
                  item(),
                  item(),
                  item(),
                  item(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}