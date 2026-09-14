import 'package:flutter/material.dart';
import 'package:meqawuel_front/src/core/widgets/custom_button.dart';
import 'package:meqawuel_front/src/core/widgets/custom_text_field.dart';
import 'package:meqawuel_front/src/core/utils/validators.dart';
import 'package:meqawuel_front/src/features/auth/presentation/pages/worker_documents_screen.dart';

class WorkerBasicInfoScreen extends StatefulWidget {
  const WorkerBasicInfoScreen({super.key});

  @override
  State<WorkerBasicInfoScreen> createState() => _WorkerBasicInfoScreenState();
}

class _WorkerBasicInfoScreenState extends State<WorkerBasicInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _experienceController = TextEditingController();
  final _specialityController = TextEditingController();

  void _next() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WorkerDocumentsScreen(
            experienceYears: _experienceController.text,
            speciality: _specialityController.text,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('بيانات الصنايعي')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'استكمل بياناتك',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 24),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                label: 'التخصص',
                hint: 'مثال: سباك، نجار، كهربائي',
                controller: _specialityController,
                validator: (val) => Validators.validateRequired(val, 'التخصص'),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'سنوات الخبرة',
                hint: 'مثال: 5',
                keyboardType: TextInputType.number,
                controller: _experienceController,
                validator: (val) => Validators.validateRequired(val, 'سنوات الخبرة'),
              ),
              const Spacer(),
              CustomButton(
                text: 'التالي (رفع المستندات)',
                onPressed: _next,
              )
            ],
          ),
        ),
      ),
    );
  }
}
