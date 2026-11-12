import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

/// Error ya traducido a un mensaje que el usuario puede entender.
class RepositorioException implements Exception {
  RepositorioException(this.mensaje, {this.codigo});
  final String mensaje;
  final String? codigo;

  @override
  String toString() => 'RepositorioException($codigo): $mensaje';
}

/// Convierte cualquier error técnico en un mensaje para el usuario.
String mensajeParaUsuario(Object error) {
  if (error is RepositorioException) return error.mensaje;
  if (error is TimeoutException) {
    return 'La operación tardó demasiado. Revisa tu conexión e inténtalo de nuevo.';
  }
  if (error is FirebaseException) {
    switch (error.code) {
      case 'permission-denied':
        return 'No tienes permiso para realizar esta acción.';
      case 'unavailable':
        return 'No hay conexión con el servidor. Inténtalo de nuevo en unos instantes.';
      case 'not-found':
        return 'La tarea ya no existe. Es posible que se haya eliminado.';
      case 'failed-precondition':
        // Típico cuando falta un índice compuesto.
        return 'La consulta necesita una configuración adicional en Firebase (índice).';
      case 'deadline-exceeded':
        return 'El servidor tardó demasiado en responder.';
      default:
        return 'Ocurrió un error inesperado (${error.code}).';
    }
  }
  return 'Ocurrió un error inesperado.';
}
