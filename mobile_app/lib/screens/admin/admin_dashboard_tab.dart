import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/supervisi_provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../widgets/custom_dialogs.dart';

class AdminDashboardTab extends StatelessWidget {
  const AdminDashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final sup = Provider.of<SupervisiProvider>(context);
    final dash = Provider.of<DashboardProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final period = sup.activePeriod;
    final top3 = dash.getTop3(period);
    final admAvg = dash.getAverageAdministrasi(period);
    final penAvg = dash.getAveragePendataan(period);
    final kbmAvg = dash.getAverageKbm(period);
    final totalAvg = dash.getOverallAverage(period);
    final wilayahStats = dash.getWilayahStats(period, sup.madrasahList);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text('Selamat Datang!', style: TextStyle(fontSize: 12, color: Colors.grey)),
            Text(
              auth.user?.name ?? 'Admin Pusat',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ActionChip(
              avatar: const Icon(Icons.calendar_month, size: 14, color: Color(0xFF4FACFE)),
              label: Text(period, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              backgroundColor: const Color(0xFF4FACFE).withOpacity(0.1),
              side: BorderSide.none,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              onPressed: () => CustomDialogs.showPeriodDialog(context),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await sup.fetchMadrasah();
          await dash.fetchRekap();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Admin Banner
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppTheme.adminGradient,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4FACFE).withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Dashboard Rekapitulasi',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Standar Penilaian:\nBaik = 100 • Sedang = 75 • Buruk = 50',
                            style: TextStyle(color: Colors.white70, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.analytics_outlined, color: Colors.white, size: 48),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Top 3 Ranking
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Top 3 Madrasah',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () => CustomDialogs.showRankingDialog(context, period),
                    child: const Text('Lihat Semua >', style: TextStyle(fontSize: 12, color: Color(0xFF4FACFE))),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              if (top3.isEmpty)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E222D) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text('Belum ada data supervisi pada periode ini', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ),
                )
              else
                Row(
                  children: top3.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final r = entry.value;
                    Color rankColor = const Color(0xFFFFD700);
                    if (idx == 1) rankColor = const Color(0xFFC0C0C0);
                    if (idx == 2) rankColor = const Color(0xFFCD7F32);

                    return Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: idx < top3.length - 1 ? 8 : 0),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E222D) : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: rankColor.withOpacity(0.5), width: 1.5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('#${idx + 1}', style: TextStyle(color: rankColor, fontWeight: FontWeight.bold, fontSize: 14)),
                                Text(
                                  r.finalScore.toStringAsFixed(1),
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0072FF), fontSize: 13),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              r.madrasahNama,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              const SizedBox(height: 24),

              // Rata-rata Per Kategori
              const Text(
                'Rata-rata Skor Kategori',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E222D) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _buildAverageBar('1. Manajemen & Administrasi', admAvg, const Color(0xFF8E2DE2)),
                    const SizedBox(height: 12),
                    _buildAverageBar('2. Pendataan & Validasi Digital', penAvg, const Color(0xFF0072FF)),
                    const SizedBox(height: 12),
                    _buildAverageBar('3. KBM, Agenda & Laporan', kbmAvg, const Color(0xFFF7971E)),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Rata-rata Keseluruhan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        Text(
                          '${totalAvg.toStringAsFixed(1)} / 100',
                          style: const TextStyle(
                            color: Color(0xFF0072FF),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Statistik Wilayah
              const Text(
                'Statistik Wilayah & Progres',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...wilayahStats.values.map((stat) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E222D) : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.withOpacity(0.1)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(stat.wilayah, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          Text(
                            '${stat.sudah}/${stat.total} (${stat.percentage.toStringAsFixed(0)}%)',
                            style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: stat.total > 0 ? stat.sudah / stat.total : 0.0,
                          minHeight: 8,
                          backgroundColor: Colors.grey.withOpacity(0.2),
                          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4FACFE)),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAverageBar(String label, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
            Text(value.toStringAsFixed(1), style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: (value / 100.0).clamp(0.0, 1.0),
            minHeight: 6,
            backgroundColor: Colors.grey.withOpacity(0.15),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
