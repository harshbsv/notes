import 'package:flutter/material.dart';
import 'package:notes_client/notes_client.dart';
import 'package:notes_flutter/loading_screen.dart';
import 'package:notes_flutter/note_dialog.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

// Sets up a singleton client object that can be used to talk to the server from
// anywhere in our app. The client is generated from your server code.
// The client is set up to connect to a Serverpod running on a local server on
// the default port. You will need to modify this to connect to staging or
// production servers.
// var client = Client('http://$localhost:8080/')
//   ..connectivityMonitor = FlutterConnectivityMonitor();

var client = Client('http://database.private-production.examplepod.com:5432')
  ..connectivityMonitor = FlutterConnectivityMonitor();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Serverpod Notes Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Note>? _notes;
  Exception? _connectionException;

  void _connectionFailed(dynamic exception) {
    setState(() {
      _notes = null;
      _connectionException = exception;
    });
  }

  Future<void> _loadNotes() async {
    try {
      final notes = await client.notes.getAllNotes();
      setState(() {
        _notes = notes;
      });
    } catch (e) {
      _connectionFailed(e);
    }
  }

  Future<void> _createNote(Note note) async {
    try {
      await client.notes.createNote(note);
      await _loadNotes();
    } catch (e) {
      _connectionFailed(e);
    }
  }

  Future<void> _deleteNote(Note note) async {
    try {
      await client.notes.deleteNote(note);
      await _loadNotes();
    } catch (e) {
      _connectionFailed(e);
    }
  }

  Future<void> _editNote(Note note) async {
    try {
      await client.notes.editNote(note);
      await _loadNotes();
    } catch (e) {
      _connectionFailed(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        title: const Text('Serverpod Notes'),
      ),
      body: _notes == null
          ? LoadingScreen(
              exception: _connectionException,
              onTryAgain: _loadNotes,
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _notes!.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.purpleAccent),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    title: Text(
                      _notes![index].text,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    trailing: SizedBox(
                      width: 150,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              showUpdateNoteDialog(
                                context: context,
                                text: _notes![index].text,
                                onSaved: (text) {
                                  // var note = Note(text: text);
                                  // _notes!.update(index, note);
                                  // _editNote(note);
                                  setState(() {
                                    _notes![index].text = text;
                                  });
                                  _editNote(_notes![index]);
                                },
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              var note = _notes![index];
                              setState(() {
                                _notes!.remove(note);
                              });
                              _deleteNote(note);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider();
              },
            ),
      floatingActionButton: _notes == null
          ? null
          : FloatingActionButton.extended(
              onPressed: () {
                showNoteDialog(
                  context: context,
                  onSaved: (text) {
                    var note = Note(text: text);
                    _notes!.add(note);
                    _createNote(note);
                  },
                );
              },
              label: const Text(
                'Create New Note',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              icon: const Icon(
                Icons.add,
                color: Colors.black,
                size: 16,
              ),
            ),
    );
  }
}
