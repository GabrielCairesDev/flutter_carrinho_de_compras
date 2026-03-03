import 'package:flutter/foundation.dart';
import 'package:flutter_carrinho_de_compras/core/result.dart';

class Command<T> extends ChangeNotifier {
  Command(this._action);

  final Future<Result<T>> Function() _action;

  bool _running = false;
  bool get running => _running;

  Result<T>? _result;
  Result<T>? get result => _result;

  Future<void> execute() async {
    if (_running) return;
    _running = true;
    _result = null;
    notifyListeners();

    _result = await _action();
    _running = false;
    notifyListeners();
  }

  void clearResult() {
    _result = null;
    notifyListeners();
  }
}

class Command1<T, A> extends ChangeNotifier {
  Command1(this._action);

  final Future<Result<T>> Function(A) _action;

  bool _running = false;
  bool get running => _running;

  Result<T>? _result;
  Result<T>? get result => _result;

  Future<void> execute(A argument) async {
    if (_running) return;
    _running = true;
    _result = null;
    notifyListeners();

    _result = await _action(argument);
    _running = false;
    notifyListeners();
  }

  void clearResult() {
    _result = null;
    notifyListeners();
  }
}
