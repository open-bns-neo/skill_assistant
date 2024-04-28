import 'package:flutter/material.dart';

class EditableTextWidget extends StatefulWidget {
  final Function(String)? onChanged;
  final String text;
  const EditableTextWidget(this.text, {super.key, this.onChanged});

  @override
  State createState() => _EditableTextWidgetState();
}

class _EditableTextWidgetState extends State<EditableTextWidget> {
  final _textEditingController = TextEditingController();
  final _focusNode = FocusNode();
  bool _isEditing = false;
  String _displayText = '';

  @override
  void initState() {
    super.initState();
    _displayText = widget.text;
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        setState(() {
          _isEditing = false;
          _displayText = _textEditingController.text;
          widget.onChanged?.call(_displayText);
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        setState(() {
          _isEditing = true;
          _textEditingController.text = _displayText; // 显示之前的文本
        });
      },
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Theme.of(context).secondaryHeaderColor,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: _isEditing
            ? TextFormField(
          focusNode: _focusNode,
          controller: _textEditingController,
          autofocus: true,
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            labelText: '重命名',
          ),
          onFieldSubmitted: (value) {
            setState(() {
              _displayText = value;
              _isEditing = false;
            });
          },
        )
            : Text(
          _displayText,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}