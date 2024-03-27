import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  String resetError = '';
  bool isEmailError = false;

  final TextEditingController email = TextEditingController();

  void _resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);

      // Mostrar mensaje de éxito o redirigir a una pantalla de éxito
      // Por ejemplo, puedes mostrar un AlertDialog o navegar a otra pantalla.
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Éxito'),
            content: Text(
                'Se ha enviado un correo electrónico para restablecer la contraseña.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Aceptar'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      setState(() {
        resetError =
            'Error al enviar el correo electrónico de restablecimiento: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1b1b1b),
      appBar: AppBar(
        backgroundColor: Color(0xff1b1b1b),
        elevation: 0,
        title: Text(
          'Restablecer Contraseña',
          style: TextStyle(fontFamily: 'JoseFinSans-Regular'),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  top: 50,
                ),
                child: Image.asset('assets/Iconos/candado.png',
                    width: 80, height: 80, fit: BoxFit.contain),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 30,
                ),
                child: Text(
                  'Ingrese su correo electrónico para restablecer la contraseña:',
                  style: TextStyle(
                      fontFamily: 'JoseFinSans-Regular',
                      fontSize: 16,
                      color: Colors.white),
                ),
              ),
              SizedBox(height: 30),
              Container(
                width: 340,
                height: 60,
                decoration: BoxDecoration(
                  color: Color.fromARGB(
                      255, 236, 236, 236), // Color de fondo del contenedor
                  borderRadius:
                      BorderRadius.circular(10), // Radio de borde circular
                ),
                child: TextField(
                  controller: email,
                  decoration: const InputDecoration(
                    hintText: 'Escribe tu correo electrónico...',
                    hintStyle: TextStyle(
                        fontFamily: 'JoseFinSans-SemiBold',
                        color: Colors
                            .grey), // Cambia el texto del hint según tus necesidades
                    contentPadding: EdgeInsets.only(
                      top: 10,
                      left: 20,
                    ), // Ajusta el relleno interno
                    border: InputBorder.none, // Elimina el borde del TextField
                  ),
                ),
              ),
              if (isEmailError)
                const Text(
                  'Correo incorrecto o no registrado',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  _resetPassword();
                },
                child: Container(
                  width: 200,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(0xffB3DA1F), // Color de fondo del contenedor
                    borderRadius:
                        BorderRadius.circular(20), // Radio de borde circular
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 15,
                      left: 50,
                    ),
                    child: Text(
                      'Restablecer',
                      style: TextStyle(
                          fontFamily: 'JoseFinSans-SemiBold',
                          color: Colors.white,
                          fontSize: 19),
                    ),
                  ),
                ),
              ),
              if (resetError.isNotEmpty)
                Text(
                  resetError,
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
