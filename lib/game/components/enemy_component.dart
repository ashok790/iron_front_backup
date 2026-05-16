import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../models/enemy.dart';
import '../game_engine.dart';

class EnemyComponent extends PositionComponent
    with HasGameReference<IronFrontGame>, CollisionCallbacks {
  final EnemyType type;
  final double healthMultiplier;
  late final EnemyStats stats;
  late double health;
  late double maxHealth;
  int _pathIndex = 1;

  EnemyComponent({required this.type, this.healthMultiplier = 1.0}) {
    stats = kEnemyData[type]!;
    maxHealth = stats.maxHealth * healthMultiplier;
    health = maxHealth;
    size = Vector2.all(stats.size);
    anchor = Anchor.center;
  }

  @override
  Future<void> onLoad() async {
    position = game.pathWaypoints.first.clone();
    add(CircleHitbox(radius: stats.size / 2));
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_pathIndex >= game.pathWaypoints.length) {
      game.onEnemyReachedBase(this);
      return;
    }
    final target = game.pathWaypoints[_pathIndex];
    final dir = (target - position);
    final dist = dir.length;
    if (dist < 4) {
      _pathIndex++;
    } else {
      dir.normalize();
      position += dir * stats.speed * dt;
    }
  }

  void takeDamage(double dmg) {
    health -= dmg;
    if (health <= 0) {
      game.onEnemyKilled(this);
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final center = Offset(size.x / 2, size.y / 2);
    // Body
    final body = Paint()..color = stats.color;
    canvas.drawCircle(center, size.x / 2, body);
    // Outline
    final outline = Paint()
      ..color = Colors.black.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, size.x / 2, outline);
    // Health bar
    final pct = (health / maxHealth).clamp(0.0, 1.0);
    final barW = size.x + 6;
    final barH = 4.0;
    final barRect = Rect.fromLTWH(-3, -10, barW, barH);
    canvas.drawRect(barRect, Paint()..color = Colors.black54);
    final hpRect = Rect.fromLTWH(-3, -10, barW * pct, barH);
    canvas.drawRect(
      hpRect,
      Paint()
        ..color = pct > 0.5
            ? Colors.green
            : pct > 0.25
                ? Colors.orange
                : Colors.red,
    );
  }
}
