import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dailytracker/quiz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class CalenderPage extends StatefulWidget {
  const CalenderPage({Key? key});

  @override
  State<CalenderPage> createState() => _CalenderPageState();
}

class _CalenderPageState extends State<CalenderPage> {
  PageController _pageController = PageController();
  List<String> habitosElegidos = [];
  DateTime _currentDate = DateTime.now();
  Map<String, List<String>> habitosCompletadosPorFecha = {};

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('es_ES', null);

    _currentDate = DateTime.now();
    _pageController = PageController(
      initialPage: (_currentDate.month - 1),
    );
   _pageController.addListener(() {
      final currentPage = _pageController.page?.round() ?? 0;
      final newMonth = (_currentDate.month + currentPage) % 12 + 1;
      var newYear =
          _currentDate.year + (_currentDate.month + currentPage - newMonth) ~/ 12;
    
      // Limitar el rango de meses para que no puedas avanzar más allá del mes actual
      if (newMonth == _currentDate.month) {
        newYear = _currentDate.year;
        _pageController.jumpToPage(_currentDate.month - 1); // Regresar a la página actual
      } 
setState(() {});
    });

    obtenerHabitosDesdeFirestore();
  }

  void obtenerHabitosDesdeFirestore() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final userId = user.uid;

      try {
        final snapshot = await FirebaseFirestore.instance
            .collection('Habitos')
            .doc(userId)
            .collection('resumenDiario')
            .get();

        snapshot.docs.forEach((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final fecha = doc.id;
          final habitosConImagenes = data['habitosConImagenes'] as List<dynamic>;

          List<String> habitosCompletadosEnFecha = [];

          for (var habitoData in habitosConImagenes) {
            final completado = habitoData['habitoCompleto'] ?? false;
            if (habitoData['nombreHabito'] != null) {
              habitosCompletadosEnFecha.add(habitoData['nombreHabito']);
            }
          }

          habitosCompletadosPorFecha[fecha] = habitosCompletadosEnFecha;
        });

        setState(() {});
      } catch (e) {
        print('Error al obtener hábitos desde Firestore: $e');
      }
    }
  }

  void navigateToQuizPage(DateTime selectedDate) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizPage(
          selectedDate: selectedDate,
          habitosDisponibles: [],
        ),
      ),
    );
  }

  void nextPage() {
    setState(() {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    });
  }

  void previousPage() {
    setState(() {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    });
  }

  String getFormattedMonthYear(DateTime date) {
    return DateFormat('MMMM y', 'es_ES').format(date);
  }

  Widget buildMonth(DateTime date) {
    final currentMonthDate = DateTime(date.year, date.month, 1);
    final currentMonthFormatted =
        DateFormat('MMMM y', 'es_ES').format(currentMonthDate);

    return Column(
      children: [
        SizedBox(
          height: 0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment
              .spaceBetween, // Alinea elementos al principio y al final.
          children: <Widget>[
            IconButton(
              onPressed: previousPage,
              icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            ),
            Expanded(
              child: Text(
                currentMonthFormatted, // Agrega tu texto personalizado si es necesario.
                style: TextStyle(
                  fontFamily: 'JoseFinSans-SemiBold',
                  color: Colors.white,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            IconButton(
              onPressed: nextPage,
              icon: Icon(Icons.arrow_forward_ios, color: Colors.white),
            ),
          ],
        ),
        SizedBox(
          height: 40,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(6, (index) {
            final dayName = DateFormat('E', 'es_ES')
                .format(DateTime(date.year, date.month, index + 1));
            return Text(
              dayName[0].toUpperCase(),
              style: TextStyle(
                color: Color(0xFFB3DA1F),
                fontFamily: 'JoseFinSans-Regular',
                fontSize: 18,
              ),
            );
          }),
        ),
        Wrap(
          spacing: 4.0,
          runSpacing: 0,
          children: List.generate(
            DateTime(date.year, date.month + 1, 0).day,
            (dayIndex) {
              final dayDate = DateTime(date.year, date.month, dayIndex + 1);
              final formattedDayDate = DateFormat('yyyy-MM-dd').format(dayDate);
              final tieneHabitosCompletados =
                  habitosCompletadosPorFecha.containsKey(formattedDayDate);

              List<String> habitosCompletados =
                  habitosCompletadosPorFecha[formattedDayDate] ?? [];
              final icon = habitosCompletados.isNotEmpty
                  ? Icons.check
                  : Icons.access_time;

              return GestureDetector(
                onTap: () {
                  navigateToQuizPage(dayDate);
                },
                child: SizedBox(
                  width: 60.0,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Text(
                          (dayIndex + 1).toString(),
                          style: const TextStyle(
                            fontFamily: 'JoseFinSans-SemiBold',
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          width: 35.0,
                          height: 35.0,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(255, 61, 61, 61),
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: determineIconForDate(dayDate),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Icon determineIconForDate(DateTime date) {
  final formattedDayDate = DateFormat('yyyy-MM-dd').format(date);
  final currentDate = DateTime.now();
  final tieneHabitosCompletados =
      habitosCompletadosPorFecha.containsKey(formattedDayDate);

  if (date.isBefore(currentDate) && !tieneHabitosCompletados) {
    // Fecha pasada sin hábitos completados
    return Icon(
      Icons.close, // Icono para días pasados sin hábitos completados
      color: Colors.red, // Cambia el color según tus preferencias
    );
  } else if (date.isBefore(currentDate) && tieneHabitosCompletados) {
    // Fecha pasada con hábitos completados
    return Icon(
      Icons.check,
      color: Color(0xFFB3DA1F),
    );
  } else if (date.isAtSameMomentAs(currentDate)) {
    // Fecha actual (hoy) sin hábitos completados
    return Icon(
      Icons.access_time,
      color: Colors.yellow, // Cambia el color según tus preferencias
    );
  } else {
    // Fecha futura
    return Icon(
      Icons.access_time_sharp, // Icono que deseas mostrar en días futuros
      color: Colors.grey, // Cambia el color según tus preferencias
    );
  }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1b1b),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QuizPage(
                  habitosDisponibles: [],
                  selectedDate: DateTime.now(),
                ),
              ),
            );
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          'Calendario',
          style: TextStyle(
            fontFamily: 'JoseFinSans-SemiBold',
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Color(0xff1B1B1B),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 40,
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemBuilder: (context, index) {
                final date = DateTime(_currentDate.year, index + 1, 1);
                return buildMonth(date);
              },
            ),
          ),
        ],
      ),
    );
  }
}