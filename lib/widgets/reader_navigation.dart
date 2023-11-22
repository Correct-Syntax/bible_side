import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/reader_text.dart';
import '../core/provider.dart';


class ReaderNavigation extends StatefulWidget {
  const ReaderNavigation({super.key});

  @override
  State<ReaderNavigation> createState() => _ReaderNavigationState();
}

class _ReaderNavigationState extends State<ReaderNavigation> {

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigation'),
        actions: [

        ]
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 30.0),
          child: GridView.builder(
            itemCount: bookMapping.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 120,
              childAspectRatio: 4 / 2,
              crossAxisSpacing: 18,
              mainAxisSpacing: 8
            ),
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  appProvider.currentBookCode = bookMapping.keys.elementAt(index);
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    bookMapping.values.elementAt(index),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge
                  ),
                ),
              );
            }
          ),
        )
      )
    );
  }
}