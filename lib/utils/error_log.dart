import 'log/app_log.dart';

void errorLog(String message, dynamic e, {String title = "Error form"}) {
  appLog("$message >>> ${e.toString()}", source: title);
}
