import 'package:flutter/material.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../../core/theme/sizes.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({
    super.key,
    required this.searchController,
    required this.onTap,
  });

  final TextEditingController searchController;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _searchBar(),
        _searchButton(),
      ],
    );
  }

  _searchBar() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding * 0.75),
        decoration: BoxDecoration(
          color: kPrimaryColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextField(
          controller: searchController,
          maxLines: 1,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
            hintText: "Search a friend",
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _searchButton() {
    return Padding(
      padding: const EdgeInsets.only(right: kDefaultPadding * 0.75),
      child: GestureDetector(
        onTap: onTap,
        child: const Icon(
          Icons.search,
        ),
      ),
    );
  }
}
