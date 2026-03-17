import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/glass_card.dart';

class IconsScreen extends StatefulWidget {
  const IconsScreen({super.key});

  @override
  State<IconsScreen> createState() => _IconsScreenState();
}

class _IconsScreenState extends State<IconsScreen> {
  final ImagePicker _picker = ImagePicker();
  List<IconData> _selectedIcons = [];
  String _searchQuery = '';
  int _selectedImportMethod = 0;

  final List<Map<String, dynamic>> _iconPacks = [
    {'name': 'Material You', 'icon': Icons.palette, 'count': 256, 'color': const Color(0xFF667EEA)},
    {'name': 'Fluent Design', 'icon': Icons.widgets, 'count': 189, 'color': const Color(0xFF10B981)},
    {'name': 'iOS Style', 'icon': Icons.apple, 'count': 312, 'color': const Color(0xFF6366F1)},
    {'name': 'Neon Glow', 'icon': Icons.auto_awesome, 'count': 145, 'color': const Color(0xFFEC4899)},
    {'name': 'Minimalist', 'icon': Icons.crop_square, 'count': 198, 'color': const Color(0xFFF59E0B)},
    {'name': 'Gradient', 'icon': Icons.gradient, 'count': 223, 'color': const Color(0xFF8B5CF6)},
  ];

  final List<Map<String, dynamic>> _importMethods = [
    {'icon': Icons.folder_open, 'label': '文件导入', 'color': const Color(0xFF3B82F6)},
    {'icon': Icons.image, 'label': '图库选择', 'color': const Color(0xFF10B981)},
    {'icon': Icons.link, 'label': 'URL导入', 'color': const Color(0xFF8B5CF6)},
    {'icon': Icons.content_paste, 'label': '剪贴板', 'color': const Color(0xFFF59E0B)},
  ];

  Future<void> _pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    for (var image in images) {
      // 处理选中的图片
    }
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
              _buildImportMethods(provider),
              const SizedBox(height: 24),
              _buildIconPacks(provider),
              const SizedBox(height: 24),
              _buildUploadedIcons(provider),
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
          '图标美化',
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
          '自定义应用图标，打造独特桌面风格',
          style: TextStyle(color: Colors.grey[400], fontSize: 14),
        ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
        const SizedBox(height: 20),
        _buildSearchBar(),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: TextField(
        onChanged: (value) => setState(() => _searchQuery = value),
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: '搜索图标...',
          hintStyle: TextStyle(color: Colors.grey[500]),
          border: InputBorder.none,
          icon: Icon(Icons.search, color: Colors.grey[500]),
          suffixIcon: IconButton(
            icon: Icon(Icons.tune, color: Colors.grey[500]),
            onPressed: () {},
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 200.ms);
  }

  Widget _buildImportMethods(ThemeProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.upload_file, color: provider.primaryColor, size: 20),
            const SizedBox(width: 8),
            const Text(
              '多方式导入',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: List.generate(_importMethods.length, (index) {
            final method = _importMethods[index];
            final isSelected = _selectedImportMethod == index;
            
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() => _selectedImportMethod = index);
                  if (index == 0 || index == 1) {
                    _pickImages();
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: EdgeInsets.only(right: index < _importMethods.length - 1 ? 12 : 0),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(colors: [method['color'], method['color'].withOpacity(0.7)])
                        : null,
                    color: isSelected ? null : Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? Colors.transparent : Colors.white.withOpacity(0.1),
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        method['icon'],
                        color: isSelected ? Colors.white : Colors.white70,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        method['label'],
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? Colors.white : Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms, delay: 300.ms);
  }

  Widget _buildIconPacks(ThemeProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.auto_awesome, color: provider.accentColor, size: 20),
            const SizedBox(width: 8),
            const Text(
              '推荐图标包',
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
            childAspectRatio: 1.5,
          ),
          itemCount: _iconPacks.length,
          itemBuilder: (context, index) {
            final pack = _iconPacks[index];
            return GlassCard(
              padding: const EdgeInsets.all(16),
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [pack['color'], pack['color'].withOpacity(0.6)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(pack['icon'], color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                pack['name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                '${pack['count']} 个图标',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          '应用图标包',
                          style: TextStyle(fontSize: 12, color: Colors.white70),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
                .animate()
                .fadeIn(duration: 400.ms, delay: Duration(milliseconds: 400 + index * 50))
                .slideY(begin: 0.1);
          },
        ),
      ],
    );
  }

  Widget _buildUploadedIcons(ThemeProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.image, color: Colors.green[400], size: 20),
            const SizedBox(width: 8),
            const Text(
              '已导入图标',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            Text(
              '0 个图标',
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: _pickImages,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.02),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                style: BorderStyle.solid,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.cloud_upload_outlined,
                  size: 48,
                  color: Colors.grey[600],
                ),
                const SizedBox(height: 12),
                Text(
                  '拖拽图标文件到此处',
                  style: TextStyle(color: Colors.grey[400], fontSize: 14),
                ),
                Text(
                  '支持 PNG, JPG, SVG 格式',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
