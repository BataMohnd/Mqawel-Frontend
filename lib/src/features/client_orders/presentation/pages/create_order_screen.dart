import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meqawuel_front/src/core/widgets/custom_text_field.dart';
import 'package:meqawuel_front/src/features/client_orders/data/models/service_category.dart';
import 'package:meqawuel_front/src/features/client_orders/data/models/worker_model.dart';
import 'package:meqawuel_front/src/features/client_orders/presentation/bloc/client_orders_bloc.dart';
import 'package:meqawuel_front/src/features/client_orders/presentation/bloc/client_orders_event.dart';
import 'package:meqawuel_front/src/features/client_orders/presentation/bloc/client_orders_state.dart';
import 'package:meqawuel_front/src/features/client_orders/presentation/pages/workers_list_screen.dart';

class CreateOrderScreen extends StatefulWidget {
  final WorkerModel? worker;
  final String? initialCategoryId;
  const CreateOrderScreen({super.key, this.worker, this.initialCategoryId});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final _descController = TextEditingController();
  final _addressController = TextEditingController(text: 'القاهرة');
  final _manualLatitudeController = TextEditingController();
  final _manualLongitudeController = TextEditingController();
  final _picker = ImagePicker();
  int _step = 0;
  late String _categoryId;
  String _urgency = 'normal';
  final List<String> _photos = [];
  double? _latitude;
  double? _longitude;
  bool _isFetchingLocation = false;

  @override
  void initState() {
    super.initState();
    _categoryId = widget.initialCategoryId ?? _categoryFromWorker(widget.worker);
  }

  String _categoryFromWorker(WorkerModel? worker) {
    if (worker == null) return 'other';
    return serviceCategories.any((category) => category.name == worker.speciality)
        ? serviceCategories.firstWhere((category) => category.name == worker.speciality).id
        : 'other';
  }

  ServiceCategory get _category => serviceCategories.firstWhere((item) => item.id == _categoryId);

  double? _parseCoordinate(TextEditingController controller) {
    final value = controller.text.trim();
    if (value.isEmpty) return null;
    return double.tryParse(value);
  }

  Future<void> _pickPhoto(ImageSource source) async {
    if (source == ImageSource.gallery) {
      final images = await _picker.pickMultiImage(imageQuality: 80, maxWidth: 1600);
      if (images.isNotEmpty && mounted) {
        setState(() => _photos.addAll(images.map((image) => image.path)));
      }
      return;
    }

    final image = await _picker.pickImage(source: source, imageQuality: 80, maxWidth: 1600);
    if (image != null && mounted) {
      setState(() => _photos.add(image.path));
    }
  }

  Future<void> _requestCurrentLocation() async {
    final messenger = ScaffoldMessenger.maybeOf(context);
    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      messenger?.showSnackBar(
        const SnackBar(content: Text('تم رفض إذن الموقع، يمكنك إدخال الموقع يدويًا أو عنوان الخدمة')),
      );
      return;
    }

    setState(() => _isFetchingLocation = true);

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium),
      );
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
      });
      if (mounted) {
        messenger?.showSnackBar(
          const SnackBar(content: Text('تم الحصول على موقعك الحالي بنجاح')),
        );
      }
    } catch (_) {
      if (mounted) {
        messenger?.showSnackBar(
          const SnackBar(content: Text('تعذر الحصول على الموقع الحالي، يمكنك إدخال إحداثياتك يدويًا')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isFetchingLocation = false);
      }
    }
  }

  Future<void> _submit() async {
    final messenger = ScaffoldMessenger.maybeOf(context);
    final clientOrdersBloc = context.read<ClientOrdersBloc>();

    if (_descController.text.trim().length < 10 || _addressController.text.trim().isEmpty) {
      messenger?.showSnackBar(
        const SnackBar(content: Text('اكتب وصفاً لا يقل عن 10 أحرف وحدد العنوان')),
      );
      return;
    }

    final manualLatitude = _parseCoordinate(_manualLatitudeController);
    final manualLongitude = _parseCoordinate(_manualLongitudeController);

    final resolvedLatitude = manualLatitude ?? _latitude;
    final resolvedLongitude = manualLongitude ?? _longitude;

    if (resolvedLatitude == null || resolvedLongitude == null) {
      messenger?.showSnackBar(
        const SnackBar(content: Text('يرجى تحديد الموقع الحالي أو إدخال إحداثيات الموقع يدويًا')),
      );
      return;
    }

    List<String> uploadedPhotos = const [];
    if (_photos.isNotEmpty) {
      try {
        uploadedPhotos = await clientOrdersBloc.repository.uploadImages(_photos);
      } catch (error) {
        messenger?.showSnackBar(
          SnackBar(content: Text(error.toString().replaceFirst('Exception: ', ''))),
        );
        return;
      }
    }

    clientOrdersBloc.add(
      CreateOrderEvent(
        category: _category.id,
        serviceType: _category.name,
        description: _descController.text,
        urgency: _urgency,
        address: _addressController.text.trim(),
        latitude: resolvedLatitude,
        longitude: resolvedLongitude,
        photos: uploadedPhotos,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('طلب خدمة')),
      body: BlocConsumer<ClientOrdersBloc, ClientOrdersState>(
        listener: (context, state) {
          if (state is OrderCreatedSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إرسال الطلب بنجاح')));
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => WorkersListScreen(category: state.order.category, orderId: state.order.id)),
            );
          } else if (state is ClientOrdersError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Stepper(
            currentStep: _step,
            onStepContinue: () {
              if (_step < 4) {
                setState(() => _step++);
              } else {
                _submit();
              }
            },
            onStepCancel: _step == 0 ? null : () => setState(() => _step--),
            controlsBuilder: (context, details) => Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: state is ClientOrdersLoading ? null : details.onStepContinue,
                    child: Text(_step == 4 ? 'إرسال الطلب' : 'التالي'),
                  ),
                  if (_step > 0)
                    TextButton(onPressed: details.onStepCancel, child: const Text('رجوع')),
                ],
              ),
            ),
            steps: [
              Step(
                title: const Text('الخدمة'),
                isActive: _step >= 0,
                content: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  physics: const NeverScrollableScrollPhysics(),
                  children: serviceCategories
                      .map(
                        (category) => ChoiceChip(
                          label: Text(category.name),
                          avatar: Icon(category.icon, size: 18),
                          selected: _categoryId == category.id,
                          onSelected: (_) => setState(() => _categoryId = category.id),
                        ),
                      )
                      .toList(),
                ),
              ),
              Step(
                title: const Text('وصف المشكلة'),
                isActive: _step >= 1,
                content: CustomTextField(
                  label: 'وصف المشكلة',
                  hint: 'اشرح المشكلة بالتفصيل',
                  controller: _descController,
                  maxLines: 5,
                ),
              ),
              Step(
                title: const Text('الصور'),
                isActive: _step >= 2,
                content: Column(
                  children: [
                    if (_photos.isNotEmpty)
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 3,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        children: _photos.asMap().entries.map((entry) {
                          final photo = entry.value;
                          return Stack(
                            children: [
                              Positioned.fill(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(File(photo), fit: BoxFit.cover),
                                ),
                              ),
                              Positioned(
                                top: 4,
                                right: 4,
                                child: CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Colors.black54,
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: const Icon(Icons.close, color: Colors.white, size: 16),
                                    onPressed: () => setState(() => _photos.removeAt(entry.key)),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton.icon(
                            onPressed: () => _pickPhoto(ImageSource.camera),
                            icon: const Icon(Icons.camera_alt),
                            label: const Text('تصوير'),
                          ),
                        ),
                        Expanded(
                          child: TextButton.icon(
                            onPressed: () => _pickPhoto(ImageSource.gallery),
                            icon: const Icon(Icons.photo_library),
                            label: const Text('المعرض'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Step(
                title: const Text('الموقع والإلحاح'),
                isActive: _step >= 3,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      label: 'العنوان',
                      hint: 'اكتب عنوان مكان الخدمة',
                      controller: _addressController,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _isFetchingLocation ? null : _requestCurrentLocation,
                            icon: _isFetchingLocation
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Icon(Icons.location_on),
                            label: const Text('استخدم موقعي الحالي'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (_latitude != null && _longitude != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'الموقع الحالي: ${_latitude!.toStringAsFixed(5)}, ${_longitude!.toStringAsFixed(5)}',
                          style: const TextStyle(color: Colors.green),
                        ),
                      ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      label: 'Latitude (اختياري)',
                      hint: '30.0444',
                      controller: _manualLatitudeController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      label: 'Longitude (اختياري)',
                      hint: '31.2357',
                      controller: _manualLongitudeController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _urgency,
                      decoration: const InputDecoration(labelText: 'درجة الإلحاح'),
                      items: const [
                        DropdownMenuItem(value: 'normal', child: Text('عادي')),
                        DropdownMenuItem(value: 'urgent', child: Text('عاجل')),
                        DropdownMenuItem(value: 'emergency', child: Text('طوارئ')),
                      ],
                      onChanged: (value) => setState(() => _urgency = value ?? 'normal'),
                    ),
                  ],
                ),
              ),
              Step(
                title: const Text('مراجعة وإرسال'),
                isActive: _step >= 4,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('الخدمة: ${_category.name}'),
                    Text('الوصف: ${_descController.text}'),
                    Text('العنوان: ${_addressController.text}'),
                    Text('الإلحاح: $_urgency'),
                    Text('الصور: ${_photos.length}'),
                    if (_latitude != null && _longitude != null)
                      Text('الموقع: ${_latitude!.toStringAsFixed(5)}, ${_longitude!.toStringAsFixed(5)}'),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
