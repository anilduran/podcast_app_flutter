import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import '../models/user.dart';
import '../providers/me_provider.dart';
import '../providers/auth_provider.dart';
import '../utils/constants.dart';

class ChangeUsernameListTile extends ConsumerStatefulWidget {
  const ChangeUsernameListTile({super.key});

  @override
  ConsumerState<ChangeUsernameListTile> createState() => _ChangeUsernameListTileState();
}

class _ChangeUsernameListTileState extends ConsumerState<ChangeUsernameListTile> {

  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final reUsernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Change Username'),
      trailing: SvgPicture.asset(
        'assets/icons/chevron_right_filled.svg',
        width: 24,
      ),
      onTap: () {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(12.0)
            )
          ), 
          builder: (ctx) => StatefulBuilder(
            builder: (ctx, setState) => SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                      Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 100,
                        height: 5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: SvgPicture.asset(
                          'assets/icons/close.svg',
                          width: 24,
                        ),
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                      ),
                    ),
                    const SizedBox(height: 10,),
                    const Text(
                      'Change Username',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24
                      ),
                    ),
                    const SizedBox(height: 10,),
                    TextFormField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0)
                        ),
                        label: const Text('Username'),
                        hintText: 'Enter a username'
                      ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 10,),
                    TextFormField(
                      controller: reUsernameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0)
                        ),
                        label: const Text('Username'),
                        hintText: 'Enter a username'
                      ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 10,),
                    ElevatedButton(
                      onPressed: () async {
                        
                        try {
                          final dio = Dio();

                          final token = ref.read(authProvider);

                          final response = await dio.put('${Constants.BASE_URL}/api/me', data: {
                            'username': usernameController.text
                          }, options: Options(
                            headers: {
                              'x-access-token': token
                            }
                          ));

                          if (response.statusCode == 200 && mounted) {
                            ref.read(meProvider.notifier).state = User.fromJson(response.data);
                            MotionToast.success(
                              animationType: AnimationType.fromLeft,
                              enableAnimation: false,
                              title: const Text(
                                'Successfull!',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold
                                ),
                              ), 
                              description: const Text('Username successfully changed!'),
                            ).show(context);
                          } else {
                            MotionToast.error(
                              animationType: AnimationType.fromLeft,
                              enableAnimation: false,
                              title: const Text(
                                'Error!',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              description: const Text('Unexpected error!'),
                            ).show(context);
                          }

                        } catch(error) {
                          MotionToast.error(
                            animationType: AnimationType.fromLeft,
                            enableAnimation: false,
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
                      child: const Text('Change'),
                    )
                  ],
                ),
              ),
            ),
          )
        );
      },
    );
  }
}