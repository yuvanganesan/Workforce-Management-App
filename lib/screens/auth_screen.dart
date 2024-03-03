import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/authentication.dart';

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: //Colors.purple,
            Color(0xffcb6ce6),
        height: deviceSize.height,
        width: deviceSize.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: Container(
                  margin: const EdgeInsets.only(bottom: 20.0),
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 94.0),
                  child: Image.asset('assets/images/logo.png')),
            ),
            Flexible(
              flex: deviceSize.width > 600 ? 2 : 1,
              child: const AuthCard(),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  // ignore: prefer_final_fields
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  var _isVisible = true;

  final passFocus = FocusNode();

  void _showDialogBox(String errorMessage) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text("Authentication failed"),
              content: Text(errorMessage),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Okay"))
              ],
            ));
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Authentication>(context, listen: false)
          .login(_authData['email']!, _authData['password']!);
    } catch (error) {
      // print(error);
      var errorMessage = error.toString();
      _showDialogBox(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 8.0,
        child: Container(
          height: 220,
          //constraints: const BoxConstraints(minHeight: 260),
          width: deviceSize.width * 0.75,
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(
                      // focusColor: Color(0xffcb6ce6),
                      labelText: 'Employee no',
                      prefixIcon: Icon(Icons.person)),
                  keyboardType: TextInputType.number,
                  onFieldSubmitted: (value) =>
                      FocusScope.of(context).requestFocus(passFocus),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Employee no required';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value!;
                  },
                ),
                TextFormField(
                  focusNode: passFocus,
                  decoration: InputDecoration(
                      // focusColor: Color(0xffcb6ce6),
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: GestureDetector(
                        child: _isVisible
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off),
                        onTap: () => setState(() {
                          _isVisible = !_isVisible;
                        }),
                      )),
                  obscureText: _isVisible,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Password required';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['password'] = value!;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 8.0),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white
                        //Theme.of(context).primaryTextTheme.button.color,
                        ),
                    child: const Text('LOGIN'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
