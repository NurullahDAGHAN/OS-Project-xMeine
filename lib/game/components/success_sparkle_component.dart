import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class SuccessSparkleComponent extends PositionComponent {
  SuccessSparkleComponent({required super.position})
    : super(size: Vector2(220, 160), anchor: Anchor.center);

  double _age = 0;

  static const double _duration = 1.1;

  void update(double dt) {
    super.update(dt);
    _age += dt;
    if (_age >= _duration) {
      removeFromParent();
    }
  }

  void render(Canvas canvas) {
    final t = (_age / _duration).clamp(0, 1).toDouble();
    final fade = math.sin(t * math.pi).clamp(0, 1).toDouble();
    final burstRadius = 24 + 58 * Curves.easeOutCubic.transform(t);

    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      burstRadius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3 * fade
        ..color =
            Color.lerp(const Color(0x00FFFFFF), const Color(0xAA96F2D7), fade)!,
    );

    for (var i = 0; i < 10; i++) {
      final angle = (math.pi * 2 / 10) * i - math.pi / 2;
      final distance = 24 + 56 * Curves.easeOut.transform(t);
      final center = Offset(
        size.x / 2 + math.cos(angle) * distance,
        size.y / 2 + math.sin(angle) * distance * 0.68,
      );
      _drawSparkle(canvas, center, 5 + (i % 3) * 2, fade);
    }
  }

  void _drawSparkle(Canvas canvas, Offset center, double radius, double fade) {
    final paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round
          ..color =
              Color.lerp(
                const Color(0x00FFFFFF),
                const Color(0xFFFFD36B),
                fade,
              )!;
    canvas.drawLine(
      Offset(center.dx - radius, center.dy),
      Offset(center.dx + radius, center.dy),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - radius),
      Offset(center.dx, center.dy + radius),
      paint,
    );
  }
}
