import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dailytracker/Login/Login.dart';
import 'package:dailytracker/premios.dart';
import 'package:dailytracker/quiz.dart';
import 'package:dailytracker/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'agregar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool hayNotificacionPendiente = true;
  bool preventScroll = true;

  double porcentaje = 0.0;
  int selectedDay = DateTime.now().day;

  void selectDay(int day) {
    setState(() {
      selectedDay = day;
    });
  }

  List<Habito> habitosSeleccionados = [];
  int habitosElegidosHoy = 0;
  int habitosCompletadosHoy = 0;
  void recibirHabitoSeleccionado(Habito habito) {
    setState(() {
      if (!habito.completado) {
        habitosCompletadosHoy++;
      }
      habito.completado = true;
      habitosElegidosHoy++;
    });

    // Establece hayNotificacionPendiente a false inmediatamente después de completar el hábito
    setState(() {
      hayNotificacionPendiente = false;
    });

    // Agregar el hábito seleccionado a Firestore
    guardarEleccionesEnFirestore(habito as List<Habito>);
  }

  Future<void> guardarEleccionesEnFirestore(List<Habito> elecciones) async {
    final date = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final userId = user.uid;
      final habitosElegidos =
          elecciones.map((habito) => habito.nombre).toList();

      try {
        final habitosConImagenes = elecciones.map((habito) {
          return {
            'nombre': habito.nombre,
            'imagen': habito.imagenUrl,
            'habitoCompleto':
                habito.completado, // Agrega el campo 'habitoCompleto'
          };
        }).toList();

        await FirebaseFirestore.instance
            .collection('Habitos')
            .doc(userId)
            .collection('resumenDiario')
            .doc(formattedDate)
            .set({
          'elecciones': habitosElegidos,
          'habitosConImagenes': habitosConImagenes,
        });

        // Asegúrate de que las URL de las imágenes se almacenen en los objetos Habito
        elecciones.forEach((habito) {
          final index = habitosElegidos.indexOf(habito.nombre);
          if (index >= 0 && index < habitosConImagenes.length) {
            final imageUrl = habitosConImagenes[index]['imagen'];
            habito.imagenUrl = imageUrl is String ? imageUrl : '';
          }
        });
      } catch (e) {
        print('Error writing to Firestore: $e');
      }
    }
  }

  void agregarHabitoManualmente(Habito habito) {
    setState(() {
      // Agregar el hábito manualmente a la lista
      habitosSeleccionados.add(habito);
    });

    // Agregar el hábito manual a Firestore
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;
      final date = DateTime.now();
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);

      FirebaseFirestore.instance
          .collection('Habitos')
          .doc(userId)
          .collection('resumenDiario')
          .doc(formattedDate)
          .get()
          .then((documentSnapshot) {
        if (documentSnapshot.exists) {
          final data = documentSnapshot.data() as Map<String, dynamic>;
          final habitosConImagenes =
              (data['habitosConImagenes'] as List<dynamic>) ?? [];

          // Agregar el nuevo hábito manual a Firestore
          habitosConImagenes.add({
            'nombre': habito.nombre,
            'imagen': habito.imagenUrl,
            'habitoCompleto': false, // Inicialmente, no se ha completado
          });

          // Actualizar Firestore con la nueva lista de hábitos
          FirebaseFirestore.instance
              .collection('Habitos')
              .doc(userId)
              .collection('resumenDiario')
              .doc(formattedDate)
              .update({
            'elecciones': FieldValue.arrayUnion([habito.nombre]),
            'habitosConImagenes': habitosConImagenes,
          }).then((value) {
            // Actualiza los hábitos desde Firestore
            obtenerHabitosDesdeFirestore();
          }).catchError((error) {
            print(
                'Error al agregar el hábito manualmente en Firestore: $error');
          });
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    obtenerHabitosDesdeFirestore();
    initializeDateFormatting('es_ES');
  }

  void obtenerHabitosDesdeFirestore() async {
    final date = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final userId = user.uid;
      final dateReference = FirebaseFirestore.instance
          .collection('Habitos')
          .doc(userId)
          .collection('resumenDiario')
          .doc(formattedDate);

      dateReference.snapshots().listen((documentSnapshot) {
        if (documentSnapshot.exists) {
          final data = documentSnapshot.data() as Map<String, dynamic>;
          final elecciones = data['elecciones'] as List<dynamic>;
          final habitosConImagenes =
              (data['habitosConImagenes'] as List<dynamic>) ?? [];

          int elegidosHoy = 0; // Contador para hábitos elegidos hoy
          int completadosHoy = 0; // Contador para hábitos completados hoy

          final habitos = elecciones.map((nombre) {
            final index = elecciones.indexOf(nombre);
            final imageUrl = habitosConImagenes[index]['imagen'] ?? '';
            final completado =
                habitosConImagenes[index]['habitoCompleto'] ?? false;

            if (completado) {
              completadosHoy++; // El hábito se marcó como completado
            }
            elegidosHoy++; // Se seleccionó un hábito hoy

            if (completado) {
              habitosCompletadosHoy++; // El hábito se marcó como completado
            }

            // Busca el hábito en listaHabitos y usa la URL de la imagen si está disponible
            final habitoEnLista = listaHabitos.firstWhere(
              (habito) => habito.nombre == nombre,
              orElse: () =>
                  Habito(nombre: nombre, imagenUrl: '', completado: completado),
            );

            if (imageUrl.isNotEmpty) {
              habitoEnLista.imagenUrl = imageUrl;
            }

            if (completado) {
              // Marca el hábito como completo si lo indica Firestore
              habitoEnLista.completado = true;
            }

            return habitoEnLista;
          }).toList();

          // Actualiza el estado para reflejar los cambios
          setState(() {
            habitosSeleccionados = habitos;
            habitosElegidosHoy = elegidosHoy;
            habitosCompletadosHoy = completadosHoy;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double porcentajeCompletado = habitosElegidosHoy > 0
        ? habitosCompletadosHoy / habitosElegidosHoy
        : 0.0;

    // Actualizar el estado 'porcentaje' con el porcentaje calculado
    setState(() {
      porcentaje = porcentajeCompletado;
    });
    DateTime currentDate = DateTime.now();
    int currentDay = currentDate.day;
    int currentWeekday = currentDate.weekday;
    DateTime startOfWeek =
        currentDate.subtract(Duration(days: currentWeekday - 1));
    DateTime endOfWeek = currentDate.add(Duration(days: 7 - currentWeekday));
    return Scaffold(
      backgroundColor: Color(0xff1B1B1B),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Color(0xFF1B1B1B),
            expandedHeight: 100.0,
            floating: false,
            actions: [
              IconButton(
                icon: Icon(Icons.settings, color: Color(0xFFB3DA1F)),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SettingsPage()));
                },
              ),
            ],
            pinned: true,
            flexibleSpace: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50.0),
                Text(
                  'Resumen',
                  style: TextStyle(
                      fontFamily: 'JoseFinSans-SemiBold',
                      fontSize: 20,
                      color: Colors.white),
                ),
                SizedBox(height: 20.0),
              ],
            ),
          ), // Agrega el calendario aquí
          SliverToBoxAdapter(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('d MMMM y', 'es_ES').format(DateTime.now()),
                    style: TextStyle(
                      fontFamily: 'JoseFinSans-Bold',
                      fontSize: 22,
                      color: Color(0xFFB3DA1F),
                    ),
                  ),
                  SizedBox(
                    height: 70,
                  ),
                  Stack(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 30,
                            ),
                            child: Text(
                              'Actividades',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'JoseFinSans-SemiBold',
                                fontSize: 24,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => QuizPage(
                                    habitosDisponibles: [],
                                    selectedDate: DateTime.now(),
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                right: 40,
                              ),
                              child: Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  Text(
                                    'Ver todas',
                                    style: TextStyle(
                                      color: Color(0xFFB3DA1F),
                                      fontSize: 15,
                                      fontFamily: 'JoseFinSans-SemiBold',
                                    ),
                                  ),
                                  if (hayNotificacionPendiente)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 15,
                                        left:
                                            20, // Ajusta el valor para subir el punto rojo
                                      ),
                                      child: Container(
                                        width: 10,
                                        height: 10,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => QuizPage(
                              habitosDisponibles: [],
                              selectedDate: DateTime.now()),
                        ),
                      );
                    },
                    child: Container(
                      width: 350,
                      height: 180,
                      decoration: BoxDecoration(
                        color: Color(0xFF363636),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 20,
                                  top: 40,
                                ),
                                child: Text(
                                  'Habitos Elegidos',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontFamily: 'JoseFinSans-SemiBold'),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 15,
                                ),
                                child: Text(
                                  '$habitosElegidosHoy',
                                  style: TextStyle(
                                      color: Color(0xFFB3DA1F), fontSize: 15),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 20,
                                  top: 20,
                                ),
                                child: Text(
                                  'Completadas',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontFamily: 'JoseFinSans-SemiBold'),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 15,
                                ),
                                child: Text(
                                  '$habitosCompletadosHoy',
                                  style: TextStyle(
                                      color: Color(0xFFB3DA1F), fontSize: 15),
                                ),
                              )
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 60,
                                ),
                                child: Text(
                                  '${(porcentaje * 100).toStringAsFixed(1)}%',
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                    fontFamily: 'JoseFinSans-SemiBold',
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 60,
                                ),
                                child: SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 10,
                                    value: porcentaje,
                                    backgroundColor: Colors.grey,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Color(0xFFB3DA1F)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 60),
                  Padding(
                    padding: const EdgeInsets.only(
                      right:
                          10, // Ajusta el espaciado derecho según tu preferencia
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 30,
                          ),
                          child: Text(
                            'Premios',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'JoseFinSans-SemiBold',
                              fontSize: 24,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        InkWell(
                          onTap: () {
                            // Navigator.push(context, MaterialPageRoute(builder: (context)=> MotivationalQuotesPage()));
                            mostrarMensaje(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: 20,
                            ),
                            child: Text(
                              'Mostrar más',
                              style: TextStyle(
                                  color: Color(
                                      0xFFB3DA1F), // Puedes cambiar el color según tu preferencia
                                  fontSize: 15,
                                  fontFamily: 'JoseFinSans-SemiBold'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    children: [
                      InkWell(
                        // onTap: () {
                        //   mostrarMensaje(context);
                        // },
                        child: ClipRect(
                          child: Container(
                            width: 350,
                            height: 140,
                            decoration: BoxDecoration(
                              color: Color(0xFF363636),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Center(
                                  child: Image.asset(
                                    'assets/Iconos/insignia3.png',
                                    width: 80,
                                    height: 80,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 25, left: 15),
                                  child: BackdropFilter(
                                    filter:
                                        ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                    child: Container(
                                      width: 90,
                                      height: 90,
                                      child: Image.asset(
                                        'assets/Iconos/insignia2.png',
                                        width: 90,
                                        height: 90,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    right: 10,
                                  ),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 10, sigmaY: 10),
                                    child: Container(
                                      width: 90,
                                      height: 90,
                                      child: Image.asset(
                                        'assets/Iconos/primera-posicion.png',
                                        width: 90,
                                        height: 90,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: BackdropFilter(
                                    filter:
                                        ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                    child: Container(
                                      width: 1,
                                      height: 1,
                                      decoration: BoxDecoration(
                                          color: Colors.transparent),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 10,
                        right: 10,
                        bottom: 0,
                        child: Icon(
                          Icons.lock,
                          color: Colors.black,
                          size: 60,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void mostrarMensaje(BuildContext context) {
  final snackBar = SnackBar(
    content: Text(
      'Próximamente estará disponible',
      style: TextStyle(fontFamily: 'JoseFinSans-SemiBold', fontSize: 15),
    ),
    backgroundColor: Color(0xffB3DA1F), // Establece el color de fondo en verde
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

// 2. Define la información de las insignias
class Insignia {
  final String nombre;
  final String descripcion;
  final String imagen;
  final int cantidadHabitos;

  Insignia({
    required this.nombre,
    required this.descripcion,
    required this.imagen,
    required this.cantidadHabitos,
  });
}