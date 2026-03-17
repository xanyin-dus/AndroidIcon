class ThemeIcon {
  final String id;
  final String name;
  final String? localPath;
  final String? networkUrl;
  final String category;
  final DateTime createdAt;

  ThemeIcon({
    required this.id,
    required this.name,
    this.localPath,
    this.networkUrl,
    this.category = 'custom',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory ThemeIcon.fromJson(Map<String, dynamic> json) {
    return ThemeIcon(
      id: json['id'],
      name: json['name'],
      localPath: json['localPath'],
      networkUrl: json['networkUrl'],
      category: json['category'] ?? 'custom',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'localPath': localPath,
      'networkUrl': networkUrl,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class ChargingAnimation {
  final String id;
  final String name;
  final String type;
  final Map<String, dynamic> config;

  ChargingAnimation({
    required this.id,
    required this.name,
    required this.type,
    this.config = const {},
  });
}

class DynamicWallpaper {
  final String id;
  final String name;
  final String type;
  final String? localPath;
  final String? networkUrl;
  final Map<String, dynamic> config;

  DynamicWallpaper({
    required this.id,
    required this.name,
    required this.type,
    this.localPath,
    this.networkUrl,
    this.config = const {},
  });
}

class SystemTheme {
  final String id;
  final String name;
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final Color backgroundColor;
  final Color surfaceColor;
  final Color textColor;
  final double cornerRadius;
  final String iconShape;
  final String fontFamily;

  SystemTheme({
    required this.id,
    required this.name,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.backgroundColor,
    required this.surfaceColor,
    required this.textColor,
    this.cornerRadius = 16,
    this.iconShape = 'rounded',
    this.fontFamily = 'Roboto',
  });
}

class ThemeProject {
  String name;
  List<ThemeIcon> icons;
  ChargingAnimation? chargingAnimation;
  List<DynamicWallpaper> wallpapers;
  SystemTheme? systemTheme;
  DateTime createdAt;
  DateTime updatedAt;

  ThemeProject({
    this.name = '未命名主题',
    List<ThemeIcon>? icons,
    this.chargingAnimation,
    List<DynamicWallpaper>? wallpapers,
    this.systemTheme,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : icons = icons ?? [],
        wallpapers = wallpapers ?? [],
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();
}
