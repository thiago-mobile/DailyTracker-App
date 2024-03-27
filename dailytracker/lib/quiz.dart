import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dailytracker/home.dart';
import 'package:dailytracker/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'agregar.dart';
import 'calender.dart';

class QuizPage extends StatefulWidget {
  final List<Habito> habitosDisponibles;
  final DateTime selectedDate;

  const QuizPage(
      {Key? key, required this.habitosDisponibles, required this.selectedDate})
      : super(key: key);

  @override
  State<QuizPage> createState() =>
      _QuizPageState(habitosDisponibles: habitosDisponibles);
}

class _QuizPageState extends State<QuizPage> {
  PageController _pageController = PageController(initialPage: 0);
  List<Habito> habitosDisponibles = [];
  int selectedDay = DateTime.now().day;
  _QuizPageState({required this.habitosDisponibles});

  void selectDay(int day) {
    setState(() {
      selectedDay = day;
    });
    obtenerHabitosDelDia(
        DateTime.now()); // Actualiza los hábitos al cambiar el día
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

  void marcarHabitoComoCompletado(Habito habito) {
    if (!habito.completado) {
      setState(() {
        habito.completado = true; // Marca el hábito como completo
      });

      // Actualiza el estado en Firebase
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

            // Encuentra el hábito correspondiente y márcalo como completo
            final habitosConImagenesUpdated =
                habitosConImagenes.map((habitoData) {
              if (habitoData['nombre'] == habito.nombre) {
                habitoData['habitoCompleto'] = true;
              }
              return habitoData;
            }).toList();

            // Actualiza el registro en Firestore
            FirebaseFirestore.instance
                .collection('Habitos')
                .doc(userId)
                .collection('resumenDiario')
                .doc(formattedDate)
                .update({
              'habitosConImagenes': habitosConImagenesUpdated,
            }).then((value) {
              print('Hábito marcado como completado en Firestore');
            }).catchError((error) {
              print(
                  'Error al marcar el hábito como completado en Firestore: $error');
            });
          }
        });
      }
    }
  }

  void obtenerHabitosDesdeFirestore() async {
    final date = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final userId = user.uid;

      try {
        final documentSnapshot = await FirebaseFirestore.instance
            .collection('Habitos')
            .doc(userId)
            .collection('resumenDiario')
            .doc(formattedDate)
            .get();

        if (documentSnapshot.exists) {
          final data = documentSnapshot.data() as Map<String, dynamic>;
          final elecciones = data['elecciones'] as List<dynamic>;
          final habitosConImagenes =
              (data['habitosConImagenes'] as List<dynamic>) ?? [];

          final habitos = elecciones.map((nombre) {
            final index = elecciones.indexOf(nombre);
            final imageUrl = habitosConImagenes[index]['imagen'] ?? '';
            final completado =
                habitosConImagenes[index]['habitoCompleto'] ?? false;

            // Busca el hábito en listaHabitos y usa la URL de la imagen si está disponible
            final habitoEnLista = listaHabitos.firstWhere(
              (habito) => habito.nombre == nombre,
              orElse: () => Habito(
                  nombre: nombre,
                  imagenUrl: '',
                  completado: false), // Establece el estado en false
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

          setState(() {
            habitosSeleccionados = habitos;
          });
        } else {
          setState(() {
            habitosSeleccionados = []; // Limpia la lista si no hay datos
          });
        }
      } catch (e) {
        print('Error al obtener hábitos desde Firestore: $e');
      }
    }
  }

  Future<void> obtenerHabitosDelDia(DateTime selectedDate) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final userId = user.uid;
      final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

      try {
        final documentSnapshot = await FirebaseFirestore.instance
            .collection('Habitos')
            .doc(userId)
            .collection('resumenDiario')
            .doc(formattedDate)
            .get();

        if (documentSnapshot.exists) {
          final data = documentSnapshot.data() as Map<String, dynamic>;
          final habitosConImagenes =
              (data['habitosConImagenes'] as List<dynamic>) ?? [];

          // Procesa los hábitos y agrégalos a habitosDelDia
          List<Habito> habitosDelDia = [];
          for (var habitoData in habitosConImagenes) {
            final nombre = habitoData['nombre'];
            final imageUrl = habitoData['imagen'];
            final completado = habitoData['habitoCompleto'];

            final habito = Habito(
              nombre: nombre,
              imagenUrl: imageUrl ?? '',
              completado: completado ?? false,
            );

            habitosDelDia.add(habito);
          }

          // Ahora tienes los hábitos del día seleccionado en la lista habitosDelDia
          // Puedes mostrarlos en tu UI
          setState(() {
            habitosSeleccionados = habitosDelDia;
          });
        }
      } catch (e) {
        print('Error al obtener hábitos desde Firestore: $e');
      }
    }
  }

  void eliminarHabito(Habito habito) {
    setState(() {
      habitosSeleccionados.remove(habito);
      habitosDisponibles.add(habito);
      listaHabitos.add(habito); // Agregar el hábito nuevamente
    });

    // Elimina el hábito de Firestore
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;
      final date = widget.selectedDate;
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);

      FirebaseFirestore.instance
          .collection('Habitos')
          .doc(userId)
          .collection('resumenDiario')
          .doc(formattedDate)
          .update({
        'elecciones': FieldValue.arrayRemove([habito.nombre]),
        'habitosConImagenes': FieldValue.arrayRemove([
          {
            'nombre': habito.nombre,
            'imagen': habito.imagenUrl,
            'habitoCompleto': habito.completado,
          }
        ]),
      }).then((value) {
        print('Hábito eliminado de Firestore');
      }).catchError((error) {
        print('Error al eliminar el hábito de Firestore: $error');
      });
    }
  }

  void eliminarHabitoCompletado(Habito habito) {
    setState(() {
      habitosSeleccionados.remove(habito);
      habitosDisponibles.add(habito);
      listaHabitos.add(habito); // Agregar el hábito nuevamente
    });

    // Elimina el hábito de Firestore
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;
      final date = widget.selectedDate;
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);

      FirebaseFirestore.instance
          .collection('Habitos')
          .doc(userId)
          .collection('resumenDiario')
          .doc(formattedDate)
          .update({
        'elecciones': FieldValue.arrayRemove([habito.nombre]),
        'habitosConImagenes': FieldValue.arrayRemove([
          {
            'nombre': habito.nombre,
            'imagen': habito.imagenUrl,
            'habitoCompleto': habito.completado,
          }
        ]),
      }).then((value) {
        print('Hábito eliminado de Firestore');
      }).catchError((error) {
        print('Error al eliminar el hábito de Firestore: $error');
      });
    }
  }

  List<Habito> habitosSeleccionados = [];
  List<Habito> habitosAgregadosPorUsuario = [];
  List<Habito> habitosFiltrados = listaHabitos;
  List<Habito> habitosAgregadosManualmente =
      []; // Nueva lista para hábitos agregados manualmente

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('es_ES');
    obtenerHabitosDelDia(widget.selectedDate);
    obtenerHabitosDelDia(DateTime(selectedDay));

    // Carga los hábitos para el día seleccionado
  }

  void recibirHabitoSeleccionado(Habito habito) {
    // Verificar si el hábito ya está en alguna de las listas
    bool yaAgregado = habitosSeleccionados.contains(habito) ||
        habitosAgregadosPorUsuario.contains(habito);

    if (!yaAgregado) {
      // Crear un nuevo objeto Habito con el estado en false
      Habito nuevoHabito = Habito(
        nombre: habito.nombre,
        imagenUrl: habito.imagenUrl,
        completado: false, // Establece el estado en false
      );

      setState(() {
        habitosFiltrados.remove(habito);
        habitosSeleccionados.add(nuevoHabito); // Agrega el nuevo hábito
      });

      // Agregar el hábito seleccionado a Firestore
      guardarEleccionesEnFirestore(habitosSeleccionados);
    }
  }

  void agregarHabitoManualmente(Habito habito) {
    setState(() {
      habitosAgregadosPorUsuario.add(habito);
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

          // Agrega el nuevo hábito a la lista actual de hábitos en Firestore
          habitosConImagenes.add({
            'nombre': habito.nombre,
            'imagen': habito.imagenUrl,
            'habitoCompleto': habito.completado,
          });

          // Actualiza la lista completa en Firestore
          FirebaseFirestore.instance
              .collection('Habitos')
              .doc(userId)
              .collection('resumenDiario')
              .doc(formattedDate)
              .update({
            'elecciones': FieldValue.arrayUnion([habito.nombre]),
            'habitosConImagenes': habitosConImagenes,
          }).then((value) {
            print('Hábito agregado manualmente en Firestore');
          }).catchError((error) {
            print(
                'Error al agregar el hábito manualmente en Firestore: $error');
          });
        }
      });
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();
    int currentDay = currentDate.day;
    int currentWeekday = currentDate.weekday;
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final startOfMonth = DateTime(now.year, now.month, 1);
    DateTime startOfWeek =
        currentDate.subtract(Duration(days: currentWeekday - 1));
    DateTime endOfWeek = currentDate.add(Duration(days: 7 - currentWeekday));
    bool isDateInPast = widget.selectedDate.isBefore(currentDate);

    return Scaffold(
      backgroundColor: const Color(0xFF292929),
      body: Stack(
        children: [
          ClipPath(
            clipper: WaveClipper(),
            child: Container(
              height: 250.0,
              color: Color(0xff1B1B1B),
            ),
          ),
          CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                leading: IconButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                    },
                    icon: Icon(Icons.arrow_back_ios)),
                backgroundColor: Color(0xFF1B1B1B),
                expandedHeight: 150.0,
                floating: false,
                pinned: true,
                actions: [
                  IconButton(
                    icon: Icon(
                      Icons.calendar_month,
                      color: Color(0xFFB3DA1F),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CalenderPage()));
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.settings, color: Color(0xFFB3DA1F)),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingsPage()));
                    },
                  ),
                ],
                flexibleSpace: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50.0),
                    Text(
                      DateFormat('d MMMM y', 'es_ES')
                          .format(widget.selectedDate),
                      style: TextStyle(
                        fontFamily: 'JoseFinSans-SemiBold',
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      height: 80.0,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                            daysInMonth,
                            (index) {
                              DateTime day =
                                  startOfWeek.add(Duration(days: index));
                              bool isToday = day.day == currentDay;
                              bool isSelectedDate =
                                  day.day == widget.selectedDate.day;
                              bool isSelectedDay = selectedDay == day.day;

                              Color containerColor = determineContainerColor(
                                  isToday, isSelectedDate, isSelectedDay);

                              return GestureDetector(
                                onTap: () {
                                  selectDay(day.day);
                                  obtenerHabitosDelDia(day);
                                },
                                child: Stack(
                                  children: [
                                    ClipOval(
                                      child: Container(
                                        width: 55,
                                        height: 110,
                                        color: containerColor,
                                        child: Center(
                                          child: Container(
                                            width: 40.0,
                                            height: 40.0,
                                            decoration: BoxDecoration(
                                              color: isSelectedDate
                                                  ? Color(
                                                      0xFF292929) // Color para la fecha seleccionada
                                                  : isToday
                                                      ? Color(
                                                          0xFF292929) // Color para el día actual
                                                      : day.day == selectedDay
                                                          ? Colors
                                                              .red // Color para el día seleccionado
                                                          : Colors
                                                              .grey, // Color predeterminado para otros días
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: isToday
                                                    ? Color(
                                                        0xFFB3DA1F) // Color para el día actual
                                                    : isSelectedDate
                                                        ? Colors
                                                            .red // Color para la fecha seleccionada
                                                        : day.day == selectedDay
                                                            ? Colors
                                                                .red // Color para el día seleccionado
                                                            : Colors
                                                                .transparent, // Color predeterminado para otros días
                                                width: isToday ||
                                                        day.day ==
                                                            selectedDay ||
                                                        isSelectedDate
                                                    ? 2.0
                                                    : 0.0,
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                '${day.day}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16.0,
                                                  color: isToday
                                                      ? Colors.white
                                                      : isSelectedDate
                                                          ? Colors.black
                                                          : Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (isToday)
                                      Positioned(
                                        top: 2,
                                        left: 0,
                                        right: 0,
                                        child: Container(
                                          width: 40.0,
                                          child: Center(
                                            child: Text(
                                              [
                                                'L',
                                                'M',
                                                'M',
                                                'J',
                                                'V',
                                                'S',
                                                'D'
                                              ][day.weekday - 1],
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14.0,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    if (!isToday)
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: Column(
                                          children: [
                                            Text(
                                              [
                                                'L',
                                                'M',
                                                'M',
                                                'J',
                                                'V',
                                                'S',
                                                'D'
                                              ][day.weekday - 1],
                                              style: TextStyle(
                                                fontFamily:
                                                    'JoseFinSans-SemiBold',
                                                fontSize: 14.0,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            SizedBox(height: 5.0),
                                            Container(
                                              width: 40.0,
                                              height: 40.0,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Color(0xff1B1B1B),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '${day.day}',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16.0,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Mostrar hábitos seleccionados individualmente
          Positioned(
            top: 170.0,
            left: 16.0,
            right: 16.0,
            child: Column(
              children: [
                if (habitosSeleccionados.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: habitosSeleccionados.length,
                    itemBuilder: (context, index) {
                      final habito = habitosSeleccionados[index];
                      bool isCompleted = habito.completado;

                      return Dismissible(
                        key: UniqueKey(),
                        background: Container(
                          color: Colors.red,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Icon(Icons.delete, color: Colors.white),
                              ),
                              Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  'Eliminar',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        secondaryBackground: isCompleted
                            ? Container()
                            : Container(
                                color: Color(0xFFB3DA1F),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 300),
                                      child: Icon(Icons.check,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                        onDismissed: (direction) {
                          if (direction == DismissDirection.startToEnd) {
                            eliminarHabito(habito);
                          } else if (direction == DismissDirection.endToStart) {
                            marcarHabitoComoCompletado(habito);
                          }
                        },
                        confirmDismiss: (DismissDirection direction) async {
                          if (direction == DismissDirection.endToStart) {
                            return !isCompleted;
                          } else {
                            eliminarHabito(habito);
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Color(0xFF363636),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  ClipOval(
                                    child: Image.network(
                                      habito.imagenUrl,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(width: 16.0),
                                  Text(
                                    habito.nombre,
                                    style: TextStyle(
                                      fontFamily: 'JoseFinSans-SemiBold',
                                      color: isCompleted
                                          ? Color(0xFFB3DA1F)
                                          : Colors.white,
                                      fontSize: 17,
                                      decoration: isCompleted
                                          ? TextDecoration.lineThrough
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                              if (habito.completado)
                                Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: const Icon(
                                    Icons.check,
                                    color: Color(0xFFB3DA1F),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                if (habitosSeleccionados.isEmpty &&
                    habitosAgregadosManualmente.isEmpty)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 140.0),
                        Image.asset(
                          'assets/Iconos/dormirr.png',
                          width: 130,
                        ),
                        SizedBox(height: 13.0),
                        Text(
                          'No hay nada por vencer.',
                          style: TextStyle(
                            fontFamily: 'JoseFinSans-SemiBold',
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        if (isDateInPast)
                          Text(
                            '¡Hora de crear nuevos hábitos!',
                            style: TextStyle(
                              fontFamily: 'JoseFinSans-SemiBold',
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        SizedBox(height: 30.0),
                        if (isDateInPast)
                          Image.asset(
                            'assets/Iconos/flecha.png',
                            width: 50,
                            height: 100,
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: widget.selectedDate.day == DateTime.now().day
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AgregarHabito(
                      habitosFiltrados: habitosFiltrados,
                      habitosSeleccionados: habitosSeleccionados,
                      recibirHabitoSeleccionado: recibirHabitoSeleccionado,
                      agregarHabitoManualmente: agregarHabitoManualmente,
                      habitosDisponibles: habitosDisponibles,
                    ),
                  ),
                );
              },
              child: Icon(Icons.add),
              backgroundColor: Color(0xFFB3DA1F),
            )
          : null,
    );
  }
}

Color determineContainerColor(
    bool isToday, bool isSelectedDate, bool isSelectedDay) {
  if (isSelectedDay) {
    return Color(0xFF292929);
  } else if (isToday) {
    return Color(0xFF2E2E2E);
  } else {
    return Color(0xFF1B1B1B);
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.9);
    final firstControlPoint = Offset(size.width / 4, size.height);
    final firstEndPoint = Offset(size.width / 2, size.height * 0.9);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    final secondControlPoint = Offset(size.width * 0.75, size.height * 0.8);
    final secondEndPoint = Offset(size.width, size.height * 0.9);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
