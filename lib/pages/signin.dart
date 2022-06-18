import 'package:chat_app/modelview/signin_modelview.dart';
import 'package:chat_app/widgets/button_widget.dart';
import 'package:chat_app/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_button/flutter_social_button.dart';
import 'package:provider/provider.dart';

import '../widgets/wave_widget.dart';

class SignIn extends StatelessWidget {
  const SignIn({Key? key}) : super(key: key);

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
            color: Color(0xFF087949),
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
          _loginBox(model),
        ],
      ),
    );
  }

  Widget _loginBox(SingInModel model) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextFieldWidget(
            hintText: "Email",
            suffixIconData: model.isValid ? Icons.check : null,
            prefixIconData: Icons.mail_outline,
            obscureText: false,
          ),
          const SizedBox(height: 10.0),
          TextFieldWidget(
            hintText: "Password",
            prefixIconData: Icons.lock_outline,
            obscureText: model.isVisible ? false : true,
            suffixIconData:
                model.isVisible ? Icons.visibility : Icons.visibility_off,
          ),
          const SizedBox(height: 20.0),
          ButtonWidget(
            title: "Sign in",
            onTap: () {},
          ),
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FlutterSocialButton(
                onTap: () {},
                mini: true,
                buttonType: ButtonType.google,
              ),
              FlutterSocialButton(
                onTap: () {},
                mini: true,
                buttonType: ButtonType.apple,
              ),
              FlutterSocialButton(
                onTap: () {},
                mini: true,
                buttonType: ButtonType.facebook,
              ),
              FlutterSocialButton(
                onTap: () {},
                mini: true,
                buttonType: ButtonType.twitter,
              ),
            ],
          )
        ],
      ),
    );
  }
}
