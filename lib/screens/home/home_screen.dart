import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../services/step_counter_service.dart';
import '../statistics/statistics_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late StepCounterService _stepService;
  int _steps = 0;

  static const Color primaryColor = Color(0xFF107ACC);
  static const Color primaryDark = Color(0xFF0A5CA0);

  /// Se ejecuta cuando se crea el widget por primera vez.
  /// Solicita permisos, inicializa el servicio de pasos y
  /// escucha los pasos en tiempo real.
  @override
  void initState() {
    super.initState();
    _requestPermission();

    _stepService = StepCounterService();
    _stepService.stepStream.listen((steps) {
      setState(() {
        _steps = steps;
      });
    });
  }

  /// Solicita el permiso ACTIVITY_RECOGNITION si no ha sido otorgado aún.
  void _requestPermission() async {
    var status = await Permission.activityRecognition.status;
    if (!status.isGranted) {
      await Permission.activityRecognition.request();
    }
  }

  /// Libera recursos cuando el widget se elimina de la pantalla.
  @override
  void dispose() {
    _stepService.dispose();
    super.dispose();
  }

  /// Construye la interfaz de usuario del podómetro, mostrando pasos y
  /// botón para ver estadísticas.
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // Tamaño total de la pantalla
    final isSmallScreen = size.width < 360;
    final padding = size.width * 0.06;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: size.height * 0.05),
                  Text(
                    "Podómetro",
                    style: TextStyle(
                      fontSize: isSmallScreen ? 24 : 28,
                      fontWeight: FontWeight.w500,
                      color: primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: size.height * 0.06),
                  AspectRatio(
                    // Permite mantener una proporción (relación de aspecto)
                    aspectRatio: 1, // 1:1
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(size.width * 0.08),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "PASOS HOY",
                            style: TextStyle(
                              fontSize: isSmallScreen ? 14 : 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            _steps.toString(),
                            style: TextStyle(
                              fontSize: isSmallScreen ? 48 : 64,
                              fontWeight: FontWeight.bold,
                              color: primaryDark,
                            ),
                          ),
                          const SizedBox(height: 10),
                          LinearProgressIndicator(
                            value: _steps / 10000,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              primaryDark,
                            ),
                            minHeight: 4,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              "Meta: 10,000",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: isSmallScreen ? 16 : 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => StatisticsScreen(
                                stepService: _stepService,
                                currentSteps: _steps,
                                primaryColor: primaryColor,
                                primaryDark: primaryDark,
                              ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryDark,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      "Ver estadísticas",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  const Spacer(), // Espacio grande
                  Padding(
                    padding: EdgeInsets.only(bottom: size.height * 0.06),
                    child: Text(
                      "Cada paso cuenta",
                      style: TextStyle(
                        fontSize: isSmallScreen ? 16 : 18,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
