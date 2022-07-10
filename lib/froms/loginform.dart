import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/serverData.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<StatefulWidget> createState() {
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  String? _host;
  String? _username;
  String? _password;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        width: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Login'),
            TextFormField(
              validator: inputValidator,
              decoration: const InputDecoration(hintText: 'Host'),
              onSaved: (value) {
                _host = value;
              },
            ),
            TextFormField(
              validator: inputValidator,
              decoration: const InputDecoration(hintText: 'Benutzername'),
              onSaved: (value) {
                _username = value;
              },
            ),
            TextFormField(
              validator: inputValidator,
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              decoration: const InputDecoration(hintText: 'Passwort'),
              onSaved: (value) {
                _password = value;
              },
            ),
            Consumer<ServerData>(
              builder: (context, data, widget) {
                return Container(
                  margin: EdgeInsets.only(top: 10),
                  child: TextButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        final success =
                            await data.login(_host!, _username!, _password!);

                        if (success) {
                          Navigator.popAndPushNamed(context, "/alarms");
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Anmeldung fehlgeschlagen")));
                        }
                      }
                    },
                    child: const Text("Anmelden"),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String? inputValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Bitte Text eintragen";
    }

    return null;
  }
}
