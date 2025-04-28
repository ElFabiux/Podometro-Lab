import 'package:flutter/material.dart';
import '../../services/step_counter_service.dart';

class StatisticsScreen extends StatefulWidget {
  final StepCounterService stepService;
  final int currentSteps;
  final Color primaryColor;
  final Color primaryDark;

  const StatisticsScreen({
    super.key,
    required this.stepService,
    required this.currentSteps,
    required this.primaryColor,
    required this.primaryDark,
  });

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  late int _steps;
  double _distanceKm = 0;
  int _minutesActive = 0;

  /// Inicializa los valores de pasos actuales y escucha nuevas actualizaciones del stream.
  /// Calcula la distancia y el tiempo activo con cada actualización.
  @override
  void initState() {
    super.initState();

    _steps = widget.currentSteps;
    _updateStats(_steps);

    widget.stepService.stepStream.listen((steps) {
      setState(() {
        _steps = steps;
        _updateStats(steps);
      });
    });
  }

  /// Calcula estadísticas con base en la cantidad de pasos:
  /// distancia aproximada en km y minutos activos estimados.
  void _updateStats(int steps) {
    _distanceKm = steps * 0.0007;
    _minutesActive = (steps ~/ 100);
  }

  /// Construye la interfaz de usuario con las estadísticas del usuario.
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
                    "Estadísticas",
                    style: TextStyle(
                      fontSize: isSmallScreen ? 24 : 28,
                      fontWeight: FontWeight.w500,
                      color: widget.primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: size.height * 0.06),
                  AspectRatio(
                    aspectRatio: 1,
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
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildStatItem(
                              "Pasos hoy:",
                              _steps.toString(),
                              isSmallScreen,
                            ),
                            const Divider(height: 24),
                            _buildStatItem(
                              "Distancia recorrida:",
                              "${_distanceKm.toStringAsFixed(2)} km",
                              isSmallScreen,
                            ),
                            const Divider(height: 24),
                            _buildStatItem(
                              "Tiempo activo:",
                              "$_minutesActive min",
                              isSmallScreen,
                            ),
                            const SizedBox(height: 20),
                            LinearProgressIndicator(
                              value: _steps / 10000,
                              backgroundColor: Colors.grey[200],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                widget.primaryDark,
                              ),
                              minHeight: 4,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                "Progreso: ${((_steps / 10000) * 100).toStringAsFixed(1)}%",
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 14 : 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.primaryDark,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      "Volver",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: EdgeInsets.only(bottom: size.height * 0.06),
                    child: Text(
                      "Mantente activo",
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

  /// Crea un widget con el nombre y valor de una estadística específica
  /// (pasos, distancia o tiempo).
  Widget _buildStatItem(String label, String value, bool isSmallScreen) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isSmallScreen ? 14 : 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isSmallScreen ? 16 : 18,
            fontWeight: FontWeight.bold,
            color: widget.primaryDark,
          ),
        ),
      ],
    );
  }
}
