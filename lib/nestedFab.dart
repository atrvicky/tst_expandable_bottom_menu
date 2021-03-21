import 'package:flutter/material.dart';
import 'package:tst_expandable_bottom_menu/unicorndial_2.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class NestedFab extends StatefulWidget {
  final List<UnicornDialer> children;
  final FloatingActionButton parentButton;
  final int orientation;
  final Icon parentButtonIcon;
  final Icon finalButtonIcon;
  final bool hasBackground;
  final Color parentButtonBackground;
  final double childPadding;
  final Color backgroundColor;
  final Function onMainButtonPressed;
  final Object parentHeroTag;
  final bool hasNotch;

  _NestedFabState fabState;

  NestedFab({
    this.parentButton,
    this.parentButtonBackground,
    this.children,
    this.parentButtonIcon,
    this.onMainButtonPressed,
    this.orientation = UnicornOrientation.HORIZONTAL,
    this.hasBackground = true,
    this.backgroundColor = Colors.white30,
    this.parentHeroTag = "parent",
    this.finalButtonIcon,
    this.childPadding = 4.0,
    this.hasNotch = false,
  }) : assert(children != null);

  @override
  State<NestedFab> createState() {
    fabState = _NestedFabState();
    return _NestedFabState();
  }

  void collapseOtherParents(String tag) {
    for (UnicornDialer dialer in children) {
      if (tag == null || dialer.parentHeroTag != tag) {
        dialer.collapseParent();
      }
    }
  }
}

class _NestedFabState extends State<NestedFab> with TickerProviderStateMixin {
  AnimationController _animationController;
  AnimationController _parentController;

  bool isOpen = false;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 180,
      ),
    );

    _parentController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 200,
      ),
    );

    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    _parentController.dispose();
    super.dispose();
  }

  void mainActionButtonOnPressed() {
    if (_animationController.isDismissed) {
      _animationController.forward();
      collapseAllParents();
    } else {
      reverseAnimation();
    }
  }

  void reverseAnimation() {
    if (_animationController != null && !_animationController.isDismissed) {
      _animationController.reverse();
    }
  }

  void collapseAllParents() {
    for (UnicornDialer dialer in widget.children) {
      dialer.collapseParent();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.fabState == null) widget.fabState = this;
    _animationController.reverse();

    var hasChildButtons = widget.children != null && widget.children.length > 0;

    // set the orientation of the children opposite to that of the parent
    if (hasChildButtons) {
      for (UnicornDialer dialer in widget.children) {
        dialer.orientation = widget.orientation == UnicornOrientation.VERTICAL
            ? UnicornOrientation.HORIZONTAL
            : UnicornOrientation.VERTICAL;
      }
    }

    if (_parentController != null && !_parentController.isAnimating) {
      if (_parentController.isCompleted) {
        _parentController.forward().then((s) {
          _parentController.reverse().then((e) {
            _parentController.forward();
          });
        });
      }
      if (_parentController.isDismissed) {
        _parentController.reverse().then((s) {
          _parentController.forward();
        });
      }
    }

    var mainFAB = _parentController != null
        ? AnimatedBuilder(
            animation: _parentController,
            builder: (
              BuildContext context,
              Widget child,
            ) {
              return Transform(
                transform: new Matrix4.diagonal3(
                  vector.Vector3(
                    _parentController.value,
                    _parentController.value,
                    _parentController.value,
                  ),
                ),
                alignment: FractionalOffset.center,
                child: FloatingActionButton(
                  isExtended: false,
                  heroTag: "parent",
                  backgroundColor: widget.parentButtonBackground,
                  onPressed: () {
                    mainActionButtonOnPressed();
                    if (widget.onMainButtonPressed != null) {
                      widget.onMainButtonPressed();
                    }
                  },
                  child: !hasChildButtons
                      ? widget.parentButtonIcon
                      : AnimatedBuilder(
                          animation: _animationController,
                          builder: (BuildContext context, Widget child) {
                            return Transform(
                              transform: new Matrix4.rotationZ(
                                  _animationController.value * 0.8),
                              alignment: FractionalOffset.center,
                              child: _animationController.isDismissed
                                  ? widget.parentButtonIcon
                                  : new Icon(
                                      widget.finalButtonIcon == null
                                          ? Icons.close
                                          : widget.finalButtonIcon.icon,
                                    ),
                            );
                          },
                        ),
                ),
              );
            },
          )
        : Container();

    if (hasChildButtons) {
      var mainFloatingButton = _animationController != null
          ? AnimatedBuilder(
              animation: _animationController,
              builder: (BuildContext context, Widget child) {
                return Transform.rotate(
                  angle: _animationController.value * 0.8,
                  child: mainFAB,
                );
              },
            )
          : Container();

      var childButtonsList = widget.children == null ||
              widget.children.length == 0
          ? List<Widget>()
          : List.generate(
              widget.children.length,
              (index) {
                var intervalValue = index == 0
                    ? 0.9
                    : ((widget.children.length - index) /
                            widget.children.length) -
                        0.2;

                intervalValue =
                    intervalValue < 0.0 ? (1 / index) * 0.5 : intervalValue;

                UnicornDialer childDialer = widget.children[index];
                List<FloatingActionButton> newList = List();
                for (FloatingActionButton fabChild
                    in childDialer.childButtons) {
                  FloatingActionButton newFab = FloatingActionButton(
                    onPressed: () {
                      if (fabChild.onPressed != null) {
                        fabChild.onPressed();
                      }
                      reverseAnimation();
                    },
                    child: fabChild.child,
                    heroTag: fabChild.heroTag,
                    backgroundColor: fabChild.backgroundColor,
                    mini: fabChild.mini,
                    tooltip: fabChild.tooltip,
                    key: fabChild.key,
                    elevation: fabChild.elevation,
                    foregroundColor: fabChild.foregroundColor,
                    highlightElevation: fabChild.highlightElevation,
                    isExtended: fabChild.isExtended,
                    shape: fabChild.shape,
                  );
                  newList.add(newFab);
                }

                childDialer.childButtons = newList;

                return Positioned(
                  right: widget.orientation == UnicornOrientation.VERTICAL
                      ? 0.0
                      : ((widget.children.length - index) * 55.0) + 15,
                  bottom: widget.orientation == UnicornOrientation.VERTICAL
                      ? ((widget.children.length - index) * 55.0) + 15
                      : 0.0,
                  child: Container(
                    margin: widget.orientation == UnicornOrientation.VERTICAL
                        ? index < (widget.children.length - 1)
                            ? EdgeInsets.only(bottom: 8)
                            : EdgeInsets.only(bottom: 0)
                        : index < (widget.children.length - 1)
                            ? EdgeInsets.only(right: 8)
                            : EdgeInsets.only(right: 0),
                    width: widget.orientation == UnicornOrientation.VERTICAL
                        ? 300
                        : 50,
                    height: widget.orientation == UnicornOrientation.VERTICAL
                        ? 50
                        : 300,
                    child: _animationController != null
                        ? ScaleTransition(
                            scale: CurvedAnimation(
                              parent: _animationController,
                              curve: Interval(
                                intervalValue,
                                1.0,
                                curve: Curves.linear,
                              ),
                            ),
                            alignment: FractionalOffset.bottomRight,
                            child: childDialer,
                          )
                        : Container(),
                  ),
                );
              },
            );

      var unicornDialWidget = Container(
        margin: widget.hasNotch ? EdgeInsets.only(bottom: 15.0) : null,
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          //fit: StackFit.expand,
          alignment: Alignment.bottomRight,
          overflow: Overflow.visible,
          children: childButtonsList.toList()
            ..add(
              Positioned(
                right: null,
                bottom: null,
                child: mainFloatingButton,
              ),
            ),
        ),
      );

      var scrim = _animationController != null
          ? ScaleTransition(
              scale: CurvedAnimation(
                parent: _animationController,
                curve: Interval(1.0, 1.0, curve: Curves.linear),
              ),
              alignment: FractionalOffset.center,
              child: GestureDetector(
                onTap: mainActionButtonOnPressed,
                child: Container(
                  color: widget.backgroundColor,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
              ),
            )
          : Container();

      return widget.hasBackground
          ? Stack(
              alignment: Alignment.topCenter,
              overflow: Overflow.visible,
              children: [
                Positioned(
                  right: -16.0,
                  bottom: -16.0,
                  child: scrim,
                ),
                unicornDialWidget,
              ],
            )
          : unicornDialWidget;
    }
    return mainFAB;
  }
}
