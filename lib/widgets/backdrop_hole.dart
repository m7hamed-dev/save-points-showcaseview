part of 'package:save_points_showcaseview/save_points_showcaseview.dart';

class _BackdropHole extends StatelessWidget {
  const _BackdropHole({super.key, required this.rect});

  final Rect? rect;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final path = Path()
          ..addRect(
            Rect.fromLTWH(0, 0, constraints.maxWidth, constraints.maxHeight),
          );
        if (rect != null) {
          path.addRRect(
            RRect.fromRectAndRadius(rect!, const Radius.circular(16)),
          );
          path.fillType = PathFillType.evenOdd;
        }
        return ClipPath(
          clipper: _HoleClipper(path),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 380),
              curve: Curves.easeInOutCubicEmphasized,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue.withValues(alpha: 0.21),
                    Colors.blue.withValues(alpha: 0.15),
                  ],
                ),
              ),
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
