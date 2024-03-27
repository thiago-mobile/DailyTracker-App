import 'package:flutter/material.dart';
// ignore_for_file: file_names, override_on_non_overriding_member
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:desk_login/animations/load_screen.dart';
// import 'package:desk_login/pages/pages/profile_pages/clothes/clothes.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../SignIn/login.dart';
// import '../my_flutter_app_icons.dart';
// import '../pages/pages/menu/menu.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  //controladores para poder guardar variables
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final userController = TextEditingController();
  // final firebase = FirebaseFirestore.instance;

//metodos para constatar que se ingresen datos en los campos
  bool isFieldsCompleted() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final user = userController.text.trim();

    return user.isNotEmpty && email.isNotEmpty && password.isNotEmpty;
  }

  void validateFields() {
    setState(() {
      isButtonDisabled = !isFieldsCompleted();
    });
  }

  bool isButtonDisabled = true;

  @override
  bool isUsernameEmpty =
      false; // Variable para controlar si el campo de usuario está vacío

  // Función de validación personalizada para verificar si el nombre de usuario está vací

  @override
  void dispose() {
    userController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  final textFieldFocusNode = FocusNode();
  late bool _obscured = true;
  Color passwordColor = Colors.white;

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (textFieldFocusNode.hasPrimaryFocus) return;
      textFieldFocusNode.canRequestFocus = false;
    });
  }

//metodo para poder registrar el usuario en firebase

  // Future<void> registerUser() async {
  //   if (!isFieldsCompleted()) {
  //     print('Por favor completa todos los campos');
  //     return;
  //   }
  //   final email = emailController.text.trim();
  //   final password = passwordController.text.trim();
  //   final user = userController.text.trim();

  //   if (user.isEmpty || email.isEmpty || password.isEmpty) {
  //     print('Email, password or user is empty');
  //     return;
  //   }
  //   try {
  //     UserCredential userCredential =
  //         await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //     String uid = userCredential.user!.uid;

  //     saveUserData(uid, user, email, password);

  //     if (password.length < 8) {
  //       print('La contraseña debe tener al menos 8 caracteres');
  //       return;
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'weak-password') {
  //       print('La contraseña es demasiado débil');
  //     } else if (e.code == 'email-already-in-use') {
  //       print('El correo electrónico ya está en uso');
  //     } else {
  //       print('Error al registrar el usuario: ${e.message}');
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }

//variables

  bool isEmailFocused = false;
  bool isPasswordFocused = false;
  bool isNameFocused = false;
  // bool _isLoggingIn = false;
  int selectedContainer = -1;
  bool isPressed = false;
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFBABABA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 0,
                  ),
                  //Logo imagen
                  child: Image.asset(
                    'assets/Logo APP/logoficial.png',
                    height: MediaQuery.of(context).size.height * 0.35,
                    width: MediaQuery.of(context).size.width * 1,
                    fit: BoxFit.contain,
                  ),
                ),
                //texto registrarse
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.22,
                    left: MediaQuery.of(context).size.width * 0.0,
                  ),
                  child: Text(
                    "Registrarse",
                    style: TextStyle(
                      fontFamily: "JosefinSans-Bold",
                      fontSize: MediaQuery.of(context).size.width * 0.1,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            // Padding(
            //   padding: EdgeInsets.only(
            //     top: MediaQuery.of(context).size.height * 0.03,
            //     left: MediaQuery.of(context).size.width * 0.02,
            //     right: MediaQuery.of(context).size.width * 0.02,
            //   ),
            //   child: Container(
            //     child: const Text(
            //       'Registrate con algunos de los siguientes pasos.',
            //       style: TextStyle(
            //         color: Colors.white,
            //         fontSize: 17,
            //         fontFamily: 'JoseFinSans-Light',
            //       ),
            //     ),
            //   ),
            // ),

// // BOTONES DE FACE
//             Padding(
//               padding: EdgeInsets.symmetric(
//                 horizontal: MediaQuery.of(context).size.width * 0.16,
//                 vertical: MediaQuery.of(context).size.height * 0.001,
//               ),
//               child: Row(
//                 mainAxisAlignment:
//                     MainAxisAlignment.spaceBetween, // Separar los botones
//                 children: [
//                   GestureDetector(
//                     onTapDown: (_) {
//                       setState(() {
//                         selectedContainer = 0;
//                       });

//                       Future.delayed(const Duration(milliseconds: 400), () {
//                         setState(() {
//                           selectedContainer = -1;
//                         });
//                       });
//                     },
//                     child: Container(
//                       height: MediaQuery.of(context).size.height * 0.06,
//                       width: MediaQuery.of(context).size.width * 0.3,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(30),
//                         border: Border.all(
//                           color: selectedContainer == 0
//                               ? Colors.purple
//                               : Colors.grey,
//                           width: 2,
//                         ),
//                       ),
//                       child: IconButton(
//                         icon: const Icon(
//                           Icons.facebook,
//                           color: Colors.white,
//                           size: 27,
//                         ),
//                         onPressed: () {
//                           // Agrega tu lógica para el botón aquí
//                         },
//                       ),
//                     ),
//                   ),

// //BOTON GOOGLE
//                   GestureDetector(
//                     onTapDown: (_) {
//                       setState(() {
//                         selectedContainer = 1;
//                       });

//                       // Agrega tu lógica para el botón aquí

//                       Future.delayed(const Duration(milliseconds: 400), () {
//                         setState(() {
//                           selectedContainer = -1;
//                         });
//                       });
//                     },
//                     child: Container(
//                       height: MediaQuery.of(context).size.height * 0.06,
//                       width: MediaQuery.of(context).size.width * 0.3,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(30),
//                         border: Border.all(
//                           color: selectedContainer == 1
//                               ? Colors.purple
//                               : Colors.grey,
//                           width: 2,
//                         ),
//                       ),
//                       child: IconButton(
//                         icon: const Icon(
//                           MyFlutterApp.google,
//                           color: Colors.white,
//                           size: 20,
//                         ),
//                         onPressed: () {
//                           // signInWithGoogle();
//                         },
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(
//               height: 20,
//             ),

            // nombre TEXTO
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.0002,
                right: MediaQuery.of(context).size.width * 0.59,
                bottom: 6,
              ),
              child: const Text(
                "Nombre",
                style: TextStyle(
                  fontFamily: "JosefinSans-Medium",
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ),

            // nombre CAJA TEXTO
            Padding(
              padding: const EdgeInsets.only(
                right: 20,
                left: 20,
                top: 0,
                bottom: 20,
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.065,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color:
                        isNameFocused ? const Color(0xffC44BC1) : Colors.grey,
                    width: 2,
                  ),
                ),
                child: TextField(
                  controller: userController,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'JosefinSans-Regular',
                    fontSize: 17,
                  ),
                  onTap: () {
                    setState(() {
                      isNameFocused = true;
                      isEmailFocused = false;
                      isPasswordFocused = false;
                    });
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 24),
                    border: InputBorder.none,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                      ),
                      child: Icon(
                        Icons.person,
                        color: isNameFocused
                            ? const Color(0xffC44BC1)
                            : Colors.grey,
                      ),
                    ),
                    hintStyle: const TextStyle(
                      fontFamily: 'JosefinSans-Thin',
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  onChanged: (_) {
                    validateFields();
                  },
                ),
              ),
            ),

//TEXTO EMAIL
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.00,
                right: MediaQuery.of(context).size.width * 0.63,
                bottom: MediaQuery.of(context).size.height * 0.0013,
              ),
              child: const Text(
                "Email",
                style: TextStyle(
                  fontFamily: "JosefinSans-Medium",
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),

// Correo electrónico CAJA TEXTO
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
                vertical: MediaQuery.of(context).size.height * 0.009,
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.065,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color:
                        isEmailFocused ? const Color(0xffC44BC1) : Colors.grey,
                    width: 2,
                  ),
                ),
                child: TextField(
                  controller: emailController,
                  onTap: () {
                    setState(() {
                      isNameFocused = false;
                      isEmailFocused = true;
                      isPasswordFocused = false;
                    });
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.017,
                    ),
                    border: InputBorder.none,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                      ),
                      child: Icon(
                        Icons.email_rounded,
                        color: isEmailFocused ? Colors.purple : Colors.grey,
                        size: 20,
                      ),
                    ),
                    hintStyle: TextStyle(
                      fontFamily: 'JosefinSans-Thin',
                      fontSize: MediaQuery.of(context).size.width * 0.033,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),

// Contraseña TEXTO
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.02,
                right: MediaQuery.of(context).size.width * 0.53,
                bottom: MediaQuery.of(context).size.height * 0.005,
              ),
              child: const Text(
                "Contraseña",
                style: TextStyle(
                  fontFamily: "JosefinSans-Medium",
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ),

// Contraseña CAJA TEXTO
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
                vertical: MediaQuery.of(context).size.height * 0.002,
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.065,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: isPasswordFocused
                        ? const Color(0xffC44BC1)
                        : const Color(0xFF9E9E9E),
                    width: 2,
                  ),
                ),
                child: TextField(
                  controller: passwordController,
                  enableInteractiveSelection: false,
                  obscureText: _obscured,
                  focusNode: textFieldFocusNode,
                  keyboardType: TextInputType.visiblePassword,
                  onTap: () {
                    setState(() {
                      isNameFocused = false;
                      isEmailFocused = false;
                      isPasswordFocused = true;
                    });
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.024,
                    ),
                    border: InputBorder.none,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                      ),
                      child: Icon(
                        Icons.lock,
                        color: isPasswordFocused
                            ? Colors.purple
                            : const Color.fromRGBO(158, 158, 158, 1),
                        size: 20,
                      ),
                    ),
                    hintStyle: TextStyle(
                      fontFamily: 'JosefinSans-Thin',
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      color: Colors.white,
                    ),
                    suffixIcon: Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.001,
                      ),
                      child: GestureDetector(
                        onTap: _toggleObscured,
                        child: Icon(
                          _obscured
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded,
                          size: MediaQuery.of(context).size.width * 0.05,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),

//BOTON DE REGISTRARSE
            GestureDetector(
              onTapDown: (_) {
                setState(() {
                  isPressed = true;
                });
              },
              onTapUp: (_) {
                setState(() {
                  isPressed = false;
                });
              },
              onTapCancel: () {
                setState(() {
                  isPressed = false;
                });
              },
              // onTap: () async {
              //   try {
              //     // Show CircularProgressIndicator
              //     setState(() {
              //       _isLoggingIn = true;
              //     });
              //     await registerUser();
              //   } 
              //   catch (e) {
              //     // Manejar la excepción aquí, puedes mostrar un mensaje de error
              //     // al usuario o realizar alguna otra acción.
              //     print('Error de inicio de sesión: $e');
              //   } finally {
              //     // Hide CircularProgressIndicator
              //     setState(() {
              //       _isLoggingIn = false;
              //     });
              //   }
              // },
              child: Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.05,
                  right: MediaQuery.of(context).size.width * 0.02,
                  left: MediaQuery.of(context).size.width * 0.02,
                  bottom: 0,
                ),
                child: FractionallySizedBox(
                  widthFactor: 0.8,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.07,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: <Color>[
                          Color(0xFFDD50DB),
                          Color(0xFF730A7C),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: isPressed
                          ? [
                              BoxShadow(
                                color: Colors.purple.withOpacity(0.7),
                                spreadRadius: 2,
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : null,
                    ),
                    // child: Center(
                    //   child: Padding(
                    //     padding: EdgeInsets.only(
                    //       top: MediaQuery.of(context).size.height * 0.003,
                    //     ),
                    //     child: _isLoggingIn
                    //         ? const CircularProgressIndicator(
                    //             valueColor:
                    //                 AlwaysStoppedAnimation<Color>(Colors.white),
                    //           )
                    //         : Text(
                    //             'Registrarse',
                    //             style: TextStyle(
                    //               fontFamily: 'JosefinSans-SemiBold',
                    //               fontSize:
                    //                   MediaQuery.of(context).size.width * 0.053,
                    //               color: Colors.white,
                    //             ),
                    //           ),
                    //   ),
                    // ),
                  ),
                ),
              ),
            ),

// no tenes cuenta TEXTO
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.02,
                  ),
                  child: const Text(
                    "Ya tenes una cuenta?",
                    style: TextStyle(
                      fontFamily: "JosefinSans-Regular",
                      fontSize: 17,
                      color: Colors.black,
                    ),
                  ),
                ),

//BOTON DE INICIAR SESION
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(
                            milliseconds: 500), // Duración de la animación
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const SignUp(),// Página de destino
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          // Personaliza la animación aquí
                          var begin = const Offset(-1.0,
                              0.0); // Posición inicial de la página de destino
                          var end = Offset
                              .zero; // Posición final de la página de destino
                          var curve = Curves
                              .ease; // Curva de animación (puede usar otras como Curves.easeInOut)

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));

                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 4,
                      top: MediaQuery.of(context).size.height * 0.02,
                    ), // Espacio entre textos
                    child: const Text(
                      'Iniciar Sesion',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'JoseFinSans-Bold',
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// //COLECCION  DE FIREBASE PARA CREAR EL USUARIO Y GUARDAR SUS DATOS
// void saveUserData(String uid, String name, String email, String password) {
//   FirebaseFirestore firestore = FirebaseFirestore.instance;

//   firestore
//       .collection('users')
//       .doc(uid) // Use the UID as the document ID
//       .set({
//         'name': name,
//         'email': email,
//         'password': password,
//       })
//       .then((value) => print("Datos guardados correctamente"))
//       .catchError((error) => print("Error al guardar los datos: $error"));
// }