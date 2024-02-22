

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stand_by_me/pages/provider/provider.dart';
import 'colors.dart';

class EditableTextWidget extends StatefulWidget {
  final String note;
  const EditableTextWidget({super.key, required this.note});
  @override
  EditableTextWidgetState createState() => EditableTextWidgetState();
}



class EditableTextWidgetState extends State<EditableTextWidget> {
  late TextEditingController _textEditingController;
  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: widget.note);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ListeningProvider listenVM = Provider.of<ListeningProvider>(context,listen:true);
    return EditableText(
      textAlign: TextAlign.start,
      autofocus: true,
      controller: _textEditingController,
      backgroundCursorColor: Colors.blue,
      cursorColor: Colors.red,
      focusNode: FocusNode(),
      style: const TextStyle(
        fontSize: 50.0,
        color: CustomColor.grey,
        fontWeight: FontWeight.bold,
      ),
      onChanged: (value) {
        setState(() {
          listenVM.isChanged = true;
          listenVM.collectedNoteText = _textEditingController.value.text.toString();
        });
      },
      onSubmitted: (value) {
        setState(() {
          listenVM.collectedNoteText = _textEditingController.value.text.toString();
        });
        if (kDebugMode) {
          print('Submitted text: $value');
        }
      },
      selectionControls: MaterialTextSelectionControls(),
      keyboardType: TextInputType.text,
      maxLines: null,
    );
  }
}
