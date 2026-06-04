import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class ComputerComponent extends PositionComponent {
  ComputerComponent({required super.position})
    : super(size: Vector2(168, 136), anchor: Anchor.center);

  bool _connected = false;
  double _connectProgress = 0;
  double _screenPulse = 0;

  void setConnected() {
    _connected = true;
  }

  void update(double dt) {
    super.update(dt);
    _screenPulse = (_screenPulse + dt * 2.2) % 1;
    final target = _connected ? 1.0 : 0.0;
    _connectProgress += (target - _connectProgress) * math.min(1, dt * 5.5);
  }

  void render(Canvas canvas) {
    _drawShadow(canvas, const Offset(0, 67), const Size(154, 34));

    final deskTop =
        Path()
          ..moveTo(8, 62)
          ..lineTo(86, 31)
          ..lineTo(160, 62)
          ..lineTo(82, 99)
          ..close();
    final deskFront =
        Path()
          ..moveTo(8, 62)
          ..lineTo(82, 99)
          ..lineTo(82, 118)
          ..lineTo(8, 82)
          ..close();
    final deskSide =
        Path()
          ..moveTo(82, 99)
          ..lineTo(160, 62)
          ..lineTo(160, 82)
          ..lineTo(82, 118)
          ..close();

    canvas.drawPath(deskTop, Paint()..color = const Color(0xFFC7926D));
    canvas.drawPath(deskFront, Paint()..color = const Color(0xFFA86F51));
    canvas.drawPath(deskSide, Paint()..color = const Color(0xFFB77A59));
    canvas.drawPath(
      deskTop,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = const Color(0xFF8C5B45),
    );
    canvas.drawLine(
      const Offset(82, 99),
      const Offset(82, 118),
      Paint()
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..color = const Color(0xFF8C5B45),
    );
    canvas.drawLine(
      const Offset(145, 70),
      const Offset(145, 91),
      Paint()
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..color = const Color(0xFF8C5B45),
    );

    final screenColor =
        Color.lerp(
          const Color(0xFF31465A),
          const Color(0xFF79DFA8),
          _connectProgress,
        )!;
    final screenPaint = Paint()..color = screenColor;
    final bodyPaint = Paint()..color = const Color(0xFFF4EFE6);
    final sidePaint = Paint()..color = const Color(0xFFD7D0C4);

    final monitorSide =
        Path()
          ..moveTo(96, 22)
          ..lineTo(113, 31)
          ..lineTo(113, 69)
          ..lineTo(96, 58)
          ..close();
    final monitorFront =
        Path()
          ..moveTo(38, 12)
          ..lineTo(96, 22)
          ..lineTo(96, 58)
          ..lineTo(38, 48)
          ..close();
    canvas.drawPath(monitorSide, sidePaint);
    canvas.drawPath(monitorFront, bodyPaint);
    canvas.drawPath(
      monitorFront,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = const Color(0xFFC6BFB3),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(45, 17, 58, 39),
        const Radius.circular(5),
      ),
      screenPaint,
    );
    if (_connectProgress > 0.02) {
      final glow =
          (0.45 + math.sin(_screenPulse * math.pi * 2) * 0.18) *
          _connectProgress;
      canvas.drawCircle(
        const Offset(74, 36),
        13 + 4 * _connectProgress,
        Paint()
          ..color =
              Color.lerp(
                const Color(0x007DFFA9),
                const Color(0x777DFFA9),
                glow.clamp(0, 1),
              )!,
      );
      _drawCheckMark(canvas, const Offset(74, 36), _connectProgress);
    }
    canvas.drawPath(
      Path()
        ..moveTo(72, 58)
        ..lineTo(86, 61)
        ..lineTo(86, 78)
        ..lineTo(72, 75)
        ..close(),
      bodyPaint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(53, 78)
        ..lineTo(92, 84)
        ..lineTo(105, 78)
        ..lineTo(67, 72)
        ..close(),
      Paint()..color = const Color(0xFFE7E1D7),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(135, 72, 17, 12),
        const Radius.circular(3),
      ),
      Paint()..color = const Color(0xFF2F4F4F),
    );
    canvas.drawCircle(
      const Offset(140, 78),
      2.2,
      Paint()..color = const Color(0xFF73CEBB),
    );
  }
}

class ModemComponent extends PositionComponent {
  ModemComponent({required super.position})
    : super(size: Vector2(132, 96), anchor: Anchor.center);

  bool _highlighted = false;
  bool _connected = false;
  double _highlightAmount = 0;
  double _ledPulse = 0;
  double _connectProgress = 0;

  void setPortHighlighted(bool highlighted) {
    _highlighted = highlighted;
  }

  void setConnected() {
    _connected = true;
    _highlighted = false;
  }

  void update(double dt) {
    super.update(dt);
    final target = _highlighted ? 1.0 : 0.0;
    _highlightAmount += (target - _highlightAmount) * math.min(1, dt * 8);
    _ledPulse = (_ledPulse + dt * 5) % 1;
    final connectedTarget = _connected ? 1.0 : 0.0;
    _connectProgress +=
        (connectedTarget - _connectProgress) * math.min(1, dt * 6);
  }

  void render(Canvas canvas) {
    _drawShadow(canvas, const Offset(0, 50), const Size(118, 28));

    final bodyPaint = Paint()..color = const Color(0xFFFEFEFC);
    final sidePaint = Paint()..color = const Color(0xFFD3E4E2);
    final facePaint = Paint()..color = const Color(0xFFEAF2EF);
    final linePaint =
        Paint()
          ..color = const Color(0xFF8AA2A0)
          ..strokeWidth = 2;

    final top =
        Path()
          ..moveTo(14, 28)
          ..lineTo(62, 12)
          ..lineTo(118, 32)
          ..lineTo(70, 54)
          ..close();
    final face =
        Path()
          ..moveTo(14, 28)
          ..lineTo(70, 54)
          ..lineTo(70, 76)
          ..lineTo(14, 48)
          ..close();
    final side =
        Path()
          ..moveTo(70, 54)
          ..lineTo(118, 32)
          ..lineTo(118, 54)
          ..lineTo(70, 76)
          ..close();

    canvas.drawPath(top, bodyPaint);
    canvas.drawPath(face, facePaint);
    canvas.drawPath(side, sidePaint);
    canvas.drawPath(
      top,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = const Color(0xFFB7C9C5),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(18, 43, 34, 17),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFF425555),
    );
    canvas.drawLine(const Offset(48, 18), const Offset(30, 0), linePaint);
    canvas.drawLine(const Offset(88, 22), const Offset(104, 2), linePaint);

    final portRect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(22, 46, 24, 10),
      const Radius.circular(3),
    );
    if (_highlightAmount > 0.01) {
      canvas.drawCircle(
        const Offset(34, 51),
        20 + 10 * _highlightAmount,
        Paint()
          ..color =
              Color.lerp(
                const Color(0x0096F2D7),
                const Color(0x9996F2D7),
                _highlightAmount,
              )!,
      );
      canvas.drawCircle(
        const Offset(34, 51),
        7 + 3 * _highlightAmount,
        Paint()..color = const Color(0xFFFFD36B),
      );
    }
    canvas.drawRRect(portRect, Paint()..color = const Color(0xFF4A5A5A));

    _drawLed(canvas, const Offset(76, 43), const Color(0xFF36D47A), 0);
    _drawLed(canvas, const Offset(90, 39), const Color(0xFF36D47A), 0.33);
    _drawLed(canvas, const Offset(103, 35), const Color(0xFFFFD36B), 0.66);
  }

  void _drawLed(Canvas canvas, Offset center, Color activeColor, double phase) {
    final wave = (math.sin((_ledPulse + phase) * math.pi * 2) + 1) / 2;
    final amount = _connectProgress * (0.65 + wave * 0.35);
    final color =
        Color.lerp(const Color(0xFFD6D6D6), activeColor, amount.clamp(0, 1))!;
    if (_connectProgress > 0.02) {
      canvas.drawCircle(
        center,
        8 + 2 * wave,
        Paint()
          ..color =
              Color.lerp(
                const Color(0x00000000),
                activeColor.withValues(alpha: 0.28),
                amount.clamp(0, 1),
              )!,
      );
    }
    canvas.drawCircle(center, 4, Paint()..color = color);
  }
}

class CharacterComponent extends PositionComponent {
  CharacterComponent({required super.position})
    : super(size: Vector2(86, 112), anchor: Anchor.center);

  double _hintPulse = 0;

  void showHintPulse() {
    _hintPulse = 1;
  }

  void update(double dt) {
    super.update(dt);
    _hintPulse = math.max(0, _hintPulse - dt * 1.8);
  }

  void render(Canvas canvas) {
    final pulseOffset = math.sin(_hintPulse * math.pi * 4) * 3;
    canvas.save();
    canvas.translate(0, -pulseOffset);

    _drawShadow(canvas, const Offset(0, 56), const Size(58, 18));
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(27, 74, 10, 24),
        const Radius.circular(5),
      ),
      Paint()..color = const Color(0xFF355F67),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(49, 74, 10, 24),
        const Radius.circular(5),
      ),
      Paint()..color = const Color(0xFF355F67),
    );
    canvas.drawOval(
      const Rect.fromLTWH(22, 42, 42, 48),
      Paint()..color = const Color(0xFF4FA3A5),
    );
    canvas.drawArc(
      const Rect.fromLTWH(12, 45, 60, 30),
      2.7,
      0.9,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 7
        ..strokeCap = StrokeCap.round
        ..color = const Color(0xFF4FA3A5),
    );
    canvas.drawCircle(
      const Offset(43, 31),
      23,
      Paint()..color = const Color(0xFFF2C7A7),
    );
    canvas.drawArc(
      const Rect.fromLTWH(22, 8, 42, 28),
      math.pi,
      math.pi,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round
        ..color = const Color(0xFF5D6B72),
    );
    canvas.drawCircle(
      const Offset(34, 29),
      3,
      Paint()..color = const Color(0xFF3B3B3B),
    );
    canvas.drawCircle(
      const Offset(52, 29),
      3,
      Paint()..color = const Color(0xFF3B3B3B),
    );
    canvas.drawArc(
      const Rect.fromLTWH(34, 31, 18, 14),
      0.1,
      math.pi - 0.2,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = const Color(0xFF8C4B3D),
    );
    canvas.restore();
  }
}

class DialogueBubbleComponent extends PositionComponent {
  DialogueBubbleComponent({required super.position, required this.text})
    : super(size: Vector2(346, 96));

  String text;
  double _changedPulse = 0;

  void setText(String value) {
    if (text == value) {
      return;
    }
    text = value;
    _changedPulse = 1;
  }

  void update(double dt) {
    super.update(dt);
    _changedPulse = math.max(0, _changedPulse - dt * 2.8);
  }

  void render(Canvas canvas) {
    final lift = math.sin(_changedPulse * math.pi) * 4;
    canvas.save();
    canvas.translate(0, -lift);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(4, 6, size.x, size.y),
        const Radius.circular(14),
      ),
      Paint()..color = const Color(0x22000000),
    );
    final bubblePaint = Paint()..color = const Color(0xFFFFFFFF);
    final borderPaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = const Color(0xFFD7CFC3);
    final accentPaint = Paint()..color = const Color(0xFF3A8F86);

    final bubble = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.x, size.y),
      const Radius.circular(14),
    );
    canvas.drawRRect(bubble, bubblePaint);
    canvas.drawRRect(bubble, borderPaint);

    final tail =
        Path()
          ..moveTo(172, 94)
          ..lineTo(192, 114)
          ..lineTo(202, 94)
          ..close();
    canvas.drawPath(tail, bubblePaint);
    canvas.drawPath(tail, borderPaint);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(12, 13, 28, 28),
        const Radius.circular(8),
      ),
      Paint()..color = const Color(0xFFE8F5F1),
    );
    canvas.drawCircle(const Offset(26, 27), 7, accentPaint);
    canvas.drawCircle(
      const Offset(29, 24),
      2,
      Paint()..color = const Color(0xFFFFFFFF),
    );

    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Color(0xFF36413E),
          fontSize: 14,
          height: 1.25,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 3,
    )..layout(maxWidth: size.x - 62);
    painter.paint(canvas, const Offset(50, 14));
    canvas.restore();
  }
}

void _drawShadow(Canvas canvas, Offset center, Size size) {
  canvas.drawOval(
    Rect.fromCenter(center: center, width: size.width, height: size.height),
    Paint()..color = const Color(0x33000000),
  );
}

void _drawCheckMark(Canvas canvas, Offset center, double progress) {
  final paint =
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color =
            Color.lerp(
              const Color(0x00FFFFFF),
              const Color(0xFFFFFFFF),
              progress.clamp(0, 1),
            )!;
  final path =
      Path()
        ..moveTo(center.dx - 8, center.dy)
        ..lineTo(center.dx - 2, center.dy + 6)
        ..lineTo(center.dx + 9, center.dy - 7);
  canvas.drawPath(path, paint);
}
