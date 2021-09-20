import "package:flutter/material.dart";

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key, required this.isLoading, required this.submitFn})
      : super(key: key);

  final bool isLoading;
  final void Function(
      {required String email,
      required String displayName,
      required String password,
      required bool isVolunteer,
      required bool isLogin,
      required BuildContext ctx}) submitFn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  //* Create global key to uniquely identify the Form widget and allows validation
  //* Standard practice for Flutter forms
  final _formKey = GlobalKey<FormState>();

  late FocusNode myFocusNode;

  //* Initialize form input variables
  bool _isLogin = true;
  String _email = '';
  String _displayName = '';
  String _password = '';
  bool _isVolunteer = false;

  //* Input Controllers
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  //* Performs validation
  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      //* save() fires the onSave() method attached to each TextFormField
      _formKey.currentState!.save();
      widget.submitFn(
        email: _email.trim(),
        displayName: _displayName.trim(),
        password: _password.trim(),
        isVolunteer: _isVolunteer,
        isLogin: _isLogin,
        ctx: context,
      );
    }
  }

  @override
  void initState() {
    super.initState();

    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();

    super.dispose();
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
                      controller: _emailController,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      enableSuggestions: false,
                      focusNode: myFocusNode,
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
                      decoration:
                          const InputDecoration(labelText: 'Confirm Password'),
                      obscureText: true,
                    ),
                  if (!_isLogin)
                    CheckboxListTile(
                        title: const Text("I am a volunteer"),
                        value: _isVolunteer,
                        onChanged: (bool? value) {
                          setState(() {
                            _isVolunteer = value!;
                          });
                        }),
                  if (_isLogin) const SizedBox(height: 10),
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
                      ),
                      child: Text(_isLogin
                          ? 'Create new account'
                          : 'I already have an account'),
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        _emailController.clear();
                        _passwordController.clear();
                        myFocusNode.requestFocus();
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
