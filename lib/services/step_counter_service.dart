import 'dart:async';
import 'package:pedometer/pedometer.dart';

class StepCounterService {
  Stream<StepCount>?
  _stepCountStream; // Datos del sensor de la librería pedometer
  int _initialSteps = 0; // Pasos registrados al iniciar la app (referencia)
  int _currentSteps = 0; // Pasos desde que inició la app
  final StreamController<int> _stepController =
      StreamController<
        int
      >.broadcast(); // Permite que varios componentes escuchen en tiempo real

  /// Constructor que inicializa el stream del sensor de pasos
  StepCounterService() {
    _initialize();
  }

  /// Stream accesible desde fuera, emite los pasos actualizados
  Stream<int> get stepStream => _stepController.stream;

  /// Se suscribe al stream del sensor de pasos
  /// y define cómo manejar nuevos eventos y errores.
  void _initialize() {
    _stepCountStream = Pedometer.stepCountStream;

    _stepCountStream?.listen(
      _onStepCount,
      onError: _onStepCountError,
      cancelOnError: true,
    );
  }

  /// Manejador de eventos del sensor: actualiza los pasos
  /// y los transmite por el stream para ser usados por la interfaz.
  void _onStepCount(StepCount event) {
    if (_initialSteps == 0) {
      _initialSteps = event.steps;
    }

    _currentSteps =
        event.steps - _initialSteps; // Pasos dados durante esta sesión
    _stepController.add(_currentSteps); // Emite el nuevo conteo a los listeners
  }

  /// Manejador de errores del sensor: imprime mensaje y notifica a los
  /// listeners del error.
  void _onStepCountError(error) {
    print('ERROOOOOOR: $error');
    _stepController.addError('No hay sensor');
  }

  /// Libera los recursos del stream cuando ya no se necesita.
  void dispose() {
    _stepController.close();
  }
}
