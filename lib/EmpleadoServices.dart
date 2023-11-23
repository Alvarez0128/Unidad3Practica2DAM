import 'package:cloud_firestore/cloud_firestore.dart';
import 'Empleado.dart';

class EmpleadoService {
  final CollectionReference empleadosCollection = FirebaseFirestore.instance.collection('Empleado');

  Future<void> agregarEmpleado(Empleado empleado) async {
    await empleadosCollection.add({
      'nombreEmpleado': empleado.nombreEmpleado,
      'salario': empleado.salario,
      'puesto': empleado.puesto,
      'departamento': empleado.departamento,
      'direccion': empleado.direccion,
      'telefono': empleado.telefono,
    });
  }

  Stream<List<Empleado>> obtenerEmpleados() {
    return empleadosCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Empleado(
          id: doc.id,
          nombreEmpleado: doc['nombreEmpleado'],
          salario: doc['salario'],
          puesto: doc['puesto'],
          departamento: doc['departamento'],
          direccion: doc['direccion'],
          telefono: doc['telefono'],
        );
      }).toList();
    });
  }

  Future<void> actualizarEmpleado(Empleado empleado) async {
    await empleadosCollection.doc(empleado.id).update({
      'nombreEmpleado': empleado.nombreEmpleado,
      'salario': empleado.salario,
      'puesto': empleado.puesto,
      'departamento': empleado.departamento,
      'direccion': empleado.direccion,
      'telefono': empleado.telefono,
    });
  }

  Future<void> eliminarEmpleado(String empleadoId) async {
    await empleadosCollection.doc(empleadoId).delete();
  }
}
