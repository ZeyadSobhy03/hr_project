import 'app_exception.dart';

class PermissionDeniedException extends AppException {
  const PermissionDeniedException(super.message);
}