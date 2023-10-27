import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

class FileManager {
  final PathProviderPlatform _pathProvider = PathProviderPlatform.instance;
  late String _path = '';

  Future<String> get path async {
    if (_path.isEmpty) {
      _path = await _pathProvider.getApplicationDocumentsPath() ?? '';
      if (_path.isEmpty) {
        throw Exception('Could not get the documents directory');
      }
    }

    return '$_path/sync';
  }

  Future<void> createFolderSync() async {
    final dir = await path;
    final syncDir = Directory(dir);
    if (!await syncDir.exists()) {
      await syncDir.create();
    }
  }

  Future<String> createSqlFile() async {
    final dir = await path;
    final file = File('$dir/content.sql');
    if (!await file.exists()) {
      file.createSync();
    }
    return file.path;
  }

  Future<String> writeTextFile() async {
    await createFolderSync();
    await createSqlFile();

    const content = 'INSERT INTO table (column) VALUES (value);';

    final dir = await path;
    final fileName = '$dir/content.sql';
    final file = File(fileName);
    await file.writeAsString(content);

    return content;
  }
}
