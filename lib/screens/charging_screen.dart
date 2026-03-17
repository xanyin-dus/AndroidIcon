import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/glass_card.dart';

class ChargingScreen extends StatefulWidget {
  const ChargingScreen({super.key});

  @override
  State<ChargingScreen> createState() => _ChargingScreenState();
}

class _ChargingScreenState extends State<ChargingScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  int _selectedStyle = 0;
  double _batteryLevel = 65;
  bool _isPlaying = true;

  final List<Map<String, dynamic>> _chargingStyles = [
    {'name': '粒子能量', 'icon': Icons.auto_awesome, 'color': const Color(0xFFFBBF24)},
    {'name': '波浪充能', 'icon': Icons.waves, 'color': const Color(0xFF22D3EE)},
    {'name': '脉冲光环', 'icon': Icons.circle_outlined, 'color': const Color(0xFF34D399)},
    {'name': '太阳光芒', 'icon': Icons.wb_sunny, 'color': const Color(0xFFFB923C)},
    {'name': '月光充能', 'icon': Icons.nightlight, 'color': const Color(0xFFA78BFA)},
    {'name': '闪电快充', 'icon': Icons.bolt, 'color': const Color(0xFFFDE047)},
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
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
              _buildStyleSelector(provider),
              const SizedBox(height: 24),
              _buildControls(provider),
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
          '充电显示美化',
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
          '自定义充电动画效果，让充电更有仪式感',
          style: TextStyle(color: Colors.grey[400], fontSize: 14),
        ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
      ],
    );
  }

  Widget _buildPreview(ThemeProvider provider) {
    return Center(
      child: Container(
        width: 280,
        height: 380,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              provider.primaryColor.withOpacity(0.1),
              provider.accentColor.withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: Stack(
            alignment: Alignment.center,
            children: [
              _buildAnimationWidget(provider),
              Positioned(
                top: 40,
                child: Row(
                  children: [
                    Icon(
                      Icons.battery_charging_full,
                      color: Colors.green[400],
                      size: 28,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${_batteryLevel.toInt()}%',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 40,
                child: Container(
                  width: 200,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Text(
                        _chargingStyles[_selectedStyle]['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '充电动画预览',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ).animate().fadeIn(duration: 400.ms, delay: 200.ms).scale(),
    );
  }

  Widget _buildAnimationWidget(ThemeProvider provider) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(200, 200),
          painter: ChargingAnimationPainter(
            animation: _animationController,
            style: _selectedStyle,
            color: _chargingStyles[_selectedStyle]['color'],
          ),
        );
      },
    );
  }

  Widget _buildStyleSelector(ThemeProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.style, color: provider.primaryColor, size: 20),
            const SizedBox(width: 8),
            const Text(
              '选择动画风格',
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
            childAspectRatio: 1,
          ),
          itemCount: _chargingStyles.length,
          itemBuilder: (context, index) {
            final style = _chargingStyles[index];
            final isSelected = _selectedStyle == index;

            return GestureDetector(
              onTap: () => setState(() => _selectedStyle = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(
                          colors: [style['color'], style['color'].withOpacity(0.7)],
                        )
                      : null,
                  color: isSelected ? null : Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? Colors.transparent : Colors.white.withOpacity(0.1),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      style['icon'],
                      color: isSelected ? Colors.white : Colors.white70,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      style['name'],
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected ? Colors.white : Colors.white70,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
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

  Widget _buildControls(ThemeProvider provider) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '动画参数',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          _buildSlider('动画速度', 0.5, 2.0, 1.0),
          const SizedBox(height: 16),
          _buildSlider('粒子数量', 10, 100, 50),
          const SizedBox(height: 16),
          _buildSlider('颜色强度', 0.3, 1.0, 0.7),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => setState(() => _isPlaying = !_isPlaying),
                  icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                  label: Text(_isPlaying ? '暂停' : '播放'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: provider.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.save),
                  label: const Text('保存'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(color: Colors.white.withOpacity(0.3)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSlider(String label, double min, double max, double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
            Text(value.toStringAsFixed(1), style: const TextStyle(fontSize: 12)),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: Colors.white.withOpacity(0.3),
            inactiveTrackColor: Colors.white.withOpacity(0.1),
            thumbColor: Colors.white,
            overlayColor: Colors.white.withOpacity(0.1),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            onChanged: (_) {},
          ),
        ),
      ],
    );
  }
}

class ChargingAnimationPainter extends CustomPainter {
  final Animation<double> animation;
  final int style;
  final Color color;

  ChargingAnimationPainter({
    required this.animation,
    required this.style,
    required this.color,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final value = animation.value;

    switch (style) {
      case 0:
        _drawParticles(canvas, center, size, value);
        break;
      case 1:
        _drawWaves(canvas, center, size, value);
        break;
      case 2:
        _drawPulse(canvas, center, size, value);
        break;
      case 3:
        _drawSunRays(canvas, center, size, value);
        break;
      case 4:
        _drawMoon(canvas, center, size, value);
        break;
      case 5:
        _drawLightning(canvas, center, size, value);
        break;
    }
  }

  void _drawParticles(Canvas canvas, Offset center, Size size, double value) {
    final paint = Paint()..style = PaintingStyle.fill;
    final random = Random(42);

    for (int i = 0; i < 30; i++) {
      final angle = (i / 30) * pi * 2 + value * pi * 2;
      final radius = 60.0 + random.nextDouble() * 20;
      final x = center.dx + cos(angle) * radius;
      final y = center.dy + sin(angle) * radius;
      
      paint.color = color.withOpacity(0.5 + random.nextDouble() * 0.3);
      canvas.drawCircle(Offset(x, y), 2 + random.nextDouble() * 2, paint);
    }

    paint.color = color.withOpacity(0.3);
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2;
    canvas.drawCircle(center, 50 + sin(value * pi * 4) * 5, paint);
  }

  void _drawWaves(Canvas canvas, Offset center, Size size, double value) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    for (int i = 0; i < 3; i++) {
      final path = Path();
      for (double x = 0; x < size.width; x++) {
        final y = center.dy + sin((x * 0.05) + value * pi * 4 + i) * 15;
        if (x == 0) {
          path.moveTo(x, y + i * 20);
        } else {
          path.lineTo(x, y + i * 20);
        }
      }
      paint.color = color.withOpacity(0.5 - i * 0.15);
      canvas.drawPath(path, paint);
    }
  }

  void _drawPulse(Canvas canvas, Offset center, Size size, double value) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (int i = 0; i < 3; i++) {
      final radius = 30.0 + ((value * 100 + i * 30) % 80);
      final alpha = 1 - ((value * 100 + i * 30) % 80) / 80;
      paint.color = color.withOpacity(alpha * 0.5);
      canvas.drawCircle(center, radius, paint);
    }

    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = color.withOpacity(0.3);
    canvas.drawCircle(center, 30, fillPaint);
  }

  void _drawSunRays(Canvas canvas, Offset center, Size size, double value) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    for (int i = 0; i < 12; i++) {
      final angle = (i / 12) * pi * 2 + value * pi;
      final innerRadius = 40.0;
      final outerRadius = 80.0 + sin(value * pi * 6 + i) * 20;
      
      paint.color = color.withOpacity(0.5 + sin(value * pi * 6 + i) * 0.3);
      
      canvas.drawLine(
        Offset(
          center.dx + cos(angle) * innerRadius,
          center.dy + sin(angle) * innerRadius,
        ),
        Offset(
          center.dx + cos(angle) * outerRadius,
          center.dy + sin(angle) * outerRadius,
        ),
        paint,
      );
    }

    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = color.withOpacity(0.5);
    canvas.drawCircle(center, 35, fillPaint);
  }

  void _drawMoon(Canvas canvas, Offset center, Size size, double value) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < 8; i++) {
      final angle = (i / 8) * pi * 2 + value * pi;
      final radius = 50.0 + sin(value * pi * 4 + i) * 10;
      
      paint.color = color.withOpacity(0.3 + sin(value * pi * 4 + i) * 0.2);
      canvas.drawCircle(
        Offset(
          center.dx + cos(angle) * radius,
          center.dy + sin(angle) * radius,
        ),
        5,
        paint,
      );
    }

    paint.color = color.withOpacity(0.4);
    canvas.drawCircle(center, 30, paint);
  }

  void _drawLightning(Canvas canvas, Offset center, Size size, double value) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = color.withOpacity(0.9);

    if ((value * 10).toInt() % 3 == 0) {
      final path = Path();
      var x = center.dx;
      var y = center.dy - 60;
      path.moveTo(x, y);

      for (int i = 0; i < 5; i++) {
        x += (Random().nextDouble() - 0.5) * 40;
        y += 25;
        path.lineTo(x, y);
      }
      canvas.drawPath(path, paint);
    }

    final circlePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = color.withOpacity(0.5);
    canvas.drawCircle(center, 40 + sin(value * pi * 10) * 5, circlePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
