import 'package:flutter/material.dart';

import 'Empleado.dart';
import 'EmpleadoServices.dart';

class AppPrincipal extends StatefulWidget {
  const AppPrincipal({super.key});

  @override
  State<AppPrincipal> createState() => _AppPrincipalState();
}

class _AppPrincipalState extends State<AppPrincipal> {
  final EmpleadoService _empleadoService = EmpleadoService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Base de datos de empleados", style: TextStyle(fontWeight: FontWeight.w300),),
        backgroundColor: const Color.fromRGBO(171, 235, 247, 1),
        actions: [
          IconButton(
            icon: const Icon(Icons.quiz_rounded),
            onPressed: () {
              _mostrarDialogoAbout(context);
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Empleado>>(
        stream: _empleadoService.obtenerEmpleados(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          List<Empleado> empleados = snapshot.data!;

          if(empleados.isEmpty){
            return const Center(child: Text("Sin empleados registrados"),);
          }else{
            return ListView.builder(
              itemCount: empleados.length,
              itemBuilder: (context, index) {
                return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 3.0),
                      borderRadius: BorderRadius.circular(24.0),
                      color: const Color.fromRGBO(222, 248, 255, 1),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(252, 255, 224, 1),
                          offset: Offset(0.0, 0.0),
                          blurRadius: 10.0,
                        ),
                      ],
                    ),
                    margin: const EdgeInsets.fromLTRB(8, 5, 10, 5),
                    child: ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                      title: Text(empleados[index].nombreEmpleado),
                      subtitle: Text('${empleados[index].puesto} - ${empleados[index].departamento}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _mostrarDialogoEliminar(context, empleados[index]),
                      ),
                      onTap: () => _mostrarDialogoDetalle(context, empleados[index]),
                    ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarFormulario(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _mostrarFormulario(BuildContext context) {
    TextEditingController nombreController = TextEditingController();
    TextEditingController salarioController = TextEditingController();
    TextEditingController puestoController = TextEditingController();
    TextEditingController departamentoController = TextEditingController();
    TextEditingController direccionController = TextEditingController();
    TextEditingController telefonoController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      elevation: 1,
      builder: (builder) {
        return Container(
            padding: EdgeInsets.only(
              top: 15,
              left: 30,
              right: 30,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Agregar nuevo empleado',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextField(
                  controller: nombreController,
                  decoration: const InputDecoration(labelText: 'Nombre:'),
                ),
                TextField(
                  controller: salarioController,
                  decoration: const InputDecoration(labelText: 'Salario:'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: puestoController,
                  decoration: const InputDecoration(labelText: 'Puesto:'),
                ),
                TextField(
                  controller: departamentoController,
                  decoration: const InputDecoration(labelText: 'Departamento:'),
                ),
                TextField(
                  controller: direccionController,
                  decoration: const InputDecoration(labelText: 'Dirección:'),
                ),
                TextField(
                  controller: telefonoController,
                  decoration: const InputDecoration(labelText: 'Teléfono:'),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Insertar el nuevo empleado
                        _empleadoService.agregarEmpleado(Empleado(
                          id: '', // No es necesario para agregar un nuevo empleado
                          nombreEmpleado: nombreController.text,
                          salario: double.parse(salarioController.text),
                          puesto: puestoController.text,
                          departamento: departamentoController.text,
                          direccion: direccionController.text,
                          telefono: telefonoController.text,
                        ));

                        // Mostrar un SnackBar para indicar el éxito
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Empleado agregado con éxito'),
                          ),
                        );
                        // Limpiar los campos y cerrar el Modal
                        nombreController.clear();
                        salarioController.clear();
                        puestoController.clear();
                        departamentoController.clear();
                        direccionController.clear();
                        telefonoController.clear();

                        Navigator.of(context).pop();
                      },
                      child: const Text('Insertar'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Limpiar los campos y cerrar el Modal
                        nombreController.clear();
                        salarioController.clear();
                        puestoController.clear();
                        departamentoController.clear();
                        direccionController.clear();
                        telefonoController.clear();

                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancelar'),
                    ),
                  ],
                ),
              ],
            ),
        );
      },
    );
  }

  void _mostrarFormularioActualizar(BuildContext context, Empleado empleado) {
    TextEditingController nombreController = TextEditingController(text: empleado.nombreEmpleado);
    TextEditingController salarioController = TextEditingController(text: empleado.salario.toString());
    TextEditingController puestoController = TextEditingController(text: empleado.puesto);
    TextEditingController departamentoController = TextEditingController(text: empleado.departamento);
    TextEditingController direccionController = TextEditingController(text: empleado.direccion);
    TextEditingController telefonoController = TextEditingController(text: empleado.telefono);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      elevation: 1,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(
            top: 15,
            left: 30,
            right: 30,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Actualizar empleado',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: nombreController,
                decoration: const InputDecoration(labelText: 'Nombre:'),
              ),
              TextField(
                controller: salarioController,
                decoration: const InputDecoration(labelText: 'Salario:'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: puestoController,
                decoration: const InputDecoration(labelText: 'Puesto:'),
              ),
              TextField(
                controller: departamentoController,
                decoration: const InputDecoration(labelText: 'Departamento:'),
              ),
              TextField(
                controller: direccionController,
                decoration: const InputDecoration(labelText: 'Dirección:'),
              ),
              TextField(
                controller: telefonoController,
                decoration: const InputDecoration(labelText: 'Teléfono:'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Actualizar el empleado
                      _empleadoService.actualizarEmpleado(Empleado(
                        id: empleado.id,
                        nombreEmpleado: nombreController.text,
                        salario: double.parse(salarioController.text),
                        puesto: puestoController.text,
                        departamento: departamentoController.text,
                        direccion: direccionController.text,
                        telefono: telefonoController.text,
                      ));

                      // Mostrar un SnackBar para indicar el éxito
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Empleado actualizado con éxito'),
                        ),
                      );

                      // Cerrar el Modal
                      Navigator.of(context).pop();
                    },
                    child: const Text('Actualizar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Cerrar el Modal
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancelar'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _mostrarDialogoDetalle(BuildContext context, Empleado empleado) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Detalle del empleado'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _detalleRow('ID', empleado.id),
              _detalleRow('Nombre', empleado.nombreEmpleado),
              _detalleRow('Salario', empleado.salario.toString()),
              _detalleRow('Puesto', empleado.puesto),
              _detalleRow('Departamento', empleado.departamento),
              _detalleRow('Dirección', empleado.direccion),
              _detalleRow('Teléfono', empleado.telefono),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _mostrarFormularioActualizar(context, empleado);
              },
              child: const Text('Actualizar'),
            ),
          ],
        );
      },
    );
  }

  Widget _detalleRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }

  void _mostrarDialogoEliminar(BuildContext context, Empleado empleado) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmación'),
          content: Text('¿Seguro que desea eliminar a ${empleado.nombreEmpleado}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _empleadoService.eliminarEmpleado(empleado.id);

                // Mostrar un SnackBar para indicar el éxito
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Empleado eliminado con éxito'),
                  ),
                );

                Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  void _mostrarDialogoAbout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Acerca de'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _detalleRow('Nombre', 'César E. Álvarez Jimenez'),
              _detalleRow('NoControl', '19400686'),
              _detalleRow('Grupo', '08:00 - 09:00'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
