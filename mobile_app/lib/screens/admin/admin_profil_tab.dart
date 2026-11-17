import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/app_constants.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_dialogs.dart';
import '../login_screen.dart';

class AdminProfilTab extends StatelessWidget {
  const AdminProfilTab({super.key});

  Future<void> _contactDeveloper(BuildContext context) async {
    final url = Uri.parse('https://wa.me/${AppConstants.developerWhatsApp}?text=Halo%20Developer%20Supervisi%20Mabin%20IASS');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
  }

  Future<void> _handleLogout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Keluar', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Apakah Anda yakin ingin keluar dari akun Admin?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      await Provider.of<AuthProvider>(context, listen: false).logout();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Administrator', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Admin Profile Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E222D) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: const Color(0xFF4FACFE).withOpacity(0.18),
                  child: const Text(
                    'AP',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0072FF)),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Admin Pusat',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0072FF).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Administrator Sistem UPT',
                    style: TextStyle(fontSize: 11, color: Color(0xFF0072FF), fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Menu Section
          const Text('Pengaturan & Informasi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 10),

          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E222D) : Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.dark_mode_outlined),
                  title: const Text('Mode Gelap (Dark Mode)', style: TextStyle(fontSize: 13)),
                  value: auth.isDarkMode,
                  onChanged: (val) => auth.toggleDarkMode(),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.dns_outlined),
                  title: const Text('Pengaturan Server API', style: TextStyle(fontSize: 13)),
                  subtitle: const Text('Ganti alamat backend Laragon atau Production', style: TextStyle(fontSize: 11)),
                  trailing: const Icon(Icons.chevron_right, size: 20),
                  onTap: () => CustomDialogs.showApiSettingsDialog(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.support_agent_outlined),
                  title: const Text('Hubungi Tim Developer', style: TextStyle(fontSize: 13)),
                  subtitle: const Text('WhatsApp: 085606373627', style: TextStyle(fontSize: 11)),
                  trailing: const Icon(Icons.chevron_right, size: 20),
                  onTap: () => _contactDeveloper(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('Versi Aplikasi', style: TextStyle(fontSize: 13)),
                  trailing: Text(
                    AppConstants.appVersion,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Logout Button
          OutlinedButton.icon(
            onPressed: () => _handleLogout(context),
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            label: const Text('Keluar dari Akun Admin', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.redAccent),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ],
      ),
    );
  }
}

