import 'package:flutter/material.dart';

class AdminView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo negro
          Container(
            color: Colors.black,
          ),
          // Forma turquesa con diseño ondulado
          Positioned(
            top: MediaQuery.of(context).size.height * 0.5,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: WaveClipper(),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.6,
                color: Colors.cyanAccent,
              ),
            ),
          ),
          // Campos de texto, botón de iniciar sesión y opción de registro
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Campo de texto para el nombre de usuario o correo
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Nombre de usuario o correo',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 20),
                  // Campo de texto para la contraseña
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Contraseña',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 20),
                  // Botón de iniciar sesión
                  ElevatedButton(
                    onPressed: () {
                      // Acción al presionar el botón de iniciar sesión
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      backgroundColor: Colors.pink[50],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'Iniciar Sesión',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Texto de opción para registrarse
                  GestureDetector(
                    onTap: () {
                      // Navegar a la pantalla de registro
                      Navigator.pushNamed(context, '/register');
                    },
                    child: Text(
                      '¿No tienes una cuenta? Regístrate aquí',
                      style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height * 0.3);

    var firstControlPoint = Offset(size.width * 0.25, size.height * 0.5);
    var firstEndPoint = Offset(size.width * 0.5, size.height * 0.4);

    var secondControlPoint = Offset(size.width * 0.75, size.height * 0.3);
    var secondEndPoint = Offset(size.width, size.height * 0.5);

    path.quadraticBezierTo(
        firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);
    path.quadraticBezierTo(
        secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
