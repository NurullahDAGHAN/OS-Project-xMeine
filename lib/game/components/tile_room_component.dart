import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../levels/level_data.dart';

class TileRoomComponent extends PositionComponent {
  TileRoomComponent({required this.theme})
    : super(position: Vector2.zero(), size: Vector2(900, 620));

  final LevelSceneTheme theme;

  void render(Canvas canvas) {
    super.render(canvas);

    _drawRoomGlow(canvas);
    _drawWalls(canvas);
    _drawFloor(canvas);
    _drawWallDetails(canvas);
  }

  void _drawRoomGlow(Canvas canvas) {
    final color = switch (theme) {
      LevelSceneTheme.home => const Color(0x18C49B6C),
      LevelSceneTheme.gateway => const Color(0x1C73A8CE),
      LevelSceneTheme.dns => const Color(0x1C6B7DFF),
      LevelSceneTheme.office => const Color(0x1CFFB347),
      LevelSceneTheme.dataCenter => const Color(0x1C2FB7D8),
      LevelSceneTheme.security => const Color(0x22E66B6B),
    };
    canvas.drawOval(
      const Rect.fromLTWH(86, 118, 724, 448),
      Paint()..color = color,
    );
  }

  void _drawWalls(Canvas canvas) {
    final leftWall =
        Path()
          ..moveTo(118, 134)
          ..lineTo(452, 28)
          ..lineTo(452, 180)
          ..lineTo(118, 288)
          ..close();
    final rightWall =
        Path()
          ..moveTo(452, 28)
          ..lineTo(795, 146)
          ..lineTo(795, 298)
          ..lineTo(452, 180)
          ..close();

    final leftColors = switch (theme) {
      LevelSceneTheme.home => [
        const Color(0xFFF1F6EA),
        const Color(0xFFE2EDD9),
      ],
      LevelSceneTheme.gateway => [
        const Color(0xFFEAF6F9),
        const Color(0xFFD6E9F0),
      ],
      LevelSceneTheme.dns => [const Color(0xFFF1EEF9), const Color(0xFFE2DDF1)],
      LevelSceneTheme.office => [
        const Color(0xFFF8F0DD),
        const Color(0xFFEBDCB8),
      ],
      LevelSceneTheme.dataCenter => [
        const Color(0xFFE7F2F4),
        const Color(0xFFCFE2E7),
      ],
      LevelSceneTheme.security => [
        const Color(0xFFF7EAEA),
        const Color(0xFFEBD4D4),
      ],
    };
    final rightColors = switch (theme) {
      LevelSceneTheme.home => [
        const Color(0xFFE9F5F4),
        const Color(0xFFD4E7E6),
      ],
      LevelSceneTheme.gateway => [
        const Color(0xFFE7F3EA),
        const Color(0xFFCFE4D9),
      ],
      LevelSceneTheme.dns => [const Color(0xFFEAF4FF), const Color(0xFFD5E5F6)],
      LevelSceneTheme.office => [
        const Color(0xFFEAF4F0),
        const Color(0xFFD1E6DC),
      ],
      LevelSceneTheme.dataCenter => [
        const Color(0xFFEAEFFC),
        const Color(0xFFD3DDF0),
      ],
      LevelSceneTheme.security => [
        const Color(0xFFEFF3E9),
        const Color(0xFFDCE7CF),
      ],
    };

    final leftPaint =
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: leftColors,
          ).createShader(const Rect.fromLTWH(118, 28, 334, 260));
    final rightPaint =
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: rightColors,
          ).createShader(const Rect.fromLTWH(452, 28, 343, 270));

    canvas.drawPath(leftWall, leftPaint);
    canvas.drawPath(rightWall, rightPaint);
    canvas.drawPath(
      leftWall,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = const Color(0xFFE2D8C7),
    );
    canvas.drawPath(
      rightWall,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = const Color(0xFFD4CCC0),
    );
  }

  void _drawFloor(Canvas canvas) {
    final floor =
        Path()
          ..moveTo(118, 288)
          ..lineTo(452, 180)
          ..lineTo(795, 298)
          ..lineTo(458, 548)
          ..close();

    final floorColors = switch (theme) {
      LevelSceneTheme.home => [
        const Color(0xFFF0E1C6),
        const Color(0xFFE4C99C),
      ],
      LevelSceneTheme.gateway => [
        const Color(0xFFE6D7B9),
        const Color(0xFFCFB284),
      ],
      LevelSceneTheme.dns => [const Color(0xFFDDE4F6), const Color(0xFFB9C8E7)],
      LevelSceneTheme.office => [
        const Color(0xFFE6D6A8),
        const Color(0xFFC8AB68),
      ],
      LevelSceneTheme.dataCenter => [
        const Color(0xFFD3DEE3),
        const Color(0xFFAAB9C0),
      ],
      LevelSceneTheme.security => [
        const Color(0xFFE1D2D2),
        const Color(0xFFC2A3A3),
      ],
    };
    final floorStroke = switch (theme) {
      LevelSceneTheme.home => const Color(0xFFC09B6A),
      LevelSceneTheme.gateway => const Color(0xFF9F8155),
      LevelSceneTheme.dns => const Color(0xFF879AC3),
      LevelSceneTheme.office => const Color(0xFFA47F3E),
      LevelSceneTheme.dataCenter => const Color(0xFF6F8791),
      LevelSceneTheme.security => const Color(0xFF9B6767),
    };
    final tileColor = switch (theme) {
      LevelSceneTheme.home => const Color(0xFFD5B783),
      LevelSceneTheme.gateway => const Color(0xFFB89A68),
      LevelSceneTheme.dns => const Color(0xFF9DAED1),
      LevelSceneTheme.office => const Color(0xFFB99958),
      LevelSceneTheme.dataCenter => const Color(0xFF8EA3AE),
      LevelSceneTheme.security => const Color(0xFFAD8181),
    };

    canvas.drawPath(
      floor,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: floorColors,
        ).createShader(const Rect.fromLTWH(118, 180, 677, 368)),
    );
    canvas.drawPath(
      floor,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = floorStroke,
    );

    final tilePaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.4
          ..color = tileColor;

    for (var i = 1; i < 8; i++) {
      final t = i / 8;
      final top =
          Offset.lerp(const Offset(118, 288), const Offset(452, 180), t)!;
      final bottom =
          Offset.lerp(const Offset(458, 548), const Offset(795, 298), t)!;
      canvas.drawLine(top, bottom, tilePaint);
    }

    for (var i = 1; i < 7; i++) {
      final t = i / 7;
      final left =
          Offset.lerp(const Offset(118, 288), const Offset(458, 548), t)!;
      final right =
          Offset.lerp(const Offset(452, 180), const Offset(795, 298), t)!;
      canvas.drawLine(left, right, tilePaint);
    }

    final softFloorShade =
        Path()
          ..moveTo(355, 360)
          ..lineTo(505, 314)
          ..lineTo(657, 369)
          ..lineTo(502, 452)
          ..close();
    canvas.drawPath(softFloorShade, Paint()..color = const Color(0x1F5D627A));
  }

  void _drawWallDetails(Canvas canvas) {
    final trimPaint =
        Paint()
          ..strokeWidth = 5
          ..strokeCap = StrokeCap.round
          ..color = const Color(0xFFCDBD9C);
    canvas.drawLine(const Offset(118, 288), const Offset(452, 180), trimPaint);
    canvas.drawLine(const Offset(452, 180), const Offset(795, 298), trimPaint);

    switch (theme) {
      case LevelSceneTheme.home:
        _drawHomeDetails(canvas);
      case LevelSceneTheme.gateway:
        _drawGatewayDetails(canvas);
      case LevelSceneTheme.dns:
        _drawDnsDetails(canvas);
      case LevelSceneTheme.office:
        _drawOfficeDetails(canvas);
      case LevelSceneTheme.dataCenter:
        _drawDataCenterDetails(canvas);
      case LevelSceneTheme.security:
        _drawSecurityDetails(canvas);
    }
  }

  void _drawHomeDetails(Canvas canvas) {
    final shelfPaint = Paint()..color = const Color(0xFFB88769);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(550, 154, 118, 12),
        const Radius.circular(5),
      ),
      shelfPaint,
    );
    canvas.drawCircle(
      const Offset(586, 140),
      13,
      Paint()..color = const Color(0xFF8DC8B3),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(625, 132, 30, 22),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFFFFD36B),
    );

    final windowPaint = Paint()..color = const Color(0xFFBFE6F2);
    final framePaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4
          ..color = const Color(0xFFFFFFFF);
    final window = RRect.fromRectAndRadius(
      const Rect.fromLTWH(232, 118, 90, 68),
      const Radius.circular(8),
    );
    canvas.drawRRect(window, windowPaint);
    canvas.drawRRect(window, framePaint);
    canvas.drawLine(const Offset(277, 118), const Offset(277, 186), framePaint);
    canvas.drawLine(const Offset(232, 152), const Offset(322, 152), framePaint);
  }

  void _drawGatewayDetails(Canvas canvas) {
    final doorPaint = Paint()..color = const Color(0xFFE9F7FF);
    final doorBorder =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..color = const Color(0xFF75A9C5);
    final portal = RRect.fromRectAndRadius(
      const Rect.fromLTWH(600, 128, 92, 112),
      const Radius.circular(44),
    );
    canvas.drawRRect(portal, doorPaint);
    canvas.drawRRect(portal, doorBorder);
    canvas.drawCircle(
      const Offset(646, 182),
      28,
      Paint()..color = const Color(0x6673CEBB),
    );
    _drawLabel(canvas, 'WAN', const Offset(624, 155), const Color(0xFF2F6D78));

    final arrowPaint =
        Paint()
          ..color = const Color(0xFF2F6D78)
          ..strokeWidth = 4
          ..strokeCap = StrokeCap.round;
    canvas.drawLine(const Offset(618, 214), const Offset(675, 190), arrowPaint);
    canvas.drawLine(const Offset(675, 190), const Offset(660, 188), arrowPaint);
    canvas.drawLine(const Offset(675, 190), const Offset(666, 203), arrowPaint);
  }

  void _drawDnsDetails(Canvas canvas) {
    final rackPaint = Paint()..color = const Color(0xFF39495F);
    final rackFace = Paint()..color = const Color(0xFF526783);
    final rack = RRect.fromRectAndRadius(
      const Rect.fromLTWH(590, 120, 96, 118),
      const Radius.circular(10),
    );
    canvas.drawRRect(rack, rackPaint);
    for (var i = 0; i < 3; i++) {
      final y = 134.0 + i * 31;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(604, y, 68, 20),
          const Radius.circular(4),
        ),
        rackFace,
      );
      canvas.drawCircle(
        Offset(660, y + 10),
        3,
        Paint()..color = const Color(0xFF7DFFA9),
      );
    }
    _drawLabel(canvas, 'DNS', const Offset(616, 211), const Color(0xFFEAF4FF));

    final cardPaint = Paint()..color = const Color(0xFFFFFFFF);
    final cardBorder =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = const Color(0xFFB7C4E5);
    final card = RRect.fromRectAndRadius(
      const Rect.fromLTWH(210, 112, 146, 78),
      const Radius.circular(10),
    );
    canvas.drawRRect(card, cardPaint);
    canvas.drawRRect(card, cardBorder);
    _drawLabel(
      canvas,
      'example.com',
      const Offset(227, 130),
      const Color(0xFF3A4867),
    );
    _drawLabel(
      canvas,
      '-> 93.184.216.34',
      const Offset(226, 156),
      const Color(0xFF2D736A),
    );
  }

  void _drawOfficeDetails(Canvas canvas) {
    final boardPaint = Paint()..color = const Color(0xFFFFFFFF);
    final boardBorder =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..color = const Color(0xFF92A394);
    final board = RRect.fromRectAndRadius(
      const Rect.fromLTWH(204, 108, 150, 82),
      const Radius.circular(8),
    );
    canvas.drawRRect(board, boardPaint);
    canvas.drawRRect(board, boardBorder);
    _drawLabel(
      canvas,
      'IP: 192.168.1.24',
      const Offset(220, 124),
      const Color(0xFF3A4867),
    );
    _drawLabel(
      canvas,
      'Mask: /24',
      const Offset(220, 150),
      const Color(0xFF2D736A),
    );

    final switchBody = RRect.fromRectAndRadius(
      const Rect.fromLTWH(590, 132, 106, 52),
      const Radius.circular(8),
    );
    canvas.drawRRect(switchBody, Paint()..color = const Color(0xFF4E6A60));
    canvas.drawRRect(
      switchBody,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = const Color(0xFF263A36),
    );
    for (var i = 0; i < 5; i++) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(604 + i * 16, 150, 10, 12),
          const Radius.circular(2),
        ),
        Paint()..color = const Color(0xFFFFD36B),
      );
    }
    _drawLabel(canvas, 'LAN', const Offset(628, 163), const Color(0xFFEAF7F0));
  }

  void _drawDataCenterDetails(Canvas canvas) {
    for (var rackIndex = 0; rackIndex < 2; rackIndex++) {
      final left = 574.0 + rackIndex * 68;
      final rack = RRect.fromRectAndRadius(
        Rect.fromLTWH(left, 108, 54, 132),
        const Radius.circular(8),
      );
      canvas.drawRRect(rack, Paint()..color = const Color(0xFF334251));
      canvas.drawRRect(
        rack,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = const Color(0xFF72889A),
      );
      for (var i = 0; i < 4; i++) {
        final y = 123.0 + i * 26;
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(left + 9, y, 36, 15),
            const Radius.circular(3),
          ),
          Paint()..color = const Color(0xFF62788C),
        );
        canvas.drawCircle(
          Offset(left + 38, y + 7.5),
          2.6,
          Paint()..color = const Color(0xFF7DFFA9),
        );
      }
    }

    final poolCard = RRect.fromRectAndRadius(
      const Rect.fromLTWH(204, 110, 160, 88),
      const Radius.circular(8),
    );
    canvas.drawRRect(poolCard, Paint()..color = const Color(0xFFFFFFFF));
    canvas.drawRRect(
      poolCard,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = const Color(0xFF9AB8C5),
    );
    _drawLabel(
      canvas,
      'DHCP POOL',
      const Offset(228, 126),
      const Color(0xFF2F6D78),
    );
    _drawLabel(
      canvas,
      '192.168.1.10-80',
      const Offset(222, 154),
      const Color(0xFF3A4867),
    );
    _drawLabel(
      canvas,
      'Lease OK',
      const Offset(245, 176),
      const Color(0xFF2D736A),
    );
  }

  void _drawSecurityDetails(Canvas canvas) {
    final wallPaint = Paint()..color = const Color(0xFF8F4F4F);
    for (var i = 0; i < 4; i++) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(588 + i * 28, 128, 24, 74),
          const Radius.circular(4),
        ),
        wallPaint,
      );
    }
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(582, 196, 126, 18),
        const Radius.circular(5),
      ),
      Paint()..color = const Color(0xFF6F3939),
    );

    final shield =
        Path()
          ..moveTo(282, 104)
          ..lineTo(342, 126)
          ..lineTo(334, 184)
          ..quadraticBezierTo(312, 210, 282, 224)
          ..quadraticBezierTo(252, 210, 230, 184)
          ..lineTo(222, 126)
          ..close();
    canvas.drawPath(shield, Paint()..color = const Color(0xFFEAF7F0));
    canvas.drawPath(
      shield,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = const Color(0xFF2D736A),
    );
    _drawLabel(canvas, 'FW', const Offset(270, 150), const Color(0xFF2D736A));

    final packetPaint =
        Paint()
          ..strokeWidth = 4
          ..strokeCap = StrokeCap.round
          ..color = const Color(0xFF2D736A);
    canvas.drawLine(
      const Offset(370, 154),
      const Offset(444, 154),
      packetPaint,
    );
    canvas.drawLine(
      const Offset(444, 154),
      const Offset(431, 146),
      packetPaint,
    );
    canvas.drawLine(
      const Offset(444, 154),
      const Offset(431, 162),
      packetPaint,
    );

    final blockedPaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4
          ..strokeCap = StrokeCap.round
          ..color = const Color(0xFFD75050);
    canvas.drawCircle(const Offset(476, 154), 17, blockedPaint);
    canvas.drawLine(
      const Offset(465, 165),
      const Offset(487, 143),
      blockedPaint,
    );
  }

  void _drawLabel(Canvas canvas, String text, Offset offset, Color color) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: 14,
          fontWeight: FontWeight.w900,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, offset);
  }
}
