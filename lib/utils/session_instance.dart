import 'package:frontend/services/session_service.dart';

/// Session-Instanz, um nicht immer eine neue Instanz vom Service erzeugen zu müssen (Single Point Of Truth)
final SessionService session = SessionService();
