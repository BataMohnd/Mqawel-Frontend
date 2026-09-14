import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meqawuel_front/src/core/widgets/custom_button.dart';
import 'package:meqawuel_front/src/core/widgets/custom_text_field.dart';
import 'package:meqawuel_front/src/features/client_orders/presentation/bloc/client_orders_bloc.dart';
import 'package:meqawuel_front/src/features/client_orders/presentation/bloc/client_orders_event.dart';
import 'package:meqawuel_front/src/features/client_orders/presentation/bloc/client_orders_state.dart';

class RatingScreen extends StatefulWidget {
  final String orderId;
  const RatingScreen({super.key, required this.orderId});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  double _rating = 0;
  final _reviewController = TextEditingController();

  void _submit() {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('برجاء تحديد التقييم بالنجوم')));
      return;
    }
    context.read<ClientOrdersBloc>().add(RateWorkerEvent(
      orderId: widget.orderId,
      rating: _rating,
      review: _reviewController.text,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تقييم الخدمة')),
      body: BlocConsumer<ClientOrdersBloc, ClientOrdersState>(
        listener: (context, state) {
          if (state is MyOrdersLoaded) {
            // Because RateWorkerEvent triggers LoadMyOrdersEvent upon success
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('شكراً لتقييمك')));
            Navigator.pop(context); // Go back to tracking or orders list
          } else if (state is ClientOrdersError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const Text('ما تقييمك لمستوى الفني؟', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        index < _rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 40,
                      ),
                      onPressed: () => setState(() => _rating = index + 1.0),
                    );
                  }),
                ),
                const SizedBox(height: 32),
                CustomTextField(
                  label: 'تعليقك (اختياري)',
                  hint: 'مثال: محترم جداً والتزامه بالميعاد ممتاز',
                  controller: _reviewController,
                  maxLines: 4,
                ),
                const Spacer(),
                CustomButton(
                  text: 'إرسال التقييم',
                  isLoading: state is ClientOrdersLoading,
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
