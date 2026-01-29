part of 'package:save_points_showcaseview/save_points_showcaseview.dart';

class _BackdropHole extends StatefulWidget {
  const _BackdropHole({
    super.key,
    required this.rect,
    this.config,
  });

  final Rect? rect;
  final ShowcaseCoachConfig? config;

  @override
  State<_BackdropHole> createState() => _BackdropHoleState();
}

class _BackdropHoleState extends State<_BackdropHole>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _blurAnimation;
  late final Animation<double> _opacityAnimation;
  Path? _cachedPath;
  Size? _cachedSize;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _blurAnimation = Tween<double>(begin: 0.0, end: 5.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );
    _opacityAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Path _buildPath(Size size) {
    // Cache path if size and rect haven't changed
    if (_cachedPath != null && _cachedSize == size) {
      return _cachedPath!;
    }

    final path = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    if (widget.rect != null) {
      path.addRRect(
        RRect.fromRectAndRadius(widget.rect!, const Radius.circular(16)),
      );
      path.fillType = PathFillType.evenOdd;
    }

    _cachedPath = path;
    _cachedSize = size;
    return path;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        final path = _buildPath(size);

        final isClassic =
            widget.config?.overlayStyle == ShowcaseOverlayStyle.classic;

        return RepaintBoundary(
          child: ClipPath(
            clipper: _HoleClipper(path),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final gradientOpacity = _opacityAnimation.value;
                if (isClassic) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(
                        alpha: 0.72 * gradientOpacity.clamp(0.0, 1.0),
                      ),
                    ),
                  );
                }
                final blurSigma = _blurAnimation.value;
                return BackdropFilter(
                  filter:
                      ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.blue.withValues(alpha: 0.21 * gradientOpacity),
                          Colors.blue.withValues(alpha: 0.15 * gradientOpacity),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _HoleClipper extends CustomClipper<Path> {
  _HoleClipper(this.path);

  final Path path;

  @override
  Path getClip(Size size) => path;

  @override
  bool shouldReclip(covariant _HoleClipper oldClipper) =>
      oldClipper.path != path;
}
