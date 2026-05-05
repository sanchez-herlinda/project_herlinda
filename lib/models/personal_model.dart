import 'package:cloud_firestore/cloud_firestore.dart';

class PersonalModel {
  String? id;
  String nombre;
  String puesto;
  String salario;

  PersonalModel({
    this.id,
    required this.nombre,
    required this.puesto,
    required this.salario,
  });

  Map<String, dynamic> toJson() => {
    "nombre": nombre,
    "puesto": puesto,
    "salario": salario,
  };

  factory PersonalModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return PersonalModel(
      id: doc.id,
      nombre: data['nombre'] ?? '',
      puesto: data['puesto'] ?? '',
      salario: data['salario']?.toString() ?? '0',
    );
  }
}
