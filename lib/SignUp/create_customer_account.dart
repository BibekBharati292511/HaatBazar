import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:hatbazarsample/main.dart';
import 'package:http/http.dart' as http;

import '../Utilities/ResponsiveDim.dart';
import '../Widgets/alertBoxWidget.dart';
import '../Widgets/loginBackgroundImage.dart';
import '../Widgets/progress_indicator.dart';

class CreateUserAccount extends StatefulWidget {
  const CreateUserAccount({Key? key}) : super(key: key);

  @override
  State<CreateUserAccount> createState() => _CreateUserAccountState();
}

class _CreateUserAccountState extends State<CreateUserAccount> {
  bool _passwordVisible = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController firstController = TextEditingController();
  TextEditingController lastController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    firstController.dispose();
    lastController.dispose();
    super.dispose();
  }

  Future<void> createUserAccounts(
      String firstName, String lastName, String email, String password,int roleId) async {
    final url = Uri.parse("http://172.24.32.1:8080/user/signup");

    try {
      final response = await http.post(
        url,
        headers: <String, String>{"Content-Type": "application/json"},
        body: jsonEncode(<String, Object>{
          "firstName": firstName,
          "lastName": lastName,
          "email": email,
          "password": password,
          "roleId":roleId,
        }),
      );

      if (response.statusCode == 200) {
        // Decode the response JSON
        Map<String, dynamic> responseData = jsonDecode(response.body);

        // Check if the response indicates that the user already exists
        if (responseData['status'] == 'Error') {
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext dialogContext) {
              return MyAlertDialog(
                title: 'Error',
                content: responseData['message'],
              );
            },
          );
        } else {
          // Proceed to the verification page
          Navigator.pushNamed(context, 'verifyCustomerUser');
          firstController.clear();
          lastController.clear();
        }
      } else {
        // Handle other status codes (e.g., 400, 500) here
        throw Exception('Failed to create user: ${response.reasonPhrase}');
      }
    } catch (e) {
      // Handle network errors here
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          return MyAlertDialog(title: 'Error', content: 'Failed to create user: $e');
        },
      );
    }
  }
  Future<void> _handleGoogleSignInFromBackend() async {
    try {
      // Make a GET request to your backend endpoint that initiates Google authentication
      final response = await http.get(Uri.parse('http://172.24.32.1:8080/user/googleSignup'));

      // Check if the request was successful
      if (response.statusCode == 200) {

        print('Google authentication flow initiated successfully');
      } else {

        throw Exception('Failed to initiate Google authentication: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Failed to initiate Google authentication: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            LoginBackgroundImage(),
            Center(
              child: buildLoginContainer(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLoginContainer() {
    return Container(
      width: MediaQuery.of(context).size.width * 1,
      height: MediaQuery.of(context).size.height,
      margin: const EdgeInsets.only(top: 160),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(42)),
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.white)),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: buildLoginForm(),
      ),
    );
  }

  Widget buildLoginForm() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context); // Navigate back
                  },
                ),
                Expanded(
                  child: Text(
                    'Sign Up',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: ResponsiveDim.font24,
                        fontWeight: FontWeight.bold,
                        fontFamily: "poppins"
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveDim.height20),
            ProgressIndicators(currentPage: 2, totalPages: 3),
             SizedBox(height: ResponsiveDim.height15),
            buildTextField(
              'Enter your email',
              TextInputType.emailAddress,
              emailController,
              _validateEmail,
            ),
            buildTextField(
              'First Name',
              TextInputType.name,
              firstController,
              _validateFirstName,
            ),
            buildTextField(
              'Last Name',
              TextInputType.name,
              lastController,
              _validateLastName,
            ),
            buildPasswordField('Create password', passwordController),
            buildPasswordField('Confirm password', confirmPasswordController),
            buildSignInButton(),
            buildDividerWithOrText(),
            const Text(
              'Already have an account?',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.normal,
              ),
            ),
            buildCreateAccountButton(),
            buildGoogleSignupButton(),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(
      String hintText,
      TextInputType keyboardType,
      TextEditingController controller,
      String? Function(String?)? validator,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 90.0, vertical: 20.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            errorText: validator != null ? validator(controller.text) : null,
            fillColor: Colors.transparent,
            filled: true,
            border: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPasswordField(String hintText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 90.0, vertical: 20.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                obscureText: !_passwordVisible,
                decoration: InputDecoration(
                  hintText: hintText,
                  errorText: _validatePassword(controller.text),
                  fillColor: Colors.transparent,
                  filled: true,
                  border: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _passwordVisible = !_passwordVisible;
                });
              },
              child: Icon(
                _passwordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _validatePassword(String value) {
    if (value.isEmpty) {
      return 'Password is required';
    } else if (value.length < 7) {
      return 'Password should be at least 7 characters';
    } else if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password should contain at least one uppercase letter';
    } else if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password should contain at least one lowercase letter';
    } else if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password should contain at least one number';
    }
    return null;
  }

  String? _validateFirstName(String? value) {
    if (value == null || value.isEmpty) {
      return 'First name is required';
    } else if (value.startsWith(RegExp(r'[0-9]'))) {
      return 'First name should not start with a number';
    } else if (!RegExp(r'^[a-zA-Z0-9 ]+$').hasMatch(value)) {
      return 'First name should not contain special characters';
    }
    return null;
  }

  String? _validateLastName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Last name is required';
    } else if (value.startsWith(RegExp(r'[0-9]'))) {
      return 'Last name should not start with a number';
    } else if (!RegExp(r'^[a-zA-Z0-9 ]+$').hasMatch(value)) {
      return 'Last name should not contain special characters';
    }
    return null;
  }

  Widget buildSignInButton() {
    bool hasError = _validateEmail(emailController.text) != null ||
        _validatePassword(passwordController.text) != null ||
        _validatePassword(confirmPasswordController.text) != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 10.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        height: MediaQuery.of(context).size.height * 0.07,
        padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 1.0),
        child: ElevatedButton(
          onPressed: hasError ? null : () async {
            // Check if passwords match
            if (passwordController.text == confirmPasswordController.text) {
              userEmail = emailController.text;
              String firstName = firstController.text;
              String lastName = lastController.text;
              String email = emailController.text;
              String password = passwordController.text;
              int? roleIds=roleId;
              print("Email is "+userEmail!);
              print("firstName is "+firstName);
              print("other email is "+email);
              print("pass is "+password);
              print(roleIds);
              // Check if email is valid
              if (_validateEmail(email) == null) {
                // Proceed with user creation
                await createUserAccounts(firstName, lastName, email, password,roleIds!);
                // Clear text fields
              } else {
                // Show error dialog for invalid email
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext dialogContext) {
                    return MyAlertDialog(
                        title: 'Error', content: _validateEmail(emailController.text)!);
                  },
                );
              }
            } else {
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext dialogContext) {
                  return MyAlertDialog(title: 'Error', content: 'Passwords do not match');
                },
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF003F12),
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
          ),
          child: const Text(
            'Continue',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }

  Widget buildDividerWithOrText() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: Colors.black,
              thickness: 1,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 1.0),
            child: Text(
              'Or',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Divider(
              color: Colors.black,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCreateAccountButton() {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, 'login');
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 70.0, vertical: 6.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
              side: const BorderSide(color: Colors.green),
            ),
          ),
          child: const Text(
            'Login',
            style: TextStyle(
              color: Color(0xFF003F12),
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 15.0),
      ],
    );
  }

  Widget buildGoogleSignupButton() {
    return ElevatedButton(
      onPressed: () {
        _handleGoogleSignInFromBackend();
        // Add your login with Google logic here
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.05,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/google_logo.png',
              height: 44.0,
              width: 44.0,
            ),
            const SizedBox(width: 5.0),
            const Text(
              'Continue with Google',
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  String? _validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      return 'Enter valid email';
    }
    // Return null if email is valid
    return null;
  }
}
