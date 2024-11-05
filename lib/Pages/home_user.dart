import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class UserDashboardView extends StatefulWidget {
  const UserDashboardView({Key? key}) : super(key: key);

  @override
  _UserDashboardViewState createState() => _UserDashboardViewState();
}

class _UserDashboardViewState extends State<UserDashboardView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String qrData = "";
  bool _showQR = false;

  void _generateQRCode() {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa todos los campos'),
          backgroundColor: Colors.black,
        ),
      );
      return;
    }

    final userData = {
      'Nombre': _nameController.text,
      'Email': _emailController.text,
      'Teléfono': _phoneController.text,
      'Dirección': _addressController.text,
    };

    setState(() {
      qrData = userData.entries.map((e) => "${e.key}: ${e.value}").join('\n');
      _showQR = true;
    });
  }

  void _editData() {
    setState(() {
      _showQR = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.black,
              Color(0xFF1A1A1A), // Negro ligeramente más claro
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: _showQR ? _buildQrView() : _buildInputView(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Icon(
            Icons.qr_code_scanner,
            color: Colors.cyanAccent[400],
            size: 32,
          ),
          const SizedBox(width: 12),
          Text(
            _showQR ? 'Tu Código QR' : 'Generador QR',
            style: TextStyle(
              color: Colors.cyanAccent[400],
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Información Personal',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.cyanAccent[400],
          ),
        ),
        const SizedBox(height: 20),
        _buildTextField(
          _nameController,
          'Nombre completo',
          Icons.person_outline,
          hint: 'Ingresa tu nombre completo',
        ),
        const SizedBox(height: 16),
        _buildTextField(
          _emailController,
          'Correo electrónico',
          Icons.email_outlined,
          hint: 'ejemplo@correo.com',
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          _phoneController,
          'Teléfono',
          Icons.phone_outlined,
          hint: '+34 XXX XXX XXX',
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          _addressController,
          'Dirección',
          Icons.location_on_outlined,
          hint: 'Ingresa tu dirección completa',
        ),
        const SizedBox(height: 32),
        _buildButton(
          onPressed: _generateQRCode,
          icon: Icons.qr_code,
          label: 'Generar Código QR',
        ),
      ],
    );
  }

  Widget _buildQrView() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.cyanAccent[400]!,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.cyanAccent.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: QrImageView(
                  data: qrData,
                  version: QrVersions.auto,
                  size: 200,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Escanea este código QR',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyanAccent[400],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                qrData,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        _buildButton(
          onPressed: _editData,
          icon: Icons.edit,
          label: 'Editar Información',
        ),
      ],
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    String? hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.cyanAccent[400]!,
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[600]),
          prefixIcon: Icon(icon, color: Colors.cyanAccent[400]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.black,
          labelStyle: TextStyle(color: Colors.cyanAccent[400]),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.cyanAccent[400],
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}