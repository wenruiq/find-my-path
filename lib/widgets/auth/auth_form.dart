import "package:flutter/material.dart";

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key, required this.isLoading, required this.submitFn})
      : super(key: key);

  final bool isLoading;
  final void Function(
    String email,
    String password,
    String displayName,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  //* Create global key to uniquely identify the Form widget and allows validation
  //* Standard practice for Flutter forms
  final _formKey = GlobalKey<FormState>();

  //* Initialize form input variables
  var _isLogin = true;
  var _userEmail = '';
  var _userDisplayName = '';
  var _userPassword = '';

  //* Performs validation
  void _trySubmit() {
    final isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();

    if (isValid != null && isValid) {
      _formKey.currentState?.save();
      widget.submitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        _userDisplayName.trim(),
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            //* Build a Form widget using the _formKey created above
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                      key: const ValueKey('email'),
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      enableSuggestions: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter an email.";
                        }
                        bool emailValid = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value);
                        if (!emailValid) {
                          return "Please enter a valid email.";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: 'Email'),
                      onSaved: (value) {
                        _userEmail = value.toString();
                      }),
                  if (!_isLogin)
                    TextFormField(
                        key: const ValueKey('username'),
                        autocorrect: true,
                        textCapitalization: TextCapitalization.words,
                        enableSuggestions: false,
                        validator: (value) {
                          if (value!.isEmpty || value.length < 4) {
                            return 'Display name must be at least 4 characters long.';
                          }
                          return null;
                        },
                        decoration:
                            const InputDecoration(labelText: 'Display Name'),
                        onSaved: (value) {
                          _userDisplayName = value.toString();
                        }),
                  TextFormField(
                      key: const ValueKey('password'),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 7) {
                          return "Password must be at least 7 characters long.";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Password',
                        // labelStyle:
                        //     TextStyle(color: Theme.of(context).primaryColor),
                        // floatingLabelStyle:
                        //     TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      style: const TextStyle(color: Colors.red),
                      obscureText: true,
                      onSaved: (value) {
                        _userPassword = value.toString();
                      }),
                  const SizedBox(height: 12),
                  if (widget.isLoading) const CircularProgressIndicator(),
                  if (!widget.isLoading)
                    ElevatedButton(
                      child: Text(_isLogin ? 'Login' : 'Signup'),
                      onPressed: _trySubmit,
                    ),
                  if (!widget.isLoading)
                    TextButton(
                      style: TextButton.styleFrom(
                        textStyle: Theme.of(context).textTheme.caption,
                        // primary: Colors.blue,
                      ),
                      child: Text(_isLogin
                          ? 'Create new account'
                          : 'I already have an account'),
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
