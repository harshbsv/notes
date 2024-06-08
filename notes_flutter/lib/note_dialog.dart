import 'package:flutter/material.dart';

void showNoteDialog({
  required BuildContext context,
  String text = '',
  required ValueChanged<String> onSaved,
}) {
  showDialog(
    context: context,
    builder: (context) => NoteDialog(
      text: text,
      onSaved: onSaved,
    ),
  );
}

void showUpdateNoteDialog({
  required BuildContext context,
  String text = '',
  required ValueChanged<String> onSaved,
}) {
  showDialog(
    context: context,
    builder: (context) => UpdateNoteDialog(
      text: text,
      onSaved: onSaved,
    ),
  );
}

class NoteDialog extends StatefulWidget {
  const NoteDialog({
    required this.text,
    required this.onSaved,
    super.key,
  });

  final String text;
  final ValueChanged<String> onSaved;

  @override
  State<NoteDialog> createState() => _NoteDialogState();
}

class _NoteDialogState extends State<NoteDialog> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.text = widget.text;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                expands: true,
                maxLines: null,
                minLines: null,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Write your note here.....',
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (controller.text.trim().isNotEmpty) {
                      widget.onSaved(controller.text.trim());
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Create New Note'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class UpdateNoteDialog extends StatefulWidget {
  const UpdateNoteDialog({
    required this.text,
    required this.onSaved,
    super.key,
  });

  final String text;
  final ValueChanged<String> onSaved;

  @override
  State<UpdateNoteDialog> createState() => _UpdateNoteDialogState();
}

class _UpdateNoteDialogState extends State<UpdateNoteDialog> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.text = widget.text;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                expands: true,
                maxLines: null,
                minLines: null,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Write your note here.....',
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (controller.text.trim().isNotEmpty) {
                      widget.onSaved(controller.text.trim());
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Update Note'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
