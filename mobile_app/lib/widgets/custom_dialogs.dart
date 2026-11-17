import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_constants.dart';
import '../config/app_theme.dart';
import '../models/madrasah_model.dart';
import '../models/rekap_model.dart';
import '../providers/supervisi_provider.dart';
import '../providers/dashboard_provider.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class CustomDialogs {
  // 1. DIALOG PENILAIAN (Scoring modal)
  static Future<void> showScoringDialog({
    required BuildContext context,
    required SupervisiItemDef item,
    required String? currentStatus,
    required String? currentNote,
    required Function(String status, String note) onSave,
  }) async {
    String selectedStatus = currentStatus ?? '';
    final noteController = TextEditingController(text: currentNote ?? '');

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
                top: 20,
                left: 20,
                right: 20,
              ),
              decoration: BoxDecoration(
                color: Theme.of(ctx).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    item.title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.description,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Pilih Penilaian:',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _buildOption(
                        label: 'Baik (100)',
                        color: AppTheme.colorBaik,
                        isSelected: selectedStatus == 'Baik',
                        onTap: () => setState(() => selectedStatus = 'Baik'),
                      ),
                      const SizedBox(width: 8),
                      _buildOption(
                        label: 'Sedang (75)',
                        color: AppTheme.colorSedang,
                        isSelected: selectedStatus == 'Sedang',
                        onTap: () => setState(() => selectedStatus = 'Sedang'),
                      ),
                      const SizedBox(width: 8),
                      _buildOption(
                        label: 'Buruk (50)',
                        color: AppTheme.colorBuruk,
                        isSelected: selectedStatus == 'Buruk',
                        onTap: () => setState(() => selectedStatus = 'Buruk'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () => setState(() => selectedStatus = 'Belum Dinilai'),
                      icon: const Icon(Icons.refresh, size: 16, color: Colors.grey),
                      label: const Text('Reset Penilaian', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: noteController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Catatan Supervisi (Opsional)',
                      hintText: 'Tuliskan temuan atau saran perbaikan...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Theme.of(ctx).cardColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      onSave(selectedStatus, noteController.text);
                      Navigator.pop(ctx);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF416C),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Simpan Penilaian', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  static Widget _buildOption({
    required String label,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? color : color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : color,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 2. DIALOG PILIH MADRASAH
  static Future<void> showSelectMadrasahDialog(BuildContext context) async {
    final provider = Provider.of<SupervisiProvider>(context, listen: false);
    final searchController = TextEditingController();
    List<MadrasahModel> filtered = List.from(provider.madrasahList);

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            void filter(String query) {
              final q = query.toLowerCase();
              setState(() {
                filtered = provider.madrasahList.where((m) {
                  return m.namaMadrasah.toLowerCase().contains(q) ||
                      m.wilayah.toLowerCase().contains(q);
                }).toList();
              });
            }

            return Container(
              height: MediaQuery.of(ctx).size.height * 0.75,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(ctx).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Pilih Madrasah Binaan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: searchController,
                    onChanged: filter,
                    decoration: InputDecoration(
                      hintText: 'Cari nama madrasah atau wilayah...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: filtered.isEmpty
                        ? const Center(child: Text('Madrasah tidak ditemukan'))
                        : ListView.separated(
                            itemCount: filtered.length,
                            separatorBuilder: (_, __) => const Divider(height: 1),
                            itemBuilder: (ctx, i) {
                              final item = filtered[i];
                              final isSelected = provider.selectedMadrasah?.id == item.id;
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: const Color(0xFF4FACFE).withOpacity(0.15),
                                  child: const Icon(Icons.school, color: Color(0xFF4FACFE)),
                                ),
                                title: Text(item.namaMadrasah, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                                subtitle: Text(item.wilayah, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                                trailing: isSelected
                                    ? const Icon(Icons.check_circle, color: Color(0xFFFF416C))
                                    : null,
                                onTap: () {
                                  provider.selectMadrasah(item);
                                  Navigator.pop(ctx);
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // 3. DIALOG GANTI PERIODE
  static Future<void> showPeriodDialog(BuildContext context) async {
    final provider = Provider.of<SupervisiProvider>(context, listen: false);

    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Pilih Periode Supervisi', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: AppConstants.periods.map((p) {
              final isSelected = provider.activePeriod == p;
              return RadioListTile<String>(
                value: p,
                groupValue: provider.activePeriod,
                title: Text(p, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                activeColor: const Color(0xFFFF416C),
                onChanged: (val) {
                  if (val != null) {
                    provider.setPeriod(val);
                    Navigator.pop(ctx);
                  }
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  // 4. DIALOG RANKING LENGKAP
  static Future<void> showRankingDialog(BuildContext context, String period) async {
    final dash = Provider.of<DashboardProvider>(context, listen: false);
    final ranked = dash.getRankedList(period);

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(ctx).size.height * 0.8,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(ctx).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Peringkat Madrasah ($period)',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'Berdasarkan nilai rata-rata supervisi terbaru',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ranked.isEmpty
                    ? const Center(child: Text('Belum ada data supervisi pada periode ini'))
                    : ListView.separated(
                        itemCount: ranked.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (ctx, i) {
                          final item = ranked[i];
                          final rank = i + 1;
                          Color rankColor = Colors.grey.shade700;
                          if (rank == 1) rankColor = const Color(0xFFFFD700); // Gold
                          if (rank == 2) rankColor = const Color(0xFFC0C0C0); // Silver
                          if (rank == 3) rankColor = const Color(0xFFCD7F32); // Bronze

                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: rankColor.withOpacity(0.2),
                              child: Text(
                                '#$rank',
                                style: TextStyle(
                                  color: rankColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            title: Text(item.madrasahNama, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                            subtitle: Text('Supervisor: ${item.supervisorNama}'),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF416C).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                item.finalScore.toStringAsFixed(1),
                                style: const TextStyle(
                                  color: Color(0xFFFF416C),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            onTap: () => showRekapDetailDialog(context, item),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 5. DIALOG DETAIL REKAP ITEM (14 points view)
  static Future<void> showRekapDetailDialog(BuildContext context, RekapModel rekap) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(ctx).size.height * 0.85,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(ctx).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                rekap.madrasahNama,
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              Text(
                'Supervisor: ${rekap.supervisorNama} • ${rekap.periode}',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _scoreBadge('Admin', rekap.adminAverage),
                  _scoreBadge('Pendataan', rekap.pendataanAverage),
                  _scoreBadge('KBM', rekap.kbmAverage),
                  _scoreBadge('Total', rekap.finalScore, isTotal: true),
                ],
              ),
              const Divider(height: 24),
              Expanded(
                child: ListView.separated(
                  itemCount: AppConstants.items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (ctx, i) {
                    final def = AppConstants.items[i];
                    final status = rekap.nilai[def.id] ?? 'Belum Dinilai';
                    final note = rekap.catatan[def.id];
                    final color = AppTheme.getStatusColor(status);

                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(ctx).cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.withOpacity(0.15)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  '${i + 1}. ${def.title}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  status,
                                  style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11),
                                ),
                              ),
                            ],
                          ),
                          if (note != null && note.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Text(
                              'Catatan: $note',
                              style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Colors.grey.shade700),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget _scoreBadge(String label, double score, {bool isTotal = false}) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 2),
        Text(
          score.toStringAsFixed(1),
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: FontWeight.bold,
            color: isTotal ? const Color(0xFFFF416C) : Colors.blueGrey,
          ),
        ),
      ],
    );
  }

  // 6. DIALOG PENGATURAN API SERVER
  static Future<void> showApiSettingsDialog(BuildContext context) async {
    final currentUrl = await StorageService.getApiUrl();
    final urlController = TextEditingController(text: currentUrl);

    if (!context.mounted) return;
    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Pengaturan API Server', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Pilih atau masukkan alamat URL backend api.php:',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: urlController,
                decoration: InputDecoration(
                  labelText: 'API URL',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  ActionChip(
                    label: const Text('Local (PC Wi-Fi)', style: TextStyle(fontSize: 11)),
                    onPressed: () => urlController.text = AppConstants.defaultLocalUrl,
                  ),
                  ActionChip(
                    label: const Text('Emulator (10.0.2.2)', style: TextStyle(fontSize: 11)),
                    onPressed: () => urlController.text = AppConstants.defaultEmulatorUrl,
                  ),
                  ActionChip(
                    label: const Text('Production', style: TextStyle(fontSize: 11)),
                    onPressed: () => urlController.text = AppConstants.defaultProductionUrl,
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                final url = urlController.text.trim();
                if (url.isNotEmpty) {
                  await StorageService.saveApiUrl(url);
                  if (ctx.mounted) {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('API URL disimpan: $url')),
                    );
                  }
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  // 7. DIALOG TAMBAH SUPERVISOR (Admin)
  static Future<void> showAddSupervisorDialog(BuildContext context, VoidCallback onSuccess) async {
    final userCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    final nameCtrl = TextEditingController();
    final wilCtrl = TextEditingController();
    bool isSaving = false;

    await showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            return AlertDialog(
              title: const Text('Tambah Supervisor', style: TextStyle(fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: userCtrl,
                      decoration: const InputDecoration(labelText: 'Username'),
                    ),
                    TextField(
                      controller: passCtrl,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Password'),
                    ),
                    TextField(
                      controller: nameCtrl,
                      decoration: const InputDecoration(labelText: 'Nama Lengkap'),
                    ),
                    TextField(
                      controller: wilCtrl,
                      decoration: const InputDecoration(labelText: 'Wilayah Tugas (misal: SURABAYA)'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: isSaving
                      ? null
                      : () async {
                          if (userCtrl.text.isEmpty ||
                              passCtrl.text.isEmpty ||
                              nameCtrl.text.isEmpty ||
                              wilCtrl.text.isEmpty) {
                            ScaffoldMessenger.of(ctx).showSnackBar(
                              const SnackBar(content: Text('Harap isi semua kolom!')),
                            );
                            return;
                          }

                          setState(() => isSaving = true);
                          final res = await ApiService.addSupervisor(
                            username: userCtrl.text.trim(),
                            password: passCtrl.text.trim(),
                            namaSupervisor: nameCtrl.text.trim(),
                            wilayahTugas: wilCtrl.text.trim().toUpperCase(),
                          );
                          setState(() => isSaving = false);

                          if (res['success'] == true) {
                            if (ctx.mounted) {
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Supervisor berhasil ditambahkan!')),
                              );
                              onSuccess();
                            }
                          } else {
                            if (ctx.mounted) {
                              ScaffoldMessenger.of(ctx).showSnackBar(
                                SnackBar(content: Text(res['message'] ?? 'Gagal menambahkan supervisor')),
                              );
                            }
                          }
                        },
                  child: isSaving
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

