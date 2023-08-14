import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import './home_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  int usernameLength = 0;
  int emailLength = 0;
  int passwordLength = 0;

  bool isPassword = true;

  @override
  void initState() {
    super.initState();
    usernameController.addListener(() {
      setState(() {
        usernameLength = usernameController.text.length;
      });
    });
    emailController.addListener(() {
      setState(() {
        emailLength = emailController.text.length;
      });
    });
    passwordController.addListener(() {
      setState(() {
        passwordLength = passwordController.text.length;
      });
    });
  }
 
  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void signUp() async {
    
    try {
 
      formKey.currentState?.save();

      if (formKey.currentState!.validate()) {
        if (EmailValidator.validate(emailController.text)) {
          await ref.read(authProvider.notifier).signUp(usernameController.text, emailController.text, passwordController.text);

          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (ctx) => const HomeScreen()
              )
            );
          }
        } else {
          MotionToast.error(
            animationType: AnimationType.fromLeft,
            enableAnimation: false,
            title: const Text(
              'Error!',
              style: TextStyle(
                fontWeight: FontWeight.bold
              ),
            ),
            description: const Text('Please enter a valid email!'),
          ).show(context);
        }

      }

    } catch(error) {
      MotionToast.error(
        animationType: AnimationType.fromLeft,
        enableAnimation: false,
        title: const Text(
          'Error!',
          style: TextStyle(
            fontWeight: FontWeight.bold
          ),
        ),
        description: const Text('Unexpected error!'),
      ).show(context);
    }
  }

  void signIn() async {
    try { 
      formKey.currentState?.validate();

      if (formKey.currentState!.validate()) {

        if (EmailValidator.validate(emailController.text)) {
          await ref.read(authProvider.notifier).signIn(emailController.text, passwordController.text);

          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (ctx) => const HomeScreen()
              )
            );
          }
        } else {
          MotionToast.error(
            animationType: AnimationType.fromLeft,
            enableAnimation: false,
            title: const Text(
              'Error!',
              style: TextStyle(
                fontWeight: FontWeight.bold
              ),
            ),
            description: const Text('Please enter a valid email!'),
          ).show(context);
        }
      }

    } catch(error) {
      MotionToast.error(
        animationType: AnimationType.fromLeft,
        enableAnimation: false,
        title: const Text(
          'Error',
          style: TextStyle(
            fontWeight: FontWeight.bold
          ),
        ),
        description: const Text('Unexpected error!'),
      ).show(context);
    }


  }

  final formKey = GlobalKey<FormState>();

  bool _isRegister = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/podcastbg.jpeg'),
            fit: BoxFit.cover
          )
        ),
        child: Container(
          color: Colors.black.withOpacity(0.5),
          child: Center(
            child: Column(
              children: [
                const Spacer(),
                SingleChildScrollView(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0)
                      )
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 48),
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 10,),
                            Text(
                              _isRegister ? 'Register' : 'Login',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22
                              ),
                            ),
                            const SizedBox(height: 10,),
                            if (_isRegister)
                              TextFormField(
                                controller: usernameController,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.person_outline_rounded),
                                  suffixIcon: usernameLength > 0 ? IconButton(
                                    onPressed: () {
                                      usernameController.text = '';
                                    },
                                    icon: SvgPicture.asset(
                                      'assets/icons/close.svg',
                                      width: 24,
                                    ),
                                  ) : null,
                                  label: const Text('Username'),
                                  hintText: 'Enter your username',
                                ),
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                              ),
                            if (_isRegister)
                              const SizedBox(height: 10,),
                            TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                
                                prefixIcon: const Icon(Icons.email_outlined),
                                suffixIcon: emailLength > 0 ? IconButton(
                                  onPressed: () {
                                    emailController.text = '';
                                  },
                                  icon: SvgPicture.asset(
                                    'assets/icons/close.svg',
                                    width: 24,
                                  ),
                                ) : null,
                                label: const Text('Email'),
                                hintText: 'Enter your email',
                              ),
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 10,),
                            TextFormField(
                              controller: passwordController,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.lock_outline_rounded),
                                suffixIcon: passwordLength > 0 ? IconButton(
                                  onPressed: () {
                                    passwordController.text = '';
                                  },
                                  icon: SvgPicture.asset(
                                    'assets/icons/close.svg',
                                    width: 24,
                                  ),
                                ) : IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isPassword = !isPassword;
                                    });
                                  },
                                  icon: Icon(isPassword ? Icons.visibility : Icons.visibility_off),
                                ),
                                label: const Text('Password'),
                                hintText: 'Enter your password',
                              ),
                              obscureText: isPassword,
                              keyboardType: TextInputType.visiblePassword,
                              textInputAction: TextInputAction.done,
                            ),
                            const SizedBox(height: 10,),
                            ElevatedButton(
                              onPressed: _isRegister ? signUp : signIn,
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                                padding: const EdgeInsets.symmetric(vertical: 16)
                              ),
                              child: Text(_isRegister ? 'Sign Up' : 'Sign In'),
                            ),
                            const SizedBox(height: 10,),
                            OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  _isRegister = !_isRegister;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                                padding: const EdgeInsets.symmetric(vertical: 16)
                              ),
                              child: Text(_isRegister ? 'Sign In' : 'Sign Up'),
                            ),
                      
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ),
        ),
      ),
    );
  }
}