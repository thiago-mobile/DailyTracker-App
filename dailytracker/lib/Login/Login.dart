// ignore_for_file: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dailytracker/Register/Register.dart';
import 'package:dailytracker/home.dart';
import 'package:dailytracker/premios.dart';
import 'package:dailytracker/reestablecer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String loginError = '';
  bool isEmailError = false;
  bool isPasswordError = false;
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool isLEmailFocused = false;
  bool isLPasswordFocused = false;
  late bool _obscured = true;
  final passwordController = TextEditingController();
  final textFieldFocusNode = FocusNode();
  // bool _isLoggingIn = false; borrar si no es usada
  int selectedContainer = -1;
  bool isPressed = false;
  bool isHovered = false;
  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (textFieldFocusNode.hasPrimaryFocus) return;
      textFieldFocusNode.canRequestFocus = false;
    });
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Guarda los datos del usuario en Firestore
      String userId = userCredential.user!.uid;
      FirebaseFirestore.instance.collection('users').doc(userId).set({
        'email': email,
        'password': password,
        // Agrega aquí otros campos que quieras guardar
      });
      print('Inicio de sesión exitoso');
    } catch (e) {
      print('Error de inicio de sesión: $e');
    }
  }

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
                  'Iniciar Sesión',
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
                top: MediaQuery.of(context).size.height * 0.07,
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
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: isLEmailFocused
                            ? const Color(0xFFB3DA1F)
                            : (Color(0xFF363636)),
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: email,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'JosefinSans-Regular',
                        fontSize: 17,
                      ),
                      onTap: () {
                        setState(() {
                          isLEmailFocused = true;
                          isLPasswordFocused = false;
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
                          padding: EdgeInsets.only(
                            left: 10,
                          ),
                          child: Icon(
                            Icons.email,
                            color: Color(0xFFB3DA1F),
                          ),
                        ),
                        hintStyle: const TextStyle(
                          fontFamily: 'JosefinSans-Thin',
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      onChanged: (_) {
                        // Puedes agregar validación personalizada aquí si es necesario.
                      },
                    ),
                  ),
                  // Mensaje de error debajo del campo
                  if (isEmailError)
                    Padding(
                      padding: const EdgeInsets.only(top: 8, left: 8),
                      child: Text(
                        'Correo incorrecto o no registrado',
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
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.070,
                decoration: BoxDecoration(
                  color: const Color(0xFF363636),
                  border: Border.all(
                    color: isLPasswordFocused
                        ? const Color(0xFFB3DA1F)
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
                      isLEmailFocused = false;
                      isLPasswordFocused = true;
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
                        size: 20,
                        color: Color(0xFFB3DA1F),
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
                          color: Color(0xFFB3DA1F),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.010,
                    left: 150,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ResetPasswordPage()));
                    },
                    child: const Text(
                      "¿Olvidaste tu contraseña?",
                      style: TextStyle(
                        fontFamily: "JosefinSans-SemiBold",
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),

//Iniciar sesion BOTON
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
              onTap: () async {
                if (email.text.isEmpty || password.text.isEmpty) {
                  // Validación para campos vacíos
                  setState(() {
                    isEmailError = email.text.isEmpty;
                    isPasswordError = password.text.isEmpty;
                    loginError = 'Por favor, completa todos los campos.';
                  });
                } else {
                  try {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: email.text.trim(),
                      password: password.text.trim(),
                    );

                    // Redirige al usuario a la pantalla de MyMenu
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  } catch (e) {
                    // Manejar la excepción aquí, puedes mostrar un mensaje de error
                    // al usuario o realizar alguna otra acción.
                    print('Error de inicio de sesión: $e');
                    setState(() {
                      loginError = 'Error de inicio de sesión: $e';
                    });
                  } finally {
                    // Hide CircularProgressIndicator
                  }
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
                        child: Text(
                          'Iniciar Sesión',
                          style: TextStyle(
                            fontFamily: 'JosefinSans-SemiBold',
                            fontSize: MediaQuery.of(context).size.width * 0.053,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

// Mostrar el mensaje de error
            if (loginError.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  "Error de Inicio de sesion, verifique los campos",
                  style: TextStyle(
                    color: Colors.red,
                    fontFamily: 'JosefinSans-Regular',
                    fontSize: 14,
                  ),
                ),
              ),

//Aun no tienes una cuenta TEXTO
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.05,
                  ),
                  child: const Text(
                    "¿Aún no tienes una cuenta?",
                    style: TextStyle(
                      fontFamily: "JosefinSans-SemiBold",
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

//Registrarse BTN - TXT
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterPage()));
              },
              child: Padding(
                padding: EdgeInsets.only(
                  left: 4,
                  top: MediaQuery.of(context).size.height * 0.02,
                ), // Espacio entre textos
                child: const Text(
                  'Registrarse',
                  style: TextStyle(
                    color: Color(0xFFA0CE5E),
                    fontFamily: 'JoseFinSans-Bold',
                    fontSize: 17,
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
