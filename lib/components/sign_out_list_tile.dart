import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../screens/auth_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

class SignOutListTile extends ConsumerStatefulWidget {
  const SignOutListTile({super.key});

  @override
  ConsumerState<SignOutListTile> createState() => _SignOutListTileState();
}

class _SignOutListTileState extends ConsumerState<SignOutListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async {

          final bool? result = await showDialog(
            context: context, 
            builder: (ctx) => AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Are you sure?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(ctx).pop(false);
                    },
                    icon: SvgPicture.asset(
                      'assets/icons/close.svg',
                      width: 24,
                    ),
                  ),
                ],
              ),
              content: const Text('Are you sure you want to exit?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Yes'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('No'),
                ),
              ],
            )
          );

          if (result == true) {
            ref.read(authProvider.notifier).signOut();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (ctx) => const AuthScreen()
              )
            );
          }

      },
      title: const Text('Sign out'),
      trailing: SvgPicture.asset(
        'assets/icons/chevron_right_filled.svg',
        width: 24,
      ),
    );
  }
}