import 'package:flutter/material.dart';
import 'package:tst_expandable_bottom_menu/nestedFab.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class UnicornOrientation {
  static const HORIZONTAL = 0;
  static const VERTICAL = 1;
}

class UnicornDialer extends StatefulWidget {
  int orientation;
  final Icon parentButton;
  final Icon finalButtonIcon;
  final bool hasBackground;
  final Color parentButtonBackground;
  final List<FloatingActionButton> childButtons;
  final int animationDuration;
  final double childPadding;
  final Color backgroundColor;
  final Function onMainButtonPressed;
  final Object parentHeroTag;
  final bool hasNotch;

  _UnicornDialer dialerState;

  UnicornDialer({
    this.parentButton,
    this.parentButtonBackground,
    this.childButtons,
    this.onMainButtonPressed,
    this.orientation = 1,
    this.hasBackground = true,
    this.backgroundColor = Colors.white30,
    this.parentHeroTag,
    this.finalButtonIcon,
    this.animationDuration = 180,
    this.childPadding = 4.0,
    this.hasNotch = false,
  })  : assert(parentButton != null),
        assert(parentHeroTag != null);

  _UnicornDialer createState() {
    dialerState = _UnicornDialer();
    return dialerState;
  }

  void collapseParent() {
    if (dialerState != null) dialerState.collapseParent();
  }
}

class _UnicornDialer extends State<UnicornDialer>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  AnimationController _parentController;
  bool isOpen = false;
  NestedFab parentFab;

  @override
  void initState() {
    parentFab = context.findAncestorWidgetOfExactType();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: widget.animationDuration,
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
      if (parentFab != null) {
        parentFab.collapseOtherParents(widget.parentHeroTag);
      }
    } else {
      _animationController.reverse();
    }
  }

  void collapseParent() {
    if (_animationController != null && !_animationController.isDismissed) {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.dialerState == null) widget.dialerState = this;

    _animationController.reverse();

    var hasChildButtons =
        widget.childButtons != null && widget.childButtons.length > 0;

    if (!_parentController.isAnimating) {
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

    var mainFAB = AnimatedBuilder(
        animation: _parentController,
        builder: (BuildContext context, Widget child) {
          return Transform(
              transform: new Matrix4.diagonal3(vector.Vector3(
                  _parentController.value,
                  _parentController.value,
                  _parentController.value)),
              alignment: FractionalOffset.center,
              child: FloatingActionButton(
                  isExtended: false,
                  heroTag: widget.parentHeroTag,
                  backgroundColor: widget.parentButtonBackground,
                  onPressed: () {
                    mainActionButtonOnPressed();
                    if (widget.onMainButtonPressed != null) {
                      widget.onMainButtonPressed();
                    }
                  },
                  child: !hasChildButtons
                      ? widget.parentButton
                      : AnimatedBuilder(
                          animation: _animationController,
                          builder: (BuildContext context, Widget child) {
                            return Transform(
                              transform: new Matrix4.rotationZ(
                                  _animationController.value * 0.8),
                              alignment: FractionalOffset.center,
                              child: new Icon(_animationController.isDismissed
                                  ? widget.parentButton.icon
                                  : widget.finalButtonIcon == null
                                      ? Icons.close
                                      : widget.finalButtonIcon.icon),
                            );
                          })));
        });

    if (hasChildButtons) {
      var mainFloatingButton = AnimatedBuilder(
          animation: _animationController,
          builder: (BuildContext context, Widget child) {
            return Transform.rotate(
                angle: _animationController.value * 0.8, child: mainFAB);
          });

      var childButtonsList =
          widget.childButtons == null || widget.childButtons.length == 0
              ? List<Widget>()
              : List.generate(widget.childButtons.length, (index) {
                  var intervalValue = index == 0
                      ? 0.9
                      : ((widget.childButtons.length - index) /
                              widget.childButtons.length) -
                          0.2;

                  intervalValue =
                      intervalValue < 0.0 ? (1 / index) * 0.5 : intervalValue;

                  var childFAB = FloatingActionButton(
                    onPressed: () {
                      if (widget.childButtons[index].onPressed != null) {
                        widget.childButtons[index].onPressed();
                      }
                      _animationController.reverse();
                      if (parentFab != null)
                        parentFab.fabState.reverseAnimation();
                    },
                    child: widget.childButtons[index].child,
                    heroTag: widget.childButtons[index].heroTag,
                    backgroundColor: widget.childButtons[index].backgroundColor,
                    mini: widget.childButtons[index].mini,
                    tooltip: widget.childButtons[index].tooltip,
                    key: widget.childButtons[index].key,
                    elevation: widget.childButtons[index].elevation,
                    foregroundColor: widget.childButtons[index].foregroundColor,
                    highlightElevation:
                        widget.childButtons[index].highlightElevation,
                    isExtended: widget.childButtons[index].isExtended,
                    shape: widget.childButtons[index].shape,
                  );

                  return Positioned(
                    right: widget.orientation == UnicornOrientation.VERTICAL
                        ? 0.0
                        : ((widget.childButtons.length - index) * 55.0) + 5,
                    bottom: widget.orientation == UnicornOrientation.VERTICAL
                        ? ((widget.childButtons.length - index) * 55.0) + 5
                        : 0.0,
                    child: Container(
                      child: Row(children: [
                        // ScaleTransition(
                        //     scale: CurvedAnimation(
                        //       parent: this._animationController,
                        //       curve:
                        //           Interval(intervalValue, 1.0, curve: Curves.linear),
                        //     ),
                        //     alignment: FractionalOffset.center,
                        //     child: (true) ||
                        //             widget.orientation ==
                        //                 UnicornOrientation.HORIZONTAL
                        //         ? Container()
                        //         : Container(
                        //             padding:
                        //                 EdgeInsets.only(right: widget.childPadding),
                        //             child: widget.childButtons[index].returnLabel())),
                        ScaleTransition(
                            scale: CurvedAnimation(
                              parent: _animationController,
                              curve: Interval(intervalValue, 1.0,
                                  curve: Curves.linear),
                            ),
                            alignment: FractionalOffset.center,
                            child: childFAB)
                      ]),
                    ),
                  );
                });

      var unicornDialWidget = Container(
          margin: widget.hasNotch ? EdgeInsets.only(bottom: 0.0) : null,
          height: double.infinity,
          width: double.infinity,
          child: Stack(
              //fit: StackFit.expand,
              alignment: Alignment.bottomRight,
              overflow: Overflow.visible,
              children: childButtonsList.toList()
                ..add(Positioned(
                    right: null, bottom: null, child: mainFloatingButton))));

      var modal = ScaleTransition(
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
              )));

      return widget.hasBackground
          ? Stack(
              alignment: Alignment.topCenter,
              overflow: Overflow.visible,
              children: [
                  Positioned(right: -16.0, bottom: -16.0, child: modal),
                  unicornDialWidget
                ])
          : unicornDialWidget;
    }

    return mainFAB;
  }
}
