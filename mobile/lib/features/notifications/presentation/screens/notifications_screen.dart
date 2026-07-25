import 'package:flutter/material.dart';
import '../../../../core/utils/toast_utils.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<Map<String, String>> _notifications = [
    {
      'title': 'Budget Alert',
      'body': 'You have exceeded Food budget limit.',
      'time': '2m ago',
      'icon': 'alert',
    },
    {
      'title': 'EMI Reminder',
      'body': 'Home Loan EMI is due in 3 days.',
      'time': '1h ago',
      'icon': 'emi',
    },
    {
      'title': 'Goal Reminder',
      'body': 'Add money to your Emergency Fund.',
      'time': '3h ago',
      'icon': 'goal',
    },
    {
      'title': 'Recurring Transaction',
      'body': 'Netflix subscription of ₹649 processed.',
      'time': 'Yesterday',
      'icon': 'recurring',
    },
    {
      'title': 'Tips',
      'body': 'You spent 32% more on Food this month.',
      'time': 'Yesterday',
      'icon': 'tip',
    },
    {
      'title': 'System',
      'body': 'Backup completed successfully.',
      'time': '2d ago',
      'icon': 'system',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () {
              ToastUtils.showSuccess(context, 'All notifications marked as read');
            },
            child: const Text('Mark all as read'),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final n = _notifications[index];
          IconData iconData = Icons.notifications;
          Color iconColor = Colors.blue;

          if (n['icon'] == 'alert') {
            iconData = Icons.warning_amber_rounded;
            iconColor = Colors.red;
          } else if (n['icon'] == 'emi') {
            iconData = Icons.alarm;
            iconColor = Colors.orange;
          } else if (n['icon'] == 'goal') {
            iconData = Icons.savings_outlined;
            iconColor = Colors.green;
          } else if (n['icon'] == 'recurring') {
            iconData = Icons.repeat_rounded;
            iconColor = Colors.purple;
          }

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: iconColor.withValues(alpha: 0.15),
                child: Icon(iconData, color: iconColor),
              ),
              title: Text(n['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(n['body']!),
              trailing: Text(n['time']!, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ),
          );
        },
      ),
    );
  }
}
