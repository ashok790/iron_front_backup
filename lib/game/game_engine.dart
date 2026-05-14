import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

import '../models/tower.dart';
import '../models/enemy.dart';
import 'components/enemy_component.dart';
import 'components/tower_component.dart';
import 'components/projectile_component.dart';
import 'components/path_component.dart';

/// The core Flame game engine for Iron Front: Last Defense.
/// Handles waves, enemies, towers, projectiles, economy, and victory state.
class IronFrontGame extends FlameGame with TapCallbacks, HasCollisionDetection {
  // ---------- Game state (observable by Flutter UI) ----------
  final ValueNotifier<int> coins = ValueNotifier(200);
  final ValueNotifier<int> lives = ValueNotifier(20);
  final ValueNotifier<int> wave = ValueNotifier(0);
  final ValueNotifier<int> score = ValueNotifier(0);
  final ValueNotifier<GameStatus> status = ValueNotifier(GameStatus.placing);
  final ValueNotifier<TowerType?> selectedTowerType = ValueNotifier(null);

  // ---------- Path (enemies follow these waypoints) ----------
  late List<Vector2> pathWaypoints;

  // ---------- Wave system ----------
  static const int totalWaves = 15;
  double _spawnTimer = 0;
  int _enemiesToSpawnInWave = 0;
  int _spawnedInWave = 0;
  final Random _rng = Random();

  // ---------- Build mode ----------
  final List<Vector2> _buildSpots = [];
  final Set<Vector2> _occupiedSpots = {};

  @override
  Color backgroundColor() => const Color(0xFF1B2A1F);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    _setupPath();
    _setupBuildSpots();
    add(PathComponent(pathWaypoints));
  }

  void _setupPath() {
    final w = size.x;
    final h = size.y;
    // Zig-zag path from left to right
    pathWaypoints = [
      Vector2(-30, h * 0.20),
      Vector2(w * 0.30, h * 0.20),
      Vector2(w * 0.30, h * 0.45),
      Vector2(w * 0.70, h * 0.45),
      Vector2(w * 0.70, h * 0.70),
      Vector2(w * 0.20, h * 0.70),
      Vector2(w * 0.20, h * 0.90),
      Vector2(w + 30, h * 0.90),
    ];
  }

  void _setupBuildSpots() {
    final w = size.x;
    final h = size.y;
    // Predefined tower placement spots (off the path)
    _buildSpots.addAll([
      Vector2(w * 0.15, h * 0.32),
      Vector2(w * 0.45, h * 0.32),
      Vector2(w * 0.50, h * 0.58),
      Vector2(w * 0.85, h * 0.32),
      Vector2(w * 0.85, h * 0.58),
      Vector2(w * 0.10, h * 0.82),
      Vector2(w * 0.45, h * 0.82),
      Vector2(w * 0.60, h * 0.20),
      Vector2(w * 0.15, h * 0.55),
    ]);
    for (final spot in _buildSpots) {
      add(BuildSpotMarker(position: spot));
    }
  }

  void startWave() {
    if (status.value != GameStatus.placing && status.value != GameStatus.waveComplete) return;
    wave.value += 1;
    _enemiesToSpawnInWave = 5 + (wave.value * 2);
    _spawnedInWave = 0;
    _spawnTimer = 0;
    status.value = GameStatus.wave;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (status.value == GameStatus.wave) _updateWave(dt);
  }

  void _updateWave(double dt) {
    _spawnTimer += dt;
    final spawnInterval = max(0.4, 1.2 - (wave.value * 0.04));
    if (_spawnTimer >= spawnInterval && _spawnedInWave < _enemiesToSpawnInWave) {
      _spawnTimer = 0;
      _spawnEnemy();
      _spawnedInWave++;
    }
    // Wave complete when all spawned + no enemies left
    if (_spawnedInWave >= _enemiesToSpawnInWave &&
        children.whereType<EnemyComponent>().isEmpty) {
      _onWaveComplete();
    }
  }

  void _spawnEnemy() {
    // Difficulty scaling
    EnemyType type;
    final w = wave.value;
    final roll = _rng.nextDouble();
    if (w >= 8 && roll < 0.15) {
      type = EnemyType.heavy;
    } else if (w >= 5 && roll < 0.35) {
      type = EnemyType.armor;
    } else if (roll < 0.55) {
      type = EnemyType.scout;
    } else {
      type = EnemyType.infantry;
    }
    final healthMultiplier = 1.0 + (w - 1) * 0.12;
    add(EnemyComponent(type: type, healthMultiplier: healthMultiplier));
  }

  void _onWaveComplete() {
    coins.value += 50 + (wave.value * 10); // wave bonus
    if (wave.value >= totalWaves) {
      status.value = GameStatus.victory;
    } else {
      status.value = GameStatus.waveComplete;
    }
  }

  void onEnemyReachedBase(EnemyComponent enemy) {
    lives.value -= enemy.stats.damageToBase;
    enemy.removeFromParent();
    if (lives.value <= 0) {
      lives.value = 0;
      status.value = GameStatus.defeat;
    }
  }

  void onEnemyKilled(EnemyComponent enemy) {
    coins.value += enemy.stats.reward;
    score.value += enemy.stats.reward * 10;
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    final selected = selectedTowerType.value;
    if (selected == null) return;
    if (status.value == GameStatus.defeat || status.value == GameStatus.victory) return;

    // Find nearest available build spot
    final tap = event.canvasPosition;
    Vector2? closest;
    double bestDist = 60;
    for (final spot in _buildSpots) {
      if (_occupiedSpots.contains(spot)) continue;
      final d = spot.distanceTo(tap);
      if (d < bestDist) {
        bestDist = d;
        closest = spot;
      }
    }
    if (closest == null) return;

    final stats = kTowerData[selected]!;
    if (coins.value < stats.cost) return;

    coins.value -= stats.cost;
    _occupiedSpots.add(closest);
    add(TowerComponent(type: selected, position: closest));
    selectedTowerType.value = null;
  }

  void selectTower(TowerType type) {
    selectedTowerType.value = (selectedTowerType.value == type) ? null : type;
  }

  void restart() {
    coins.value = 200;
    lives.value = 20;
    wave.value = 0;
    score.value = 0;
    status.value = GameStatus.placing;
    _occupiedSpots.clear();
    children.whereType<EnemyComponent>().forEach((e) => e.removeFromParent());
    children.whereType<TowerComponent>().forEach((t) => t.removeFromParent());
    children.whereType<ProjectileComponent>().forEach((p) => p.removeFromParent());
  }
}

enum GameStatus { placing, wave, waveComplete, victory, defeat }

/// Visual marker for available tower placement spots.
class BuildSpotMarker extends PositionComponent {
  BuildSpotMarker({required Vector2 position})
      : super(position: position, size: Vector2.all(32), anchor: Anchor.center);

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), size.x / 2, paint);
    final fill = Paint()..color = Colors.white.withOpacity(0.05);
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), size.x / 2, fill);
  }
}
