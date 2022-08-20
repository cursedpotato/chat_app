import 'package:chat_app/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PeopleScreen extends HookWidget {
  const PeopleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var searchController = useTextEditingController();
    return SafeArea(
      child: Row(
        children: [
          Expanded(
            child: Container(
              
              padding: const EdgeInsets.symmetric(
                  horizontal: kDefaultPadding * 0.75),
              decoration: BoxDecoration(

                color: kPrimaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: searchController,
                maxLines: 1,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                    hintText: "Search a friend", border: InputBorder.none),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: const Icon(
              Icons.search,
            ),
          )
        ],
      ),
    );
  }
}
