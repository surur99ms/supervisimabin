import 'package:flutter/material.dart';
import '../models/rekap_model.dart';
import '../models/madrasah_model.dart';
import '../services/api_service.dart';

class DashboardProvider with ChangeNotifier {
  List<RekapModel> _allRekap = [];
  bool _isLoading = false;

  List<RekapModel> get allRekap => _allRekap;
  bool get isLoading => _isLoading;

  Future<void> fetchRekap() async {
    _isLoading = true;
    notifyListeners();
    _allRekap = await ApiService.getRekap();
    _isLoading = false;
    notifyListeners();
  }

  // Filter records by period
  List<RekapModel> getRekapForPeriod(String period) {
    return _allRekap.where((r) => r.periode == period).toList();
  }

  // Deduplicate: latest entry per madrasah for the active period
  List<RekapModel> getLatestUniqueRekap(String period) {
    final periodRecords = getRekapForPeriod(period);
    final Map<String, RekapModel> uniqueMap = {};
    for (var r in periodRecords) {
      if (!uniqueMap.containsKey(r.madrasahNama)) {
        uniqueMap[r.madrasahNama] = r;
      }
    }
    return uniqueMap.values.toList();
  }

  // Ranked list (sorted descending by finalScore)
  List<RekapModel> getRankedList(String period) {
    final list = getLatestUniqueRekap(period);
    list.sort((a, b) => b.finalScore.compareTo(a.finalScore));
    return list;
  }

  // Top 3 ranking
  List<RekapModel> getTop3(String period) {
    final list = getRankedList(period);
    return list.take(3).toList();
  }

  // Category averages across all supervised schools in active period
  double getAverageAdministrasi(String period) {
    final list = getLatestUniqueRekap(period);
    if (list.isEmpty) return 0.0;
    final sum = list.fold<double>(0.0, (acc, r) => acc + r.adminAverage);
    return sum / list.length;
  }

  double getAveragePendataan(String period) {
    final list = getLatestUniqueRekap(period);
    if (list.isEmpty) return 0.0;
    final sum = list.fold<double>(0.0, (acc, r) => acc + r.pendataanAverage);
    return sum / list.length;
  }

  double getAverageKbm(String period) {
    final list = getLatestUniqueRekap(period);
    if (list.isEmpty) return 0.0;
    final sum = list.fold<double>(0.0, (acc, r) => acc + r.kbmAverage);
    return sum / list.length;
  }

  double getOverallAverage(String period) {
    final adm = getAverageAdministrasi(period);
    final pen = getAveragePendataan(period);
    final kbm = getAverageKbm(period);
    return (adm + pen + kbm) / 3.0;
  }

  // Regional statistics
  Map<String, WilayahStat> getWilayahStats(String period, List<MadrasahModel> allMadrasah) {
    final supervisedNames = getLatestUniqueRekap(period).map((r) => r.madrasahNama).toSet();
    final Map<String, WilayahStat> stats = {};

    for (var m in allMadrasah) {
      final w = m.wilayah.isEmpty ? 'LAINNYA' : m.wilayah.toUpperCase();
      stats.putIfAbsent(w, () => WilayahStat(wilayah: w));
      stats[w]!.total++;
      if (supervisedNames.contains(m.namaMadrasah)) {
        stats[w]!.sudah++;
      }
    }
    return stats;
  }
}

class WilayahStat {
  final String wilayah;
  int total = 0;
  int sudah = 0;

  WilayahStat({required this.wilayah});

  int get belum => total - sudah;
  double get percentage => total > 0 ? (sudah / total) * 100 : 0.0;
}

