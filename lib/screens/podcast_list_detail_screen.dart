import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import './create_podcast_screen.dart';
import 'dart:io';
import '../models/podcast_list.dart';
import '../utils/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/podcasts_provider.dart';
import '../components/podcast_list_tile.dart';
import '../components/podcast_list_tile_shimmer.dart';
class PodcastListDetailScreen extends ConsumerStatefulWidget {

  PodcastList podcastList;

  PodcastListDetailScreen({super.key, required this.podcastList});

  @override
  ConsumerState<PodcastListDetailScreen> createState() => _PodcastListDetailScreenState();
}

class _PodcastListDetailScreenState extends ConsumerState<PodcastListDetailScreen> {

  bool isEditOpened = true;
  File? image;
  bool isLoading = false;
  bool isInit = true;

  @override
  void initState() {
    super.initState();
    
  }
  
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (isInit) {
      setState(() {
        isLoading = true;
      });
      await ref.read(podcastsProvider.notifier).fetchPodcastsByPodcastListID(widget.podcastList.id);
      setState(() {
        isLoading = false;
      });
    }
    isInit = false;
  }

  @override
  Widget build(BuildContext context) {

    final podcasts = ref.watch(podcastsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.podcastList.title),
        actions: [
          // IconButton(
          //   icon: SvgPicture.asset(
          //     'assets/icons/edit_filled.svg',
          //     width: 24,
          //     color: Colors.white,
          //   ),
          //   onPressed: () {
          //     showModalBottomSheet(
          //       context: context, 
          //       shape: const RoundedRectangleBorder(
          //         borderRadius: BorderRadius.vertical(
          //           top: Radius.circular(12.0)
          //         )
          //       ),
          //       builder: (ctx) => StatefulBuilder(
          //         builder: (ctx, setState) => Padding(
          //           padding: const EdgeInsets.all(16.0),
          //           child: SingleChildScrollView(
          //             physics: const BouncingScrollPhysics(),
          //             child: Column(

          //               crossAxisAlignment: CrossAxisAlignment.stretch,
          //               children: [
          //                 Align(
          //                   alignment: Alignment.center,
          //                   child: Container(
          //                     height: 5,
          //                     width: 100,
          //                     decoration: BoxDecoration(
          //                       borderRadius: BorderRadius.circular(12.0),
          //                       color: Colors.grey
          //                     ),
          //                   ),
          //                 ),
          //                 const SizedBox(height: 10,),
          //                 Align(
          //                   alignment: Alignment.centerRight,
          //                   child: IconButton(
          //                     onPressed: () {
          //                       Navigator.of(ctx).pop();
          //                     },
          //                     icon: SvgPicture.asset(
          //                       'assets/icons/close.svg',
          //                       width: 24,
          //                     ),
          //                   ),
          //                 ),
          //                 const SizedBox(height: 10,),
          //                 Align(
          //                   alignment: Alignment.center,
          //                   child: Stack(
          //                     children: [
          //                       GestureDetector(
          //                         onTap: () {
          //                           setState(() {
          //                             isEditOpened = true;
          //                           });
          //                         },
          //                         child: Container(
          //                           width: 150,
          //                           height: 150,
          //                           decoration: BoxDecoration(
          //                             color: Colors.grey,
          //                             borderRadius: BorderRadius.circular(12.0),
          //                             image: image != null ? DecorationImage(
          //                               image: FileImage(image!),
          //                               fit: BoxFit.cover
          //                             ) : null
          //                           ),
          //                         ),
          //                       ),
          //                       if (isEditOpened == true)
          //                         Positioned(
          //                           top: 0,
          //                           right: 0,
          //                           bottom: 0,
          //                           left: 0,
          //                           child: GestureDetector(
          //                             onTap: () {
          //                               setState(() {
          //                                 isEditOpened = false;
          //                               });
          //                             },
          //                             child: Container(
          //                               decoration: BoxDecoration(
          //                                 borderRadius: BorderRadius.circular(12.0),
          //                                 color: Colors.black.withOpacity(0.5)
          //                               ),
          //                               child: Center(
          //                                 child: IconButton(
          //                                   onPressed: () async {
                                              
          //                                     final picker = ImagePicker();
          //                                     final result = await picker.pickImage(source: ImageSource.gallery);
          //                                     if (result != null) {
          //                                       setState(() {
          //                                         image = File(result.path);
          //                                         isEditOpened = false; 
          //                                       });
          //                                     }

          //                                   },
          //                                   icon: SvgPicture.asset(
          //                                     'assets/icons/edit_filled.svg',
          //                                     width: 32,
          //                                     color: Colors.white,
          //                                   ),
          //                                 ),
          //                               ),
          //                             ),
          //                           ),
          //                         ),
    
          //                     ],
          //                   ),
          //                 ),
          //                 const SizedBox(height: 10,),
          //                 TextFormField(
          //                   decoration: InputDecoration(
          //                     border: OutlineInputBorder(
          //                       borderRadius: BorderRadius.circular(30.0)
          //                     ),
          //                     label: const Text('Title'),
          //                     hintText: 'Enter a title'
          //                   ),
          //                 ),
          //                 const SizedBox(height: 10,),
          //                 TextFormField(
          //                   decoration: InputDecoration(
          //                     border: OutlineInputBorder(
          //                       borderRadius: BorderRadius.circular(30.0)
          //                     ),
          //                     label: const Text('Description'),
          //                     hintText: 'Enter a description...'
          //                   ),
          //                 ),
          //                 const SizedBox(height: 10,),
          //                 ElevatedButton(
          //                   onPressed: () {

          //                   },
          //                   child: const Text('Save'),
          //                 )
          //               ],
          //             ),
          //           ),
          //         ),
          //       )
          //     );
          //   },
          // ),
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/add.svg',
              width: 24,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => CreatePodcastScreen(podcastList: widget.podcastList,))
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)
                ),
                child: Image(
                  width: double.infinity,
                  height: 250,
                  image: CachedNetworkImageProvider('${Constants.S3_BUCKET_URL}/${widget.podcastList.imageUrl}'),
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
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0)
                    )
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
                      widget.podcastList.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                      ),
                    ),

                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16, top: 16),
            child: Text(
              widget.podcastList.description,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Items',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24
              ),
            ),
          ),
          Expanded(
            child: isLoading ? const PodcastListTileShimmer() : ListView.builder(
              itemCount: podcasts.length,
              itemBuilder: (ctx, i) => PodcastListTile(podcast: podcasts[i]),
            ),
          ),
        ],
      ),
    );
  }
}