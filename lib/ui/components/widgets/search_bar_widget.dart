import 'dart:math';

import 'package:flutter/material.dart';

/// Created by Yunus Emre Yıldırım
/// on 9.09.2022

class SearchBarWidget extends StatefulWidget {
  final TextEditingController textController;

  const SearchBarWidget({Key? key, required this.textController}) : super(key: key);

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> with SingleTickerProviderStateMixin {
  /// toggle == 1 is search bar expand, toggle == 0 is search bar collapse
  int toggle = 0;
  final double searchBarWidth = 400;
  late Duration defaultAnimationDuration;
  late AnimationController animationController;
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();

    defaultAnimationDuration = const Duration(milliseconds: 500);
    animationController = AnimationController(vsync: this, duration: defaultAnimationDuration);
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    animationController.dispose();
    focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget? child) {
        return AnimatedContainer(
          duration: defaultAnimationDuration,
          width: toggle == 0 ? 32 : searchBarWidth,
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: toggle == 0 ? Colors.transparent : Colors.white70,
            borderRadius: const BorderRadius.all(Radius.circular(30)),
          ),
          child: Stack(
            children: [
              /// clear button animated positioned
              AnimatedPositioned(
                duration: defaultAnimationDuration,
                right: 0,
                curve: Curves.easeInOut,
                child: AnimatedOpacity(
                  duration: defaultAnimationDuration,
                  opacity: toggle == 0 ? 0.0 : 1.0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: AnimatedBuilder(
                        animation: animationController,
                        builder: (BuildContext context, Widget? child) {
                          return Transform.rotate(
                            angle: animationController.value * 2.0 * pi,
                            child: child,
                          );
                        },
                        child: InkWell(
                          onTap: () => widget.textController.clear(),
                          child: const Icon(
                            Icons.close,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              /// search text animated positioned
              AnimatedPositioned(
                duration: defaultAnimationDuration,
                left: toggle == 0 ? 0 : 20.0,
                top: 14,
                curve: Curves.easeInOut,
                child: AnimatedOpacity(
                  duration: defaultAnimationDuration,
                  opacity: toggle == 0 ? 0.0 : 1.0,
                  child: Container(
                    padding: const EdgeInsets.only(left: 10),
                    alignment: Alignment.topCenter,
                    width: searchBarWidth / 1.5,
                    child: TextField(
                      controller: widget.textController,
                      autofocus: true,
                      focusNode: focusNode,
                      cursorRadius: const Radius.circular(10.0),
                      cursorWidth: 2.0,
                      onEditingComplete: () {
                        /// on editing complete the keyboard will be closed and the search bar will be closed
                        // onFocusKeyboard();
                        // setState(() {
                        //   toggle = 0;
                        // });
                        widget.textController.clear();
                      },
                      style: const TextStyle(color: Colors.black54),
                      cursorColor: Colors.black.withOpacity(0.5),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(bottom: 5),
                        isDense: true,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        labelText: 'Kelime arayın ...',
                        labelStyle: const TextStyle(
                          color: Color(0xff5B5B5B),
                          fontSize: 17.0,
                          fontWeight: FontWeight.w500,
                        ),
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              /// search icon animated container
              AnimatedBuilder(
                animation: animationController,
                builder: (BuildContext context, Widget? child) {
                  return AnimatedPositioned(
                    duration: defaultAnimationDuration,
                    top: toggle == 0 ? 7 : 3,
                    curve: Curves.easeInOut,
                    child: AnimatedContainer(
                      duration: defaultAnimationDuration,
                      curve: Curves.easeInOut,
                      child: InkWell(
                        child: AnimatedIcon(
                          progress: animationController,
                          icon: AnimatedIcons.search_ellipsis,
                          semanticLabel: 'Listede kelime ara',
                          color: toggle == 0 ? Colors.grey : Colors.black,
                          size: 32,
                        ),
                        onTap: () {
                          if (toggle == 0) {
                            toggle = 1;
                            animationController.forward();
                          } else {
                            toggle = 0;
                            animationController.reverse();
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
