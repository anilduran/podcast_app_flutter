import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import './feed_screen.dart';
import './search_screen.dart';
import './profile_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import './library_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {

  bool isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInit) {
      ref.read(authProvider.notifier).fetchMyCredentials();
    }
    isInit = false;

  }

  int _selectedIndex = 0;
  final _screens = const [
    FeedScreen(),
    SearchScreen(),
    LibraryScreen(),
    ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/home.svg',
              width: 24,
              color: Colors.white,
            ),
            activeIcon: SvgPicture.asset(
              'assets/icons/home_filled.svg',
              width: 24,
              color: Colors.white,
            ),
            label: 'Home'
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/search.svg',
              width: 24,
              color: Colors.white,
            ),
            label: 'Search'
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/podcasts_filled.svg',
              width: 24,
              color: Colors.white,
            ),
            label: 'Library'
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/settings.svg',
              width: 24,
              color: Colors.white,
            ),
            activeIcon: SvgPicture.asset(
              'assets/icons/settings_filled.svg',
              width: 24,
              color: Colors.white,
            ),
            label: 'Profile'
          )
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}