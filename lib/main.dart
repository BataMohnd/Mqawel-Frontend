import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meqawuel_front/src/core/theme/app_theme.dart';
import 'package:meqawuel_front/src/core/network/dio_client.dart';
import 'package:meqawuel_front/src/features/auth/data/repositories/auth_repository.dart';
import 'package:meqawuel_front/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:meqawuel_front/src/features/client_orders/data/repositories/client_orders_repository.dart';
import 'package:meqawuel_front/src/features/client_orders/presentation/bloc/client_orders_bloc.dart';
import 'package:meqawuel_front/src/features/worker_portal/data/repositories/worker_portal_repository.dart';
import 'package:meqawuel_front/src/features/worker_portal/presentation/bloc/worker_portal_bloc.dart';
import 'package:meqawuel_front/src/features/marketplace/data/repositories/marketplace_repository.dart';
import 'package:meqawuel_front/src/features/marketplace/presentation/bloc/marketplace_bloc.dart';
import 'package:meqawuel_front/src/features/marketplace/presentation/cubit/cart_cubit.dart';
import 'package:meqawuel_front/src/features/auth/presentation/pages/splash_screen.dart';

void main() {
  final dioClient = DioClient();
  final authRepository = AuthRepository(dioClient);
  final clientOrdersRepository = ClientOrdersRepository(dioClient);
  final workerPortalRepository = WorkerPortalRepository(dioClient);
  final marketplaceRepository = MarketplaceRepository(dioClient);

  runApp(MoqawelApp(
    authRepository: authRepository,
    clientOrdersRepository: clientOrdersRepository,
    workerPortalRepository: workerPortalRepository,
    marketplaceRepository: marketplaceRepository,
  ));
}

class MoqawelApp extends StatelessWidget {
  final AuthRepository authRepository;
  final ClientOrdersRepository clientOrdersRepository;
  final WorkerPortalRepository workerPortalRepository;
  final MarketplaceRepository marketplaceRepository;

  const MoqawelApp({
    super.key,
    required this.authRepository,
    required this.clientOrdersRepository,
    required this.workerPortalRepository,
    required this.marketplaceRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(authRepository: authRepository),
        ),
        BlocProvider(
          create: (context) => ClientOrdersBloc(repository: clientOrdersRepository)..repository.initSocket(),
        ),
        BlocProvider(
          create: (context) => WorkerPortalBloc(repository: workerPortalRepository)..repository.initSocket(),
        ),
        BlocProvider(
          create: (context) => MarketplaceBloc(repository: marketplaceRepository),
        ),
        BlocProvider(
          create: (context) => CartCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'Moqawel - مقاول',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
