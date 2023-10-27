import 'package:flutter/material.dart';
import 'package:path_experiments/file_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Path Provider Test',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late FileManager _fileManager;

  @override
  void initState() {
    super.initState();
    _fileManager = FileManager();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      appBar: AppBar(
        title: const Text('Path Provider Test'),
        backgroundColor: Colors.deepPurple.shade300,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FutureBuilder(
              future: _fileManager.path,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Center(
                    child: Text(snapshot.data.toString()),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              }),
          ElevatedButton(
            onPressed: () async {
              final content = await _fileManager.writeTextFile();
              final fileDir = '${await _fileManager.path}/content.sql';
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 5),
                  // ignore: prefer_adjacent_string_concatenation
                  content: Text('File created at $fileDir' + '\n' + content),
                ),
              );
            },
            child: const Text('Create File'),
          ),
        ],
      ),
    );
  }
}
