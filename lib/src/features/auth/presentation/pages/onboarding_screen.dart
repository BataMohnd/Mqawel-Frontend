import 'package:flutter/material.dart';
import 'package:meqawuel_front/src/core/widgets/custom_button.dart';
import 'package:meqawuel_front/src/features/auth/presentation/pages/role_selection_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              const Icon(Icons.handshake, size: 120, color: Colors.amber),
              const SizedBox(height: 32),
              Text(
                'أهلاً بك في مقاول',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 28),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'سواء كنت تبحث عن فني محترف أو كنت فنياً تبحث عن عمل، نحن نوصلكم ببعض بكل سهولة وثقة.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              CustomButton(
                text: 'ابدأ الآن',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RoleSelectionScreen()),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
