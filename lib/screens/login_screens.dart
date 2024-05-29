import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instaclone/resources/auth_methods.dart';
import 'package:instaclone/responsiveness/mobile_screen_layout.dart';
import 'package:instaclone/responsiveness/responsive_layout.dart';
import 'package:instaclone/responsiveness/web_screen_layout.dart';
import 'package:instaclone/screens/signup_screens.dart';
import 'package:instaclone/utils/colors.dart';
import 'package:instaclone/utils/globle_variables.dart';
import 'package:instaclone/utils/imageutil.dart';
import 'package:instaclone/widgets/text_fields.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passcontroller = TextEditingController();
  bool _isloading = false;
  @override
  void dispose() {
    super.dispose();
    _emailcontroller.dispose();
    _passcontroller.dispose();
  }

  void navigatetosignup() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      ),
    );
  }

  void loginuser() async {
    setState(() {
      _isloading = true;
    });
    String res = await Authmethods().loginuser(
        email: _emailcontroller.text, password: _passcontroller.text);
    if (res != 'success') {
      showsnackbar(res, context);
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            mobilescreenlayout: MobileScreenLayout(),
            webscreenlayout: WebScreenLayout(),
          ),
        ),
      );
    }
    setState(() {
      _isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: MediaQuery.of(context).size.width > weblayoutsize
              ? EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width /3)
              : const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 2,
                child: Container(),
              ),
              SvgPicture.asset(
                'assets/ic_instagram.svg',
                color: primaryColor,
                height: 64,
              ),
              const SizedBox(
                height: 64,
              ),
              InputTextField(
                  hinttext: 'Enter Your Email',
                  textEditingController: _emailcontroller,
                  textinputtype: TextInputType.emailAddress),
              const SizedBox(
                height: 16,
              ),
              InputTextField(
                hinttext: 'Password',
                textEditingController: _passcontroller,
                textinputtype: TextInputType.text,
                ispass: true,
              ),
              const SizedBox(
                height: 16,
              ),
              InkWell(
                onTap: loginuser,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                      color: Colors.blue),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: _isloading
                      ? const Center(
                          child: CircularProgressIndicator(color: primaryColor),
                        )
                      : const Text('Log in'),
                ),
              ),
              Flexible(
                flex: 2,
                child: Container(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: const Text('Dont have an account?'),
                  ),
                  GestureDetector(
                    onTap: navigatetosignup,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: const Text(
                        'Sign in',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
