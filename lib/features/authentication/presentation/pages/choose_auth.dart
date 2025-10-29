import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vertex/features/authentication/presentation/bloc/user_bloc.dart';
import '../../../../widgets/screen_width_button.dart';

class ChooseAuthPage extends StatefulWidget {
  const ChooseAuthPage({super.key});

  @override
  State<ChooseAuthPage> createState() => _ChooseAuthPageState();
}

class _ChooseAuthPageState extends State<ChooseAuthPage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is OAuthDone) {
          context.go('/dashboard');
        } else if (state is OAuthError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message,
              style: Theme.of(context).textTheme.labelSmall),
          backgroundColor: Theme.of(context).cardColor));
        }
      },
      builder: (context, state) {
        final isLoading = state is OAuthDoing;
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  Image.asset(
                    "assets/images/logo.png",
                    width: MediaQuery.of(context).size.aspectRatio * 400,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Text("Vertex",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(letterSpacing: 2.5)),
                  Text("Demo App",
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(letterSpacing: 1.5)),
                  const Expanded(child: SizedBox()),
                  ScreenWidthButton(
                    text: isLoading ? "Signing in..." : "Google OAuth",
                    buttonFunc: () {
                      if (!isLoading) {
                        context
                            .read<AuthenticationBloc>()
                            .add(GoogleSignInRequested());
                      }
                    },
                    isLoading: isLoading,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                ]),
          ),
        );
      },
    );
  }
}
