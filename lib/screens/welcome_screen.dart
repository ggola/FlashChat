import 'package:flutter/material.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/utilities/action_button.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animationColor;
  Animation animationIconSize;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
      upperBound: 1.0,
    );
    // Curved animation on icon
    animationIconSize =
        CurvedAnimation(parent: controller, curve: Curves.decelerate);
    // Color tween animation for background color
    animationColor = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(controller);
    // Start the animation
    controller.forward();
    // Manages the state: animation_.value is automatically passed
    controller.addListener(() {
      setState(() {});
    });
  }

  // Dispose: stop animation when the view is about to be disposed
  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animationColor.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: animationIconSize.value * 60.0,
                  ),
                ),
                // Pre-packaged animation
                TypewriterAnimatedTextKit(
                  // takes String array for multi-line
                  text: [
                    'Flash Chat',
                  ],
                  duration: Duration(seconds: 5),
                  isRepeatingAnimation: true,
                  textStyle: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            ActionButton(
              color: Colors.lightBlueAccent,
              text: 'Log in',
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            ActionButton(
              color: Colors.blueAccent,
              text: 'Register',
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
            )
          ],
        ),
      ),
    );
  }
}
