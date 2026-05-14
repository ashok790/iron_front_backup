import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../game_engine.dart';
import 'enemy_component.dart';

class ProjectileComponent extends PositionComponent with HasGameReference<IronFrontGame> {
  final EnemyComponent target;
  final double damage;
  final Color color;
  final double speed = 500;

  ProjectileComponent({
    required Vector2 start,
    required this.target,
    required this.damage,
    required this.color,
  }) {
    position = start;
    size = Vector2.all(8);
    anchor = Anchor.center;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!target.isMounted) {
      removeFromParent();
      return;
    }
    final dir = target.position - position;
    final d = dir.length;
    if (d < 8) {
      target.takeDamage(damage);
      removeFromParent();
      return;
    }
    dir.normalize();
    position += dir * speed * dt;
  }

  @override
  void render(Canvas canvas) {
    final center = Offset(size.x / 2, size.y / 2);
    canvas.drawCircle(center, 4, Paint()..color = color);
    canvas.drawCircle(
      center,
      4,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }
}
