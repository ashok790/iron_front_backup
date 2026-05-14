import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../game/game_engine.dart';
import '../models/tower.dart';
import '../services/ads_service.dart';
import '../widgets/hud_widgets.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final IronFrontGame _game;

  @override
  void initState() {
    super.initState();
    _game = IronFrontGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B2A1F),
      body: SafeArea(
        child: Column(
          children: [
            // ----- TOP HUD -----
            _TopHud(game: _game, onClose: () => Navigator.of(context).pop()),
            // ----- GAME -----
            Expanded(
              child: Stack(
                children: [
                  GameWidget(game: _game),
                  // Status overlays
                  ValueListenableBuilder<GameStatus>(
                    valueListenable: _game.status,
                    builder: (_, s, __) {
                      if (s == GameStatus.victory) return _VictoryOverlay(game: _game);
                      if (s == GameStatus.defeat) return _DefeatOverlay(game: _game);
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
            // ----- BOTTOM TOWER PICKER -----
            _TowerPicker(game: _game),
          ],
        ),
      ),
    );
  }
}

class _TopHud extends StatelessWidget {
  final IronFrontGame game;
  final VoidCallback onClose;
  const _TopHud({required this.game, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: const Color(0xFF0D1117),
      child: Row(
        children: [
          IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: onClose),
          const Spacer(),
          HudStat(icon: Icons.favorite, color: Colors.red, valueListenable: game.lives),
          const SizedBox(width: 14),
          HudStat(icon: Icons.monetization_on, color: Colors.amber, valueListenable: game.coins),
          const SizedBox(width: 14),
          ValueListenableBuilder<int>(
            valueListenable: game.wave,
            builder: (_, w, __) => HudPill(label: 'WAVE $w/${IronFrontGame.totalWaves}'),
          ),
          const Spacer(),
          ValueListenableBuilder<GameStatus>(
            valueListenable: game.status,
            builder: (_, s, __) {
              final isReady = s == GameStatus.placing || s == GameStatus.waveComplete;
              return ElevatedButton.icon(
                onPressed: isReady ? game.startWave : null,
                icon: const Icon(Icons.play_arrow, size: 18),
                label: Text(isReady ? 'START' : 'IN WAVE',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6B8E23),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _TowerPicker extends StatelessWidget {
  final IronFrontGame game;
  const _TowerPicker({required this.game});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      color: const Color(0xFF0D1117),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: TowerType.values.map((t) {
          final s = kTowerData[t]!;
          return ValueListenableBuilder<TowerType?>(
            valueListenable: game.selectedTowerType,
            builder: (_, selected, __) {
              return ValueListenableBuilder<int>(
                valueListenable: game.coins,
                builder: (_, coins, __) {
                  final canAfford = coins >= s.cost;
                  final isSelected = selected == t;
                  return GestureDetector(
                    onTap: canAfford ? () => game.selectTower(t) : null,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: 96,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelected ? s.color.withOpacity(0.3) : const Color(0xFF1B2A1F),
                        border: Border.all(
                          color: isSelected ? Colors.white : s.color,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Column(
                        children: [
                          Icon(s.icon, color: canAfford ? s.color : Colors.grey, size: 28),
                          Text(s.name,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.monetization_on, color: Colors.amber, size: 12),
                              const SizedBox(width: 2),
                              Text('${s.cost}',
                                  style: TextStyle(
                                      color: canAfford ? Colors.amber : Colors.red, fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        }).toList(),
      ),
    );
  }
}

class _VictoryOverlay extends StatelessWidget {
  final IronFrontGame game;
  const _VictoryOverlay({required this.game});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.75),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.emoji_events, color: Colors.amber, size: 90),
          const SizedBox(height: 12),
          const Text('VICTORY!',
              style: TextStyle(
                color: Colors.amber,
                fontSize: 36,
                fontWeight: FontWeight.w900,
                letterSpacing: 4,
              )),
          const SizedBox(height: 8),
          Text('Score: ${game.score.value}',
              style: const TextStyle(color: Colors.white, fontSize: 18)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              game.restart();
              // Show interstitial ad after match
              AdsService.instance.showInterstitial();
            },
            child: const Text('PLAY AGAIN'),
          ),
        ],
      ),
    );
  }
}

class _DefeatOverlay extends StatelessWidget {
  final IronFrontGame game;
  const _DefeatOverlay({required this.game});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.75),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.dangerous, color: Colors.red, size: 90),
          const SizedBox(height: 12),
          const Text('DEFEAT',
              style: TextStyle(
                color: Colors.red,
                fontSize: 36,
                fontWeight: FontWeight.w900,
                letterSpacing: 4,
              )),
          const SizedBox(height: 8),
          Text('You reached wave ${game.wave.value}',
              style: const TextStyle(color: Colors.white70, fontSize: 16)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              AdsService.instance.showRewardedAd(onReward: () {
                game.lives.value = 10;
                game.status.value = GameStatus.wave;
              });
            },
            icon: const Icon(Icons.play_circle_fill),
            label: const Text('WATCH AD TO REVIVE'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: game.restart,
            child: const Text('RESTART'),
          ),
        ],
      ),
    );
  }
}
