import 'package:chat_app/modelview/signin_modelview.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/widgets/button_widget.dart';
import 'package:chat_app/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_button/flutter_social_button.dart';
import 'package:provider/provider.dart';

import '../widgets/wave_widget.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<SingInModel>(context);
    final bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
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
          _loginBox(model, context),
        ],
      ),
    );
  }

  Widget _loginBox(SingInModel model, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextFieldWidget(
            hintText: "Email",
            suffixIconData: model.isValid ? Icons.check : null,
            controller: _emailController,
            prefixIconData: Icons.mail_outline,
            obscureText: false,
          ),
          const SizedBox(height: 10.0),
          TextFieldWidget(
            hintText: "Password",
            controller: _passwordController,
            prefixIconData: Icons.lock_outline,
            obscureText: model.isVisible ? false : true,
            suffixIconData:
                model.isVisible ? Icons.visibility : Icons.visibility_off,
          ),
          const SizedBox(height: 20.0),
          ButtonWidget(
            title: "Sign in",
            onTap: () {
              AuthMethods().signInWithMail(_emailController.text , _passwordController.text);
            },
          ),
          const SizedBox(height: 20.0),
          Row(
            children: [
              SizedBox(
                width: 200,
                child: FlutterSocialButton(
                  onTap: () {
                    // TODO: add authMehods
                    AuthMethods().signInWithGoogle();
                  },
                  buttonType: ButtonType.google,
                ),
              ),
              
            ],
          )
        ],
      ),
    );
  }
}
