import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meqawuel_front/src/core/widgets/custom_button.dart';
import 'package:meqawuel_front/src/core/theme/app_colors.dart';
import 'package:meqawuel_front/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:meqawuel_front/src/features/auth/presentation/bloc/auth_event.dart';
import 'package:meqawuel_front/src/features/auth/presentation/bloc/auth_state.dart';
import 'package:meqawuel_front/src/features/auth/presentation/pages/pending_review_screen.dart';

class WorkerDocumentsScreen extends StatefulWidget {
  final String experienceYears;
  final String speciality;

  const WorkerDocumentsScreen({
    super.key,
    required this.experienceYears,
    required this.speciality,
  });

  @override
  State<WorkerDocumentsScreen> createState() => _WorkerDocumentsScreenState();
}

class _WorkerDocumentsScreenState extends State<WorkerDocumentsScreen> {
  final ImagePicker _picker = ImagePicker();
  
  File? _idFront;
  File? _idBack;
  File? _criminalRecord;
  File? _selfie;

  Future<void> _pickImage(Function(File) onPicked) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        onPicked(File(image.path));
      });
    }
  }

  void _submit() {
    if (_idFront == null || _idBack == null || _criminalRecord == null || _selfie == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('برجاء رفع جميع المستندات المطلوبة')),
      );
      return;
    }

    context.read<AuthBloc>().add(SubmitWorkerDocsEvent(
      experienceYears: widget.experienceYears,
      idFrontPath: _idFront!.path,
      idBackPath: _idBack!.path,
      criminalRecordPath: _criminalRecord!.path,
      selfiePath: _selfie!.path,
    ));
  }

  Widget _buildDocPicker(String title, File? file, Function(File) onPicked) {
    return GestureDetector(
      onTap: () => _pickImage(onPicked),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.primaryLight.withValues(alpha: 0.2)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 100,
              decoration: BoxDecoration(
                color: file != null ? null : Colors.grey.shade200,
                borderRadius: const BorderRadius.horizontal(right: Radius.circular(12)),
                image: file != null ? DecorationImage(image: FileImage(file), fit: BoxFit.cover) : null,
              ),
              child: file == null ? const Icon(Icons.camera_alt, color: Colors.grey) : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            if (file != null) const Icon(Icons.check_circle, color: Colors.green),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('رفع المستندات')),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is WorkerDocsSubmittedSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const PendingReviewScreen()),
              (route) => false,
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDocPicker('صورة البطاقة (الوجه)', _idFront, (f) => _idFront = f),
                _buildDocPicker('صورة البطاقة (الخلف)', _idBack, (f) => _idBack = f),
                _buildDocPicker('فيش وتشبيه', _criminalRecord, (f) => _criminalRecord = f),
                _buildDocPicker('صورة شخصية (سيلفي)', _selfie, (f) => _selfie = f),
                const SizedBox(height: 32),
                CustomButton(
                  text: 'إرسال الطلب',
                  isLoading: state is AuthLoading,
                  onPressed: _submit,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
