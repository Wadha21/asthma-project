import 'package:asthma/Screens/NavBar/nav_bar.dart';
import 'package:asthma/Screens/auth/login_screen.dart';
import 'package:asthma/blocs/auth_bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/user_bloc/user_bloc.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (oldState, newState) {
        if (newState is CheckLoginState) {
          context.read<UserBloc>().add(LoadUserData());
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => const NavigatorBarScreen()),
              (route) => false);
        } else if (newState is ErrorChecktate) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
              (route) => false);
        }
        return false;
      },
      builder: (context, state) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator.adaptive(),
          ),
        );
      },
    );
  }
}
