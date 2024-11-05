import 'package:flutter/material.dart';
import 'package:twilio_flutter/twilio_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserView extends StatefulWidget {
  @override
  _UserViewState createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _smsController = TextEditingController();
  final _phoneController = TextEditingController();
  
  bool _isLoading = false;
  bool _isEmailPasswordEntered = false;
  bool _showSmsField = false;
  String? _verificationCode;
  
  late TwilioFlutter twilioFlutter;

  @override
  void initState() {
    super.initState();
    twilioFlutter = TwilioFlutter(
      accountSid: '',
      authToken: '',
      twilioNumber: ''
    );
  }

  String _generateVerificationCode() {
    return (100000 + DateTime.now().millisecondsSinceEpoch % 900000).toString();
  }

  Future<void> _sendSmsCode() async {
    if (_phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, ingresa un número de teléfono')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      _verificationCode = _generateVerificationCode();
      
      await twilioFlutter.sendSMS(
        toNumber: _phoneController.text,
        messageBody: 'Tu código de verificación es: $_verificationCode',
      );

      setState(() {
        _showSmsField = true;
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Código enviado correctamente')),
      );
    } catch (e) {
      print('Error al enviar SMS: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al enviar el código SMS: ${e.toString()}')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _verifySmsCode() async {
    if (_smsController.text != _verificationCode) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Código incorrecto')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isVerified', true);

      Navigator.pushReplacementNamed(context, '/userDashboard');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error en la verificación')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

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
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!_isEmailPasswordEntered) ...[
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'Correo electrónico',
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
                    TextField(
                      controller: _passwordController,
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
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isEmailPasswordEntered = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        backgroundColor: Colors.pink[50],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'Continuar',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ] else if (!_showSmsField) ...[
                    TextField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        hintText: 'Número de teléfono (+1234567890)',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _sendSmsCode,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        backgroundColor: Colors.pink[50],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator()
                          : Text(
                              'Enviar Código SMS',
                              style: TextStyle(color: Colors.black),
                            ),
                    ),
                  ] else ...[
                    TextField(
                      controller: _smsController,
                      decoration: InputDecoration(
                        hintText: 'Código SMS',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _verifySmsCode,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        backgroundColor: Colors.pink[50],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator()
                          : Text(
                              'Verificar Código',
                              style: TextStyle(color: Colors.black),
                            ),
                    ),
                  ],
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _smsController.dispose();
    _phoneController.dispose();
    super.dispose();
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
