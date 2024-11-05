
import 'package:flutter/material.dart';


// Vista principal del administrador
class HomeAdminView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.black,
          ),
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
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text(
                  'Bienvenido, Administrador',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 20),
                Text(
                  'Opciones Administrativas',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                SizedBox(height: 10),
                ListTile(
                  leading: Icon(Icons.people, color: Colors.cyanAccent),
                  title: Text(
                    'Lista de Invitados',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GuestListView()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.event, color: Colors.cyanAccent),
                  title: Text(
                    'Ver Eventos',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/events');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.qr_code_scanner, color: Colors.cyanAccent),
                  title: Text(
                    'Escanear QR',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                  },
                ),
                ListTile(
                  leading: Icon(Icons.settings, color: Colors.cyanAccent),
                  title: Text(
                    'Configuraciones',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/settings');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Vista de lista de invitados
class GuestListView extends StatelessWidget {
  final List<String> guests = ["Juan Pérez", "Maria López", "Carlos Díaz"]; // Ejemplo de datos de invitados

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Invitados'),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        child: ListView.builder(
          itemCount: guests.length,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.grey[900],
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                title: Text(
                  guests[index],
                  style: TextStyle(color: Colors.white),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.check_circle, color: Colors.green),
                      onPressed: () {
                        // Acción para el botón "Entró"
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${guests[index]} ha entrado')),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.cancel, color: Colors.red),
                      onPressed: () {
                        // Acción para el botón "Salió"
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${guests[index]} ha salido')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// Clase personalizada para la forma ondulada
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
