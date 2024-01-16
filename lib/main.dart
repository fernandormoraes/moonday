import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'package:moonday_project/moon_day.dart';
import 'package:moonday_project/overlays/game_over.dart';
import 'package:moonday_project/overlays/main_menu.dart';

void main() {
  runApp(
    GameWidget<MoondayGame>.controlled(
      gameFactory: MoondayGame.new,
      overlayBuilderMap: {
        'MainMenu': (_, game) => MainMenu(game: game),
        'GameOver': (_, game) => GameOver(game: game),
      },
      initialActiveOverlays: const ['MainMenu'],
    ),
  );
}
