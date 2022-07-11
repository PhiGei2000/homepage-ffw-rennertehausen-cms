import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homepage_ffw_rennertehausen_cms/settings.dart';
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
  bool _remember = true;

  final TextEditingController _hostController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    loadSettings();
  }

  void loadSettings() async {
    final host = await Settings.getHost();
    final username = await Settings.getUsername();

    setState(() {
      _host = host;
      _username = username;
      _hostController.text = host;
      _usernameController.text = username;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SizedBox(
        width: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Login'),
            TextFormField(
              validator: inputValidator,
              decoration: const InputDecoration(hintText: 'Host'),
              controller: _hostController,
              onSaved: (value) {
                _host = value;
              },
            ),
            TextFormField(
              validator: inputValidator,
              decoration: const InputDecoration(hintText: 'Benutzername'),
              controller: _usernameController,
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
                  child: Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();

                                final success = await data.login(
                                    _host!, _username!, _password!);

                                if (success) {
                                  if (_remember) {
                                    Settings.setHost(_host!);
                                    Settings.setUsername(_username!);
                                  }

                                  Navigator.popAndPushNamed(context, "/alarms");
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Anmeldung fehlgeschlagen")));
                                }
                              }
                            },
                            child: const Text("Anmelden"),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Checkbox(
                              value: _remember,
                              onChanged: (value) {
                                setState(() {
                                  _remember = value!;
                                });
                              },
                            ),
                            const Text("merken"),
                          ],
                        ),
                      ),
                    ],
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
