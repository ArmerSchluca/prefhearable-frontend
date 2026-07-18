import 'package:frontend/models/particpant.dart';
import 'package:frontend/services/session_service.dart';

/// SessionService-Instanz, um nicht immer eine neue Instanz vom Service erzeugen zu müssen (Single Point Of Truth)
final SessionService sessionService = SessionService();

final Participant participant = Participant();
