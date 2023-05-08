import 'package:chat_app/features/auth/models/auth_model.dart';
import 'package:chat_app/features/auth/services/auth_service.dart';
import 'package:chat_app/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:chat_app/features/auth/views/widgets/button_widget.dart';
import 'package:chat_app/features/auth/views/widgets/textfield_widget.dart';
import 'package:chat_app/features/home/views/screens/home_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../widgets/wave_animation/wave_widget.dart';

class SignIn extends HookWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: size.height - 200,
            color: const Color(0xFF087949),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutQuad,
            top: keyboardOpen ? -size.height / 3.7 : 0.0,
            child: WaveWidget(
              size: size,
              yOffset: size.height / 3.0,
              color: Colors.white,
            ),
          ),
          const _LoginSection()
        ],
      ),
    );
  }
}

class _LoginSection extends HookConsumerWidget {
  const _LoginSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final isVisible = useState(false);
    final isValid = useState<bool>(false);

    ref.listen<AuthSignInModel>(
      authProvider,
      (previous, next) {
        if (next.isSigningIn.getOrElse(() => true)) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
          );
          return;
        }

        if (next.isSigningIn.isLeft()) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Something went wrong"),
            ),
          );
        }
      },
    );
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextFieldWidget(
            hintText: "Email",
            suffixIconData: isValid.value ? Icons.check : null,
            controller: emailController,
            prefixIconData: Icons.mail_outline,
            onChanged: (p0) {
              isValid.value = EmailValidator.validate(p0);
            },
          ),
          const SizedBox(height: 10.0),
          TextFieldWidget(
            onIconTap: () {
              isVisible.value = !isVisible.value;
            },
            hintText: "Password",
            controller: passwordController,
            prefixIconData: Icons.lock_outline,
            obscureText: !isVisible.value,
            suffixIconData:
                isVisible.value ? Icons.visibility : Icons.visibility_off,
          ),
          const SizedBox(height: 20.0),
          ButtonWidget(
            color: const Color(0xFF087949),
            title: "Sign in",
            onTap: () {
              if (emailController.text.isEmpty &&
                  passwordController.text.isEmpty) return;

              ref.read(authProvider.notifier).authMethod =
                  AuthServices.signInWithMail(
                emailController.text,
                passwordController.text,
              );

              ref.read(authProvider.notifier).signIn();
            },
          ),
          const SizedBox(height: 20.0),
          Row(
            children: [
              ButtonWidget(
                color: const Color.fromRGBO(219, 68, 55, 1),
                title: "Google",
                onTap: () {
                  ref.read(authProvider.notifier).authMethod =
                      AuthServices.signInWithGoogle();
                  ref.read(authProvider.notifier).signIn();
                },
              ),
              const SizedBox(
                width: 10,
              ),
              ButtonWidget(
                color: const Color.fromRGBO(66, 103, 178, 1),
                title: "Facebook",
                onTap: () async {
                  ref.read(authProvider.notifier).authMethod =
                      AuthServices.signInWithFacebook();
                  ref.read(authProvider.notifier).signIn();
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
