import 'package:flutter/material.dart';


class CustomTrainWidget extends StatelessWidget {
  final String title;
  final Widget child;
  const CustomTrainWidget({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, BoxConstraints constraints){
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          padding: const EdgeInsets.all(8),
          width: double.infinity,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).colorScheme.background,
            boxShadow: const [
              BoxShadow(
                  blurRadius: 5,
                  spreadRadius: 3,
                  offset: Offset(0,2),
                  color: Colors.black12
              ),
            ],
          ),
          child: Column(
            children: [
              Text(title, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 10),
              child
            ],
          ),
        );
      },
    );
  }
}
