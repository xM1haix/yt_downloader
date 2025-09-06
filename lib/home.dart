import "dart:io";

import "package:flutter/material.dart";
import "package:youtube_explode_dart/youtube_explode_dart.dart";

const outputPath =
    "/home/xM1haix/Desktop/projects/flutter/yt_downloader/test.mp4";
const videoUrl = "https://www.youtube.com/watch?v=Mf_pvNkNJjk";

Future<void> download() async {
  final ytExplode = YoutubeExplode();

  try {
    // Get video info
    final video = await ytExplode.videos.get(videoUrl);

    // Get manifest for streams
    final manifest = await ytExplode.videos.streamsClient.getManifest(video.id);

    // Select audio-only and video streams (you can customize this selection)
    final audioStreamInfo = manifest.audioOnly.first;
    final videoStreamInfo = manifest.video.first;

    // Get stream data as byte streams
    final audioStream = ytExplode.videos.streamsClient.get(audioStreamInfo);
    final videoStream = ytExplode.videos.streamsClient.get(videoStreamInfo);

    // Save audio
    final audioFile = File(
      "${outputPath}_audio.${audioStreamInfo.container.name}",
    );
    final audioFileStream = audioFile.openWrite();
    await audioStream.pipe(audioFileStream);
    await audioFileStream.flush();
    await audioFileStream.close();

    // Save video
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

class Home extends StatefulWidget {
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
