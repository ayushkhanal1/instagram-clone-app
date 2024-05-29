import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instaclone/resources/auth_methods.dart';
import 'package:instaclone/responsiveness/mobile_screen_layout.dart';
import 'package:instaclone/responsiveness/responsive_layout.dart';
import 'package:instaclone/responsiveness/web_screen_layout.dart';
import 'package:instaclone/screens/login_screens.dart';
import 'package:instaclone/utils/colors.dart';
import 'package:instaclone/utils/imageutil.dart';
import 'package:instaclone/widgets/text_fields.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<SignUpScreen> {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passcontroller = TextEditingController();
  final TextEditingController _usernamecontroller = TextEditingController();
  final TextEditingController _biocontroller = TextEditingController();
  Uint8List? _image;
  bool _isloading = false;
  @override
  void dispose() {
    super.dispose();
    _emailcontroller.dispose();
    _passcontroller.dispose();
  }

  void selectimage() async {
    Uint8List img = await pickimage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  void navigatetologin() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  void signupuser() async {
    setState(() {
      _isloading = true;
    });
    String res = await Authmethods().signupUser(
        email: _emailcontroller.text,
        Password: _passcontroller.text,
        bio: _biocontroller.text,
        username: _usernamecontroller.text,
        file: _image!);
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
          padding: const EdgeInsets.symmetric(horizontal: 32),
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
                height: 24,
              ),
              const SizedBox(
                height: 32,
              ),
              Stack(
                children: [
                  _image == null
                      ? const CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage(
                              'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Default_pfp.svg/2048px-Default_pfp.svg.png'),
                        )
                      : CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_image!),
                        ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: selectimage,
                      icon: const Icon(Icons.add_a_photo),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              InputTextField(
                  hinttext: 'Enter Your Username',
                  textEditingController: _usernamecontroller,
                  textinputtype: TextInputType.text),
              const SizedBox(
                height: 12,
              ),
              InputTextField(
                  hinttext: 'Enter Your Email',
                  textEditingController: _emailcontroller,
                  textinputtype: TextInputType.emailAddress),
              const SizedBox(
                height: 12,
              ),
              InputTextField(
                hinttext: 'Password',
                textEditingController: _passcontroller,
                textinputtype: TextInputType.text,
                ispass: true,
              ),
              const SizedBox(
                height: 12,
              ),
              InputTextField(
                  hinttext: 'Enter Your Bio',
                  textEditingController: _biocontroller,
                  textinputtype: TextInputType.text),
              const SizedBox(
                height: 12,
              ),
              InkWell(
                onTap: signupuser,
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
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        )
                      : const Text('Sign Up'),
                ),
              ),
              Flexible(
                flex: 2,
                child: Container(),
              ),
              GestureDetector(
                onTap: navigatetologin,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: const Text(
                    'log in',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
