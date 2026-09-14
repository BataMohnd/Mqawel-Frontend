import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meqawuel_front/src/core/widgets/custom_button.dart';
import 'package:meqawuel_front/src/features/marketplace/presentation/cubit/cart_cubit.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _paymentMethod = 'cash';
  bool _isLoading = false;

  void _placeOrder() async {
    setState(() => _isLoading = true);
    // Mock API call
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      context.read<CartCubit>().clearCart();
      
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 64),
              const SizedBox(height: 16),
              const Text('تم تأكيد الطلب!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('جارٍ تجهيز الخامات وسيتم التواصل معك قريباً للتوصيل.', textAlign: TextAlign.center),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // close dialog
                  Navigator.pop(context); // close checkout
                  Navigator.pop(context); // close cart -> back to home
                },
                child: const Text('العودة للرئيسية'),
              )
            ],
          ),
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartState = context.read<CartCubit>().state;

    return Scaffold(
      appBar: AppBar(title: const Text('إتمام الدفع')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('عنوان التوصيل', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.location_on),
                title: const Text('مدينتي - B6 - مجموعة 64'),
                subtitle: const Text('شقة 12 - الدور الثالث'),
                trailing: TextButton(onPressed: (){}, child: const Text('تغيير')),
              ),
            ),
            const SizedBox(height: 24),
            const Text('طريقة الدفع', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Card(
              child: Column(
                children: [
                  RadioListTile(
                    title: const Text('الدفع كاش عند الاستلام'),
                    value: 'cash',
                    groupValue: _paymentMethod,
                    onChanged: (val) => setState(() => _paymentMethod = val.toString()),
                  ),
                  RadioListTile(
                    title: const Text('محفظة إلكترونية / بطاقة ائتمان'),
                    value: 'card',
                    groupValue: _paymentMethod,
                    onChanged: (val) => setState(() => _paymentMethod = val.toString()),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('ملخص الطلب', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('قيمة المشتريات'),
                Text('${cartState.total} ج.م'),
              ],
            ),
            const SizedBox(height: 8),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('رسوم التوصيل'),
                Text('50.0 ج.م'),
              ],
            ),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('الإجمالي الكلي', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('${cartState.total + 50} ج.م', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
              ],
            ),
            const SizedBox(height: 48),
            CustomButton(
              text: 'تأكيد الطلب الآن',
              isLoading: _isLoading,
              onPressed: _placeOrder,
            )
          ],
        ),
      ),
    );
  }
}
