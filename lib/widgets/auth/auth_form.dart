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
  var _email = '';
  var _displayName = '';
  var _password = '';
  var _confirmPassword = '';

  //* Input controller (to pass values between input fields)
  final TextEditingController _passwordController = TextEditingController();

  //* Performs validation
  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      //* save() fires the onSave() method attached to each TextFormField
      _formKey.currentState!.save();
      widget.submitFn(
        _email.trim(),
        _password.trim(),
        _displayName.trim(),
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
                        _email = value.toString();
                      }),
                  if (!_isLogin)
                    TextFormField(
                        key: const ValueKey('displayName'),
                        autocorrect: true,
                        textCapitalization: TextCapitalization.words,
                        enableSuggestions: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter a display name.";
                          }
                          if (value.length < 4) {
                            return 'Display name must be at least 4 characters long.';
                          }
                          return null;
                        },
                        decoration:
                            const InputDecoration(labelText: 'Display Name'),
                        onSaved: (value) {
                          _displayName = value.toString();
                        }),
                  TextFormField(
                      key: const ValueKey('password'),
                      controller: _passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a password.";
                        }
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters long.';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      onSaved: (value) {
                        _password = value.toString();
                      }),
                  if (!_isLogin)
                    TextFormField(
                        key: const ValueKey('confirmPassword'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please confirm your password.";
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords don\'t match.';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            labelText: 'Confirm Password'),
                        obscureText: true,
                        onSaved: (value) {
                          _confirmPassword = value.toString();
                        }),
                  const SizedBox(height: 20),
                  if (widget.isLoading) const CircularProgressIndicator(),
                  if (!widget.isLoading)
                    ElevatedButton(
                      child: Text(_isLogin ? 'Login' : 'Sign Up'),
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
