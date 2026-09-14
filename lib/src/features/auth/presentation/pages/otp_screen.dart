import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meqawuel_front/src/core/widgets/custom_button.dart';
import 'package:meqawuel_front/src/core/widgets/custom_text_field.dart';
import 'package:meqawuel_front/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:meqawuel_front/src/features/auth/presentation/bloc/auth_event.dart';
import 'package:meqawuel_front/src/features/auth/presentation/bloc/auth_state.dart';
import 'package:meqawuel_front/src/features/auth/presentation/pages/worker_basic_info_screen.dart';
import 'package:meqawuel_front/src/features/client_orders/presentation/pages/main_bottom_nav_screen.dart';

class OtpScreen extends StatefulWidget {
  final String phone;
  final String role;
  
  const OtpScreen({super.key, required this.phone, required this.role});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _otpController = TextEditingController();
  int _counter = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    setState(() => _counter = 60);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_counter > 0) {
        setState(() => _counter--);
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_otpController.text.length == 4) {
      context.read<AuthBloc>().add(VerifyOtpEvent(
        phone: widget.phone,
        otp: _otpController.text,
        role: widget.role,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('كود التحقق')),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            if (widget.role == 'worker' && state.user.name == 'مستخدم جديد') {
              // Usually check if profile is complete, assuming new worker needs to complete profile
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const WorkerBasicInfoScreen()),
                (route) => false,
              );
            } else if (widget.role == 'client') {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم الدخول بنجاح')));
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainBottomNavScreen()));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم الدخول بنجاح')));
            }
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'أدخل كود التحقق',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 24),
                ),
                const SizedBox(height: 8),
                Text(
                  'تم إرسال الكود إلى ${widget.phone}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 32),
                CustomTextField(
                  label: 'الكود المكون من 4 أرقام',
                  hint: 'مثال: 1234',
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 32),
                CustomButton(
                  text: 'تأكيد',
                  isLoading: state is AuthLoading,
                  onPressed: _submit,
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: _counter == 0 ? () {
                      _startTimer();
                      context.read<AuthBloc>().add(SendOtpEvent(phone: widget.phone, role: widget.role));
                    } : null,
                    child: Text(
                      _counter > 0 ? 'إعادة إرسال الكود خلال $_counter ثانية' : 'إعادة إرسال الكود',
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
