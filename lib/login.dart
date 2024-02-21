import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Utilities/ResponsiveDim.dart';
import 'Widgets/LoadingWidget.dart';
import 'Widgets/alertBoxWidget.dart';
import 'package:sign_in_button/sign_in_button.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  State<MyLogin> createState() => _MyLoginState();

  Widget buildBackgroundImage(BuildContext context) {
    return Positioned(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.97,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(100),
            bottomRight: Radius.circular(100),
          ),
          image: DecorationImage(
            image: AssetImage('assets/images/img_9.png'),
            alignment: Alignment.topCenter,
          ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF15810C), Color(0xFFFCFDFC)],
            stops: [0.524, 0.27],
          ),
        ),
      ),
    );
  }
}

class _MyLoginState extends State<MyLogin> {
  bool _passwordVisible = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> signIn(String email, String password) async {
    final url = Uri.parse("http://172.24.32.1:8080/user/signIn");

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        url,
        headers: <String, String>{"Content-Type": "application/json"},
        body: jsonEncode(<String, Object>{
          "email": email,
          "password": password,
        }),
      );

      final Map<String, dynamic> responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        String token = responseBody["token"] as String;
        String role=responseBody["role"] as String;
        print(token);
        if(role=="Buyers"){
          Navigator.pushNamed(context, 'homePage');
        }
        else if(role=="Sellers"){
          Navigator.pushNamed(context, 'sellerHomePage');
        }
      } else {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext dialogContext) {
            return MyAlertDialog(
              title: 'Error',
              content: 'Failed to login: ${responseBody["message"]}',
            );
          },
        );
      }
    } on SocketException {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          return MyAlertDialog(title: 'Error', content: 'Network Error');
        },
      );
    } on HttpException catch (e) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          return MyAlertDialog(
            title: 'Error',
            content: 'Your request is unavailable right now',
          );
        },
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            widget.buildBackgroundImage(context),
            Center(
              child: _isLoading ? LoadingWidget() : buildLoginContainer(),
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
      margin: const EdgeInsets.only(top: 245),
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
      margin: EdgeInsets.only(top: ResponsiveDim.height45),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to HaatBazaar',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),
            ),
            buildTextField('Enter your email', TextInputType.emailAddress, emailController),
            buildPasswordField('Enter your password', passwordController),
            buildForgetPasswordButton(),
            buildSignInButton(),
            buildDividerWithOrText(),
            buildCreateAccountButton(),
            buildGoogleLoginButton(context),

          ],
        ),
      ),
    );
  }

  Widget buildTextField(String hintText, TextInputType keyboardType, TextEditingController controller) {
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
            suffixIcon: IconButton(
              icon: Icon(
                _passwordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _passwordVisible = !_passwordVisible;
                });
              },
            ),
          ),
        ),
      ),
    );
  }



  Widget buildForgetPasswordButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          Navigator.pushNamed(context, 'sendEmailVerification');
        },
        child: const Text(
          'Forget Password?',
          style: TextStyle(
            fontSize: 15,
          ),
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
          onPressed: () async {
            String password = passwordController.text;
            String email = emailController.text;
            await signIn(email, password);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF003F12),
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
          ),
          child: const Text(
            'Sign In',
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
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
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
            Navigator.pushNamed(context, 'roleSelection');
          },
          style: TextButton.styleFrom(
            padding:  EdgeInsets.symmetric(horizontal: ResponsiveDim.width45, vertical: ResponsiveDim.height15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ResponsiveDim.radius6),
              side: const BorderSide(color: Colors.green),
            ),
          ),
          child: const Text(
            'Create Account',
            style: TextStyle(
              color: Color(0xFF003F12),
              fontSize: 15,
              fontWeight: FontWeight.bold,
              fontFamily: "poppins"
            ),
          ),
        ),
         SizedBox(height: ResponsiveDim.height15),
      ],
    );
  }



  Widget buildGoogleLoginButton(BuildContext context) {
    return Material(
      elevation: 4, // Add elevation for shadow effect
      borderRadius: BorderRadius.circular(6.0),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black, backgroundColor: Colors.white, // Define text color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.height * 0.06,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12.0), // Adjust the left padding
                child: Image.asset(
                  'assets/images/google_logo.png',
                  height: 44.0,
                  width: 44.0,
                ),
              ),
              const SizedBox(width: 5.0),
              const Text(
                'Login with Google',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontFamily: "poppins",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}



