import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.pinkAccent,
          title: const Text(
            "Lucky Number Generator",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: const LuckyNumber(),
      ),
    ));

class LuckyNumber extends StatefulWidget {
  const LuckyNumber({super.key});

  @override
  State<LuckyNumber> createState() => _LuckyNumberState();
}

class _LuckyNumberState extends State<LuckyNumber> {
  final key = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();
  Map<String, String> _luckyNumbers =
      {}; // Store lucky numbers with their messages

  void validateData() {
    if (key.currentState!.validate()) {
      _generateLuckyNumbers();
    }
  }

  void _generateLuckyNumbers() {
    final inputText = _controller.text;
    if (inputText.isNotEmpty) {
      final numbers = inputText.split(',').map((s) => s.trim()).toList();
      final Map<String, String> result = {};

      for (var numStr in numbers) {
        final int inputNumber = int.tryParse(numStr) ?? 0;
        final int luckyNumber = _calculateLuckyNumber(inputNumber);

        result[numStr] = luckyNumber >= 7
            ? 'Congratulations! Your number $numStr is lucky with a single-digit lucky number $luckyNumber!'
            : 'Sorry, your number $numStr is not considered lucky with a single-digit lucky number $luckyNumber.';
      }

      setState(() {
        _luckyNumbers = result;
      });
    }
  }

  int _calculateLuckyNumber(int number) {
    // Helper function to calculate the sum of digits
    int sumOfDigits(int number) {
      int sum = 0;
      while (number > 0) {
        sum += number % 10;
        number ~/= 10;
      }
      return sum;
    }

    // Reduce number to a single digit
    int luckyNumber = number;
    while (luckyNumber >= 10) {
      luckyNumber = sumOfDigits(luckyNumber);
    }
    return luckyNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: key,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: _controller,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field can\'t be empty.';
                }
                return null;
              },
              decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(),
                    borderRadius: BorderRadius.all(Radius.zero)),
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.greenAccent,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.all(Radius.zero)),
                contentPadding: EdgeInsets.all(20),
                hintText: 'Enter numbers separated by commas',
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: validateData,
              child: const Text("Generate Lucky Numbers"),
            ),
            const SizedBox(height: 20),
            if (_luckyNumbers.isNotEmpty)
              ..._luckyNumbers.entries.map((entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      entry.value,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                      ),
                    ),
                  )),
          ],
        ),
      ),
    );
  }
}
