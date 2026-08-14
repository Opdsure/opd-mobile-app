import 'package:flutter/material.dart';
import 'package:opdsure/config/app_design_system.dart';
import 'package:video_player/video_player.dart';

/// A video card widget for the partnership carousel.
/// Handles initialization, loading, error states, and auto-plays muted.
class PartnershipVideoCard extends StatefulWidget {
  final String videoUrl;
  final double width;
  final double height;

  const PartnershipVideoCard({
    super.key,
    required this.videoUrl,
    required this.width,
    required this.height,
  });

  @override
  State<PartnershipVideoCard> createState() => _PartnershipVideoCardState();
}

class _PartnershipVideoCardState extends State<PartnershipVideoCard> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl),
      );
      await _controller.initialize();
      _controller.setVolume(0); // Mute for promotional carousel
      _controller.setLooping(true);
      _controller.play();
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return _buildErrorPlaceholder();
    }

    if (!_isInitialized) {
      return _buildLoadingPlaceholder();
    }

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: FittedBox(
        fit: BoxFit.cover,
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          width: _controller.value.size.width,
          height: _controller.value.size.height,
          child: VideoPlayer(_controller),
        ),
      ),
    );
  }

  Widget _buildLoadingPlaceholder() {
    return Container(
      width: widget.width,
      height: widget.height,
      color: AppDesign.accentLight,
      child: const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppDesign.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      width: widget.width,
      height: widget.height,
      color: AppDesign.accentLight,
      child: const Center(
        child: Icon(
          Icons.videocam_off_outlined,
          color: AppDesign.textTertiary,
          size: 32,
        ),
      ),
    );
  }
}
