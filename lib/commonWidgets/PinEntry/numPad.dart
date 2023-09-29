import 'package:flutter/material.dart';

class NumPad extends StatelessWidget {
  final List<TextEditingController> pinControllers;

  const NumPad({super.key, required this.pinControllers});
  @override
  Widget build(BuildContext context) {
    void inputNumber(String number) {
      for (var i = 0; i < 4; i++) {
        if (pinControllers[i].text.isEmpty) {
          pinControllers[i].text = number;
          if (i < 3) {
            // FocusScope.of(context).nextFocus();
          }
          break; // Exit loop after filling an empty slot
        }
      }
    }

    void deleteNumber() {
      for (var i = 3; i >= 0; i--) {
        if (pinControllers[i].text.isNotEmpty) {
          pinControllers[i].text = '';
          if (i > 0) {
            // FocusScope.of(context).previousFocus();
          }
          break; // Exit loop after deleting a digit
        }
      }
    }

    return Container(
      margin: const EdgeInsets.only(left: 30, right: 30),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ButtonOfNumPad(
                  num: "1",
                  onPressed: () {
                    inputNumber("1");
                  }),
              ButtonOfNumPad(
                num: "2",
                onPressed: () {
                  inputNumber("2");
                },
              ),
              ButtonOfNumPad(
                num: "3",
                onPressed: () {
                  inputNumber("3");
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ButtonOfNumPad(
                num: "4",
                onPressed: () {
                  inputNumber("4");
                },
              ),
              ButtonOfNumPad(
                num: "5",
                onPressed: () {
                  inputNumber("5");
                },
              ),
              ButtonOfNumPad(
                  num: "6",
                  onPressed: () {
                    inputNumber("6");
                  }),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ButtonOfNumPad(
                num: "7",
                onPressed: () {
                  inputNumber("7");
                },
              ),
              ButtonOfNumPad(
                num: "8",
                onPressed: () {
                  inputNumber("8");
                },
              ),
              ButtonOfNumPad(
                num: "9",
                onPressed: () {
                  inputNumber("9");
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: Row(
                  children: [
                    const Expanded(
                      child: SizedBox(),
                    ),
                    const SizedBox(width: 64),
                    Expanded(
                      child: ButtonOfNumPad(
                        num: "0",
                        onPressed: () {
                          inputNumber("0");
                        },
                      ),
                    ),
                    const SizedBox(width: 64),
                    Expanded(
                      child: IconButton(
                        icon: const Icon(
                          Icons.backspace,
                          color: Color(0xFFf5f5f8),
                        ),
                        onPressed: deleteNumber,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ButtonOfNumPad extends StatelessWidget {
  final String num;
  final VoidCallback? onPressed;

  const ButtonOfNumPad({
    Key? key,
    required this.num,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56.0, // Adjust the width to your desired size for a circular shape
      height: 56.0, // Same as width for a circular shape
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: FloatingActionButton.extended(
        heroTag: num,
        elevation: 0,
        backgroundColor: const Color(0xFFf5f5f8),
        onPressed: onPressed,
        label: Text(
          num,
          style: const TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
      ),
    );
  }
}
