import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_call_app/app_two/ui/widgets/spacers.dart';

class RectButton extends StatelessWidget {
  final String text;
  final Function pressed;
  IconData icondata;
  double iconsize;
  double widthRatio;
  Color color;

  RectButton({
    Key? key,
    required this.pressed,
    required this.text,
    required this.icondata,
    this.iconsize = 22,
    this.widthRatio = 0.4,
    this.color = const Color.fromARGB(255, 22, 39, 192),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Center(
      child: InkWell(
        onTap: () {
          // ignore: avoid_print
          print(text);
          pressed();
        },
        child: Container(
          padding: const EdgeInsets.all(6),
          height: size.height / 20,
          width: size.width * widthRatio,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: color,
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icondata,
                  size: iconsize,
                  color: Colors.white,
                ),
                Hspacer(8),
                Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EndCallButton extends StatelessWidget {
  final String text;
  final Function pressed;

  const EndCallButton({
    Key? key,
    required this.pressed,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print(text);
        pressed();
      },
      child: const CircleAvatar(
        child: Icon(
          CupertinoIcons.phone_arrow_up_right,
          size: 20,
          color: Colors.white,
        ),
      ),
    );
  }
}
