import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/app_constants.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_dialogs.dart';
import '../login_screen.dart';

class SupervisorProfilTab extends StatelessWidget {
  const SupervisorProfilTab({super.key});

  Future<void> _contactDeveloper(BuildContext context) async {
    final url = Uri.parse('https://wa.me/${AppConstants.developerWhatsApp}?text=Halo%20Developer%20Supervisi%20Mabin%20IASS');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tidak dapat membuka WhatsApp')),
          );
        }
      }
    } catch (_) {}
  }

  Future<void> _handleLogout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Keluar', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
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
    final user = auth.user;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Profile Header Card
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
                  backgroundColor: const Color(0xFFFF416C).withOpacity(0.15),
                  child: Text(
                    user != null && user.name.isNotEmpty
                        ? user.name.substring(0, user.name.length >= 2 ? 2 : 1).toUpperCase()
                        : 'SP',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF416C),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  user?.name ?? 'Supervisor',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4FACFE).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Petugas Supervisi Mabin',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF4FACFE),
                      fontWeight: FontWeight.bold,
                    ),
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
            label: const Text('Keluar Aplikasi', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
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

