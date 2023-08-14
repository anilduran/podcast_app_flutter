import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../providers/me_provider.dart';
import '../components/file_upload_progress_bar.dart';
import 'package:dio/dio.dart';
import '../utils/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/user.dart';
import '../components/change_username_list_tile.dart';
import '../components/change_email_list_tile.dart';
import '../components/change_password_list_tile.dart';
import '../components/change_theme_list_tile.dart';
import '../components/sign_out_list_tile.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool isEditOpened = false;
  File? image;
  int imageUploadProgress = 0;

  @override
  void initState() {
    super.initState();
    ref.read(authProvider.notifier).fetchMyCredentials();
  }

  
  @override
  Widget build(BuildContext context) {

    final me = ref.watch(meProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Screen'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isEditOpened = true;
                          });
                        },
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: const Color.fromRGBO(34, 40, 49, 1),
                          backgroundImage: me?.profilePhotoUrl != null ? CachedNetworkImageProvider('${Constants.S3_BUCKET_URL}/${me!.profilePhotoUrl}') : null,
                        ),
                      ),
                      if (isEditOpened)
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
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(100.0)
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
                                    width: 24,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 20,),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        me?.username ?? '',
                        style: const TextStyle(
                          fontSize: 16
                        ),
                      ),
                      Text(
                        me?.email ?? '',
                        style: const TextStyle(
                          color: Colors.grey
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            if (image != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Image(
                            image: FileImage(image!),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 200,
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                image = null;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30.0)
                              ),
                              child: SvgPicture.asset(
                                'assets/icons/close.svg',
                                width: 24,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    FileUploadProgressBar(progress: imageUploadProgress),
                    const SizedBox(height: 10,),
                    ElevatedButton(
                      onPressed: () async {
                        
                        try {
                          final dio = Dio();

                          final token = ref.read(authProvider);

                          final imageResponse = await dio.get('${Constants.BASE_URL}/api/podcast-lists/image-presigned-url', options: Options(
                            headers: {
                              'x-access-token': token
                            }
                          ));

                          final url = imageResponse.data['url'];
                          final key = imageResponse.data['key'];

                          await dio.put(
                            url, 
                            data: image!.openRead(), 
                            options: Options(
                              contentType: 'image/jpeg',
                              headers: {
                                Headers.contentLengthHeader: await image!.length()
                              }
                            ),
                            onSendProgress: (count, total) {
                              setState(() {
                                imageUploadProgress = ((count / total) * 100).round();
                              });
                            },
                          );

                          final response = await dio.put('${Constants.BASE_URL}/api/me', data: {
                            'profilePhotoUrl': key
                          }, options: Options(
                            headers: {
                              'x-access-token': token
                            }
                          ));

                          if (response.statusCode == 200 && mounted) {
                            setState(() {
                              imageUploadProgress = 0;
                              image = null;
                            });

                            ref.read(meProvider.notifier).state = User.fromJson(response.data);

                            MotionToast.success(
                              enableAnimation: false,
                              animationType: AnimationType.fromLeft,
                              title: const Text(
                                'Success!',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              description: const Text('Profile photo successfully updated!'),
                            ).show(context);
                          }

                          
                        } catch(error) {
                          MotionToast.error(
                            enableAnimation: false,
                            animationType: AnimationType.fromLeft,
                            title: const Text(
                              'Error!',
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            description: const Text('Unexpected error!'),
                          ).show(context);
                        }

                      },  
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ), 
            const ChangeUsernameListTile(),
            const ChangeEmailListTile(),
            const ChangePasswordListTile(),
            const ChangeThemeListTie(),
            const SignOutListTile(),
          ],
        ),
      ),
    );
  }
}