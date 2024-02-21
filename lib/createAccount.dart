import 'package:flutter/material.dart';

import 'Widgets/loginBackgroundImage.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  bool _passwordVisible = false;
  int currentPage = 1;
  int totalPages = 4;

  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
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
            const Text(
              'Sign Up',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Stack(
              alignment: Alignment.center,
              children: [
                LinearProgressIndicator(
                  value: currentPage / totalPages,
                  backgroundColor: Colors.grey,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                ),
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '$currentPage/$totalPages',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            buildTextField('Enter new email', TextInputType.emailAddress),
            buildTextField('Phone', TextInputType.phone),
            buildPasswordField('Create password', passwordController),
            buildPasswordField('Confirm password', confirmPasswordController),
            buildSignInButton(),
            buildDividerWithOrText(),
            const Text(
              'Already has an account?',
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

  Widget buildTextField(String hintText, TextInputType keyboardType) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 90.0, vertical: 20.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: TextFormField(
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
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

  Widget buildSignInButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 10.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        height: MediaQuery.of(context).size.height * 0.07,
        padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 1.0),
        child: ElevatedButton(
          onPressed: () {
            // Check if passwords match
            if (passwordController.text == confirmPasswordController.text) {
              //print("Password: '${passwordController.text}'");
              //print("Confirm Password: '${confirmPasswordController.text}'");

              //print("yo rock");
              // Passwords match, proceed to the next page
              // Add your navigation logic here
            } else {
              // Passwords do not match, show an error or handle as needed
              // For now, print a message
              //print('Passwords do not match');


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
            // Add your create account logic here
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
}
