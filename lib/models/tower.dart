import 'package:flutter/material.dart';

enum TowerType { machineGun, rocket, sniper }

class TowerStats {
  final String name;
  final String description;
  final int cost;
  final double damage;
  final double range;
  final double fireRate; // shots per second
  final Color color;
  final IconData icon;

  const TowerStats({
    required this.name,
    required this.description,
    required this.cost,
    required this.damage,
    required this.range,
    required this.fireRate,
    required this.color,
    required this.icon,
  });
}

const Map<TowerType, TowerStats> kTowerData = {
  TowerType.machineGun: TowerStats(
    name: 'MG Nest',
    description: 'Rapid-fire infantry suppression. Cheap and fast.',
    cost: 50,
    damage: 8,
    range: 140,
    fireRate: 4.0,
    color: Color(0xFF6B8E23),
    icon: Icons.gps_fixed,
  ),
  TowerType.rocket: TowerStats(
    name: 'Rocket Pod',
    description: 'High-damage AOE. Slow rate of fire.',
    cost: 120,
    damage: 35,
    range: 180,
    fireRate: 0.8,
    color: Color(0xFFCD5C5C),
    icon: Icons.rocket_launch,
  ),
  TowerType.sniper: TowerStats(
    name: 'Sniper Post',
    description: 'Massive range, high single-target damage.',
    cost: 200,
    damage: 60,
    range: 320,
    fireRate: 0.6,
    color: Color(0xFF4682B4),
    icon: Icons.center_focus_strong,
  ),
};
