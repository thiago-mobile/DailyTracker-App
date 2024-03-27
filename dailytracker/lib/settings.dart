import 'package:dailytracker/Login/Login.dart';
import 'package:dailytracker/Privacidad.dart';
import 'package:dailytracker/perfil.dart';
import 'package:dailytracker/quiz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isNotificationsEnabled = false;
  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navega de vuelta a la página de inicio de sesión
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        (Route<dynamic> route) => false, // Limpia la pila de navegación
      );
    } catch (e) {
      print('Error al cerrar sesión: $e');
    }
  }

  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF292929),
        elevation: 0,
        title: Text(
          'Configuración',
          style: TextStyle(
            fontFamily: 'JoseFinSans-Regular',
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      backgroundColor: Color(0xFF292929),
      body: Padding(
        padding: const EdgeInsets.only(top: 50, left: 7),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 250),
              child: Text(
                'Cuenta',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontFamily: 'JoseFinSans-SemiBold',
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
              child: Container(
                width: 370,
                height: 200,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 48, 48, 48),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  // Este es el primer conjunto de elementos
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilePage(),
                          ),
                        );
                      },
                      child: Container(
                        width: double
                            .infinity, // Establece el ancho del Container para llenar el espacio horizontal
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 48, 48, 48),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Image.asset(
                                'assets/Iconos/user.png',
                                width: 20,
                                height: 20,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProfilePage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Cuenta',
                                  style: TextStyle(
                                    fontFamily: 'JoseFinSans-Regular',
                                    fontSize: 17,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Spacer(),
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProfilePage()));
                              },
                              icon: Icon(
                                Icons.arrow_forward_ios,
                                color: Color(0xFFB3DA1F),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PrivacidadSeguridad(),
                          ),
                        );
                      },
                      child: Container(
                        width: double
                            .infinity, // Establece el ancho del Container para llenar el espacio horizontal
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 48, 48, 48),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
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
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PrivacidadSeguridad(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Privacidad y Seguridad',
                                  style: TextStyle(
                                    fontFamily: 'JoseFinSans-Regular',
                                    fontSize: 17,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Spacer(),
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PrivacidadSeguridad()));
                              },
                              icon: Icon(
                                Icons.arrow_forward_ios,
                                color: Color(0xFFB3DA1F),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Share.share('https://forms.gle/t449L9iYceB8jpESA');
                      },
                      child: Container(
                        width: double
                            .infinity, // Establece el ancho del Container para llenar el espacio horizontal
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 48, 48, 48),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Image.asset(
                                'assets/Iconos/compartir.png',
                                width: 20,
                                height: 20,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: GestureDetector(
                                onTap: () {
                                  Share.share(
                                      'https://forms.gle/t449L9iYceB8jpESA');
                                },
                                child: Text(
                                  ' compartí tu opinión',
                                  style: TextStyle(
                                    fontFamily: 'JoseFinSans-Regular',
                                    fontSize: 17,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Spacer(),
                            IconButton(
                              onPressed: () {
                                Share.share(
                                    '¡Te invito a probar nuestra aplicacion!',
                                    subject: 'DailyTracker');
                              },
                              icon: Icon(
                                Icons.arrow_forward_ios,
                                color: Color(0xFFB3DA1F),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Repite la estructura anterior para otros conjuntos
                  ],
                ),
              ),
            ), // Espacio entre los contenedores
            SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.only(right: 150),
              child: Text(
                'Contenido y Pantalla',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'JoseFinSans-SemiBold',
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              // onTap: () {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(builder: (context) => ProfilePage()),
              //   );
              // },
              child: Container(
                width: 370,
                height: 200,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 48, 48, 48),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double
                          .infinity, // Establece el ancho del Container para llenar el espacio horizontal
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 48, 48, 48),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Image.asset(
                              'assets/Iconos/idioma.png',
                              width: 20,
                              height: 20,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: GestureDetector(
                              onTap: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => ProfilePage(),
                                //   ),
                                // );
                              },
                              child: Text(
                                'Idioma',
                                style: TextStyle(
                                  fontFamily: 'JoseFinSans-Regular',
                                  fontSize: 17,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          Text(
                            'Español',
                            style: TextStyle(
                              fontFamily: 'JoseFinSans-Regular',
                              fontSize: 17,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => ProfilePage()));
                            },
                            icon: Icon(
                              Icons.arrow_forward_ios,
                              color: Color(0xFFB3DA1F),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double
                          .infinity, // Establece el ancho del Container para llenar el espacio horizontal
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 48, 48, 48),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Image.asset(
                              'assets/Iconos/notification.png',
                              width: 20,
                              height: 20,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: GestureDetector(
                              onTap: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => ProfilePage(),
                                //   ),
                                // );
                              },
                              child: Text(
                                'Notificaciones',
                                style: TextStyle(
                                  fontFamily: 'JoseFinSans-Regular',
                                  fontSize: 17,
                                  color: Colors.white,
                                ),
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
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        _signOut();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                        );
                      },
                      child: Container(
                        width: double
                            .infinity, // Establece el ancho del Container para llenar el espacio horizontal
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 48, 48, 48),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Image.asset(
                                'assets/Iconos/cerrar-sesion.png',
                                width: 20,
                                height: 20,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: GestureDetector(
                                onTap: () {
                                  _signOut();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Cerrar sesión',
                                  style: TextStyle(
                                    fontFamily: 'JoseFinSans-Regular',
                                    fontSize: 17,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Spacer(),
                            IconButton(
                              onPressed: () {
                                _signOut();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()));
                              },
                              icon: Icon(
                                Icons.arrow_forward_ios,
                                color: Color(0xFFB3DA1F),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ), // Espacio entre los contenedores// Espacio entre los contenedores
          ],
        ),
      ),
    );
  }
}
