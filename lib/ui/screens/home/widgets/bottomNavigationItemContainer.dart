import 'package:eschool_teacher/utils/uiUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BottomNavItem {
  final String title;
  final String activeImageUrl;
  final String disableImageUrl;

  BottomNavItem({
    required this.activeImageUrl,
    required this.disableImageUrl,
    required this.title,
  });
}

class BottomNavItemContainer extends StatefulWidget {
  final BoxConstraints boxConstraints;
  final int index;
  final int currentIndex;
  final AnimationController animationController;
  final BottomNavItem bottomNavItem;
  final Function onTap;
  const BottomNavItemContainer({
    Key? key,
    required this.boxConstraints,
    required this.currentIndex,
    required this.bottomNavItem,
    required this.animationController,
    required this.onTap,
    required this.index,
  }) : super(key: key);

  @override
  State<BottomNavItemContainer> createState() => _BottomNavItemContainerState();
}

class _BottomNavItemContainerState extends State<BottomNavItemContainer> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        widget.onTap(widget.index);
      },
      child: SizedBox(
        width: widget.boxConstraints.maxWidth * (0.25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 0.05),
                  end: const Offset(0.0, 0.4),
                ).animate(
                  CurvedAnimation(
                    parent: widget.animationController,
                    curve: Curves.easeInOut,
                  ),
                ),
                child: Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                      color: widget.index == widget.currentIndex
                          ? Colors.black
                          : Colors.white,
                      shape: BoxShape.circle),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SvgPicture.asset(
                        height: 20,
                        width: 20,
                        widget.index == widget.currentIndex
                            ? widget.bottomNavItem.disableImageUrl
                            : widget.bottomNavItem.disableImageUrl,
                        color: widget.index == widget.currentIndex
                            ? Colors.white
                            : Colors.black,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                )),
            SizedBox(
              height: widget.boxConstraints.maxHeight * (0.051),
            ),
            FadeTransition(
              opacity: Tween<double>(begin: 1.0, end: 0.0)
                  .animate(widget.animationController),
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 0.0),
                  end: const Offset(0.0, 0.5),
                ).animate(
                  CurvedAnimation(
                    parent: widget.animationController,
                    curve: Curves.easeInOut,
                  ),
                ),
                child: Text(
                  UiUtils.getTranslatedLabel(
                    context,
                    widget.bottomNavItem.title,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
