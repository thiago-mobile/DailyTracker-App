import 'package:dailytracker/home.dart';
import 'package:flutter/material.dart';

class PremiosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1B1B1B),
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            },
            icon: Icon(Icons.arrow_back_ios)),
        title: Text(
          'Premios',
          style: TextStyle(fontFamily: 'JoseFinSans-SemiBold'),
        ),
        centerTitle: true,
        backgroundColor: Color(0xff1B1B1B),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment
            .start, // Alinea los elementos en la parte superior
        children: [
          SizedBox(
              height:
                  20), // Espaciado entre la barra de la aplicación y los premios
          PremioWidget(
            imageAsset: 'assets/Iconos/primera-posicion.png',
            name: 'Leyenda',
            description: '¡Completar todos los habitos del dia.',
          ),
          PremioWidget(
            imageAsset: 'assets/Iconos/insignia2.png',
            name: 'Soldado',
            description: '¡Sigue trabajando en tus hábitos!',
          ),
          PremioWidget(
            imageAsset: 'assets/Iconos/insignia3.png',
            name: 'Ingresante',
            description: '¡Has comenzado tu viaje de hábitos!',
          ),
        ],
      ),
    );
  }
}

class PremioWidget extends StatelessWidget {
  final String imageAsset;
  final String name;
  final String description;

  PremioWidget({
    required this.imageAsset,
    required this.name,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 15), // Espaciado entre la imagen y el nombre
          Text(
            name,
            style: TextStyle(
              fontSize: 20, // Tamaño de fuente para el nombre
              fontFamily: 'JoseFinSans-SemiBold',
              color: Colors.grey, // Color del nombre
            ),
          ),
          SizedBox(height: 30),
          Image.asset(
            imageAsset,
            width: 100,
            height: 100,
          ),
          SizedBox(height: 30), // Espaciado entre el nombre y la descripción
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16, // Tamaño de fuente para la descripción
              fontFamily: 'JoseFinSans-Regular',
              color: Colors.white, // Color de la descripción
            ),
          ),
        ],
      ),
    );
  }
}
