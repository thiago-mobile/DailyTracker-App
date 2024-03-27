import 'dart:io';
import 'package:dailytracker/quiz.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AgregarHabito extends StatefulWidget {
  final List<Habito> habitosFiltrados;
  final List<Habito> habitosSeleccionados;
  final Function recibirHabitoSeleccionado;
  final Function agregarHabitoManualmente;
  final List<Habito> habitosDisponibles;

  const AgregarHabito({
    Key? key,
    required this.habitosFiltrados,
    required this.habitosSeleccionados,
    required this.recibirHabitoSeleccionado,
    required this.agregarHabitoManualmente,
    required this.habitosDisponibles,
  }) : super(key: key);

  @override
  State<AgregarHabito> createState() => _AgregarHabitoState();
}

class _AgregarHabitoState extends State<AgregarHabito> {
  TextEditingController _nuevoHabitoController = TextEditingController();
  List<Habito> habitosPredefinidos = [];
  List<Habito> habitosAgregadosPorUsuario = [];
  Future? _uploadTask;

  @override
  void initState() {
    super.initState();
    _mostrarMensajeSiEsPrimeraVez();
    habitosPredefinidos = widget.habitosFiltrados.where((habito) {
      return !widget.habitosSeleccionados.contains(habito) &&
          !habitosAgregadosPorUsuario.contains(habito);
    }).toList();
  }

  void _mostrarMensajeSiEsPrimeraVez() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool yaMostroMensaje = prefs.getBool('yaMostroMensaje') ?? false;

    if (!yaMostroMensaje) {
      mostrarMensaje(context);
      prefs.setBool('yaMostroMensaje', true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF292929),
      appBar: AppBar(
        backgroundColor: Color(0xFF292929),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              color: Color(0xFF363636),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nuevoHabitoController,
                    style: TextStyle(
                        fontFamily: 'JoseFinSans-SemiBold',
                        color: Colors.white),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(left: 10),
                      hintText: "¡Busca o crea tu nuevo hábito!",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontFamily: 'JoseFinSans-SemiBold',
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add_circle_outline),
                  color: Colors.white,
                  onPressed: () {
                    String nuevoHabito = _nuevoHabitoController.text;
                    if (nuevoHabito.isNotEmpty) {
                      _mostrarDialogoAgregarHabitoManualmente(nuevoHabito);
                    }
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: habitosPredefinidos.length,
              itemBuilder: (context, index) {
                final habito = habitosPredefinidos[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 13.0),
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: Color(0xFF363636),
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    child: ListTile(
                      leading: Padding(
                        padding: const EdgeInsets.only(top: 11),
                        child: ClipOval(
                          child: Image.network(
                            habito.imagenUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: Text(
                        habito.nombre,
                        style: TextStyle(
                          fontFamily: 'JoseFinSans-SemiBold',
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        widget.recibirHabitoSeleccionado(habito);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          if (_uploadTask != null)
            FutureBuilder(
              future: _uploadTask,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return SizedBox.shrink();
                }
              },
            ),
        ],
      ),
    );
  }

  void _mostrarDialogoAgregarHabitoManualmente(String nuevoHabito) async {
    final imagePicker = ImagePicker();
    final imageFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      final imagePath = imageFile.path;
      final imageRef = FirebaseStorage.instance
          .ref()
          .child('habit_images')
          .child(nuevoHabito)
          .child('imagen.jpg');

      final uploadTask = imageRef.putFile(File(imagePath));
      setState(() {
        _uploadTask = uploadTask;
      });

      await uploadTask;

      final imageUrl = await imageRef.getDownloadURL();

      if (mounted) {
        setState(() {
          _uploadTask = null;
        });
      }

      if (imageUrl.isNotEmpty) {
        Habito nuevoHabitoConImagen = Habito(
          nombre: nuevoHabito,
          imagenUrl: imageUrl,
        );

        setState(() {
          habitosAgregadosPorUsuario.add(nuevoHabitoConImagen);
          _nuevoHabitoController.clear();
        });

        // Agregar el hábito a la lista de hábitos disponibles
        widget.habitosFiltrados.add(nuevoHabitoConImagen);

        // Notifica a la página principal que se ha seleccionado un nuevo hábito
        widget.recibirHabitoSeleccionado(nuevoHabitoConImagen);

        final snackBar = SnackBar(
          backgroundColor: Color(0xffB3DA1F),
          content: Text(
            'Hábito "$nuevoHabito" creado exitosamente.',
            style: TextStyle(
                fontFamily: 'JoseFinSans-SemiBold',
                fontSize: 15,
                color: Colors.white),
          ),
          duration: Duration(seconds: 4),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    _nuevoHabitoController.dispose();
    super.dispose();
  }
}

void mostrarMensaje(BuildContext context) {
  final snackBar = SnackBar(
    content: Text(
      '¡Crea tu habito personalizado escribiendo el nombre y tocando el + !',
      style: TextStyle(fontFamily: 'JoseFinSans-SemiBold', fontSize: 15),
    ),
    backgroundColor: Color(0xffB3DA1F), // Establece el color de fondo en verde
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

class Habito {
  final String nombre;
  String imagenUrl;
  bool completado;

  Habito({
    required this.nombre,
    required this.imagenUrl,
    this.completado = false,
  });
}

List<Habito> listaHabitos = [
  Habito(
    nombre: "Tomar agua",
    imagenUrl:
        "https://firebasestorage.googleapis.com/v0/b/dailytracker-c36c9.appspot.com/o/Iconos%2Fhabit_tomaragua.png?alt=media&token=1a89e9c3-0094-497e-abf7-8631f32dfd36&_gl=1*1vluxyx*_ga*MzI4ODI2ODA1LjE2ODA4MjU5OTM.*_ga_CW55HF8NVT*MTY5NzIzNzcyNC40Ni4xLjE2OTcyMzgzNDYuNjAuMC4w",
  ),
  Habito(
    nombre: "Caminar",
    imagenUrl:
        "https://firebasestorage.googleapis.com/v0/b/dailytracker-c36c9.appspot.com/o/Iconos%2Fhabit_caminar.png?alt=media&token=c02e243d-0d90-4971-9a2a-8b5c6ccb295b&_gl=1*dmroh*_ga*MzI4ODI2ODA1LjE2ODA4MjU5OTM.*_ga_CW55HF8NVT*MTY5NzIzNzcyNC40Ni4xLjE2OTcyMzg0MTYuNjAuMC4w",
  ),
  Habito(
    nombre: "Leer",
    imagenUrl:
        "https://firebasestorage.googleapis.com/v0/b/dailytracker-c36c9.appspot.com/o/Iconos%2Fhabit_leer.png?alt=media&token=c3d8b23d-e354-42cb-9cc6-67faa5c96cfd&_gl=1*dl4q5w*_ga*MzI4ODI2ODA1LjE2ODA4MjU5OTM.*_ga_CW55HF8NVT*MTY5NzIzNzcyNC40Ni4xLjE2OTcyMzgzNjIuNDQuMC4w",
  ),
  Habito(
    nombre: "Descansar",
    imagenUrl:
        "https://firebasestorage.googleapis.com/v0/b/dailytracker-c36c9.appspot.com/o/Iconos%2Fhabit_descansar.png?alt=media&token=9132b423-02ff-4431-aa76-b11f8e3f6cf1&_gl=1*j3591s*_ga*MzI4ODI2ODA1LjE2ODA4MjU5OTM.*_ga_CW55HF8NVT*MTY5NzIzNzcyNC40Ni4xLjE2OTcyMzg0MDAuNi4wLjA.",
  ),
  Habito(
    nombre: "Ejercicio",
    imagenUrl:
        "https://firebasestorage.googleapis.com/v0/b/dailytracker-c36c9.appspot.com/o/Iconos%2Fhabit_ejercicio.png?alt=media&token=73e7a0a9-56bc-429c-b927-73281300faa6&_gl=1*3j6rm6*_ga*MzI4ODI2ODA1LjE2ODA4MjU5OTM.*_ga_CW55HF8NVT*MTY5NzIzNzcyNC40Ni4xLjE2OTcyMzgzNzguMjguMC4w",
  ),
  // Agrega más hábitos aquí
];
