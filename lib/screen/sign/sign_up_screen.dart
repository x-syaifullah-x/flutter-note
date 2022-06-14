import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:submission_bmafup/data/user/user_repository.dart';
import 'package:submission_bmafup/data/user/user.dart';
import 'package:submission_bmafup/screen/home/home_screen.dart';
import 'package:submission_bmafup/screen/sign/utils/sign_utils.dart';
import 'package:submission_bmafup/screen/sign/widget/sign_text_field.dart';
import 'package:submission_bmafup/utils/utils.dart';

import 'sign_in_screen.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(true);
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: _Content(),
            ),
          ),
        ),
      ),
    );
  }
}

class _Content extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  final _textEditingControllerEmail = TextEditingController();
  final _textEditingControllerPhoneNumber = TextEditingController();
  final _textEditingControllerPassword = TextEditingController();
  final _textEditingControllerPasswordConfirm = TextEditingController();
  final _focusNodeEmail = FocusNode();
  final _focusNodePhoneNumber = FocusNode();
  final _focusNodePassword = FocusNode();
  final _focusNodePasswordConfirm = FocusNode();

  String? _errorMessageEmail;
  String? _errorMessagePhoneNumber;
  String? _errorMessagePassword;
  String? _errorMessagePasswordConfirm;

  bool _isAgree = true;
  bool _isObscureTextPassword = true;
  bool _isObscureTextConfirmPassword = true;

  @override
  void dispose() {
    _textEditingControllerEmail.dispose();
    _textEditingControllerPhoneNumber.dispose();
    _textEditingControllerPassword.dispose();
    _textEditingControllerPasswordConfirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _createAccountText(),
        _emailAddressTextField(),
        _phoneNumberTextField(),
        _passwordTextField(),
        _confirmPasswordTextField(),
        _sizeBoxHeight20(),
        _agreementRow(),
        _sizeBoxHeight20(),
        _buttonSignUp(context),
        _alreadyAccountText(context),
      ],
    );
  }

  Widget _createAccountText() {
    return const Padding(
      padding: EdgeInsets.only(top: 30, bottom: 25),
      child: Text(
        "Create Account",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 35,
        ),
      ),
    );
  }

  Widget _agreementRow() {
    return Row(
      children: [
        Checkbox(
          value: _isAgree,
          visualDensity: VisualDensity.compact,
          onChanged: (isChecked) {
            setState(() {
              _isAgree = isChecked ?? false;
            });
          },
        ),
        const Flexible(
          child: Text(
            "I agree to the User Agreement and Privacy Policy.",
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _emailAddressTextField() {
    return SignTextField(
      label: "Email Address",
      hint: "Enter your email address",
      controller: _textEditingControllerEmail,
      keyboardType: TextInputType.emailAddress,
      focusNode: _focusNodeEmail,
      errorText: _errorMessageEmail,
      onChange: (value) {
        if (_errorMessageEmail != null) {
          setState(() => _errorMessageEmail = null);
        }
      },
    );
  }

  Widget _phoneNumberTextField() {
    return SignTextField(
      label: "Phone Number",
      hint: "Enter your phone number",
      controller: _textEditingControllerPhoneNumber,
      keyboardType: TextInputType.phone,
      errorText: _errorMessagePhoneNumber,
      focusNode: _focusNodePhoneNumber,
      onChange: (value) {
        if (_errorMessagePhoneNumber != null) {
          setState(() => _errorMessagePhoneNumber = null);
        }
      },
    );
  }

  Widget _passwordTextField() {
    return SignTextField(
      label: "Password",
      hint: "Enter your password",
      controller: _textEditingControllerPassword,
      obscureText: _isObscureTextPassword,
      errorText: _errorMessagePassword,
      focusNode: _focusNodePassword,
      suffixIcon: IconButton(
        icon: Icon(
          _isObscureTextPassword ? Icons.visibility : Icons.visibility_off,
        ),
        onPressed: () => setState(() {
          _isObscureTextPassword = !_isObscureTextPassword;
        }),
      ),
      onChange: (value) {
        if (_errorMessagePassword != null) {
          setState(() => _errorMessagePassword = null);
        }
      },
    );
  }

  Widget _confirmPasswordTextField() {
    return SignTextField(
      label: "Confirm Password",
      hint: "Enter again your password",
      controller: _textEditingControllerPasswordConfirm,
      obscureText: _isObscureTextConfirmPassword,
      errorText: _errorMessagePasswordConfirm,
      focusNode: _focusNodePasswordConfirm,
      suffixIcon: IconButton(
        icon: Icon(
          _isObscureTextConfirmPassword
              ? Icons.visibility
              : Icons.visibility_off,
        ),
        onPressed: () {
          setState(() {
            _isObscureTextConfirmPassword = !_isObscureTextConfirmPassword;
          });
        },
      ),
      onChange: (value) {
        if (_errorMessagePasswordConfirm != null) {
          setState(() => _errorMessagePasswordConfirm = null);
        }
      },
    );
  }

  Widget _alreadyAccountText(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 6),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: "Already have an account?",
          style: const TextStyle(
            color: Colors.black,
            fontSize: 12,
          ),
          children: [
            TextSpan(
              text: " Login",
              style: const TextStyle(color: Colors.blueAccent),
              recognizer: TapGestureRecognizer()
                ..onTap = () => {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (builder) => const SignInScreen(),
                        ),
                        (route) => false,
                      ),
                    },
            )
          ],
        ),
      ),
    );
  }

  Widget _buttonSignUp(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: Size(getWidthDevice(context, 65), 40),
      ),
      onPressed: () => _signUp(
        User(
          _textEditingControllerEmail.text,
          _textEditingControllerPassword.text,
          _textEditingControllerPhoneNumber.text,
        ),
      ),
      child: const Text("Sign Up"),
    );
  }

  void _signUp(User data) {
    return _validateInput((isValid) {
      if (isValid) {
        UserRepository.getInstance().signup(data).then((result) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => HomeScreen(result),
            ),
            (route) => false,
          );
        }).catchError((message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message, style: const TextStyle(color: Colors.red)),
            ),
          );
        });
      }
    });
  }

  void _validateInput(Function(bool) result) {
    setState(() {
      final email = _textEditingControllerEmail.text;
      if (email.isEmpty) {
        _errorMessageEmail = "Please input email address";
        _focusNodeEmail.requestFocus();
        result.call(false);
        return;
      } else if (!isEmail(email)) {
        _errorMessageEmail = "Please input correct email address";
        _focusNodeEmail.requestFocus();
        result.call(false);
        return;
      } else {
        _errorMessageEmail = null;
      }

      if (_textEditingControllerPhoneNumber.text.isEmpty) {
        _errorMessagePhoneNumber = "Please input phone number";
        _focusNodePhoneNumber.requestFocus();
        result.call(false);
        return;
      } else {
        _errorMessagePhoneNumber = null;
      }

      var password = _textEditingControllerPassword.text;
      _errorMessagePassword = passwordValidate(password);
      if (_errorMessagePassword != null) {
        _focusNodePassword.requestFocus();
        result.call(false);
        return;
      }

      var passwordConfirm = _textEditingControllerPasswordConfirm.text;
      if (passwordConfirm.isEmpty) {
        _errorMessagePasswordConfirm = "Please input confirm password";
        _focusNodePasswordConfirm.requestFocus();
        result.call(false);
        return;
      } else {
        _errorMessagePasswordConfirm = null;
      }

      if (password != passwordConfirm) {
        _errorMessagePasswordConfirm = "The password does not match. Try again";
        _focusNodePasswordConfirm.requestFocus();
        result.call(false);
        return;
      } else {
        _errorMessagePasswordConfirm = null;
      }

      if (!_isAgree) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please check i agree to the User Agreement"),
          ),
        );
        result.call(false);
        return;
      }
      result.call(true);
    });
  }

  SizedBox _sizeBoxHeight20() => const SizedBox(height: 20);
}
