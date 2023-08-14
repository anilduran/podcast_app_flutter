import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../components/file_upload_progress_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/constants.dart';
import '../providers/auth_provider.dart';
import '../providers/podcast_lists_provider.dart';
class CreatePodcastListScreen extends ConsumerStatefulWidget {


  const CreatePodcastListScreen({super.key});

  @override
  ConsumerState<CreatePodcastListScreen> createState() => _CreatePodcastListScreenState();
}

class _CreatePodcastListScreenState extends ConsumerState<CreatePodcastListScreen> {

  final formKey = GlobalKey<FormState>();
  File? image;
  bool isEditOpened = true;
  int imageUploadProgress = 0;
  final createPodcastData = {
    'title': '',
    'description': ''
  };

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  bool isButtonActive = true;
  
  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
  }
    

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Podcas List'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Create a Playlist',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24
                ),
              ),
              const SizedBox(height: 10,),
              Align(
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isEditOpened = true;
                        });
                      },
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          image: image != null ? DecorationImage(
                            image: FileImage(image!),
                            fit: BoxFit.cover
                          ) : null,
                          color: Colors.grey[400]
                        ),
                      ),
                    ),
                    if (isEditOpened == true)
                      Positioned(
                        top: 0,
                        right: 0,
                        bottom: 0,
                        left: 0,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isEditOpened = false;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
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
                                      isEditOpened = false;
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
                        )
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              if (!isButtonActive) FileUploadProgressBar(progress: imageUploadProgress),
              const SizedBox(height: 10,),
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0)
                  ),
                  label: const Text('Title'),
                  hintText: 'Enter a title'
                ),
                onSaved: (value) {
                  createPodcastData['title'] = value!;
                },
              ),
              const SizedBox(height: 10,),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0)
                  ),
                  label: const Text('Description'),
                  hintText: 'Enter a description'
                ),
                onSaved: (value) {
                  createPodcastData['description'] = value!;
                },
              ),
              const SizedBox(height: 10,),
              // ListTile(
              //   title: const Text('Is public?'),
              //   trailing: Switch(
              //     value: true, 
              //     onChanged: (value) {
                    
              //     }
              //   ),
              // ),
              // const SizedBox(height: 10,),
              // Wrap(
              //   children: categories.map((category) => GestureDetector(
              //     onTap: () {
            
              //     },
              //     child: Chip(
              //       label: Text(
              //         category.name,
              //       ),
              //     ),
              //   )).toList(),
              // ),
              const SizedBox(height: 10,),
              ElevatedButton(
                onPressed: isButtonActive ? () async {
                  if (formKey.currentState!.validate()) {

                    try {
                      setState(() {
                        isButtonActive = false;
                      });

                      final dio = Dio();
        
                      final token = ref.read(authProvider);

                      final imageResponse = await dio.get('${Constants.BASE_URL}/api/podcast-lists/image-presigned-url', options: Options(
                        headers: {
                          'x-access-token': token
                        }
                      ));
        
                      final imageUrl = imageResponse.data['url'];
                      final imageKey = imageResponse.data['key'];
        
                      await dio.put(
                        imageUrl,
                        data: image!.openRead(),
                        options: Options(
                          contentType: 'image/jpg',
                          headers: {
                            Headers.contentLengthHeader: await image!.length()
                          }
                        ),
                        onSendProgress: (count, total) {
                          setState(() {
                            imageUploadProgress = ((count / total) * 100).round();
                          });
                        }
                      );
        
                      final result = await ref.read(podcastListsProvider.notifier).createPodcastList(titleController.text, descriptionController.text, imageKey);

                      if (result && mounted) {
                        Navigator.of(context).pop();
                      }
        
                    } catch(error) {
                      print(error);
                    } finally {
                      setState(() {
                        isButtonActive = true;
                      });
                    }
                  }
                } : null,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30)
                ),
                child: const Text('Create'),
              )
            ],
          ),
        ),
      )
    );
  }
}