import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class AnimatedBtn extends StatelessWidget {
  const AnimatedBtn({
    Key? key,
    required RiveAnimationController btnAnimationController,
    required this.press,
    required this.icon,
    required this.label,
  })  : _btnAnimationController = btnAnimationController,
        super(key: key);
  final Icon icon;
  final String label;
  final RiveAnimationController _btnAnimationController;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: SizedBox(
        height: 64,
        width: 236,
        child: Stack(
          children: [
            RiveAnimation.asset(
              "assets/RiveAssets/button.riv",
              controllers: [_btnAnimationController],
            ),
            Positioned.fill(
              top: 8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  icon,
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: Theme.of(context).textTheme.labelLarge,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

//import 'package:flutter/material.dart';

class RiveAnimatedBtn extends StatefulWidget {
  const RiveAnimatedBtn(
      {Key? key,
      required this.label,
      required this.onTap,
      required this.iconData})
      : super(key: key);
  final String label;
  final Function onTap;
  final Icon iconData;
  static String id = 'RiveAnimatedBtn_id';

  @override
  State<RiveAnimatedBtn> createState() => _RiveAnimatedBtnState();
}

class _RiveAnimatedBtnState extends State<RiveAnimatedBtn> {
  late RiveAnimationController _btnAnimationController;
  @override
  void initState() {
    _btnAnimationController = OneShotAnimation(
      "active",
      autoplay: false,
    );
    super.initState();
  }

  @override
  void dispose() {
    _btnAnimationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBtn(
      label: widget.label,
      icon: widget.iconData,
      btnAnimationController: _btnAnimationController,
      press: () {
        _btnAnimationController.isActive = true;
        widget.onTap();
      },
    );
  }
}
