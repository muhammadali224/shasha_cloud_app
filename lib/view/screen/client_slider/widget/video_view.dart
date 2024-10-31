// import 'package:chewie/chewie.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_cached_manager/flutter_cache_manager.dart';
// import 'package:video_player/video_player.dart';
//
// import '../../../../main.dart';
//
// class ReelsViewVideo extends StatefulWidget {
//   final String url;
//
//   const ReelsViewVideo({
//     super.key,
//     required this.url,
//   });
//
//   @override
//   State<ReelsViewVideo> createState() => _ReelsViewVideoState();
// }
//
// class _ReelsViewVideoState extends State<ReelsViewVideo> {
//   VideoPlayerController? _controller;
//   ChewieController? chewieController;
//   Chewie? playerWidget;
//   int? bufferDelay;
//
//   @override
//   void initState() {
//     super.initState();
//     initializePlayer(widget.url);
//   }
//
//   @override
//   void didUpdateWidget(covariant ReelsViewVideo oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.url != widget.url) {
//       _disposePlayer();
//       initializePlayer(widget.url);
//     }
//   }
//
//   void initializePlayer(String url) async {
//     final fileInfo = await checkCacheFor(url);
//     if (fileInfo == null) {
//       _controller = VideoPlayerController.networkUrl(Uri.parse(url));
//
//       _controller!.initialize().then((value) {
//         setState(() {
//           chewieController = ChewieController(
//             videoPlayerController: _controller!,
//             autoPlay: true,
//             looping: true,
//             showControls: false,
//             progressIndicatorDelay: bufferDelay != null
//                 ? Duration(milliseconds: bufferDelay!)
//                 : null,
//           );
//           playerWidget = Chewie(controller: chewieController!);
//         });
//         cachedForUrl(url);
//       });
//     } else {
//       final file = fileInfo.file;
//       _controller = VideoPlayerController.file(file);
//       _controller!.initialize().then((value) {
//         setState(() {
//           chewieController = ChewieController(
//             videoPlayerController: _controller!,
//             autoPlay: true,
//             looping: true,
//             showControls: false,
//             progressIndicatorDelay: bufferDelay != null
//                 ? Duration(milliseconds: bufferDelay!)
//                 : null,
//           );
//           playerWidget = Chewie(controller: chewieController!);
//         });
//       });
//     }
//   }
//
//   Future<FileInfo?> checkCacheFor(String url) async {
//     final FileInfo? value = await DefaultCacheManager().getFileFromCache(url);
//     return value;
//   }
//
//   void cachedForUrl(String url) async {
//     await DefaultCacheManager().getSingleFile(url).then((value) {
//       logger.d('Downloaded successfully for $url');
//     });
//   }
//
//   void _disposePlayer() {
//     _controller?.pause();
//     _controller?.dispose();
//     chewieController?.dispose();
//   }
//
//   @override
//   void dispose() {
//     _disposePlayer();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return (chewieController != null && _controller!.value.isInitialized)
//         ? Transform.scale(
//             // ? Transform(
//             // transform: Matrix4.identity()..scale(1.0, 1.1),
//             // scale: 1.05,
//             scaleX: 1,
//             scaleY: 1.06,
//             alignment: Alignment.center,
//             child: SizedBox(
//                 width: _controller?.value.size.width,
//                 height: _controller?.value.size.height,
//                 child: playerWidget!),
//           )
//         : const SizedBox.shrink();
//
//     // return Stack(
//     //   fit: StackFit.expand,
//     //   children: [
//     //     if (chewieController != null && _controller!.value.isInitialized)
//     //       GestureDetector(
//     //         onTap: () {
//     //           if (_controller!.value.isPlaying) {
//     //             _controller!.pause();
//     //           } else {
//     //             _controller!.play();
//     //           }
//     //         },
//     //         child: playerWidget!,
//     //       ),
//     //   ],
//     // );
//   }
// }
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_manager/flutter_cache_manager.dart';
import 'package:video_player/video_player.dart';

class ReelsViewVideo extends StatefulWidget {
  final String url;
  final VoidCallback onComplete;
  final Function(String) onError;
  final Widget placeholder;
  final bool isLooping;

  const ReelsViewVideo({
    super.key,
    required this.url,
    required this.onComplete,
    required this.onError,
    required this.placeholder,
    required this.isLooping,
  });

  @override
  State<ReelsViewVideo> createState() => _ReelsViewVideoState();
}

class _ReelsViewVideoState extends State<ReelsViewVideo> {
  VideoPlayerController? _controller;
  ChewieController? _chewieController;
  Chewie? _playerWidget;

  @override
  void initState() {
    super.initState();
    _initializePlayer(widget.url);
  }

  @override
  void didUpdateWidget(covariant ReelsViewVideo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _disposePlayer();
      _initializePlayer(widget.url);
    }
  }

  void _initializePlayer(String url) async {
    final fileInfo = await _checkCacheFor(url);
    try {
      if (fileInfo == null) {
        _controller = VideoPlayerController.networkUrl(Uri.parse(url));
      } else {
        _controller = VideoPlayerController.file(fileInfo.file);
      }
      await _controller!.initialize();
      _controller!.setLooping(widget.isLooping);
      _controller!.addListener(_videoListener);

      setState(() {
        _chewieController = ChewieController(
          videoPlayerController: _controller!,
          autoPlay: true,
          looping: widget.isLooping,
          showControls: false,
        );
        _playerWidget = Chewie(controller: _chewieController!);
      });

      if (fileInfo == null) {
        _cacheVideo(url);
      }
    } catch (e) {
      widget.onError(e.toString());
    }
  }

  void _videoListener() {
    if (_controller!.value.position >= _controller!.value.duration) {
      widget.onComplete();
      if (!widget.isLooping) {
        _controller?.removeListener(_videoListener);
      }
    } else if (_controller!.value.hasError) {
      widget.onError(_controller!.value.errorDescription ?? 'Video Error');
    }
  }

  Future<FileInfo?> _checkCacheFor(String url) async {
    return await DefaultCacheManager().getFileFromCache(url);
  }

  void _cacheVideo(String url) async {
    await DefaultCacheManager().getSingleFile(url);
  }

  void _disposePlayer() {
    _controller?.pause();
    _controller?.removeListener(_videoListener);
    _controller?.dispose();
    _chewieController?.dispose();
  }

  @override
  void dispose() {
    _disposePlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller != null && _controller!.value.isInitialized
        ? Transform.scale(
            scaleX: 1,
            scaleY: 1.06,
            alignment: Alignment.center,
            child: SizedBox(
              width: _controller?.value.size.width,
              height: _controller?.value.size.height,
              child: GestureDetector(
                onTap: () {
                  if (_controller!.value.isPlaying) {
                    _controller?.pause();
                  } else {
                    _controller?.play();
                  }
                  setState(() {});
                },
                child: _playerWidget!,
              ),
            ),
          )
        : widget.placeholder;
  }
}
