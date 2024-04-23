import 'package:logging/logging.dart';
import 'package:signalr_netcore/http_connection_options.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';

import '../../network/endpoints.dart';
import '../../utils/prefs_helper.dart';

class HubHelper{
  static HubConnection? connection;
  static Future<void> initHub() async {
    const url = EndPoints.hubUrl;
    // Configure the logging
    Logger.root.level = Level.ALL;
    // Writes the log messages to the console
    Logger.root.onRecord.listen((LogRecord rec) {
      print('${rec.level.name}: ${rec.time}: ${rec.message}');
    });

    // If you want only to log out the message for the higher level hub protocol:
    final hubPortLogger = Logger("SignalR - hub");
    // If you want to also to log out transport messages:
    final transportProtLogger = Logger("SignalR - transport");

    //if(AppConstants.connection?.state == HubConnectionState.disconnected || AppConstants.connection?.connectionId == null) {
    connection = HubConnectionBuilder()
        .withUrl(EndPoints.finalHub,
        options: HttpConnectionOptions(
            logger: transportProtLogger
        ))
        .configureLogging(hubPortLogger)
        .withAutomaticReconnect()
        .build();
    await connection?.start();

    print("INIT ID : ${connection?.connectionId}\n");
    connection?.on("ReceiveNotification", (message) {
      print("RECEIVED $message\n");
    });
    connection?.onclose(({error}) {
      print("ON CLOSE : $error\n");
      connection?.start();
    });
  }
  static Future<String> getMyToken() async {
    if (Preference.prefs.containsKey('sessionToken')) {
      var token = Preference.prefs.getString('sessionToken').toString();
      return token;
    }
    return "Empty";
  }
}

