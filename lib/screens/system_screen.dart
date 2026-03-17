import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/glass_card.dart';

class SystemScreen extends StatefulWidget {
  const SystemScreen({super.key});

  @override
  State<SystemScreen> createState() => _SystemScreenState();
}

class _SystemScreenState extends State<SystemScreen> {
  int _selectedSection = 0;
  String _selectedFont = 'Roboto';
  String _selectedShape = 'rounded';
  double _cornerRadius = 16;

  final List<Map<String, dynamic>> _fonts = [
    {'id': 'roboto', 'name': 'Roboto', 'preview': 'Aa'},
    {'id': 'noto', 'name': 'Noto Sans', 'preview': 'Aa'},
    {'id': 'product', 'name': 'Product Sans', 'preview': 'Aa'},
    {'id': 'inter', 'name': 'Inter', 'preview': 'Aa'},
  ];

  final List<Map<String, dynamic>> _shapes = [
    {'id': 'circle', 'name': '圆形', 'icon': Icons.circle},
    {'id': 'rounded', 'name': '圆角', 'icon': Icons.square_rounded},
    {'id': 'squircle', 'name': '超圆角', 'icon': Icons.square},
    {'id': 'square', 'name': '方形', 'icon': Icons.crop_square},
  ];

  final List<Map<String, dynamic>> _presetThemes = [
    {
      'name': 'Material You',
      'colors': [const Color(0xFF6750A4), const Color(0xFF625B71), const Color(0xFF7D5260)],
    },
    {
      'name': '海洋蓝',
      'colors': [const Color(0xFF0077B6), const Color(0xFF00B4D8), const Color(0xFF90E0EF)],
    },
    {
      'name': '日落橙',
      'colors': [const Color(0xFFF77F00), const Color(0xFFFCBF49), const Color(0xFFEAE2B7)],
    },
    {
      'name': '森林绿',
      'colors': [const Color(0xFF2D6A4F), const Color(0xFF40916C), const Color(0xFF95D5B2)],
    },
    {
      'name': '霓虹紫',
      'colors': [const Color(0xFF9D4EDD), const Color(0xFFC77DFF), const Color(0xFFE0AAFF)],
    },
    {
      'name': '极简白',
      'colors': [const Color(0xFF2B2D42), const Color(0xFF8D99AE), const Color(0xFFEF233C)],
    },
  ];

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
              _buildSectionTabs(provider),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 2, child: _buildContent(provider)),
                  const SizedBox(width: 20),
                  Expanded(child: _buildPhonePreview(provider)),
                ],
              ),
              const SizedBox(height: 24),
              _buildPresetThemes(provider),
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
          '系统美化',
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
          '自定义系统颜色、字体和形状样式',
          style: TextStyle(color: Colors.grey[400], fontSize: 14),
        ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
      ],
    );
  }

  Widget _buildSectionTabs(ThemeProvider provider) {
    return Row(
      children: [
        _buildTab(0, Icons.palette, '颜色配置', provider),
        const SizedBox(width: 12),
        _buildTab(1, Icons.text_fields, '字体设置', provider),
        const SizedBox(width: 12),
        _buildTab(2, Icons.category, '形状样式', provider),
      ],
    );
  }

  Widget _buildTab(int index, IconData icon, String label, ThemeProvider provider) {
    final isSelected = _selectedSection == index;
    
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedSection = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(colors: provider.gradientColors)
                : null,
            color: isSelected ? null : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? Colors.transparent : Colors.white.withOpacity(0.1),
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? Colors.white : Colors.white70),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? Colors.white : Colors.white70,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(ThemeProvider provider) {
    switch (_selectedSection) {
      case 0:
        return _buildColorSection(provider);
      case 1:
        return _buildFontSection(provider);
      case 2:
        return _buildShapeSection(provider);
      default:
        return _buildColorSection(provider);
    }
  }

  Widget _buildColorSection(ThemeProvider provider) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '自定义颜色',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          _buildColorItem('主色调', provider.primaryColor, (color) => provider.setPrimaryColor(color)),
          const SizedBox(height: 16),
          _buildColorItem('强调色', provider.accentColor, (color) => provider.setAccentColor(color)),
          const SizedBox(height: 16),
          _buildColorItem('背景色', const Color(0xFF0F0F1A), (_) {}),
          const SizedBox(height: 16),
          _buildColorItem('表面色', const Color(0xFF1A1A2E), (_) {}),
          const SizedBox(height: 16),
          _buildColorItem('文字色', Colors.white, (_) {}),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildColorItem(String label, Color color, Function(Color) onChanged) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => _showColorPicker(color, onChanged),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
              Text(
                '#${color.value.toRadixString(16).substring(2).toUpperCase()}',
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.white54, size: 20),
          onPressed: () => _showColorPicker(color, onChanged),
        ),
      ],
    );
  }

  void _showColorPicker(Color initialColor, Function(Color) onChanged) {
    Color selectedColor = initialColor;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('选择颜色', style: TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: initialColor,
            onColorChanged: (color) => selectedColor = color,
            pickerAreaHeightPercent: 0.8,
            enableAlpha: false,
            labelTypes: const [],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              onChanged(selectedColor);
              Navigator.pop(context);
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  Widget _buildFontSection(ThemeProvider provider) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '选择字体',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          ...List.generate(_fonts.length, (index) {
            final font = _fonts[index];
            final isSelected = _selectedFont == font['id'];
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GestureDetector(
                onTap: () => setState(() => _selectedFont = font['id']),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(colors: provider.gradientColors)
                        : null,
                    color: isSelected ? null : Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? Colors.transparent : Colors.white.withOpacity(0.1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        font['preview'],
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        font['name'],
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Spacer(),
                      if (isSelected)
                        const Icon(Icons.check, color: Colors.white),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildShapeSection(ThemeProvider provider) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '图标形状',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.5,
            ),
            itemCount: _shapes.length,
            itemBuilder: (context, index) {
              final shape = _shapes[index];
              final isSelected = _selectedShape == shape['id'];
              
              return GestureDetector(
                onTap: () => setState(() => _selectedShape = shape['id']),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(colors: provider.gradientColors)
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
                      Icon(shape['icon'], size: 28),
                      const SizedBox(height: 8),
                      Text(shape['name'], style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          const Text(
            '圆角半径',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text('0dp', style: TextStyle(fontSize: 12, color: Colors.grey)),
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: provider.primaryColor,
                    inactiveTrackColor: Colors.white.withOpacity(0.1),
                    thumbColor: Colors.white,
                  ),
                  child: Slider(
                    value: _cornerRadius,
                    min: 0,
                    max: 32,
                    onChanged: (value) => setState(() => _cornerRadius = value),
                  ),
                ),
              ),
              Text('${_cornerRadius.toInt()}dp', style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildPhonePreview(ThemeProvider provider) {
    return Container(
      height: 480,
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
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A2E),
            borderRadius: BorderRadius.circular(28),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Container(
                width: 80,
                height: 24,
                decoration: BoxDecoration(
                  color: provider.primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: provider.primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: provider.primaryColor,
                        borderRadius: BorderRadius.circular(_getBorderRadius()),
                      ),
                      child: const Center(child: Text('🎨', style: TextStyle(fontSize: 20))),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('主题预览', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                        Text('实时查看效果', style: TextStyle(fontSize: 10, color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 4,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  children: ['📱', '💬', '📷', '🎵', '⚙️', '📁', '🎮', '🌐']
                      .map((emoji) => Container(
                            decoration: BoxDecoration(
                              color: provider.primaryColor,
                              borderRadius: BorderRadius.circular(_getBorderRadius()),
                            ),
                            child: Center(child: Text(emoji, style: const TextStyle(fontSize: 18))),
                          ))
                      .toList(),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: ['🏠', '🔍', '📱', '👤']
                      .map((emoji) => Text(emoji, style: const TextStyle(fontSize: 20)))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 200.ms).slideX(begin: 0.1);
  }

  double _getBorderRadius() {
    switch (_selectedShape) {
      case 'circle':
        return 50;
      case 'square':
        return 0;
      case 'squircle':
        return 20;
      default:
        return _cornerRadius;
    }
  }

  Widget _buildPresetThemes(ThemeProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.auto_awesome, color: provider.accentColor, size: 20),
            const SizedBox(width: 8),
            const Text(
              '预设主题',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 2,
          ),
          itemCount: _presetThemes.length,
          itemBuilder: (context, index) {
            final theme = _presetThemes[index];
            
            return GestureDetector(
              onTap: () {
                provider.setPrimaryColor(theme['colors'][0]);
                provider.setAccentColor(theme['colors'][1]);
              },
              child: GlassCard(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Row(
                      children: (theme['colors'] as List<Color>).map((color) {
                        return Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black26),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        theme['name'],
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
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
}
