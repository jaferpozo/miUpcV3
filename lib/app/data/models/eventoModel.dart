part of 'models.dart';
class EventoModel extends EventoEntity {
  EventoModel({
    super.id,
    required super.idDispositivo,
    required super.tipoEvento,
    required super.fechaEvento,
    required super.descripcionEvento,
    required super.referenciaLugar,
    required super.latitudDispositivo,
    required super.longitudDispositivo,
    required super.latitudEvento,
    required super.longitudEvento,
    required super.nombreSeudonimo,
    required super.numeroTelefono,
    required super.correoElectronico,
    super.nombreArchivoRespaldo,
    required super.direccionIp,
    required super.agenteUsuario,
    required super.estado,
    required super.fechaCreacion,
    required super.fechaActualizacion,
  });

  factory EventoModel.fromJson(Map<String, dynamic> json) {
    return EventoModel(
      id: json['id'],
      idDispositivo: json['idDispositivo'] ?? '',
      tipoEvento: json['tipoEvento'] ?? '',
      fechaEvento: (json['fechaEvento']),
      descripcionEvento: json['descripcionEvento'] ?? '',
      referenciaLugar: json['referenciaLugar'] ?? '',
      latitudDispositivo: (json['latitudDispositivo'] as num).toDouble(),
      longitudDispositivo: (json['longitudDispositivo'] as num).toDouble(),
      latitudEvento: (json['latitudEvento'] as num).toDouble(),
      longitudEvento: (json['longitudEvento'] as num).toDouble(),
      nombreSeudonimo: json['nombreSeudonimo'] ?? '',
      numeroTelefono: json['numeroTelefono'] ?? '',
      correoElectronico: json['correoElectronico'] ?? '',
      nombreArchivoRespaldo: json['nombreArchivoRespaldo'],
      direccionIp: json['direccionIp'] ?? '',
      agenteUsuario: json['agenteUsuario'] ?? '',
      estado: json['estado'] ?? '',
      fechaCreacion: (json['fechaCreacion']),
      fechaActualizacion: (json['fechaActualizacion']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idDispositivo': idDispositivo,
      'tipoEvento': tipoEvento,
      'fechaEvento': fechaEvento,
      'descripcionEvento': descripcionEvento,
      'referenciaLugar': referenciaLugar,
      'latitudDispositivo': latitudDispositivo,
      'longitudDispositivo': longitudDispositivo,
      'latitudEvento': latitudEvento,
      'longitudEvento': longitudEvento,
      'nombreSeudonimo': nombreSeudonimo,
      'numeroTelefono': numeroTelefono,
      'correoElectronico': correoElectronico,
      'nombreArchivoRespaldo': nombreArchivoRespaldo,
      'direccionIp': direccionIp,
      'agenteUsuario': agenteUsuario,
      'estado': estado,
      'fechaCreacion': fechaCreacion,
      'fechaActualizacion': fechaActualizacion,
    };
  }

  factory EventoModel.fromEntity(EventoEntity entity) {
    return EventoModel(
      id: entity.id,
      idDispositivo: entity.idDispositivo,
      tipoEvento: entity.tipoEvento,
      fechaEvento: entity.fechaEvento,
      descripcionEvento: entity.descripcionEvento,
      referenciaLugar: entity.referenciaLugar,
      latitudDispositivo: entity.latitudDispositivo,
      longitudDispositivo: entity.longitudDispositivo,
      latitudEvento: entity.latitudEvento,
      longitudEvento: entity.longitudEvento,
      nombreSeudonimo: entity.nombreSeudonimo,
      numeroTelefono: entity.numeroTelefono,
      correoElectronico: entity.correoElectronico,
      nombreArchivoRespaldo: entity.nombreArchivoRespaldo,
      direccionIp: entity.direccionIp,
      agenteUsuario: entity.agenteUsuario,
      estado: entity.estado,
      fechaCreacion: entity.fechaCreacion,
      fechaActualizacion: entity.fechaActualizacion,
    );
  }
}
