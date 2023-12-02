import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final String field;
  final String content;
  final void Function()? onEdit;
  const ProfileCard({super.key, required this.field, required this.content, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16)
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(field, style: const TextStyle(color: Colors.black45),),
                  GestureDetector(onTap: onEdit,child: const Icon(Icons.edit))
                ],
              ),
              const SizedBox(height: 10),
              Text(content, style: const TextStyle(fontWeight: FontWeight.bold),),
            ],
          ),
        ),
      ),
    );
  }
}
