import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lms_app/Pages/login_screen.dart';
import 'package:lms_app/Providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

class signUpScreen extends StatefulWidget {
  const signUpScreen({super.key});

  @override
  State<signUpScreen> createState() => _signUpScreenState();
}

class _signUpScreenState extends State<signUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPwdController = TextEditingController();
  bool passwordVisible = true;
  bool passwordVisibleC = true;

  String _role = 'student';
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.width / 4,
                right: 20,
                left: 20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              //SignupHeaderWidget(),
              Column(
                children: [
                  // header
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                              fontSize: 25,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontWeight: FontWeight.bold),
                        )),
                  ),
                  // SignupForm(),
                  Form(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 50,
                            child: TextFormField(
                              cursorColor: Colors.blue,
                              controller: _nameController,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                hintText: "Your name here",
                                hintStyle: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: GoogleFonts.poppins()
                                      .fontFamily, // Set the font family
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 50,
                            child: TextFormField(
                              cursorColor: Colors.blue,
                              controller: _emailController,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                hintText: "Your email here",
                                hintStyle: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: GoogleFonts.poppins()
                                      .fontFamily, // Set the font family
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 50,
                            child: TextFormField(
                              cursorColor: Colors.blue,
                              controller: _passwordController,
                              obscureText: true,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                hintText: "Your password here",
                                hintStyle: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: GoogleFonts.poppins()
                                      .fontFamily, // Set the font family
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 50,
                            child: TextFormField(
                              cursorColor: Colors.blue,
                              controller: _confirmPwdController,
                              obscureText: true,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                hintText: "Confirmed password here",
                                hintStyle: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: GoogleFonts.poppins()
                                      .fontFamily, // Set the font family
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          /////////////////////////////////////////////////////

                          ToggleSwitch(
                            minWidth: MediaQuery.of(context).size.width / 1.8,
                            minHeight: 60,
                            cornerRadius: 60,
                            fontSize: 15,
                            iconSize: 16,
                            activeBgColors: const [
                              [Colors.black],
                              [Colors.black]
                            ],
                            activeFgColor: Colors.white,
                            inactiveBgColor: Colors.white,
                            inactiveFgColor: Colors.black,
                            totalSwitches: 2,
                            labels: ['Instructor', 'Student'],
                            initialLabelIndex: _role == "Instructor" ? 0 : 1,
                            onToggle: (index) {
                              setState(() {
                                _role = index == 0 ? "instructor" : "student";
                              });
                            },
                          ),
                          const SizedBox(
                            height: 25,
                          ),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30))),
                                  fixedSize: const Size.fromHeight(60),
                                  backgroundColor: Colors.black,
                                ),
                                onPressed: () async {
                                  try {
                                    await userProvider.register(
                                      _nameController.text,
                                      _emailController.text,
                                      _passwordController.text,
                                      _role,
                                    );

                                    Navigator.of(context)
                                        .pushReplacementNamed('/home');
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text('Failed to sign up')),
                                    );
                                  }
                                },
                                child: Text(
                                  "Sign Up",
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                )),
                          )
                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    height: MediaQuery.of(context).size.width / 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Do you have an Account ?"),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const loginScreen()), // signup page
                                );
                              },
                              child: Text(
                                'Sign In',
                                style: GoogleFonts.poppins(
                                    color: Color(0xFF3182CE),
                                    fontWeight: FontWeight.w500),
                              )),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ])),
      ),
    ));
  }
}
