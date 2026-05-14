import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class PathComponent extends PositionComponent {
  final List<Vector2> waypoints;
  PathComponent(this.waypoints);

  @override
  int get priority => -10;

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // Dirt road background
    final road = Paint()
      ..color = const Color(0xFF6B5D3F)
      ..strokeWidth = 42
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final path = Path()..moveTo(waypoints.first.x, waypoints.first.y);
    for (int i = 1; i < waypoints.length; i++) {
      path.lineTo(waypoints[i].x, waypoints[i].y);
    }
    canvas.drawPath(path, road);

    // Dashed centerline
    final dash = Paint()
      ..color = Colors.yellow.withOpacity(0.4)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawPath(path, dash);
  }
}
