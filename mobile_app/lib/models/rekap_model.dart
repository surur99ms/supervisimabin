import 'dart:convert';
import '../config/app_constants.dart';

class RekapModel {
  final int id;
  final String madrasahNama;
  final int supervisorId;
  final String supervisorNama;
  final Map<String, String> nilai;
  final Map<String, String> catatan;
  final String waktu;
  final String periode;

  RekapModel({
    required this.id,
    required this.madrasahNama,
    required this.supervisorId,
    required this.supervisorNama,
    required this.nilai,
    required this.catatan,
    required this.waktu,
    required this.periode,
  });

  factory RekapModel.fromJson(Map<String, dynamic> json) {
    Map<String, String> parseMap(dynamic value) {
      if (value == null) return {};
      if (value is Map) {
        return value.map((k, v) => MapEntry(k.toString(), v?.toString() ?? ''));
      }
      if (value is String) {
        try {
          final decoded = jsonDecode(value);
          if (decoded is Map) {
            return decoded.map((k, v) => MapEntry(k.toString(), v?.toString() ?? ''));
          }
        } catch (_) {}
      }
      return {};
    }

    return RekapModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      madrasahNama: json['madrasah_nama'] ?? '',
      supervisorId: json['supervisor_id'] is int
          ? json['supervisor_id']
          : int.tryParse(json['supervisor_id'].toString()) ?? 0,
      supervisorNama: json['supervisor_nama'] ?? '',
      nilai: parseMap(json['nilai']),
      catatan: parseMap(json['catatan']),
      waktu: json['waktu'] ?? '',
      periode: json['periode'] ?? '',
    );
  }

  // Calculate averages per category
  double get adminAverage {
    const ids = ['adm_1', 'adm_2', 'adm_3', 'adm_4', 'adm_5', 'adm_6'];
    int total = 0;
    for (var id in ids) {
      total += AppConstants.getScoreValue(nilai[id]);
    }
    return total / ids.length;
  }

  double get pendataanAverage {
    const ids = ['kur_1', 'kur_2', 'kur_3', 'kur_4'];
    int total = 0;
    for (var id in ids) {
      total += AppConstants.getScoreValue(nilai[id]);
    }
    return total / ids.length;
  }

  double get kbmAverage {
    const ids = ['loy_1', 'loy_2', 'loy_3', 'loy_4'];
    int total = 0;
    for (var id in ids) {
      total += AppConstants.getScoreValue(nilai[id]);
    }
    return total / ids.length;
  }

  double get finalScore {
    return (adminAverage + pendataanAverage + kbmAverage) / 3.0;
  }
}

