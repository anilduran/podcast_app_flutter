import 'package:flutter/material.dart';

class FileUploadProgressBar extends StatelessWidget {

  int progress;

  FileUploadProgressBar({
    super.key,
    required this.progress
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width - 32,
          height: 20, 
          decoration: BoxDecoration(
            color: Colors.grey[400],
            borderRadius: BorderRadius.circular(12.0)
          ),
        ),
        Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          child: Container(
            width: (MediaQuery.of(context).size.width - 32) * (progress / 100),
            height: 20,
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(120.0)
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          bottom: 0,
          left: 0,
          child: Center(
            child: Text(
              '%$progress',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
        )
      ],
    );
  }
}