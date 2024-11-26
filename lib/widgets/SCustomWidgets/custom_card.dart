import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String imageAssetPath;
  final String title;
  const CustomCard({super.key, required this.imageAssetPath, required this.title});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).colorScheme.background,
          ),
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(imageAssetPath, width: 44, height: 44,),
              const SizedBox(width: 20),
              Text(title, style: Theme.of(context).textTheme.bodyLarge,),
            ],
          ),
        ),
      ),
    );
  }
}
