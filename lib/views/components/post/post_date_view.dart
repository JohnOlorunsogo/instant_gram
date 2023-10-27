import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostDateView extends StatelessWidget {
  const PostDateView({required this.date, super.key});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat.yMMMMd('en_US');
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Text(formatter.format(date)),
    );
  }
}
