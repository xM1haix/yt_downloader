import "package:flutter/material.dart";
import "package:yt_downloader/home.dart";

void main() {
  runApp(const MyApp());
}

///Main skelethon of the app

class MyApp extends StatelessWidget {
  ///
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark(),
      home: const Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}
