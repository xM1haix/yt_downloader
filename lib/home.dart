import "dart:io";

import "package:flutter/material.dart";
import "package:youtube_explode_dart/youtube_explode_dart.dart";

///test path for download
const outputPath =
    "/home/xM1haix/Desktop/projects/flutter/yt_downloader/test.mp4";

///test Uri for a YT video
const videoUrl = "https://www.youtube.com/watch?v=Mf_pvNkNJjk";

///[Future] which should download the video
Future<void> download() async {
  final ytExplode = YoutubeExplode();

  try {
    final video = await ytExplode.videos.get(videoUrl);
    final manifest = await ytExplode.videos.streamsClient.getManifest(video.id);
    final audioStreamInfo = manifest.audioOnly.first;
    final videoStreamInfo = manifest.video.first;
    final audioStream = ytExplode.videos.streamsClient.get(audioStreamInfo);
    final videoStream = ytExplode.videos.streamsClient.get(videoStreamInfo);
    final audioFile = File(
      "${outputPath}_audio.${audioStreamInfo.container.name}",
    );
    final audioFileStream = audioFile.openWrite();
    await audioStream.pipe(audioFileStream);
    await audioFileStream.flush();
    await audioFileStream.close();
    final videoFile = File(
      "${outputPath}_video.${videoStreamInfo.container.name}",
    );
    final videoFileStream = videoFile.openWrite();
    await videoStream.pipe(videoFileStream);
    await videoFileStream.flush();
    await videoFileStream.close();
    debugPrint("Download complete!");
  } catch (e) {
    debugPrint("Error during download: $e");
  } finally {
    ytExplode.close();
  }
}

///Home page
class Home extends StatefulWidget {
  ///
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: const FloatingActionButton(onPressed: download),
    );
  }
}
