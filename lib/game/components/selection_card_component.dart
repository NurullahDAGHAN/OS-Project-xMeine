import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

enum SelectionCardState { idle, dragging, returning, accepted }

class SelectionDropZoneComponent extends PositionComponent {
  SelectionDropZoneComponent({
    required Vector2 center,
    required this.label,
    this.radius = 72,
  }) : super(
         position: center,
         size: Vector2(radius * 2, radius * 2),
         anchor: Anchor.center,
       );

  final String label;
  final double radius;

  bool _highlighted = false;
  double _highlightAmount = 0;
  double _pulse = 0;

  void setHighlighted(bool highlighted) {
    _highlighted = highlighted;
  }

  @override
  void update(double dt) {
    super.update(dt);
    _pulse = (_pulse + dt * 1.9) % 1;
    final target = _highlighted ? 1.0 : 0.0;
    _highlightAmount += (target - _highlightAmount) * math.min(1, dt * 8);
  }

  @override
  void render(Canvas canvas) {
    final center = Offset(size.x / 2, size.y / 2);
    final wave = (math.sin(_pulse * math.pi * 2) + 1) / 2;
    final glow = 0.35 + _highlightAmount * 0.65;

    canvas.drawCircle(
      center,
      radius * (0.62 + wave * 0.04 + _highlightAmount * 0.08),
      Paint()
        ..color =
            Color.lerp(
              const Color(0x2273CEBB),
              const Color(0x88FFD36B),
              _highlightAmount,
            )!,
    );
    canvas.drawCircle(
      center,
      radius * 0.5,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color =
            Color.lerp(
              const Color(0x993A8F86),
              const Color(0xFFFFC83D),
              _highlightAmount,
            )!,
    );
    canvas.drawCircle(
      center,
      radius * 0.28,
      Paint()
        ..color =
            Color.lerp(
              const Color(0xBBFFFFFF),
              const Color(0xFFFFF4CC),
              _highlightAmount,
            )!,
    );
    canvas.drawIcon(
      Icons.input,
      center.translate(-10, -13),
      22,
      Color.lerp(
        const Color(0xFF2D736A),
        const Color(0xFF9B6A00),
        _highlightAmount,
      )!,
    );

    final painter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color:
              Color.lerp(
                const Color(0xFF2D736A),
                const Color(0xFF7D5600),
                _highlightAmount,
              )!,
          fontSize: 11,
          height: 1.05,
          fontWeight: FontWeight.w900,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
      maxLines: 2,
    )..layout(maxWidth: radius * 1.15);
    painter.paint(
      canvas,
      Offset(center.dx - painter.width / 2, center.dy + radius * 0.18),
    );

    if (glow > 0.5) {
      canvas.drawCircle(
        center,
        radius * 0.5,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..color = const Color(0xFFFFFFFF).withValues(alpha: glow - 0.5),
      );
    }
  }
}

class SelectionCardComponent extends PositionComponent with DragCallbacks {
  SelectionCardComponent({
    required this.label,
    required this.correct,
    required this.target,
    required this.onAccepted,
    required this.onWrongDrop,
    required this.onNearTargetChanged,
    required Vector2 restPosition,
    required this.icon,
  }) : _restPosition = restPosition.clone(),
       super(
         position: restPosition.clone(),
         size: Vector2(218, 62),
         anchor: Anchor.center,
       );

  final String label;
  final bool correct;
  final Vector2 target;
  final VoidCallback onAccepted;
  final VoidCallback onWrongDrop;
  final ValueChanged<bool> onNearTargetChanged;
  final IconData icon;

  final Vector2 _restPosition;
  late Vector2 _returnStart = _restPosition.clone();
  SelectionCardState _state = SelectionCardState.idle;
  double _returnProgress = 1;
  double _hoverPulse = 0;
  bool _wasNearTarget = false;

  static const double _snapRadius = 78;
  static const double _nearRadius = 128;

  @override
  void update(double dt) {
    super.update(dt);
    _hoverPulse = (_hoverPulse + dt * 2.1) % 1;

    if (_state == SelectionCardState.returning) {
      _returnProgress = math.min(1, _returnProgress + dt * 4.2);
      final eased = Curves.easeOutBack.transform(_returnProgress);
      position = _lerpVector(_returnStart, _restPosition, eased);
      if (_returnProgress >= 1) {
        position = _restPosition.clone();
        _state = SelectionCardState.idle;
      }
    }

    _updateTargetHighlight();
  }

  @override
  void render(Canvas canvas) {
    final lifted = _state == SelectionCardState.dragging;
    final accepted = _state == SelectionCardState.accepted;
    final wave = (math.sin(_hoverPulse * math.pi * 2) + 1) / 2;
    final lift = lifted ? -5.0 : 0.0;

    canvas.save();
    canvas.translate(0, lift);

    final shadowAlpha = lifted ? 0.26 : 0.17;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(7, 9, size.x - 14, size.y - 8),
        const Radius.circular(8),
      ),
      Paint()..color = Colors.black.withValues(alpha: shadowAlpha),
    );

    final body = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.x, size.y - 8),
      const Radius.circular(8),
    );
    canvas.drawRRect(
      body,
      Paint()
        ..color =
            accepted
                ? const Color(0xFFE5FAEF)
                : lifted
                ? const Color(0xFFFFF7D8)
                : const Color(0xFFFFFFFF),
    );
    canvas.drawRRect(
      body,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = lifted ? 3 : 2
        ..color =
            accepted
                ? const Color(0xFF78DFA4)
                : lifted
                ? const Color(0xFFFFC83D)
                : const Color(0xFFCDE5DD),
    );

    final iconRect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(10, 10, 38, 34),
      const Radius.circular(8),
    );
    canvas.drawRRect(iconRect, Paint()..color = const Color(0xFFE8F5F1));
    canvas.drawIcon(icon, const Offset(20, 17), 19, const Color(0xFF2D736A));

    final painter = TextPainter(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          color: Color(0xFF263A36),
          fontSize: 13,
          height: 1.08,
          fontWeight: FontWeight.w900,
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 2,
      ellipsis: '...',
    )..layout(maxWidth: size.x - 66);
    painter.paint(canvas, const Offset(56, 13));

    if (_state == SelectionCardState.idle) {
      canvas.drawCircle(
        Offset(size.x - 22, size.y - 22),
        8 + wave * 2,
        Paint()..color = const Color(0x2273CEBB),
      );
    }

    if (accepted) {
      _drawCheck(canvas, Offset(size.x - 25, 18));
    }

    canvas.restore();
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    if (_state == SelectionCardState.accepted) {
      return;
    }
    _state = SelectionCardState.dragging;
    _returnProgress = 1;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    if (_state != SelectionCardState.dragging) {
      return;
    }
    position += event.localDelta;
    position.clamp(Vector2(size.x / 2, 92), Vector2(900 - size.x / 2, 585));
    _updateTargetHighlight();
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    if (_state != SelectionCardState.dragging) {
      return;
    }

    if (position.distanceTo(target) <= _snapRadius && correct) {
      _state = SelectionCardState.accepted;
      position = target.clone();
      onNearTargetChanged(false);
      onAccepted();
      return;
    }

    _startReturn();
    onWrongDrop();
  }

  @override
  void onDragCancel(DragCancelEvent event) {
    super.onDragCancel(event);
    if (_state == SelectionCardState.accepted) {
      return;
    }
    _startReturn();
  }

  void _startReturn() {
    _state = SelectionCardState.returning;
    _returnStart = position.clone();
    _returnProgress = 0;
    _updateTargetHighlight(force: true);
  }

  void _updateTargetHighlight({bool force = false}) {
    final nearTarget =
        _state == SelectionCardState.dragging &&
        position.distanceTo(target) <= _nearRadius;
    if (force || nearTarget != _wasNearTarget) {
      _wasNearTarget = nearTarget;
      onNearTargetChanged(nearTarget);
    }
  }

  Vector2 _lerpVector(Vector2 from, Vector2 to, double t) {
    return from + (to - from) * t;
  }

  void _drawCheck(Canvas canvas, Offset center) {
    final paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..color = const Color(0xFF1F6B3D);
    final path =
        Path()
          ..moveTo(center.dx - 8, center.dy)
          ..lineTo(center.dx - 2, center.dy + 6)
          ..lineTo(center.dx + 9, center.dy - 8);
    canvas.drawPath(path, paint);
  }
}

extension _CanvasIcon on Canvas {
  void drawIcon(IconData icon, Offset offset, double size, Color color) {
    final painter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontSize: size,
          fontFamily: icon.fontFamily,
          package: icon.fontPackage,
          color: color,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(this, offset);
  }
}
