import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? email = '';
  String? password = '';
  final TextEditingController passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool isRegistering = false;
  bool isEmailInUseError = false;
  bool isPasswordWeak = false;

  Future<void> _getDataFromDatabase() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("Usuarios")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (snapshot.exists) {
        setState(() {
          email = snapshot.data()!["Correo"];
          password = snapshot.data()!["Contraseña"];
        });
      }
    } catch (e) {
      print("Error al obtener datos de Firestore: $e");
    }
  }

  final currentUser = FirebaseAuth.instance.currentUser!;
  @override
  void initState() {
    super.initState();
    _getDataFromDatabase();
  }

  void _toggleObscured() {
    setState(() {
      _obscurePassword = !_obscurePassword;
      passwordController.text =
          _obscurePassword ? '********' : (password ?? '');
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
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
              'Informacion del usuario',
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
            child: Container(
              width: 370,
              height: 250,
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
                            'assets/Iconos/user.png',
                            width: 20,
                            height: 20,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            'Correo Electronico',
                            style: TextStyle(
                              fontFamily: 'JoseFinSans-Regular',
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Spacer(),

                        Text(
                          currentUser.email!,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'JoseFinSans-Regular',
                            fontSize: 13,
                          ),
                        ), // Responsive font size

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
                            'Contraseña',
                            style: TextStyle(
                              fontFamily: 'JoseFinSans-Regular',
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Spacer(),
                        Expanded(
                          child: TextFormField(
                            controller: passwordController,
                            readOnly: true,
                            obscureText:
                                _obscurePassword, // Asegúrate de que esté configurado correctamente
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'JoseFinSans-Bold',
                              fontSize: 16,
                            ),
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
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
                      // Este es el primer conjunto de elementos
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
                          child: Text(
                            'Región',
                            style: TextStyle(
                              fontFamily: 'JoseFinSans-Regular',
                              fontSize: 17,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Spacer(),
                        Text(
                          'Argentina',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'JoseFinSans-Regular',
                            fontSize: 13,
                          ),
                        ), //
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
                      // Este es el primer conjunto de elementos
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Image.asset(
                            'assets/Iconos/call.png',
                            width: 20,
                            height: 20,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            'Numero telefonico',
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
