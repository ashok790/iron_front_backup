import 'package:flutter/material.dart';

enum EnemyType { infantry, scout, armor, heavy }

class EnemyStats {
  final String name;
  final double maxHealth;
  final double speed; // pixels per second
  final int reward;
  final int damageToBase;
  final Color color;
  final double size;

  const EnemyStats({
    required this.name,
    required this.maxHealth,
    required this.speed,
    required this.reward,
    required this.damageToBase,
    required this.color,
    required this.size,
  });
}

const Map<EnemyType, EnemyStats> kEnemyData = {
  EnemyType.infantry: EnemyStats(
    name: 'Infantry',
    maxHealth: 30,
    speed: 50,
    reward: 8,
    damageToBase: 1,
    color: Color(0xFF8B4513),
    size: 18,
  ),
  EnemyType.scout: EnemyStats(
    name: 'Scout',
    maxHealth: 18,
    speed: 95,
    reward: 12,
    damageToBase: 1,
    color: Color(0xFFFFA500),
    size: 16,
  ),
  EnemyType.armor: EnemyStats(
    name: 'Armor',
    maxHealth: 120,
    speed: 35,
    reward: 25,
    damageToBase: 2,
    color: Color(0xFF556B2F),
    size: 24,
  ),
  EnemyType.heavy: EnemyStats(
    name: 'Heavy Tank',
    maxHealth: 280,
    speed: 22,
    reward: 60,
    damageToBase: 4,
    color: Color(0xFF2F4F4F),
    size: 30,
  ),
};
