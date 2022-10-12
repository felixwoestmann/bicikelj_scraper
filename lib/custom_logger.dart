import 'package:logger/logger.dart';

class CustomLogger {
  static final Logger logger = Logger(
    printer: PrettyPrinter(methodCount: 0, printEmojis: false),
    output: null,
  );

  static void log(String message) {
    logger.i(message);
  }
}
