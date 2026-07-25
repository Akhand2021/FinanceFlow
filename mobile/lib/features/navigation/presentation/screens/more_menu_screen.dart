import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MoreMenuScreen extends StatelessWidget {
  const MoreMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('More Options'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildMenuItem(context, Icons.person_outline, 'Profile', '/settings'),
          _buildMenuItem(context, Icons.account_balance_wallet_outlined, 'Accounts & Cards', '/accounts'),
          _buildMenuItem(context, Icons.category_outlined, 'Categories', '/categories'),
          _buildMenuItem(context, Icons.pie_chart_outline, 'Monthly Budgets', '/budgets'),
          _buildMenuItem(context, Icons.savings_outlined, 'Savings Goals', '/budgets'),
          _buildMenuItem(context, Icons.request_quote_outlined, 'Loans & EMIs', '/loans'),
          _buildMenuItem(context, Icons.analytics_outlined, 'Reports & Health Score', '/reports'),
          _buildMenuItem(context, Icons.repeat_rounded, 'Recurring Subscriptions', '/recurring'),
          _buildMenuItem(context, Icons.auto_fix_high, 'Merchant Rules Engine', '/rules'),
          _buildMenuItem(context, Icons.sms_outlined, 'Pending SMS Queue', '/sms-queue'),
          _buildMenuItem(context, Icons.settings_outlined, 'Settings & Security', '/settings'),
          _buildMenuItem(context, Icons.help_outline, 'Help & Support', '/support'),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title, String route) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF6C63FF)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          context.push(route);
        },
      ),
    );
  }
}
