class GeneralError implements Exception {
  final String messsage;
  final StackTrace? stackTrace;
  GeneralError(this.messsage, [this.stackTrace]);
}
