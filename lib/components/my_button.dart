import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final IconData buttonIcon;

  const MyButton({
    required this.onPressed,
    required this.buttonText,
    required this.buttonIcon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: const LinearGradient(
                colors: [Color(0xff4338CA), Color(0xff6D28D9)],
              ),
            ),
            child: Button(
              buttonText: buttonText,
              buttonIcon: buttonIcon,
              onPressed: onPressed,
            ),
          ),
        ),
      ],
    );
  }
}

class Button extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final IconData buttonIcon;

  const Button({
    required this.onPressed,
    required this.buttonText,
    required this.buttonIcon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(0),
        alignment: Alignment.center,
        padding: MaterialStateProperty.all(
          const EdgeInsets.only(right: 45, left: 45, top: 15, bottom: 15),
        ),
        backgroundColor: MaterialStateProperty.all(Colors.transparent),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min, // Restrict size based on content
        children: [
          Icon(
            buttonIcon,
            color: Colors.white,
          ),
          const SizedBox(width: 5.0),
          Text(
            buttonText,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          )
        ],
      ),
    );
  }
}
