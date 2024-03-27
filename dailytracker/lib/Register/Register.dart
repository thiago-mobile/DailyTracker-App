// ignore_for_file: file_names
import 'package:dailytracker/Login/Login.dart';
import 'package:dailytracker/home.dart';
import 'package:dailytracker/premios.dart';
import 'package:dailytracker/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final RegExp emailRegExp =
      RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)*(\.[a-z]{2,4})$');
  bool isEmailFormatError = false;
  bool isEmailInUseError = false;
  bool isPasswordWeak = false;
  bool _isWeakPassword(String password) {
    final RegExp passwordRegExp =
        RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$');
    return !passwordRegExp.hasMatch(password);
  }

  bool isPasswordError = false;
  bool isRepeatPasswordError = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final firebase = FirebaseFirestore.instance;

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  bool isRegistering = false;
  bool isREmailFocused = false;
  bool isRPasswordFocused = false;
  bool isRepeatPasswordFocused = false;
  bool isRPressed = false;
  bool isLoggingIn = false;
  bool isEmailFieldEmpty = true;
  bool isPasswordFieldEmpty = true;

  Future<void> registerUser() async {
    if (_isWeakPassword(password.text)) {
      setState(() {
        isPasswordWeak = true;
      });
      return;
    }
    checkPasswordsMatching(); // Verifica si las contraseñas coinciden

    if (!mounted) {
      return; // Check if the widget is still mounted
    }
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );

      final User? user = userCredential.user;
      if (user != null) {
        await firebase.collection('Usuarios').doc(user.uid).set({
          "Correo": email.text,
          "Contraseña": password.text,
          // Puedes agregar más campos aquí si lo necesitas
        });

        // Usuario registrado y datos guardados in Firestore
        // Puedes navegar a la página de inicio u otra página aquí
      }
    } catch (e) {
      print('Error de registro: $e');
      if (e is FirebaseAuthException) {
        if (e.code == 'email-already-in-use') {
          if (mounted) {
            setState(() {
              isEmailInUseError = true;
            });
          }
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          isRegistering = false;
        });
      }
    }
  }

  final TextEditingController repeatPassword = TextEditingController();
  final textFieldFocusNode = FocusNode();
  late bool _obscured = true;
  bool arePasswordsMatching = false;
  void checkPasswordsMatching() {
    setState(() {
      arePasswordsMatching = password.text == repeatPassword.text;
    });
  }

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (textFieldFocusNode.hasPrimaryFocus) return;
      textFieldFocusNode.canRequestFocus = false;
    });
  }
  // bool _isLoggingIn = false; borrar si no es usada

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1B1B),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //foto LOGO
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.05,
                left: 10,
              ),
              child: Center(
                child: Image.asset(
                  'assets/Iconos/ic_launcher.png',
                  height: MediaQuery.of(context).size.height * 0.20,
                  width: MediaQuery.of(context).size.width * 0.35,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            //Regístrate y empieza a seguir tu salud día a día
            Center(
              child: Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.04,
                ),
                child: Text(
                  'Registrarse',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'JosefinSans-Bold',
                    fontSize: MediaQuery.of(context).size.width * 0.09,
                  ),
                ),
              ),
            ),

            //Correo TEXTO
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.04,
                right: MediaQuery.of(context).size.width * 0.35,
                bottom: 6,
              ),
              child: const Text(
                "Correo Electrónico",
                style: TextStyle(
                  fontFamily: "JosefinSans-SemiBold",
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ),

            //Correo CONTAINER
            Padding(
              padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.04,
                left: MediaQuery.of(context).size.width * 0.04,
                top: MediaQuery.of(context).size.height * 0,
                bottom: MediaQuery.of(context).size.height * 0.005,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.070,
                    decoration: BoxDecoration(
                      color: const Color(0xFF363636),
                      border: Border.all(
                        color: isREmailFocused
                            ? const Color(0xFFB3DA1F)
                            : (Color(0xFF363636)),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: TextField(
                        controller: email,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'JosefinSans-Regular',
                          fontSize: 17,
                        ),
                        onTap: () {
                          setState(() {
                            isREmailFocused = true;
                            isRPasswordFocused = false;
                            isRepeatPasswordFocused = false;
                          });
                        },
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 20),
                          border: InputBorder.none,
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Icon(
                              Icons.email,
                              color: Color(0xFFB3DA1F),
                            ),
                          ),
                          hintText: 'pepe@gmail.com...', // Texto guía
                          hintStyle: const TextStyle(
                            fontFamily: 'JosefinSans-Regular',
                            fontSize: 16,
                            color: Color(0xFF797979), // Color del texto guía
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            isEmailFieldEmpty = value.isEmpty;
                            isEmailFormatError = !emailRegExp.hasMatch(value);
                          });
                        },
                      ),
                    ),
                  ),
                  // Mensaje de error debajo del campo
                  if (isEmailFieldEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8, left: 8),
                      child: Text(
                        'Este campo es obligatorio',
                        style: TextStyle(
                          color: Colors.red,
                          fontFamily: 'JosefinSans-Regular',
                          fontSize: 12,
                        ),
                      ),
                    )
                  else if (isEmailFormatError)
                    Padding(
                      padding: const EdgeInsets.only(top: 8, left: 8),
                      child: Text(
                        'Formato incorrecto...',
                        style: TextStyle(
                          color: Colors.red,
                          fontFamily: 'JosefinSans-Regular',
                          fontSize: 12,
                        ),
                      ),
                    )
                  else if (isEmailInUseError)
                    Padding(
                      padding: const EdgeInsets.only(top: 8, left: 8),
                      child: Text(
                        'El correo electrónico ya está en uso',
                        style: TextStyle(
                          color: Colors.red,
                          fontFamily: 'JosefinSans-Regular',
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            //Contrasena TEXTO
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.03,
                right: MediaQuery.of(context).size.width * 0.47,
                bottom: MediaQuery.of(context).size.height * 0.005,
              ),
              child: const Text(
                "Contraseña",
                style: TextStyle(
                  fontFamily: "JosefinSans-SemiBold",
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ),

            //Contrasena CONTAINER
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
                vertical: MediaQuery.of(context).size.height * 0.002,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.070,
                    decoration: BoxDecoration(
                      color: const Color(0xFF363636),
                      border: Border.all(
                        color: isRPasswordFocused
                            ? isPasswordError
                                ? Colors.red
                                : const Color(0xFFB3DA1F)
                            : (Color(0xFF363636)),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      controller: password,
                      enableInteractiveSelection: false,
                      obscureText: _obscured,
                      focusNode: textFieldFocusNode,
                      keyboardType: TextInputType.visiblePassword,
                      onTap: () {
                        setState(() {
                          isREmailFocused = false;
                          isRPasswordFocused = true;
                          isRepeatPasswordFocused = false;
                        });
                      },
                      onChanged: (value) {
                        setState(() {
                          isPasswordFieldEmpty = value.isEmpty;
                          isPasswordError = _isWeakPassword(value);
                        });
                      },
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.020,
                        ),
                        border: InputBorder.none,
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(
                            left: 10,
                          ),
                          child: Icon(
                            Icons.lock,
                            color: isRPasswordFocused
                                ? isPasswordError
                                    ? Colors.red
                                    : const Color(0xFFB3DA1F)
                                : const Color(0xFFB3DA1F),
                            size: 20,
                          ),
                        ),
                        hintStyle: TextStyle(
                          fontFamily: 'JosefinSans-SemiBold',
                          fontSize: 20,
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
                              color: Color(0xFFB3DA1F),
                            ),
                          ),
                        ),
                      ),
                      style: const TextStyle(
                        fontFamily: 'JoseFinSans-SemiBold',
                        color: Colors.white,
                      ),
                    ),
                  ),
                  // Mensaje de error debajo del campo
                  if (isPasswordError)
                    Padding(
                      padding: EdgeInsets.only(
                        top: 4,
                        left: 12,
                      ),
                      child: Text(
                        'La contraseña debe tener al menos 6 caracteres y algun número.',
                        style: TextStyle(
                          color: Colors.red,
                          fontFamily: 'JosefinSans-Regular',
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            //Repetir contrasena TEXTO
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.03,
                right: MediaQuery.of(context).size.width * 0.30,
                bottom: MediaQuery.of(context).size.height * 0.005,
              ),
              child: const Text(
                "Repita su Contraseña",
                style: TextStyle(
                  fontFamily: "JosefinSans-SemiBold",
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ),

            //Repetir contrasena CONTAINER
            Padding(
              padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.04,
                left: MediaQuery.of(context).size.width * 0.04,
                top: MediaQuery.of(context).size.height * 0,
                bottom: MediaQuery.of(context).size.height * 0.005,
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.070,
                decoration: BoxDecoration(
                  color: const Color(0xFF363636),
                  border: Border.all(
                    color: isRepeatPasswordFocused
                        ? isRepeatPasswordError
                            ? Colors.red
                            : const Color(0xFFB3DA1F)
                        : (Color(0xFF363636)),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'JosefinSans-Regular',
                    fontSize: 17,
                  ),
                  onTap: () {
                    setState(() {
                      isREmailFocused = false;
                      isRPasswordFocused = false;
                      isRepeatPasswordFocused = true;
                    });
                  },
                  onChanged: (value) {
                    setState(() {
                      isRepeatPasswordError = value != password.text;
                      isPasswordFieldEmpty = value.isEmpty;
                      isPasswordWeak = _isWeakPassword(value);
                    });
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.020,
                    ),
                    border: InputBorder.none,
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(
                        left: 10,
                      ),
                      child: Icon(
                        Icons.lock,
                        color: Color(0xFFB3DA1F),
                      ),
                    ),
                    hintStyle: const TextStyle(
                      fontFamily: 'JosefinSans-Thin',
                      fontSize: 20,
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
                          color: Color(0xFFB3DA1F),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
// Mensaje de error debajo del campo de repetir contraseña
            if (isRepeatPasswordError)
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 8),
                child: Text(
                  'Las contraseñas no coinciden',
                  style: TextStyle(
                    color: Colors.red,
                    fontFamily: 'JosefinSans-Regular',
                    fontSize: 12,
                  ),
                ),
              ),

            //Registrarse BOTON
            GestureDetector(
              onTapDown: (_) {
                setState(() {
                  isRPressed = true;
                });
              },
              onTapUp: (_) {
                setState(() {
                  isRPressed = false;
                });
              },
              onTapCancel: () {
                setState(() {
                  isRPressed = false;
                });
              },
              onTap: () async {
                if (!isEmailFieldEmpty && !isPasswordFieldEmpty) {
                  try {
                    // Show CircularProgressIndicator
                    setState(() {
                      isLoggingIn = true;
                    });

                    await registerUser();

                    // Only navigate if registration is successful
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  } catch (e) {
                    // Handle the exception here, you can show an error message to the user.
                    print('Error de inicio de sesión: $e');
                  } finally {
                    // Hide CircularProgressIndicator
                    setState(() {
                      isLoggingIn = false;
                    });
                  }
                } else {
                  // Show a SnackBar if the fields are not complete
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in all the fields.'),
                    ),
                  );
                }
              },
              child: Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.04,
                  right: MediaQuery.of(context).size.width * 0.02,
                  left: MediaQuery.of(context).size.width * 0.02,
                  bottom: 0,
                ),
                child: FractionallySizedBox(
                  widthFactor: 0.8,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.070,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: <Color>[
                          Color(0xFFACC44C),
                          Color(0xFF2ED835),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFA0CE5E)
                              .withOpacity(0.4), // Color de la sombra
                          spreadRadius: 2, // Radio de propagación de la sombra
                          blurRadius: 20, // Radio de desenfoque de la sombra
                          offset: const Offset(0,
                              4), // Desplazamiento de la sombra en coordenadas X e Y
                        ),
                      ],
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.003,
                        ),
                        child: isRegistering
                            ? const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              )
                            : Text(
                                'Registrarse',
                                style: TextStyle(
                                  fontFamily: 'JosefinSans-SemiBold',
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.053,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            //Ya tienes una cuenta TEXTO
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.03,
                  ),
                  child: const Text(
                    "¿Ya tienes una cuenta?",
                    style: TextStyle(
                        fontFamily: "JosefinSans-SemiBold",
                        fontSize: 15,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
            //Iniciar sesion BTN - TXT
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              },
              child: Padding(
                padding: EdgeInsets.only(
                  left: 4,
                  top: MediaQuery.of(context).size.height * 0.01,
                ), // Espacio entre textos
                child: const Text(
                  'Iniciar Sesion',
                  style: TextStyle(
                    color: Color(0xFFA0CE5E),
                    fontFamily: 'JoseFinSans-Bold',
                    fontSize: 19,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

  // void saveUserData(String uid, String email, String password) {
  //   FirebaseFirestore firestore = FirebaseFirestore.instance;

  //   firestore
  //       .collection('users')
  //       .doc(uid) // Use the UID as the document ID
  //       .set({
  //         'email': email,
  //         'password': password,
  //       })
  //       .then((value) => print("Datos guardados correctamente"))
  //       .catchError((error) => print("Error al guardar los datos: $error"));
  // }
