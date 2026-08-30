import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

/// Google's official 4-color "G" mark, drawn from its real path data (not
/// approximated with a generic Material icon) — Google's own branding
/// guidelines require this exact multi-color treatment on sign-in buttons,
/// never a monochrome substitute.
class GoogleLogo extends StatelessWidget {
  const GoogleLogo({super.key, this.size = 20});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _GoogleLogoPainter()),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  static final _blue = _parsePath(
    'M17.64 9.2045c0-.6381-.0573-1.2518-.1636-1.8409H9v3.4814h4.8436c-.2086 1.125-.8427 2.0782-1.7959 2.7164v2.2581h2.9087c1.7018-1.5668 2.6836-3.8741 2.6836-6.615z',
  );
  static final _green = _parsePath(
    'M9 18c2.43 0 4.4673-.806 5.9564-2.1805l-2.9087-2.2581c-.806.5404-1.8368.859-3.0477.859-2.3441 0-4.3282-1.5831-5.036-3.7104H.9573v2.3318C2.4382 15.9832 5.4818 18 9 18z',
  );
  static final _yellow = _parsePath(
    'M3.964 10.71c-.18-.5405-.2827-1.1181-.2827-1.71s.1027-1.1695.2827-1.71V4.9582H.9573C.3477 6.1732 0 7.5477 0 9s.3477 2.8268.9573 4.0418L3.964 10.71z',
  );
  static final _red = _parsePath(
    'M9 3.5795c1.3214 0 2.5077.4541 3.4405 1.346l2.5814-2.5814C13.4632.8918 11.4259 0 9 0 5.4818 0 2.4382 2.0168.9573 4.9582L3.964 7.29c.7077-2.1273 2.6918-3.7105 5.036-3.7105z',
  );

  static Path _parsePath(String d) => parseSvgPathData(d);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 18, size.height / 18);
    canvas.drawPath(_blue, Paint()..color = const Color(0xFF4285F4));
    canvas.drawPath(_green, Paint()..color = const Color(0xFF34A853));
    canvas.drawPath(_yellow, Paint()..color = const Color(0xFFFBBC05));
    canvas.drawPath(_red, Paint()..color = const Color(0xFFEA4335));
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _GoogleLogoPainter oldDelegate) => false;
}

/// Apple's bitten-apple glyph, drawn from its real path data. Apple's Human
/// Interface Guidelines require this exact silhouette (monochrome, matching
/// the surrounding button's text color) for "Sign in with Apple" buttons.
class AppleLogo extends StatelessWidget {
  const AppleLogo({super.key, this.size = 20, this.color = Colors.white});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _AppleLogoPainter(color: color)),
    );
  }
}

class _AppleLogoPainter extends CustomPainter {
  _AppleLogoPainter({required this.color});

  final Color color;

  static final _glyph = parseSvgPathData(
    'M12.152 6.896c-.948 0-2.415-1.078-3.96-1.04-2.04.027-3.91 1.183-4.961 3.014-2.117 3.675-.546 9.103 1.519 12.09 1.013 1.454 2.208 3.09 3.792 3.039 1.52-.065 2.09-.987 3.935-.987 1.831 0 2.35.987 3.96.948 1.637-.026 2.676-1.48 3.676-2.948 1.156-1.688 1.636-3.325 1.662-3.415-.039-.013-3.182-1.221-3.22-4.857-.026-3.04 2.48-4.494 2.597-4.559-1.429-2.09-3.623-2.324-4.39-2.376-2-.156-3.675 1.09-4.61 1.09zM15.53 3.83c.843-1.012 1.4-2.427 1.245-3.83-1.207.052-2.662.805-3.532 1.818-.78.896-1.454 2.338-1.273 3.714 1.338.104 2.715-.688 3.559-1.701',
  );

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 24, size.height / 24);
    canvas.drawPath(_glyph, Paint()..color = color);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _AppleLogoPainter oldDelegate) =>
      oldDelegate.color != color;
}
