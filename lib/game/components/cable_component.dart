import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

enum CableDragState { idle, dragging, returning, connected }

class CableComponent extends PositionComponent with DragCallbacks {
  CableComponent({
    required this.start,
    required this.restEnd,
    required this.target,
    required this.onConnected,
    required this.onNearTargetChanged,
    required this.onWrongDrop,
  }) : super(position: Vector2.zero(), size: Vector2(900, 620));

  final Vector2 start;
  final Vector2 restEnd;
  final Vector2 target;
  final VoidCallback onConnected;
  final ValueChanged<bool> onNearTargetChanged;
  final VoidCallback onWrongDrop;

  late Vector2 _end = restEnd.clone();
  late Vector2 _returnStart = restEnd.clone();
  CableDragState _state = CableDragState.idle;
  bool _wasNearTarget = false;
  double _returnProgress = 1;
  double _nearAmount = 0;
  double _grabPulse = 0;
  double _flowPulse = 0;

  static const double _grabRadius = 40;
  static const double _snapRadius = 52;
  static const double _nearRadius = 105;

  void forceConnected() {
    _end = target.clone();
    _state = CableDragState.connected;
    _returnProgress = 1;
    _nearAmount = 0;
    onNearTargetChanged(false);
  }

  void update(double dt) {
    super.update(dt);
    _grabPulse = (_grabPulse + dt * 2.4) % 1;
    _flowPulse = (_flowPulse + dt * 1.9) % 1;

    if (_state == CableDragState.returning) {
      _returnProgress = math.min(1, _returnProgress + dt * 3.6);
      final eased = Curves.easeOutBack.transform(_returnProgress);
      _end = _lerpVector(_returnStart, restEnd, eased);
      if (_returnProgress >= 1) {
        _state = CableDragState.idle;
        _end = restEnd.clone();
      }
    }

    _updateTargetHighlight();
  }

  void render(Canvas canvas) {
    _drawComputerPortLead(canvas);

    final control = Offset(
      (start.x + _end.x) / 2,
      math.max(start.y, _end.y) + 70,
    );
    final cablePath =
        Path()
          ..moveTo(start.x, start.y)
          ..quadraticBezierTo(control.dx, control.dy, _end.x, _end.y);

    final plugLift = _state == CableDragState.dragging ? -4.0 : 0.0;
    final plugCenter = Offset(_end.x, _end.y + plugLift);
    final nearGlow = _nearAmount.clamp(0, 1).toDouble();

    if (_state == CableDragState.idle || _state == CableDragState.returning) {
      final pulseRadius = 30 + math.sin(_grabPulse * math.pi * 2) * 3;
      canvas.drawCircle(
        Offset(_end.x, _end.y),
        pulseRadius,
        Paint()..color = const Color(0x2273CEBB),
      );
    }

    if (nearGlow > 0) {
      canvas.drawCircle(
        Offset(target.x, target.y),
        26 + 12 * nearGlow,
        Paint()
          ..color =
              Color.lerp(
                const Color(0x0096F2D7),
                const Color(0x8896F2D7),
                nearGlow,
              )!,
      );
    }

    canvas.drawPath(
      cablePath,
      Paint()
        ..color = const Color(0x332F4F4F)
        ..strokeWidth = 17
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawPath(
      cablePath,
      Paint()
        ..color = const Color(0xFF254C50)
        ..strokeWidth = 12
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawPath(
      cablePath,
      Paint()
        ..color = const Color(0xFF73CEBB)
        ..strokeWidth = 6
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
    if (_state == CableDragState.connected) {
      _drawCableFlow(canvas, cablePath);
    }

    canvas.drawCircle(
      Offset(start.x, start.y),
      14,
      Paint()..color = const Color(0xFF2F4F4F),
    );
    canvas.drawCircle(
      Offset(start.x, start.y),
      8,
      Paint()..color = const Color(0xFF73CEBB),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: plugCenter, width: 42, height: 27),
        const Radius.circular(6),
      ),
      Paint()
        ..color =
            _state == CableDragState.dragging
                ? const Color(0xFFFFD36B)
                : _state == CableDragState.connected
                ? const Color(0xFF36D47A)
                : const Color(0xFF506363),
    );
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(plugCenter.dx + 13, plugCenter.dy),
        width: 14,
        height: 12,
      ),
      Paint()..color = const Color(0xFF2F4F4F),
    );
    canvas.drawCircle(
      Offset(plugCenter.dx - 8, plugCenter.dy - 5),
      3,
      Paint()..color = const Color(0xFFFFFFFF),
    );
    canvas.drawCircle(
      plugCenter,
      _grabRadius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color =
            _state == CableDragState.dragging
                ? const Color(0x77FFD36B)
                : const Color(0x2273CEBB),
    );
  }

  void _drawComputerPortLead(Canvas canvas) {
    final leadStart = Offset(start.x - 18, start.y - 10);
    final leadEnd = Offset(start.x, start.y);
    canvas.drawLine(
      leadStart,
      leadEnd,
      Paint()
        ..color = const Color(0xFF254C50)
        ..strokeWidth = 12
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawLine(
      leadStart,
      leadEnd,
      Paint()
        ..color = const Color(0xFF73CEBB)
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: leadStart, width: 23, height: 16),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFF2F4F4F),
    );
  }

  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    if (_state == CableDragState.connected) {
      return;
    }
    if (event.localPosition.distanceTo(_end) <= _grabRadius) {
      _state = CableDragState.dragging;
      _returnProgress = 1;
    }
  }

  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    if (_state != CableDragState.dragging) {
      return;
    }
    _end += event.localDelta;
    _end.clamp(Vector2(90, 100), Vector2(820, 550));
    _updateTargetHighlight();
  }

  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    if (_state != CableDragState.dragging) {
      return;
    }

    if (_end.distanceTo(target) <= _snapRadius) {
      _end = target.clone();
      _state = CableDragState.connected;
      onNearTargetChanged(false);
      onConnected();
      return;
    }

    _startReturn();
    onWrongDrop();
  }

  void onDragCancel(DragCancelEvent event) {
    super.onDragCancel(event);
    if (_state == CableDragState.connected) {
      return;
    }
    _startReturn();
  }

  void _updateTargetHighlight({bool force = false}) {
    final distance = _end.distanceTo(target);
    _nearAmount = 1 - ((distance - _snapRadius) / (_nearRadius - _snapRadius));
    _nearAmount = _nearAmount.clamp(0, 1);
    final nearTarget = distance <= _nearRadius;
    if (force || nearTarget != _wasNearTarget) {
      _wasNearTarget = nearTarget;
      onNearTargetChanged(nearTarget);
    }
  }

  void _startReturn() {
    _state = CableDragState.returning;
    _returnStart = _end.clone();
    _returnProgress = 0;
    _updateTargetHighlight(force: true);
  }

  Vector2 _lerpVector(Vector2 from, Vector2 to, double t) {
    return from + (to - from) * t;
  }

  void _drawCableFlow(Canvas canvas, Path cablePath) {
    for (var i = 0; i < 3; i++) {
      final opacity = (math.sin((_flowPulse + i / 3) * math.pi * 2) + 1) / 2;
      canvas.drawPath(
        cablePath,
        Paint()
          ..color =
              Color.lerp(
                const Color(0x007DFFA9),
                const Color(0xAA7DFFA9),
                opacity * 0.55,
              )!
          ..strokeWidth = 2.2
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
      );
    }
  }
}
