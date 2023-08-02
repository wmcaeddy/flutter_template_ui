import 'package:elearning_app/constants/colors.dart';
import 'package:flutter/material.dart';

class SearchInput extends StatefulWidget {
  final void Function(String) onSearch; // Callback function to trigger API call

  const SearchInput({Key? key, required this.onSearch}) : super(key: key);

  @override
  _SearchInputState createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  final TextEditingController _searchController = TextEditingController();

  void _handleSearch() {
    final searchText = _searchController.text;
    widget.onSearch(searchText); // Trigger the onSearch callback with the search text.
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              border: Border.all(
                color: ccFontLight.withOpacity(0.3),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(26),
            ),
            child: TextField(
              controller: _searchController,
              cursorColor: ccFontLight,
              onSubmitted: (_) => _handleSearch(), // Call _handleSearch on "Enter" key press
              decoration: InputDecoration(
                fillColor: ccFontLight.withOpacity(0.1),
                filled: true, //set background inside text field
                contentPadding: const EdgeInsets.all(18),
                border: InputBorder.none, //remove default border from TextField()
                hintText: "Search for history, classes...",
                hintStyle: const TextStyle(
                  color: ccFontLight,
                ),
              ),
            ),
          ),
          Positioned(
            right: 45,
            top: 35,
            child: GestureDetector(
              onTap: _handleSearch, // Call _handleSearch on search icon click
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ccAccent,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Image.asset(
                  "assets/icons/search.png",
                  width: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}