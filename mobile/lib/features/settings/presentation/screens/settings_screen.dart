import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_notifier.dart';
import '../providers/settings_provider.dart';
import '../../../../core/utils/currency_utils.dart';
import '../../../../core/utils/toast_utils.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsNotifierProvider);
    final settings = settingsAsync.valueOrNull;
    final authState = ref.watch(authNotifierProvider);
    final currentCurrency = settings?.currency ?? 'INR';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings & Security'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Header Card
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                radius: 28,
                backgroundColor: const Color(0xFF6C63FF),
                child: Text(
                  authState.user?.firstName.isNotEmpty == true
                      ? authState.user!.firstName[0].toUpperCase()
                      : 'U',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(
                '${authState.user?.firstName ?? 'User'} ${authState.user?.lastName ?? ''}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              subtitle: Text(authState.user?.email ?? 'user@financeflow.com'),
            ),
          ),
          const SizedBox(height: 20),

          const Text('CURRENCY & PREFERENCES',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  fontSize: 12)),
          const SizedBox(height: 8),

          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.attach_money_rounded, color: Color(0xFF6C63FF)),
                  title: const Text('Primary Currency'),
                  subtitle: const Text('Default currency for reports & transactions'),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6C63FF).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$currentCurrency (${CurrencyUtils.getSymbol(currentCurrency)})',
                      style: const TextStyle(
                          color: Color(0xFF6C63FF), fontWeight: FontWeight.bold),
                    ),
                  ),
                  onTap: () => _showCurrencyPickerDialog(context, ref, currentCurrency),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.language_rounded, color: Color(0xFF6C63FF)),
                  title: const Text('Language'),
                  trailing: Text(
                    settings?.language ?? 'English',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.palette_outlined, color: Color(0xFF6C63FF)),
                  title: const Text('App Theme'),
                  trailing: Text(
                    settings?.theme ?? 'System',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text('SECURITY & PRIVACY',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  fontSize: 12)),
          const SizedBox(height: 8),

          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.pin_outlined, color: Color(0xFF6C63FF)),
                  title: const Text('PIN Lock'),
                  subtitle: const Text('Require 4-digit PIN on app startup'),
                  value: settings?.pinnedLocked ?? false,
                  onChanged: (val) {
                    ref.read(settingsNotifierProvider.notifier).updateSettings({
                      'pinnedLocked': val,
                    });
                    ToastUtils.showSuccess(
                        context, val ? 'PIN Lock enabled!' : 'PIN Lock disabled.');
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.fingerprint_rounded, color: Color(0xFF6C63FF)),
                  title: const Text('Biometric Lock'),
                  subtitle: const Text('FaceID / TouchID security'),
                  value: settings?.biometricLocked ?? false,
                  onChanged: (val) {
                    ref.read(settingsNotifierProvider.notifier).updateSettings({
                      'biometricLocked': val,
                    });
                    ToastUtils.showSuccess(context,
                        val ? 'Biometric security enabled!' : 'Biometric security disabled.');
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Logout Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text('Logout',
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () {
                ref.read(authNotifierProvider.notifier).logout();
                ToastUtils.showInfo(context, 'Logged out successfully.');
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showCurrencyPickerDialog(BuildContext context, WidgetRef ref, String current) {
    final currencies = [
      {'code': 'INR', 'name': 'Indian Rupee', 'symbol': '₹'},
      {'code': 'USD', 'name': 'US Dollar', 'symbol': '\$'},
      {'code': 'EUR', 'name': 'Euro', 'symbol': '€'},
      {'code': 'GBP', 'name': 'British Pound', 'symbol': '£'},
      {'code': 'CAD', 'name': 'Canadian Dollar', 'symbol': 'C\$'},
      {'code': 'AUD', 'name': 'Australian Dollar', 'symbol': 'A\$'},
      {'code': 'AED', 'name': 'UAE Dirham', 'symbol': 'AED'},
      {'code': 'JPY', 'name': 'Japanese Yen', 'symbol': '¥'},
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Select Primary Currency', style: TextStyle(fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: currencies.length,
            itemBuilder: (context, index) {
              final c = currencies[index];
              final isSelected = c['code'] == current;

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: isSelected ? const Color(0xFF6C63FF) : Colors.grey[200],
                  child: Text(
                    c['symbol']!,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(c['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(c['code']!),
                trailing: isSelected ? const Icon(Icons.check_circle, color: Color(0xFF6C63FF)) : null,
                onTap: () {
                  ref.read(settingsNotifierProvider.notifier).updateSettings({
                    'currency': c['code'],
                  });
                  ToastUtils.showSuccess(context, 'Currency updated to ${c['code']} (${c['symbol']})');
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
