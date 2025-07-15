import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'core/navigation/app_router.dart';
import 'features/auth/data/repositories/mock_auth_repository.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/appointments/presentation/bloc/appointments_bloc.dart';

class HayahApp extends StatelessWidget {
  const HayahApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(authRepository: MockAuthRepository()),
        ),
        BlocProvider(create: (context) => AppointmentsBloc()),
      ],
      child: MaterialApp(
        title: 'Hayah Health',
        theme: AppTheme.lightTheme,
        initialRoute: '/',
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
