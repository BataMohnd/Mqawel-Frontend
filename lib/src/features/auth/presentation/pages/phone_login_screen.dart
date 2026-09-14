import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meqawuel_front/src/core/widgets/custom_button.dart';
import 'package:meqawuel_front/src/core/widgets/custom_text_field.dart';
import 'package:meqawuel_front/src/core/utils/validators.dart';
import 'package:meqawuel_front/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:meqawuel_front/src/features/auth/presentation/bloc/auth_event.dart';
import 'package:meqawuel_front/src/features/auth/presentation/bloc/auth_state.dart';
import 'package:meqawuel_front/src/features/auth/presentation/pages/otp_screen.dart';

class PhoneLoginScreen extends StatefulWidget {
  final String role;
  const PhoneLoginScreen({super.key, required this.role});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        SendOtpEvent(phone: _phoneController.text.trim(), role: widget.role),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تسجيل الدخول'),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is OtpSentSuccess) {
            if (state.message != null) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message!)));
            }
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => OtpScreen(phone: state.phone, role: state.role),
            ));
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'أدخل رقم هاتفك',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 24),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'سنقوم بإرسال كود تفعيل (OTP) للتحقق من هويتك',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 32),
                  CustomTextField(
                    label: 'رقم الهاتف',
                    hint: 'مثال: 01012345678',
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    validator: Validators.validatePhone,
                  ),
                  const SizedBox(height: 32),
                  CustomButton(
                    text: 'متابعة',
                    isLoading: isLoading,
                    onPressed: _submit,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

}
