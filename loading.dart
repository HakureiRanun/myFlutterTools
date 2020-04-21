import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Loading {
  static OverlayEntry _overlayEntry;
  static bool _showing = false;
  static Future loading(
      BuildContext context, Future future, Function finsh) async {
    OverlayState overlayState = Overlay.of(context);
    _showing = true;
    if (_overlayEntry == null) {
      _overlayEntry = OverlayEntry(
          builder: (BuildContext context) => Positioned(
              top: MediaQuery.of(context).size.height * 2 / 5,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.0),
                  child: AnimatedOpacity(
                    opacity: _showing ? 1.0 : 0.0,
                    duration: _showing
                        ? Duration(milliseconds: 100)
                        : Duration(milliseconds: 400),
                    child: Center(
                      child: Card(
                        color: Color.fromRGBO(0, 0, 0, 0.25),
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: new CircularProgressIndicator(),
                        ),
                      ),
                    ),
                  ))));
      overlayState.insert(_overlayEntry);
    } else {
      _overlayEntry.markNeedsBuild();
    }
    try {
      await future.then((res) {
        finsh(res);
      }).then((res) {
        _showing = false;
        _overlayEntry.markNeedsBuild();
        _overlayEntry.remove();
        _overlayEntry = null;
      });
    } catch (e) {
      _showing = false;
      _overlayEntry.markNeedsBuild();
      _overlayEntry.remove();
      _overlayEntry = null;
    } finally {
      _showing = false;
      _overlayEntry.markNeedsBuild();
      _overlayEntry.remove();
      _overlayEntry = null;
    }
  }
}
