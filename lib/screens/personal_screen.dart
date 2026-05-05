import 'package:flutter/material.dart';
import '../models/personal_model.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';

class PersonalScreen extends StatelessWidget {
  const PersonalScreen({super.key});

  void _mostrarForm(BuildContext context, [PersonalModel? p]) {
    final n = TextEditingController(text: p?.nombre);
    final pu = TextEditingController(text: p?.puesto);
    final s = TextEditingController(text: p?.salario);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: n,
              decoration: const InputDecoration(labelText: "Nombre completo"),
            ),
            TextField(
              controller: pu,
              decoration: const InputDecoration(labelText: "Puesto"),
            ),
            TextField(
              controller: s,
              decoration: const InputDecoration(labelText: "Salario"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final fs = FirestoreService();
                final nuevo = PersonalModel(
                  id: p?.id,
                  nombre: n.text,
                  puesto: pu.text,
                  salario: s.text,
                );
                p == null ? fs.addPersonal(nuevo) : fs.updatePersonal(nuevo);
                Navigator.pop(context);
              },
              child: const Text("Guardar"),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final FirestoreService fs = FirestoreService();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestión de Personal"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => AuthService().logout(),
          ),
        ],
      ),
      body: StreamBuilder<List<PersonalModel>>(
        stream: fs.getPersonal(),
        builder: (context, snap) {
          if (!snap.hasData)
            return const Center(child: CircularProgressIndicator());
          return ListView.builder(
            itemCount: snap.data!.length,
            itemBuilder: (context, i) {
              final persona = snap.data![i];
              return ListTile(
                title: Text(persona.nombre),
                subtitle: Text(persona.puesto),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => fs.deletePersonal(persona.id!),
                ),
                onTap: () => _mostrarForm(context, persona),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
