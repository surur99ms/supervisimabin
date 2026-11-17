import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/app_constants.dart';
import '../../config/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/supervisi_provider.dart';
import '../../providers/dashboard_provider.dart';

class SupervisorNilaiTab extends StatelessWidget {
  const SupervisorNilaiTab({super.key});

  Future<void> _handleWhatsAppShare(BuildContext context) async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final sup = Provider.of<SupervisiProvider>(context, listen: false);

    if (sup.selectedMadrasah == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih madrasah terlebih dahulu!')),
      );
      return;
    }

    final message = sup.generateWhatsAppMessage(auth.user!);
    final encoded = Uri.encodeComponent(message);
    final url = Uri.parse('https://wa.me/?text=$encoded');

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tidak dapat membuka WhatsApp.')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _handleSubmit(BuildContext context) async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final sup = Provider.of<SupervisiProvider>(context, listen: false);
    final dash = Provider.of<DashboardProvider>(context, listen: false);

    if (sup.selectedMadrasah == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih madrasah terlebih dahulu di tab Tugas!')),
      );
      return;
    }

    if (sup.scoredCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Belum ada poin supervisi yang dinilai!')),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Setor Nilai', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text(
          'Simpan dan setorkan hasil supervisi untuk "${sup.selectedMadrasah?.namaMadrasah}" ke server admin?',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF416C), foregroundColor: Colors.white),
            child: const Text('Ya, Simpan'),
          ),
        ],
      ),
    );

    if (confirm != true || !context.mounted) return;

    final result = await sup.submitSupervisi(auth.user!);

    if (!context.mounted) return;

    if (result['success'] == true) {
      // Refresh dashboard data
      await dash.fetchRekap();

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          icon: const Icon(Icons.check_circle, color: Colors.green, size: 50),
          title: const Text('Berhasil Disimpan!', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text(
            'Nilai supervisi untuk ${sup.selectedMadrasah?.namaMadrasah} berhasil disetorkan ke server pusat.',
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                sup.resetAssessment();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Gagal menyimpan supervisi!'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final sup = Provider.of<SupervisiProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rekap Nilai Supervisi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset Formulir',
            onPressed: () {
              sup.resetAssessment();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Formulir penilaian telah direset.')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Target Madrasah Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E222D) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.withOpacity(0.15)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Madrasah Target:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Text(
                        '${sup.scoredCount} / ${sup.totalItems} Poin',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF416C), fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    sup.selectedMadrasah?.namaMadrasah ?? 'Belum ada madrasah dipilih',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: sup.selectedMadrasah != null ? null : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMiniScore('Admin', sup.adminAverage),
                      _buildMiniScore('Pendataan', sup.pendataanAverage),
                      _buildMiniScore('KBM', sup.kbmAverage),
                      _buildMiniScore('Total', sup.finalScore, isPrimary: true),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Submit Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: sup.isLoading ? null : () => _handleSubmit(context),
                    icon: sup.isLoading
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Icon(Icons.cloud_upload_outlined, size: 18),
                    label: const Text('Setor ke Admin', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF416C),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _handleWhatsAppShare(context),
                    icon: const Icon(Icons.share, size: 18),
                    label: const Text('Kirim via WA', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF25D366),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 14 Points Summary
            const Text(
              'Rincian 14 Poin Penilaian',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            ...AppConstants.items.asMap().entries.map((entry) {
              final idx = entry.key;
              final item = entry.value;
              final score = sup.getScore(item.id);
              final note = sup.getNote(item.id);
              final color = AppTheme.getStatusColor(score);

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E222D) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.withOpacity(0.1)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.grey.withOpacity(0.15),
                      child: Text('${idx + 1}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          if (note != null && note.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text('Note: $note', style: TextStyle(fontSize: 10, color: Colors.grey.shade600, fontStyle: FontStyle.italic)),
                          ],
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        score ?? 'Belum',
                        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 10),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniScore(String label, double val, {bool isPrimary = false}) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 2),
        Text(
          val.toStringAsFixed(1),
          style: TextStyle(
            fontSize: isPrimary ? 16 : 13,
            fontWeight: FontWeight.bold,
            color: isPrimary ? const Color(0xFFFF416C) : null,
          ),
        ),
      ],
    );
  }
}

