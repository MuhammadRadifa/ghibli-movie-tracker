import 'package:flutter/material.dart';
import 'package:ghibli_movies/layers/data/constant/app_color.dart';
import 'package:ghibli_movies/layers/data/provider/film_state.dart';
import 'package:ghibli_movies/layers/presentation/screen/detail/detail.dart';
import 'package:ghibli_movies/layers/presentation/screen/favorite/favorite.dart';
import 'package:ghibli_movies/layers/presentation/screen/home/home.dart';
import 'package:ghibli_movies/layers/presentation/screen/about/settings.dart';
import 'package:ghibli_movies/layers/presentation/screen/statistics/statistics.dart';
import 'package:ghibli_movies/layers/presentation/shared/bottom_bar_app_content.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => FilmState(), // Initialize FilmState
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.background),
      ),
      home: const SplashScreen(),
      routes: {'/screen': (context) => const MyHomePage()},
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate a time-consuming task (e.g., loading data) for the splash screen.
    // Replace this with your actual data loading logic.
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return; // ✅ Cek apakah context masih aktif
      Navigator.pushReplacementNamed(context, '/screen');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 300,
              height: 300,
              child: Image.asset('assets/image/logo.png', fit: BoxFit.contain),
            ),
          ],
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  late List<Widget Function()> _pageBuilders = [];
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageBuilders = [
      () => HomeScreen(
        onItemTapped: (String filmId) {
          // Update the FilmState with the selected film ID
          Provider.of<FilmState>(context, listen: false).setFilmId(filmId);
          // Navigate to DetailScreen
          _pageController.jumpToPage(2); // Assuming DetailScreen is at index 2
        },
      ),
      () => StatisticsScreen(),
      () => FavoriteScreen(
        onItemTapped: (String filmId) {
          // Update the FilmState with the selected film ID
          Provider.of<FilmState>(context, listen: false).setFilmId(filmId);
          // Navigate to DetailScreen
          _pageController.jumpToPage(3); // Assuming DetailScreen is at index 2
        },
      ),
      () => AboutScreen(),
      () => DetailScreen(),
    ];
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leadingWidth: 100,
        leading: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Image.asset('assets/image/studio.png', fit: BoxFit.contain),
        ),
        actions: [
          Center(
            child: SizedBox(
              width: 100,
              height: 100,
              child: Image.asset('assets/image/ponyo.png', fit: BoxFit.contain),
            ),
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) => setState(() => _selectedIndex = index),
        children: _pageBuilders.map((builder) => builder()).toList(),
      ),
      bottomNavigationBar: BottomBarAppContent(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) {
          setState(() {
            _selectedIndex = index;
          });
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        pageBuilders: _pageBuilders,
      ),
      floatingActionButton: SizedBox(
        width: 80,
        height: 80,
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              _selectedIndex = 1;
            });
            _pageController.animateToPage(
              1,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
          shape: const CircleBorder(
            side: BorderSide(color: AppColors.primary, width: 5.0),
          ),
          backgroundColor: AppColors.secondary,
          child: Text(
            '20/22',
            style: TextStyle(
              fontSize: 20,
              color: AppColors.background,
              fontWeight: FontWeight.bold,
            ),
          ), // Bigger icon
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
