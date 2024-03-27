import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dailytracker/Login/Login.dart';
import 'package:dailytracker/settings.dart';
import 'package:flutter/material.dart';

class PrivacidadSeguridad extends StatefulWidget {
  const PrivacidadSeguridad({super.key});

  @override
  State<PrivacidadSeguridad> createState() => _PrivacidadSeguridadState();
}

class _PrivacidadSeguridadState extends State<PrivacidadSeguridad> {
  bool isNotificationsEnabled = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(
              context,
              MaterialPageRoute(builder: (context) => SettingsPage()),
            );
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        backgroundColor: Color(0xff222222),
      ),
      backgroundColor: Color(0xff222222),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 10,
              left: 20,
            ),
            child: Text(
              'Seguridad y Privacidad',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontFamily: 'JoseFinSans-Regular',
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => ProfilePage()),
              // );
            },
            child: Container(
              width: 370,
              height: 200,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 48, 48, 48),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                // Cambiamos de Row a Column
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      // Este es el primer conjunto de elementos
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Image.asset(
                            'assets/Iconos/candado.png',
                            width: 20,
                            height: 20,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            'Cambiar Contraseña',
                            style: TextStyle(
                              fontFamily: 'JoseFinSans-Regular',
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          onPressed: () {
                            // Tu acción al presionar la flecha
                          },
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            color: Color(0xFFB3DA1F),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      // Este es el segundo conjunto de elementos
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Image.asset(
                            'assets/Iconos/candado.png',
                            width: 20,
                            height: 20,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            'Cuenta Privada',
                            style: TextStyle(
                              fontFamily: 'JoseFinSans-Regular',
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Spacer(),
                        Switch(
                          value: isNotificationsEnabled,
                          onChanged: (value) {
                            setState(() {
                              isNotificationsEnabled = value;
                            });
                          },
                          activeTrackColor: Color(
                              0xFFB3DA1F), // Color del slider cuando está activado
                          activeColor: Colors
                              .white, // Color del botón cuando está activado
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      // Este es el primer conjunto de elementos
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Image.asset(
                            'assets/Iconos/basura.png',
                            width: 20,
                            height: 20,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            'Eliminar Cuenta',
                            style: TextStyle(
                              fontFamily: 'JoseFinSans-Regular',
                              fontSize: 17,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            color: Color(0xFFB3DA1F),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Repite los conjuntos adicionales aquí, si es necesario
                ],
              ),
            ),
          ), // Espacio entre los contenedores
        ],
      ),
    );
  }
}
