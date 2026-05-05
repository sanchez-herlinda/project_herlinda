import 'dart:io';

void main() async {
  print('\n🚀 --- Agente de GitHub para Flutter/Dart --- 🚀\n');

  // 1. Pedir el link del repositorio
  stdout.write(
    '🔗 Ingresa el link de tu nuevo repositorio en GitHub (ej. https://github.com/usuario/repo.git):\n> ',
  );
  String? repoLink = stdin.readLineSync();

  if (repoLink == null || repoLink.trim().isEmpty) {
    print('❌ Error: El link del repositorio es obligatorio.');
    exit(1);
  }

  // 2. Pedir el mensaje del commit
  stdout.write('\n💬 Ingresa el mensaje del commit:\n> ');
  String? commitMessage = stdin.readLineSync();

  if (commitMessage == null || commitMessage.trim().isEmpty) {
    commitMessage = 'Initial commit';
    print('⚠️ No ingresaste mensaje. Se usará por defecto: "$commitMessage"');
  }

  // 3. Pedir la rama (Main por defecto)
  stdout.write(
    '\n🌿 Ingresa el nombre de la rama (Presiona Enter para usar "main"):\n> ',
  );
  String? branchName = stdin.readLineSync();

  if (branchName == null || branchName.trim().isEmpty) {
    branchName = 'main';
  }

  print('\n⚙️  Ejecutando secuencia de Git...\n');

  // Función auxiliar para ejecutar comandos en la terminal
  Future<void> runGitCommand(
    List<String> args, {
    bool ignoreError = false,
  }) async {
    print('\$ git ${args.join(' ')}');
    var result = await Process.run('git', args);

    if (result.exitCode != 0 && !ignoreError) {
      print('❌ Error ejecutando comando:');
      print(result.stderr);
      exit(1); // Detener el script si hay un error crítico
    } else if (result.stdout.toString().trim().isNotEmpty) {
      print(result.stdout);
    }
  }

  try {
    // Inicializar git (por si flutter create no lo hizo, o para asegurarlo)
    await runGitCommand(['init']);

    // Agregar todos los archivos
    await runGitCommand(['add', '.']);

    // Crear el commit (ignoramos error aquí por si no hay cambios nuevos)
    await runGitCommand([
      'commit',
      '-m',
      commitMessage.trim(),
    ], ignoreError: true);

    // Renombrar la rama a la seleccionada (ej. main)
    await runGitCommand(['branch', '-M', branchName.trim()]);

    // Limpiar el remote 'origin' por si ya existía uno viejo y agregar el nuevo
    await runGitCommand(['remote', 'remove', 'origin'], ignoreError: true);
    await runGitCommand(['remote', 'add', 'origin', repoLink.trim()]);

    // Hacer el push
    print('\n⏳ Subiendo archivos a GitHub...');
    await runGitCommand(['push', '-u', 'origin', branchName.trim()]);

    print('\n✅ ¡Éxito! Tu proyecto ha sido subido a GitHub correctamente. 🌐');
  } catch (e) {
    print('\n❌ Ocurrió un error inesperado: $e');
  }
}
