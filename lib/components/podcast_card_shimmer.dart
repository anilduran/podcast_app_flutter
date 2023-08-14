import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PodcastCardShimmer extends StatelessWidget {
  const PodcastCardShimmer({super.key});

  Widget card() => Container(
    width: 180,
    height: 240,
    decoration: BoxDecoration(
      color: Colors.grey,
      borderRadius: BorderRadius.circular(12.0)
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300, 
      highlightColor: Colors.grey.shade100,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Row(
          children: [
            card(),
            const SizedBox(width: 20,),
            card(),
            const SizedBox(width: 20,),
            card(),
          ],
        ),
      )
    );
  }
}