library custom_video_player;

import 'dart:io';
import 'package:general_widgets/general_widgets.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
// **** CHEWIE CODE ***
// simply a wrapper to the video_player library to provide playback controls (a gui) for the video player
import 'package:chewie/chewie.dart';

class ChewiePlayerScreen extends StatefulWidget {
  final Key? key;
  final String? networkUrl;
  final String? localUrl;
  final File? localFile;
  final bool looping;
  final bool autoPlay;
  final bool showControls;
  final bool mute;

  /// overrides default controller
  final ChewieController? chewieController;

  // {} = named parameters are required on class initialisation
  // @required = required parameters to be passed
  ChewiePlayerScreen({
    this.key,
    this.networkUrl,
    this.localUrl,
    this.localFile,
    this.looping = false,
    this.autoPlay = false,
    this.showControls = true,
    this.mute = false,
    this.chewieController,
  }) : super(key: key);

  @override
  _ChewiePlayerScreenState createState() => _ChewiePlayerScreenState();
}

class _ChewiePlayerScreenState extends State<ChewiePlayerScreen> {
  ChewieController? _chewieController;
  bool _videoCheck = true;
  VideoPlayerController? videoPlayerController;

  void _getChewieVideo() {
    if (widget.chewieController != null) {
      _chewieController = widget.chewieController;
      return;
    }

    // https://flutter.dev/docs/cookbook/plugins/play-video
    if (widget.networkUrl != null) {
      videoPlayerController = VideoPlayerController.network(widget.networkUrl!);
    } else if (widget.localUrl != null) {
      videoPlayerController = VideoPlayerController.asset(widget.localUrl!);
    } else if (widget.localFile != null) {
      videoPlayerController = VideoPlayerController.file(widget.localFile!);
    } else {
      // no video details passed to widget... comment error handling
      _videoCheck = false;
      // end function execution
      return;
    }

    // add any additional configuration not allowed by the chewie player
    if (widget.mute == true) {
      videoPlayerController!.setVolume(0);
    }

    _chewieController = ChewieController(
      videoPlayerController: videoPlayerController!,
      aspectRatio: 1 / 1,
      // Shows the first frame of the video as opposed to a dark screen
      autoInitialize: true,
      looping: widget.looping,
      autoPlay: widget.autoPlay,
      // whether to show playback controls
      showControls: widget.showControls,
      // prevent control overlay when loading to improve aesthetics
      showControlsOnInitialize: false,
      allowMuting: true,
      // Error handling. e.g. playing a video from a non existant url
      errorBuilder: (context, errorMessage) {
        return ShowError(error: errorMessage);
      },
    );
  }

  @override
  void initState() {
    _getChewieVideo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_videoCheck != true) {
      return AspectRatio(
        aspectRatio: 1,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error),
              SizedBox(height: 20),
              Text('Error: No video url provided'),
            ],
          ),
        ),
      );
    }
    return Chewie(
      controller: _chewieController!,
    );
  }

  void killResources() {
    videoPlayerController?.dispose();
    _chewieController?.dispose();
  }

  // discard any resources used by the the object / state in this case the video player controller to prevent memory leaks
  @override
  void dispose() {
    killResources();
    super.dispose();
  }

  // if a key is not passed to the widget on creation, the vbideo player widget may not be updated correctly when
  // flutter walks the element tree. Can use this inherited function to account for this scenario if necessary.
  // @override
  // void didUpdateWidget(ChewiePlayerScreen oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  // }
}
