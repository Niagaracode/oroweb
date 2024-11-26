import 'package:flutter/material.dart';

class AdditionalInformation extends StatelessWidget {
  final String label;
  final String value;
  final String assetImage;
  final String Max;
  final String Min;

  const AdditionalInformation({
    super.key,
    required this.label,
    required this.value,
    required this.assetImage,
    required this.Max,
    required this.Min,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          mainAxisAlignment:
              MainAxisAlignment.start, // Center content vertically
          crossAxisAlignment:
              CrossAxisAlignment.start, // Center content horizontally
          children: [
            Image.asset(
              assetImage,
              width: 110,
              height: 90,
              fit: BoxFit.scaleDown,
            ),
            const SizedBox(height: 20),
            if (label != "WindDirection") ...[
              SizedBox(
                width: 170,
                child: Text(
                  "Max : $Max",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    letterSpacing: 1.0,
                  ),
                  textAlign: TextAlign.end, // Ensure text is centered
                ),
              ),
              SizedBox(
                width: 170,
                child: Text(
                  "Min : $Min",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.end, // Ensure text is centered
                ),
              ),
            ],
          ],
        ),
        const SizedBox(width: 0),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 20, 85.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label == "AtmospherePressure" ? "Air Pressure" : label,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8),
              ),
              const SizedBox(height: 0),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.pinkAccent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
