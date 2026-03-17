import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/glass_card.dart';

class WallpaperScreen extends StatefulWidget {
  const WallpaperScreen({super.key});

  @override
  State<WallpaperScreen> createState() => _WallpaperScreenState();
}

class _WallpaperScreenState extends State<WallpaperScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  int _selectedWallpaper = 0;
  bool _isPlaying = true;

  final List<Map<String, dynamic>> _wallpapers = [
    {
      'name': '渐变流光',
      'type': 'gradient',
      'colors': [const Color(0xFF667EEA), const Color(0xFF764BA2), const Color(0xFFEC4899)],
      'icon': Icons.gradient,
    },
    {
      'name': '粒子星河',
      'type': 'particle',
      'colors': [const Color(0xFF0F0C29), const Color(0xFF302B63), const Color(0xFF24243E)],
      'icon': Icons.auto_awesome,
    },
    {
      'name': '海洋波浪',
      'type': 'wave',
      'colors': [const Color(0xFF0077B6), const Color(0xFF00B4D8), const Color(0xFF90E0EF)],
      'icon': Icons.waves,
    },
    {
      'name': '极光幻彩',
      'type': 'aurora',
      'colors': [const Color(0xFF43E97B), const Color(0xFF38F9D7), const Color(0xFFFA709A)],
      'icon': Icons.nights_stay,
    },
    {
      'name': '霓虹都市',
      'type': 'neon',
      'colors': [const Color(0xFF0F0F23), const Color(0xFF1A1A3E), const Color(0xFF2D2D5A)],
      'icon': Icons.location_city,
    },
    {
      'name': '日落黄昏',
      'type': 'sunset',
      'colors': [const Color(0xFFF12711), const Color(0xFFF5AF19), const Color(0xFFFFECD2)],
      'icon': Icons.wb_twilight,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(provider),
              const SizedBox(height: 24),
              _buildPreview(provider),
              const SizedBox(height: 24),
              _buildWallpaperGrid(provider),
              const SizedBox(height: 24),
              _buildImportSection(provider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(ThemeProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '动态壁纸',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            foreground: Paint()
              ..shader = LinearGradient(
                colors: provider.gradientColors,
              ).createShader(const Rect.fromLTWH(0, 0, 200, 0)),
          ),
        ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1),
        const SizedBox(height: 8),
        Text(
          '设置炫酷动态壁纸，让桌面动起来',
          style: TextStyle(color: Colors.grey[400], fontSize: 14),
        ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
      ],
    );
  }

  Widget _buildPreview(ThemeProvider provider) {
    return Center(
      child: Container(
        width: double.infinity,
        height: 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: provider.primaryColor.withOpacity(0.2),
              blurRadius: 30,
              spreadRadius: 5,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return CustomPaint(
                    size: const Size(double.infinity, 220),
                    painter: WallpaperPainter(
                      animation: _animationController,
                      wallpaper: _wallpapers[_selectedWallpaper],
                    ),
                  );
                },
              ),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            '实时预览',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      onPressed: () {
                        setState(() => _isPlaying = !_isPlaying);
                        if (_isPlaying) {
                          _animationController.repeat();
                        } else {
                          _animationController.stop();
                        }
                      },
                    ),
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.download, color: Colors.white, size: 20),
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ).animate().fadeIn(duration: 400.ms, delay: 200.ms).scale(),
    );
  }

  Widget _buildWallpaperGrid(ThemeProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.auto_awesome, color: provider.accentColor, size: 20),
            const SizedBox(width: 8),
            const Text(
              '预设壁纸',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.8,
          ),
          itemCount: _wallpapers.length,
          itemBuilder: (context, index) {
            final wallpaper = _wallpapers[index];
            final isSelected = _selectedWallpaper == index;

            return GestureDetector(
              onTap: () => setState(() => _selectedWallpaper = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: (wallpaper['colors'] as List<Color>)
                        .map((c) => isSelected ? c : c.withOpacity(0.5))
                        .toList(),
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? Colors.white : Colors.transparent,
                    width: isSelected ? 2 : 0,
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(
                        wallpaper['icon'],
                        size: 32,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      left: 8,
                      right: 8,
                      child: Text(
                        wallpaper['name'],
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    if (isSelected)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.check, size: 14, color: Colors.black),
                        ),
                      ),
                  ],
                ),
              ),
            )
                .animate()
                .fadeIn(delay: Duration(milliseconds: 300 + index * 50))
                .slideY(begin: 0.1);
          },
        ),
      ],
    );
  }

  Widget _buildImportSection(ThemeProvider provider) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.upload_file, color: provider.primaryColor, size: 20),
              const SizedBox(width: 8),
              const Text(
                '导入自定义壁纸',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildImportButton(Icons.image, '图库选择', provider.primaryColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildImportButton(Icons.video_library, '视频壁纸', provider.accentColor),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 600.ms);
  }

  Widget _buildImportButton(IconData icon, String label, Color color) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(color: color, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class WallpaperPainter extends CustomPainter {
  final Animation<double> animation;
  final Map<String, dynamic> wallpaper;

  WallpaperPainter({
    required this.animation,
    required this.wallpaper,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final colors = wallpaper['colors'] as List<Color>;
    final type = wallpaper['type'] as String;
    final value = animation.value;

    switch (type) {
      case 'gradient':
        _drawGradient(canvas, size, colors, value);
        break;
      case 'particle':
        _drawParticles(canvas, size, colors, value);
        break;
      case 'wave':
        _drawWaves(canvas, size, colors, value);
        break;
      case 'aurora':
        _drawAurora(canvas, size, colors, value);
        break;
      case 'neon':
        _drawNeon(canvas, size, colors, value);
        break;
      case 'sunset':
        _drawSunset(canvas, size, colors, value);
        break;
    }
  }

  void _drawGradient(Canvas canvas, Size size, List<Color> colors, double value) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: colors,
      stops: const [0.0, 0.5, 1.0],
      transform: GradientRotation(value * pi),
    );
    canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));

    for (int i = 0; i < 50; i++) {
      final random = Random(i);
      canvas.drawCircle(
        Offset(random.nextDouble() * size.width, random.nextDouble() * size.height),
        random.nextDouble() * 2,
        Paint()..color = Colors.white.withOpacity(random.nextDouble() * 0.3),
      );
    }
  }

  void _drawParticles(Canvas canvas, Size size, List<Color> colors, double value) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final gradient = RadialGradient(
      colors: colors,
      stops: const [0.0, 0.5, 1.0],
    );
    canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));

    final paint = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < 100; i++) {
      final random = Random(i);
      final x = (random.nextDouble() * size.width + value * 100 * random.nextDouble()) % size.width;
      final y = (random.nextDouble() * size.height + value * 50 * random.nextDouble()) % size.height;
      
      paint.color = Colors.white.withOpacity(random.nextDouble() * 0.5 + 0.2);
      canvas.drawCircle(Offset(x, y), random.nextDouble() * 3 + 1, paint);
    }
  }

  void _drawWaves(Canvas canvas, Size size, List<Color> colors, double value) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, Paint()..color = colors[0]);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    for (int i = 0; i < 3; i++) {
      final path = Path();
      for (double x = 0; x <= size.width; x++) {
        final y = size.height * 0.5 + sin((x * 0.02) + value * pi * 4 + i) * 30;
        if (x == 0) {
          path.moveTo(x, y + i * 30);
        } else {
          path.lineTo(x, y + i * 30);
        }
      }
      paint.color = colors[(i + 1) % colors.length].withOpacity(0.5);
      canvas.drawPath(path, paint);
    }
  }

  void _drawAurora(Canvas canvas, Size size, List<Color> colors, double value) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, Paint()..color = const Color(0xFF0A0A1A));

    for (int i = 0; i < 5; i++) {
      final path = Path();
      path.moveTo(0, size.height * 0.3 + i * 20);
      
      for (double x = 0; x <= size.width; x += 10) {
        final y = size.height * 0.3 + 
                  sin((x * 0.01) + value * pi * 2 + i * 0.5) * 50 +
                  cos((x * 0.02) + value * pi * 3) * 30;
        path.lineTo(x, y);
      }
      
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();

      canvas.drawPath(
        path,
        Paint()..shader = LinearGradient(
          colors: [colors[i % colors.length].withOpacity(0.3), colors[(i + 1) % colors.length].withOpacity(0.1)],
        ).createShader(rect),
      );
    }
  }

  void _drawNeon(Canvas canvas, Size size, List<Color> colors, double value) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, Paint()..color = colors[0]);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (int i = 0; i < 10; i++) {
      final x = (i * size.width / 10 + value * 100) % size.width;
      paint.color = colors[(i % colors.length)].withOpacity(0.5 + sin(value * pi * 4 + i) * 0.3);
      canvas.drawLine(
        Offset(x, 0),
        Offset(x + sin(value * pi * 2 + i) * 50, size.height),
        paint,
      );
    }
  }

  void _drawSunset(Canvas canvas, Size size, List<Color> colors, double value) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: colors,
      stops: const [0.0, 0.5, 1.0],
    );
    canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));

    final sunPaint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.orange.withOpacity(0.8), Colors.orange.withOpacity(0)],
      ).createShader(Rect.fromCircle(
        center: Offset(size.width * 0.5, size.height * 0.6),
        radius: 50 + sin(value * pi * 2) * 10,
      ));
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.6),
      50 + sin(value * pi * 2) * 10,
      sunPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
