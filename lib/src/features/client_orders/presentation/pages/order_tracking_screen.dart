import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meqawuel_front/src/features/client_orders/data/models/order_model.dart';
import 'package:meqawuel_front/src/features/client_orders/presentation/bloc/client_orders_bloc.dart';
import 'package:meqawuel_front/src/features/client_orders/presentation/pages/rating_screen.dart';

class OrderTrackingScreen extends StatefulWidget {
  final OrderModel order;
  const OrderTrackingScreen({super.key, required this.order});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  late OrderModel _currentOrder;

  @override
  void initState() {
    super.initState();
    _currentOrder = widget.order;
    // Listen to Socket stream from repository
    context.read<ClientOrdersBloc>().repository.orderStatusStream.listen((updatedOrder) {
      if (updatedOrder.id == _currentOrder.id) {
        setState(() {
          _currentOrder = updatedOrder;
        });
      }
    });
  }

  int _getStatusStep(String status) {
    switch(status) {
      case 'pending': return 0;
      case 'accepted': return 1;
      case 'in_progress': return 2;
      case 'completed': return 3;
      default: return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final step = _getStatusStep(_currentOrder.status);

    return Scaffold(
      appBar: AppBar(title: const Text('متابعة الطلب')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            if (_currentOrder.status == 'cancelled')
               const Text('تم إلغاء هذا الطلب', style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold))
            else
              Stepper(
                currentStep: step,
                controlsBuilder: (context, details) => const SizedBox.shrink(),
                steps: [
                  Step(
                    title: const Text('الطلب اتبعّت'),
                    content: const Text('جاري البحث عن فني أو انتظار موافقته.'),
                    isActive: step >= 0,
                    state: step > 0 ? StepState.complete : StepState.indexed,
                  ),
                  Step(
                    title: const Text('قبل الطلب / في الطريق'),
                    content: const Text('الفني وافق على الطلب وفي طريقه إليك.'),
                    isActive: step >= 1,
                    state: step > 1 ? StepState.complete : StepState.indexed,
                  ),
                  Step(
                    title: const Text('بدأ الشغل'),
                    content: const Text('الفني يقوم بالعمل الآن.'),
                    isActive: step >= 2,
                    state: step > 2 ? StepState.complete : StepState.indexed,
                  ),
                  Step(
                    title: const Text('خلص الشغل'),
                    content: const Text('تم الانتهاء من العمل. يرجى التقييم.'),
                    isActive: step >= 3,
                    state: step == 3 ? StepState.complete : StepState.indexed,
                  ),
                ],
              ),
            const Spacer(),
            if (step == 3)
              ElevatedButton(
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => RatingScreen(orderId: _currentOrder.id),
                  ));
                },
                child: const Text('تقييم الخدمة', style: TextStyle(fontSize: 18)),
              )
          ],
        ),
      ),
    );
  }
}
