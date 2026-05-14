abstract class Failure {
  final String message;
  final StackTrace? stackTrace;

  const Failure(this.message, [this.stackTrace]);
}

class CalculationFailure extends Failure {
  const CalculationFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class ConversionFailure extends Failure {
  const ConversionFailure(super.message);
}

class StorageFailure extends Failure {
  const StorageFailure(super.message);
}
