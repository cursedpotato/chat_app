import 'package:chat_app/widgets/buttonwidget.dart';
import 'package:chat_app/widgets/textfieldwidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_button/flutter_social_button.dart';

class SignIn extends StatelessWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const TextFieldWidget(
              hintText: "Email",
              prefixIconData: Icons.mail_outline,
              obsureText: false,
            ),
            const SizedBox(height: 10.0),
            const TextFieldWidget(
              hintText: "Password",
              prefixIconData: Icons.lock_outline,
              obsureText: true,
            ),
            const SizedBox(height: 20.0),
            ButtonWidget(
              title: "Sign in",
              onTap: () {},
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FlutterSocialButton(
                  onTap: () {},
                  mini: true, 
                  buttonType: ButtonType
                      .google, 
                ),
                FlutterSocialButton(
                  onTap: () {},
                  mini: true,  
                  buttonType: ButtonType
                      .apple, 
                ),
                FlutterSocialButton(
                  onTap: () {},
                  mini: true,  
                  buttonType: ButtonType
                      .facebook, 
                ),
                FlutterSocialButton(
                  onTap: () {},
                  mini: true,  
                  buttonType: ButtonType
                      .twitter, 
                ),
                
              ],
            )
          ],
        ),
      ),
    );
  }
}
