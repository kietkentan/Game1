class ScreenPage {
  int level;
  ScreenEnum type;

  ScreenPage({required this.level, required this.type});
}

enum ScreenEnum { PASS, NOW, BLOCK }