import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_constants.dart';
import '../../config/app_theme.dart';
import '../../providers/supervisi_provider.dart';
import '../../widgets/custom_dialogs.dart';

class SupervisorTugasTab extends StatefulWidget {
  const SupervisorTugasTab({super.key});

  @override
  State<SupervisorTugasTab> createState() => _SupervisorTugasTabState();
}

class _SupervisorTugasTabState extends State<SupervisorTugasTab> {
  String? _selectedCategory; // null = Category Overview, or 'administrasi', 'pendataan', 'kbm'

  @override
  Widget build(BuildContext context) {
    final sup = Provider.of<SupervisiProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedCategory == null
              ? 'Pokok Supervisi'
              : _getCategoryTitle(_selectedCategory!),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        leading: _selectedCategory != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => setState(() => _selectedCategory = null),
              )
            : null,
      ),
      body: Column(
        children: [
          // Madrasah Selector Banner
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF4FACFE).withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF4FACFE).withOpacity(0.3)),
            ),
            child: InkWell(
              onTap: () => CustomDialogs.showSelectMadrasahDialog(context),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: const Color(0xFF4FACFE),
                    radius: 18,
                    child: const Icon(Icons.school, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Madrasah Yang Dinilai:',
                          style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          sup.selectedMadrasah?.namaMadrasah ?? 'Tekan untuk pilih madrasah...',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: sup.selectedMadrasah != null
                                ? (isDark ? Colors.white : Colors.black87)
                                : const Color(0xFFFF416C),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Color(0xFF4FACFE)),
                ],
              ),
            ),
          ),

          // Main Content
          Expanded(
            child: _selectedCategory == null
                ? _buildCategoryList(sup, isDark)
                : _buildSubItemsList(sup, _selectedCategory!, isDark),
          ),
        ],
      ),
    );
  }

  String _getCategoryTitle(String cat) {
    switch (cat) {
      case 'administrasi':
        return 'Manajemen & Administrasi';
      case 'pendataan':
        return 'Pendataan & Validasi Digital';
      case 'kbm':
        return 'KBM, Agenda & Laporan';
      default:
        return 'Supervisi';
    }
  }

  // LEVEL 1: Category Overview
  Widget _buildCategoryList(SupervisiProvider sup, bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildCategoryCard(
          title: '1. Manajemen & Administrasi',
          subtitle: '6 Poin Penilaian (Buku Tamu, Visi/Misi, RKM, RKAM, Struktur, Tupoksi)',
          gradient: AppTheme.categoryAdminGradient,
          icon: Icons.assignment_outlined,
          count: '6 Poin',
          onTap: () => setState(() => _selectedCategory = 'administrasi'),
        ),
        const SizedBox(height: 14),
        _buildCategoryCard(
          title: '2. Pendataan & Validasi Digital',
          subtitle: '4 Poin Penilaian (Data Lembaga, Murid, Guru, Sahabat Khidmah)',
          gradient: AppTheme.categoryPendataanGradient,
          icon: Icons.computer_outlined,
          count: '4 Poin',
          onTap: () => setState(() => _selectedCategory = 'pendataan'),
        ),
        const SizedBox(height: 14),
        _buildCategoryCard(
          title: '3. KBM, Agenda & Laporan',
          subtitle: '4 Poin Penilaian (KBM Harian, Agenda Kegiatan, Keuangan, Laporan)',
          gradient: AppTheme.categoryKbmGradient,
          icon: Icons.menu_book_outlined,
          count: '4 Poin',
          onTap: () => setState(() => _selectedCategory = 'kbm'),
        ),
        const SizedBox(height: 24),

        // Mini session progress
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E222D) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.withOpacity(0.12)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Progres Penilaian Saat Ini:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  Text(
                    '${sup.scoredCount} / ${sup.totalItems} Terisi',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF416C), fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: sup.scoredCount / sup.totalItems,
                  minHeight: 8,
                  backgroundColor: Colors.grey.withOpacity(0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFF416C)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard({
    required String title,
    required String subtitle,
    required LinearGradient gradient,
    required IconData icon,
    required String count,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.white.withOpacity(0.2),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
          ],
        ),
      ),
    );
  }

  // LEVEL 2: Sub-items List
  Widget _buildSubItemsList(SupervisiProvider sup, String category, bool isDark) {
    final subItems = AppConstants.items.where((i) => i.category == category).toList();

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: subItems.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (ctx, index) {
        final item = subItems[index];
        final currentScore = sup.getScore(item.id);
        final currentNote = sup.getNote(item.id);
        final scoreColor = AppTheme.getStatusColor(currentScore);

        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E222D) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: currentScore != null ? scoreColor.withOpacity(0.6) : Colors.grey.withOpacity(0.15),
              width: currentScore != null ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                if (sup.selectedMadrasah == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Pilih madrasah terlebih dahulu di bagian atas!')),
                  );
                  CustomDialogs.showSelectMadrasahDialog(context);
                  return;
                }

                CustomDialogs.showScoringDialog(
                  context: context,
                  item: item,
                  currentStatus: currentScore,
                  currentNote: currentNote,
                  onSave: (status, note) {
                    sup.setScore(item.id, status, note: note);
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: Colors.grey.withOpacity(0.15),
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item.description,
                                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: scoreColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: scoreColor, width: 1),
                          ),
                          child: Text(
                            currentScore ?? 'Nilai Sekarang',
                            style: TextStyle(
                              color: scoreColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (currentNote != null && currentNote.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(8),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Catatan: $currentNote',
                          style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Colors.grey.shade700),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

