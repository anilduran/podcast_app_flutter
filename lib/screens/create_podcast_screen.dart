import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:podcast_app/providers/podcasts_provider.dart';
import '../components/file_upload_progress_bar.dart';
import '../models/podcast_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreatePodcastScreen extends ConsumerStatefulWidget {
  PodcastList podcastList;

  CreatePodcastScreen({super.key, required this.podcastList});

  @override
  ConsumerState<CreatePodcastScreen> createState() => _CreatePodcastScreenState();
}

class _CreatePodcastScreenState extends ConsumerState<CreatePodcastScreen> {


  final formKey = GlobalKey<FormState>();
  bool isImageEditOpened = false;
  bool isSoundEditOpened = false;
  File? image;
  File? sound;
  FilePickerResult? result2;
  int imageUploadProgress = 0;
  int podcastUploadProgress = 0;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final player = AudioPlayer();

  bool isButtonActive = true;

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Podcast Screen'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isImageEditOpened = true;
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(34, 40, 49, 1),
                        borderRadius: BorderRadius.circular(12.0),
                        image: image != null ? DecorationImage(
                          image: FileImage(image!),
                          fit: BoxFit.cover
                        ) : null
                      ),
                    ),
                  ),
                  if (isImageEditOpened)
                    Positioned(
                      top: 0,
                      right: 0,
                      bottom: 0,
                      left: 0,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isImageEditOpened = false;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12.0)
                          ),
                          child: Center(
                            child: IconButton(
                              onPressed: () async {
                                final picker = ImagePicker();
                                final result = await picker.pickImage(source: ImageSource.gallery);
                                if (result != null) {
                                  setState(() {
                                    image = File(result.path);
                                    isImageEditOpened = false;
                                  });
                                  
                                }
                              },
                              icon: SvgPicture.asset(
                                'assets/icons/edit_filled.svg',
                                width: 48,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10,),
              if (!isButtonActive) FileUploadProgressBar(progress: imageUploadProgress),
              const SizedBox(height: 10,),
              Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isSoundEditOpened = true;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromRGBO(34, 40, 49, 1),
                          width: 2,
                        ), 
                        borderRadius: BorderRadius.circular(12.0)
                      ),
                      child: Column(
                        children: [
                          StreamBuilder(
                            stream: player.positionStream,
                            builder: (ctx, snapshot) => ProgressBar(
                              thumbColor: Color.fromRGBO(34, 40, 49, 1),
                              progressBarColor: Color.fromRGBO(34, 40, 49, 1),
                              baseBarColor: Colors.grey,
                              progress: snapshot.data ??  Duration.zero, 
                              total: player.duration ?? Duration.zero,
                              onSeek: (duration) {
                                player.seek(duration);
                              },
                              onDragStart: (d) async {
                                await player.stop();
                              },
                              onDragEnd: () async {
                                await player.play();
                              },
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (player.position.inSeconds - 10 < 0) {
                                    player.seek(Duration.zero);
                                  } else {
                                    player.seek(Duration(seconds: player.position.inSeconds - 10));
                                  }
                                },
                                icon: SvgPicture.asset(
                                  'assets/icons/replay_filled.svg',
                                  width: 48,
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  if (player.playing) {
                                    await player.stop();
                                  } else {
                                    await player.play();
                                  }
                                },
                                icon: StreamBuilder(
                                  stream: player.playingStream,
                                  builder: (ctx, snapshot) => snapshot.data == true ? SvgPicture.asset(
                                    'assets/icons/pause_filled.svg',
                                    width: 48,
                                  ) : SvgPicture.asset(
                                    'assets/icons/play_arrow_filled.svg',
                                    width: 48,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  if (player.position.inSeconds + 10 > player.duration!.inSeconds) {
                                    player.seek(player.duration);
                                  } else {
                                    player.seek(Duration(seconds: player.position.inSeconds + 10));
                                  }
                                },
                                icon: SvgPicture.asset(
                                  'assets/icons/forward_filled.svg',
                                  width: 48,
                                ),
                              ),

                            ],
                          ),
                        ],
                      )
                    ),
                  ),
                  if (isSoundEditOpened)
                    Positioned(
                      top: 0,
                      right: 0,
                      bottom: 0,
                      left: 0,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isSoundEditOpened = false;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: Colors.black.withOpacity(0.5)
                          ),
                          child: Center(
                            child: IconButton(
                              onPressed: () async {
                                final result = await FilePicker.platform.pickFiles(
                                  allowMultiple: false,
                                  type: FileType.custom,
                                  allowedExtensions: ['mp3']
                                );
        
                                result2 = result;
                                if (result != null) {
                                  setState(() {
                                    sound = File(result.files.single.path!);
                                    isSoundEditOpened = false;
                                  });
                                  await player.setFilePath(result.files.single.path!);
                                  player.play();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0)
                                )
                              ),
                              icon: SvgPicture.asset(
                                'assets/icons/edit_filled.svg',
                                width: 48,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )
                    ),
                ],
              ),
              const SizedBox(height: 10,),
              if (!isButtonActive) FileUploadProgressBar(progress: podcastUploadProgress),
              const SizedBox(height: 10,),
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  label: const Text('Title'),
                  hintText: 'Enter a title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0)
                  )
                ),
              ),
              const SizedBox(height: 10,),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  label: const Text('Description'),
                  hintText: 'Enter a description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0)
                  )
                ),
              ),
              const SizedBox(height: 10,),
              ElevatedButton(
                onPressed: isButtonActive ? () async {
                  
                  try {
                    if (image != null && sound != null) {
                      setState(() {
                      isButtonActive = false;
                    });

                    await ref.read(podcastsProvider.notifier).createPodcast(
                      titleController.text,
                      descriptionController.text,
                      widget.podcastList.id,
                      image!,
                      sound!,
                      (progress) { 
                        setState(() {
                          imageUploadProgress = progress;
                        });
                      },
                      (progress) {
                        setState(() {
                          podcastUploadProgress = progress;
                        });
                      }
                    );

                    if (mounted) {
                      Navigator.of(context).pop();
                    }
                  }

                  } catch(error) {
                    print(error);
                  } finally {
                    setState(() {
                      isButtonActive = true;
                    });
                  }
        
                } : null, 
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30)
                ),
                child: const Text('Create')
              )
            ],
          ),
        ),
      ),
    );
  }
}