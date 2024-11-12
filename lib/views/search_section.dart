import 'package:flutter/material.dart';

class SearchSection extends StatelessWidget {
  final List<String> items = ['Option 1', 'Option 2', 'Option 3'];
  String? selectedItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              DropdownButton<String>(
                hint: Text('Select'),
                value: selectedItem,
                onChanged: (value) {
                  selectedItem = value;
                },
                items: items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
