import 'package:flutter/cupertino.dart';

class LoginBackgroundImage extends StatelessWidget {
  const LoginBackgroundImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.97,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(100),
            bottomRight: Radius.circular(100),
          ),
          image: DecorationImage(
            image: AssetImage('assets/images/img_8.png'),
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
