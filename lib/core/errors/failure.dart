abstract class Failure {
  final String message;

  Failure({required this.message});

  @override
  String toString() => message;
}

abstract class Success {
  final String message;

  Success({required this.message});

  @override
  String toString() => message;
}
