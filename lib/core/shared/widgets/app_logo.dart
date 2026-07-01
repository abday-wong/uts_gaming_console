import 'package:flutter/material.dart';
import 'package:uts_gaming_console/core/constants/app_colors.dart';
import 'package:uts_gaming_console/core/theme/neo_theme.dart';

class AppLogo extends StatelessWidget {
  final double size;

  const AppLogo({super.key, this.size = 64});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.neoBlue,
        shape: BoxShape.rectangle,
        border: NeoTheme.border,
        boxShadow: const [NeoTheme.shadowSmall],
      ),
      child: CustomPaint(
        size: Size(size, size),
        painter: ControllerPainter(),
      ),
    );
  }
}

class ControllerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;
    
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.black
      ..strokeWidth = 2.0;

    final w = size.width;
    final h = size.height;

    // Outer shell body (slanted/curved controller shape in neon pink)
    final path = Path();
    path.moveTo(w * 0.15, h * 0.35);
    path.lineTo(w * 0.85, h * 0.35);
    path.lineTo(w * 0.85, h * 0.65);
    path.lineTo(w * 0.65, h * 0.75);
    path.lineTo(w * 0.35, h * 0.75);
    path.lineTo(w * 0.15, h * 0.65);
    path.close();

    paint.color = AppColors.neoPink;
    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);

    // Left D-pad (black cross)
    final dpad = Path();
    // vertical bar
    dpad.moveTo(w * 0.28, h * 0.45);
    dpad.lineTo(w * 0.34, h * 0.45);
    dpad.lineTo(w * 0.34, h * 0.59);
    dpad.lineTo(w * 0.28, h * 0.59);
    dpad.close();
    // horizontal bar
    dpad.moveTo(w * 0.23, h * 0.50);
    dpad.lineTo(w * 0.39, h * 0.50);
    dpad.lineTo(w * 0.39, h * 0.54);
    dpad.lineTo(w * 0.23, h * 0.54);
    dpad.close();

    paint.color = Colors.black;
    canvas.drawPath(dpad, paint);

    // Right Action Buttons (Neon Green / Neon Yellow circles)
    paint.color = AppColors.neoGreen;
    canvas.drawCircle(Offset(w * 0.65, h * 0.53), w * 0.07, paint);
    canvas.drawCircle(Offset(w * 0.65, h * 0.53), w * 0.07, borderPaint);

    paint.color = AppColors.neoYellow;
    canvas.drawCircle(Offset(w * 0.75, h * 0.48), w * 0.07, paint);
    canvas.drawCircle(Offset(w * 0.75, h * 0.48), w * 0.07, borderPaint);

    // Screen display or grid line
    final gridLine = Path();
    gridLine.moveTo(w * 0.43, h * 0.43);
    gridLine.lineTo(w * 0.57, h * 0.43);
    gridLine.lineTo(w * 0.57, h * 0.57);
    gridLine.lineTo(w * 0.43, h * 0.57);
    gridLine.close();
    paint.color = Colors.black;
    canvas.drawPath(gridLine, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
