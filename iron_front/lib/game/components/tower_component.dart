import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../models/tower.dart';
import '../game_engine.dart';
import 'enemy_component.dart';
import 'projectile_component.dart';

class TowerComponent extends PositionComponent with HasGameReference<IronFrontGame> {
  final TowerType type;
  late final TowerStats stats;
  double _fireCooldown = 0;
  double _barrelAngle = 0;

  TowerComponent({required this.type, required Vector2 position}) {
    stats = kTowerData[type]!;
    this.position = position;
    size = Vector2.all(38);
    anchor = Anchor.center;
  }

  @override
  void update(double dt) {
    super.update(dt);
    _fireCooldown -= dt;
    final target = _findTarget();
    if (target != null) {
      final dir = target.position - position;
      _barrelAngle = atan2(dir.y, dir.x);
      if (_fireCooldown <= 0) {
        _fireCooldown = 1 / stats.fireRate;
        _shoot(target);
      }
    }
  }

  EnemyComponent? _findTarget() {
    EnemyComponent? best;
    double bestDist = stats.range;
    for (final e in game.children.whereType<EnemyComponent>()) {
      final d = e.position.distanceTo(position);
      if (d <= bestDist) {
        bestDist = d;
        best = e;
      }
    }
    return best;
  }

  void _shoot(EnemyComponent target) {
    game.add(ProjectileComponent(
      start: position.clone(),
      target: target,
      damage: stats.damage,
      color: stats.color,
    ));
  }

  @override
  void render(Canvas canvas) {
    final center = Offset(size.x / 2, size.y / 2);

    // Base platform
    final base = Paint()..color = Colors.brown.shade800;
    canvas.drawCircle(center, size.x / 2, base);
    final baseRing = Paint()
      ..color = Colors.black54
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, size.x / 2, baseRing);

    // Tower body
    final body = Paint()..color = stats.color;
    canvas.drawCircle(center, size.x / 2 - 6, body);

    // Barrel
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(_barrelAngle);
    final barrel = Paint()..color = Colors.black87;
    canvas.drawRect(Rect.fromLTWH(0, -3, size.x / 2 + 4, 6), barrel);
    canvas.restore();
  }
}
