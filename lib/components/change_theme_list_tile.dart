import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChangeThemeListTie extends StatefulWidget {
  const ChangeThemeListTie({super.key});

  @override
  State<ChangeThemeListTie> createState() => _ChangeThemeListTieState();
}

class _ChangeThemeListTieState extends State<ChangeThemeListTie> {

  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        setState(() {
          isDarkMode = !isDarkMode;
        });
      },
      leading: isDarkMode == false ? SvgPicture.asset(
        'assets/icons/light_mode_filled.svg',
        width: 24,
        color: Colors.orangeAccent,
      ) : SvgPicture.asset(
        'assets/icons/dark_mode_filled.svg',
        width: 24,
        color: Colors.blue,
      ),
      title: Text(isDarkMode ? 'Dark' : 'Light'),
      trailing: SvgPicture.asset(
        'assets/icons/chevron_right_filled.svg',
        width: 24,
      ),
    );
  }
}