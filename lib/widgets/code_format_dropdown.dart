import 'package:flutter/material.dart';

class CodeFormatDropdown extends StatefulWidget {
  Function(int) onPick;

  CodeFormatDropdown({this.onPick});

  @override
  _CodeFormatDropdownState createState() => _CodeFormatDropdownState();
}

class _CodeFormatDropdownState extends State<CodeFormatDropdown> {
  int _selectedValue = 6;

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      items: [
        DropdownMenuItem(
          value: 2,
          child: Text(
            "Code39",
          ),
        ),
        DropdownMenuItem(
          value: 6,
          child: Text(
            "Code128",
          ),
        ),
        DropdownMenuItem(
          value: 3,
          child: Text(
            "Code93",
          ),
        ),
        DropdownMenuItem(
          value: 1,
          child: Text(
            "EAN8",
          ),
        ),
        DropdownMenuItem(
          value: 0,
          child: Text(
            "EAN13",
          ),
        ),
        DropdownMenuItem(
          value: 4,
          child: Text(
            "UPCA",
          ),
        ),
        DropdownMenuItem(
          value: 5,
          child: Text(
            "UPCE",
          ),
        ),
      ],
      onChanged: (value) {
        setState(() {
          _selectedValue = value;
        });
        widget.onPick(value);
      },
      value: _selectedValue,
    );
  }
}
