import 'package:flutter/material.dart';
import '../config/app_constants.dart';
import '../models/madrasah_model.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class SupervisiProvider with ChangeNotifier {
  List<MadrasahModel> _madrasahList = [];
  MadrasahModel? _selectedMadrasah;
  String _activePeriod = AppConstants.defaultPeriod;
  bool _isLoading = false;

  // In-memory current assessment scores & notes
  final Map<String, String> _nilai = {};
  final Map<String, String> _catatan = {};

  List<MadrasahModel> get madrasahList => _madrasahList;
  MadrasahModel? get selectedMadrasah => _selectedMadrasah;
  String get activePeriod => _activePeriod;
  bool get isLoading => _isLoading;
  Map<String, String> get nilai => _nilai;
  Map<String, String> get catatan => _catatan;

  // Scored count
  int get scoredCount => _nilai.values.where((v) => v.isNotEmpty && v != 'Belum Dinilai').length;
  int get totalItems => AppConstants.items.length; // 14

  Future<void> init() async {
    _activePeriod = await StorageService.getActivePeriod();
    await fetchMadrasah();
  }

  Future<void> fetchMadrasah() async {
    _isLoading = true;
    notifyListeners();
    _madrasahList = await ApiService.getMadrasah();
    _isLoading = false;
    notifyListeners();
  }

  void selectMadrasah(MadrasahModel madrasah) {
    _selectedMadrasah = madrasah;
    notifyListeners();
  }

  Future<void> setPeriod(String period) async {
    _activePeriod = period;
    await StorageService.saveActivePeriod(period);
    notifyListeners();
  }

  void setScore(String itemId, String status, {String? note}) {
    if (status == 'Belum Dinilai' || status.isEmpty) {
      _nilai.remove(itemId);
    } else {
      _nilai[itemId] = status;
    }

    if (note != null) {
      if (note.trim().isEmpty) {
        _catatan.remove(itemId);
      } else {
        _catatan[itemId] = note.trim();
      }
    }
    notifyListeners();
  }

  String? getScore(String itemId) => _nilai[itemId];
  String? getNote(String itemId) => _catatan[itemId];

  void resetAssessment() {
    _nilai.clear;
    _catatan.clear();
    _selectedMadrasah = null;
    notifyListeners();
  }

  // Current session category averages
  double get adminAverage {
    const ids = ['adm_1', 'adm_2', 'adm_3', 'adm_4', 'adm_5', 'adm_6'];
    int total = 0;
    for (var id in ids) {
      total += AppConstants.getScoreValue(_nilai[id]);
    }
    return total / ids.length;
  }

  double get pendataanAverage {
    const ids = ['kur_1', 'kur_2', 'kur_3', 'kur_4'];
    int total = 0;
    for (var id in ids) {
      total += AppConstants.getScoreValue(_nilai[id]);
    }
    return total / ids.length;
  }

  double get kbmAverage {
    const ids = ['loy_1', 'loy_2', 'loy_3', 'loy_4'];
    int total = 0;
    for (var id in ids) {
      total += AppConstants.getScoreValue(_nilai[id]);
    }
    return total / ids.length;
  }

  double get finalScore {
    return (adminAverage + pendataanAverage + kbmAverage) / 3.0;
  }

  // Submit to API
  Future<Map<String, dynamic>> submitSupervisi(UserModel user) async {
    if (_selectedMadrasah == null) {
      return {'success': false, 'message': 'Pilih madrasah terlebih dahulu!'};
    }
    if (scoredCount == 0) {
      return {'success': false, 'message': 'Belum ada poin yang dinilai!'};
    }

    _isLoading = true;
    notifyListeners();

    final result = await ApiService.submitSupervisi(
      madrasahNama: _selectedMadrasah!.namaMadrasah,
      supervisorNama: user.name,
      supervisorId: user.id ?? 0,
      periode: _activePeriod,
      nilai: _nilai,
      catatan: _catatan,
    );

    _isLoading = false;
    notifyListeners();
    return result;
  }

  // Format WhatsApp Message
  String generateWhatsAppMessage(UserModel user) {
    final sb = StringBuffer();
    sb.writeln('*LAPORAN SUPERVISI MABIN IASS*');
    sb.writeln('==============================');
    sb.writeln('🏫 *Madrasah:* ${_selectedMadrasah?.namaMadrasah ?? "-"}');
    sb.writeln('📍 *Wilayah:* ${_selectedMadrasah?.wilayah ?? "-"}');
    sb.writeln('👤 *Supervisor:* ${user.name}');
    sb.writeln('📅 *Periode:* $_activePeriod');
    sb.writeln('⭐ *Skor Total:* ${finalScore.toStringAsFixed(1)} / 100');
    sb.writeln('------------------------------');
    sb.writeln('📊 *Rincian Nilai:*');
    sb.writeln('• Administrasi: ${adminAverage.toStringAsFixed(1)}');
    sb.writeln('• Pendataan: ${pendataanAverage.toStringAsFixed(1)}');
    sb.writeln('• KBM & Laporan: ${kbmAverage.toStringAsFixed(1)}');
    sb.writeln('------------------------------');
    sb.writeln('📝 *Catatan Khusus:*');
    
    bool hasNotes = false;
    for (var item in AppConstants.items) {
      final note = _catatan[item.id];
      if (note != null && note.isNotEmpty) {
        sb.writeln('• ${item.title}: $note');
        hasNotes = true;
      }
    }
    if (!hasNotes) {
      sb.writeln('Tidak ada catatan khusus.');
    }
    sb.writeln('==============================');
    sb.writeln('_Laporan dikirim otomatis dari Supervisi Mabin App_');
    return sb.toString();
  }
}

