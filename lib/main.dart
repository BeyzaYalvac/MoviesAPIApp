import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterfilmleruygulamasi/FavoriteList.dart';
import 'package:flutterfilmleruygulamasi/bestOfArtist.dart';
import 'NewsList.dart';
import 'applicatonMainPage.dart';
import 'askAI.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
//
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
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
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomePage());
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.black,
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red, Colors.black],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Text(
                  "Movie IT",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            ListTile(
              tileColor: Colors.red,
              leading: const Icon(Icons.moving_sharp, color: Colors.black),
              title: const Center(
                child: Text(
                  "Popular Films",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PopularMoviePage()),
                );
              },
            ),
            const SizedBox(height: 16.0),
            ListTile(
              tileColor: Colors.white,
              leading: const Icon(Icons.moving_sharp, color: Colors.black),
              title: const Center(
                child: Text(
                  "Your Favorite Films",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FavoriteListPage()),
                );
              },
            ),
            const SizedBox(height: 16.0),
            ListTile(
              tileColor: Colors.white,
              leading: const Icon(Icons.moving_sharp, color: Colors.black),
              title: const Center(
                child: Text(
                  "Ask AI",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChatBotPage()),
                );
              },
            ),
            ListTile(
              tileColor: Colors.white,
              leading: const Icon(Icons.moving_sharp, color: Colors.red),
              title: const Center(
                child: Text(
                  "Best Of Artist",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BestOfArtists()),
                );
              },
            )
          ],
        ),
      ),
      body: const Column(
        children: [
          Expanded(child: MainPage()),
        ],
      ),
    );
  }
}
