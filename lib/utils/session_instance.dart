import 'package:frontend/models/particpant.dart';
import 'package:frontend/services/session_service.dart';

/// SessionService-Instanz, um nicht immer eine neue Instanz vom Service erzeugen zu müssen (Single Point Of Truth)
SessionService sessionService = SessionService();

Participant participant = Participant();
