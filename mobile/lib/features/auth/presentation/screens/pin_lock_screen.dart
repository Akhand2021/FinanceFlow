import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/toast_utils.dart';

class PinLockScreen extends StatefulWidget {
  const PinLockScreen({super.key});

  @override
  State<PinLockScreen> createState() => _PinLockScreenState();
}

class _PinLockScreenState extends State<PinLockScreen> {
  String _pin = '';

  void _onKeyPress(String val) {
    if (_pin.length < 4) {
      setState(() => _pin += val);
      if (_pin.length == 4) {
        if (_pin == '1234' || _pin == '0000') {
          ToastUtils.showSuccess(context, 'App Unlocked!');
          context.go('/dashboard');
        } else {
          ToastUtils.showError(context, 'Incorrect PIN. Try 1234');
          setState(() => _pin = '');
        }
      }
    }
  }

  void _onDelete() {
    if (_pin.isNotEmpty) {
      setState(() => _pin = _pin.substring(0, _pin.length - 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 60),
            const Icon(Icons.lock_outline_rounded,
                size: 56, color: Color(0xFF6C63FF)),
            const SizedBox(height: 16),
            Text(
              'Enter App PIN',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Enter 4 digit PIN to continue',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),

            // PIN Dots Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                final isFilled = index < _pin.length;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isFilled
                        ? const Color(0xFF6C63FF)
                        : Colors.grey.withValues(alpha: 0.3),
                  ),
                );
              }),
            ),

            const Spacer(),

            // Custom Numeric Keypad
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.4,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                if (index == 9) {
                  return IconButton(
                    icon: const Icon(Icons.fingerprint,
                        size: 36, color: Color(0xFF6C63FF)),
                    onPressed: () {
                      ToastUtils.showSuccess(
                          context, 'Biometric authenticated!');
                      context.go('/dashboard');
                    },
                  );
                } else if (index == 10) {
                  return InkWell(
                    onTap: () => _onKeyPress('0'),
                    borderRadius: BorderRadius.circular(40),
                    child: const Center(
                      child: Text('0',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                    ),
                  );
                } else if (index == 11) {
                  return IconButton(
                    icon: const Icon(Icons.backspace_outlined),
                    onPressed: _onDelete,
                  );
                }
                final number = (index + 1).toString();
                return InkWell(
                  onTap: () => _onKeyPress(number),
                  borderRadius: BorderRadius.circular(40),
                  child: Center(
                    child: Text(
                      number,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
