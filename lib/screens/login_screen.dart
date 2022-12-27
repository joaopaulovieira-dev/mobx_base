import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:mobx_base/controllers/login_controller.dart';
import 'package:mobx_base/widgets/custom_icon_button.dart';
import 'package:mobx_base/widgets/custom_text_field.dart';

import 'list_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController controller = LoginController();

  late ReactionDisposer disposer;

  @override
  void initState() {
    super.initState();
    //1º tipo de reação: autorun - executa sempre que houver alteração
    // autorun((_) {
    //   if (controller.loggedIn) {
    //     Navigator.of(context).pushReplacement(
    //       MaterialPageRoute(builder: (_) => const ListScreen()),
    //     );
    //   }
    // });

    //2º tipo de reação: reaction - executa quando houver alteração e quando a condição for verdadeira
    // reaction((_) => controller.loggedIn, (loggedIn) {
    //   if (loggedIn != null) {
    //     Navigator.of(context).pushReplacement(
    //       MaterialPageRoute(builder: (_) => const ListScreen()),
    //     );
    //   }
    // });

    //3º tipo de reação: when - executa quando a condição for verdadeira
    disposer = when((_) => controller.loggedIn, () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const ListScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Card(
            margin: const EdgeInsets.all(32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 16,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Entrar',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Observer(builder: (_) {
                    return CustomTextField(
                      hint: 'E-mail',
                      prefix: const Icon(Icons.account_circle),
                      textInputType: TextInputType.emailAddress,
                      onChanged: controller.setEmail,
                      enabled: !controller.loading,
                    );
                  }),
                  const SizedBox(height: 16),
                  Observer(builder: (_) {
                    return CustomTextField(
                      hint: 'Senha',
                      prefix: const Icon(Icons.lock),
                      suffix: CustomIconButton(
                        radius: 32,
                        iconData: controller.passwordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                        onTap: controller.togglePasswordVisibility,
                      ),
                      obscure: !controller.passwordVisible,
                      onChanged: controller.setPassword,
                      enabled: !controller.loading,
                    );
                  }),
                  const SizedBox(height: 16),
                  Observer(builder: (_) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        backgroundColor: Theme.of(context).primaryColor,
                        textStyle: const TextStyle(color: Colors.white),
                        padding: const EdgeInsets.all(12),
                      ),
                      child: controller.loading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                              ),
                            )
                          : const Text('Login'),
                      onPressed:
                          controller.isFormValid ? controller.login : null,
                    );
                  })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    disposer();
    super.dispose();
  }
}
