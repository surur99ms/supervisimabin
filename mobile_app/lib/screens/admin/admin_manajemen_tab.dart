import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/supervisor_model.dart';
import '../../providers/supervisi_provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../services/api_service.dart';
import '../../widgets/custom_dialogs.dart';

class AdminManajemenTab extends StatefulWidget {
  const AdminManajemenTab({super.key});

  @override
  State<AdminManajemenTab> createState() => _AdminManajemenTabState();
}

class _AdminManajemenTabState extends State<AdminManajemenTab> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  List<SupervisorModel> _supervisors = [];
  bool _isLoadingSupervisors = false;

  @override
  void initState() {
    super.initState();
    _loadSupervisors();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadSupervisors() async {
    setState(() => _isLoadingSupervisors = true);
    _supervisors = await ApiService.getSupervisors();
    if (mounted) setState(() => _isLoadingSupervisors = false);
  }

  Future<void> _handleDeleteData(String jenis, String title) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Hapus $title?', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent)),
        content: Text(
          'PERINGATAN: Tindakan ini akan mengosongkan tabel $title secara permanen dari database!',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
            child: const Text('Hapus Permanen'),
          ),
        ],
      ),
    );

    if (confirm != true || !mounted) return;

    final res = await ApiService.deleteData(jenis);
    if (!mounted) return;

    if (res['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$title berhasil dihapus.')),
      );
      if (mounted) {
        await Provider.of<DashboardProvider>(context, listen: false).fetchRekap();
        await Provider.of<SupervisiProvider>(context, listen: false).fetchMadrasah();
        await _loadSupervisors();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res['message'] ?? 'Gagal menghapus data'), backgroundColor: Colors.redAccent),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final sup = Provider.of<SupervisiProvider>(context);
    final dash = Provider.of<DashboardProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final records = dash.getRekapForPeriod(sup.activePeriod).where((r) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return r.madrasahNama.toLowerCase().contains(q) ||
          r.supervisorNama.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Data', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_outlined),
            tooltip: 'Tambah Supervisor',
            onPressed: () => CustomDialogs.showAddSupervisorDialog(context, _loadSupervisors),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Action card: Tambah supervisor
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: const Icon(Icons.person_add, color: Colors.white),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Kelola Supervisor', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                        Text('Daftarkan akun supervisor baru', style: TextStyle(color: Colors.white70, fontSize: 11)),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => CustomDialogs.showAddSupervisorDialog(context, _loadSupervisors),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF0072FF),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    ),
                    child: const Text('Tambah', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Supervisor List Section (Collapsible)
            ExpansionTile(
              title: Text(
                'Daftar Supervisor Aktif (${_supervisors.length})',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              leading: const Icon(Icons.people_outline, color: Color(0xFF0072FF)),
              children: [
                if (_isLoadingSupervisors)
                  const Padding(padding: EdgeInsets.all(16), child: Center(child: CircularProgressIndicator()))
                else if (_supervisors.isEmpty)
                  const Padding(padding: EdgeInsets.all(16), child: Center(child: Text('Belum ada data supervisor', style: TextStyle(fontSize: 12))))
                else
                  ..._supervisors.map((spv) {
                    return ListTile(
                      dense: true,
                      leading: CircleAvatar(
                        radius: 16,
                        backgroundColor: const Color(0xFF0072FF).withOpacity(0.1),
                        child: Text(
                          spv.namaSupervisor.isNotEmpty ? spv.namaSupervisor[0] : 'S',
                          style: const TextStyle(color: Color(0xFF0072FF), fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                      title: Text(spv.namaSupervisor, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                      subtitle: Text('${spv.username} • Wilayah: ${spv.wilayahTugas}', style: const TextStyle(fontSize: 10)),
                    );
                  }),
              ],
            ),
            const Divider(height: 32),

            // Hasil Supervisi Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Hasil Supervisi Masuk', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text('${records.length} Data', style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 10),

            // Search Bar
            TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Cari madrasah atau supervisor...',
                prefixIcon: const Icon(Icons.search, size: 20),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: isDark ? const Color(0xFF1E222D) : Colors.white,
              ),
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 12),

            // List of submissions
            if (records.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E222D) : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                  child: Text('Tidak ada hasil supervisi yang cocok', style: TextStyle(fontSize: 12, color: Colors.grey)),
                ),
              )
            else
              ...records.map((r) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E222D) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.withOpacity(0.12)),
                  ),
                  child: InkWell(
                    onTap: () => CustomDialogs.showRekapDetailDialog(context, r),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: const Color(0xFF4FACFE).withOpacity(0.15),
                          child: const Icon(Icons.school, color: Color(0xFF4FACFE), size: 18),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(r.madrasahNama, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                              const SizedBox(height: 2),
                              Text(
                                '${r.supervisorNama} • ${r.waktu}',
                                style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4FACFE).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            r.finalScore.toStringAsFixed(1),
                            style: const TextStyle(color: Color(0xFF0072FF), fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),

            const Divider(height: 36),

            // Danger Zone: Hapus Data
            const Text(
              'Manajemen Hapus Data (Zona Berbahaya)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.redAccent),
            ),
            const SizedBox(height: 10),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: () => _handleDeleteData('hasil', 'Hasil Supervisi'),
                  icon: const Icon(Icons.delete_outline, size: 16, color: Colors.redAccent),
                  label: const Text('Hapus Hasil Supervisi', style: TextStyle(fontSize: 11, color: Colors.redAccent)),
                  style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.redAccent)),
                ),
                OutlinedButton.icon(
                  onPressed: () => _handleDeleteData('madrasah', 'Data Madrasah'),
                  icon: const Icon(Icons.delete_outline, size: 16, color: Colors.redAccent),
                  label: const Text('Hapus Data Madrasah', style: TextStyle(fontSize: 11, color: Colors.redAccent)),
                  style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.redAccent)),
                ),
                OutlinedButton.icon(
                  onPressed: () => _handleDeleteData('supervisor', 'Data Supervisor'),
                  icon: const Icon(Icons.delete_outline, size: 16, color: Colors.redAccent),
                  label: const Text('Hapus Data Supervisor', style: TextStyle(fontSize: 11, color: Colors.redAccent)),
                  style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.redAccent)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
