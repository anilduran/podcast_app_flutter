import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class FeedScreenSliderShimmer extends StatelessWidget {
  const FeedScreenSliderShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300, 
      highlightColor: Colors.grey.shade100,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(12.0)
        ),
        width: double.infinity,
        height: 200,
      ),
    );
  }
}