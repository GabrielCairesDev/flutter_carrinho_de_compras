import 'package:intl/intl.dart';

final _brl = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

String formatBRL(double value) => _brl.format(value);
