import 'package:flutter/material.dart';
import 'package:fluttervalidation/src/blocs/login_bloc.dart';
export 'package:fluttervalidation/src/blocs/login_bloc.dart';

class Provider extends InheritedWidget {
  static Provider _instancia;
  factory Provider({Key key, Widget child}) {
    if (_instancia == null) {
      _instancia = new Provider._internal(
        key: key,
        child: child,
      );
    }
    return _instancia;
  }

  Provider._internal({Key key, Widget child}) : super(key: key, child: child);
  final loginBloc = LoginBloc();

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

//Para que se llame directamente, sin instanciar el provider
  static LoginBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(Provider) as Provider)
        .loginBloc;
  }
}
