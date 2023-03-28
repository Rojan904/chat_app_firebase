import 'package:chat_app/bloc_switch/auth/login/bloc/login_bloc.dart';
import 'package:chat_app/bloc_switch/auth/register/pages/register_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../pages/home.dart';
import '../../../../../services/auth_service.dart';
import '../../../../../widgets/widgets.dart';

class LoginPage2 extends StatefulWidget {
  const LoginPage2({Key? key}) : super(key: key);

  @override
  State<LoginPage2> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage2> {
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  // final LoginBloc loginBloc = LoginBloc();
  bool autoValidateEmail = false;
  bool autoValidatePassword = false;
  bool obscurePassword = true;
  late FocusNode emailFocusNode;
  late FocusNode pwFocusNode;
  AuthService authService = AuthService();
  @override
  void initState() {
    super.initState();
    emailFocusNode = FocusNode();
    pwFocusNode = FocusNode();
  }

  @override
  void dispose() {
    emailFocusNode.dispose();
    pwFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginError) {
            showSnackbar(context, Colors.red, state.message);
          } else if (state is LoggedIn) {
            nextScreenReplace(context, const HomePage());
          }
        },
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            return Stack(
              children: [
                state is LoginLoading
                    ? Center(
                        child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColor),
                      )
                    : Container(),
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 80),
                    child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const Text(
                              "Groupie",
                              style: TextStyle(
                                  fontSize: 40, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                                "Login now to see what they are talking!",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w400)),
                            Image.asset("assets/login.png"),
                            TextFormField(
                              decoration: textInputDecoration.copyWith(
                                  labelText: "Email",
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: Theme.of(context).primaryColor,
                                  )),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,

                              onChanged: (val) {
                                setState(() {
                                  email = val;
                                });
                                // context
                                //     .read<LoginBloc>()
                                //     .add(LoginEmailChangedEvent(email: val));
                              },

                              // check tha validation
                              validator: (val) {
                                return RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(val!)
                                    ? null
                                    : "Please enter a valid email";
                              },
                              onTap: () {
                                setState(() {
                                  autoValidateEmail = true;
                                });
                              },
                              focusNode: emailFocusNode,
                              onEditingComplete: () {
                                FocusScope.of(context)
                                    .requestFocus(pwFocusNode);
                                setState(() {
                                  autoValidatePassword = true;
                                });
                              },
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              obscureText: true,
                              decoration: textInputDecoration.copyWith(
                                  labelText: "Password",
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      setState(
                                        () {
                                          obscurePassword = !obscurePassword;
                                        },
                                      );
                                    },
                                    child: Icon(
                                      obscurePassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.grey,
                                    ),
                                  )),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              onTap: () {
                                setState(() {
                                  autoValidatePassword = true;
                                });
                              },
                              focusNode: pwFocusNode,
                              onEditingComplete: () {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                setState(() {
                                  autoValidateEmail = true;
                                });
                              },
                              validator: (val) {
                                if (val!.length < 6) {
                                  return "Password must be at least 6 characters";
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (val) {
                                setState(() {
                                  password = val;
                                });
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30))),
                                child: const Text(
                                  "Sign In",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                                onPressed: () {
                                  login();
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text.rich(TextSpan(
                              text: "Don't have an account? ",
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 14),
                              children: <TextSpan>[
                                TextSpan(
                                    text: "Register here",
                                    style: const TextStyle(
                                        color: Colors.black,
                                        decoration: TextDecoration.underline),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        nextScreen(
                                            context, const RegisterPage2());
                                      }),
                              ],
                            )),
                          ],
                        )),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  login() async {
    if (formKey.currentState!.validate()) {
      BlocProvider.of<LoginBloc>(context)
          .add(LoginAttemptEvent(email: email, password: password));
    }
  }
}
