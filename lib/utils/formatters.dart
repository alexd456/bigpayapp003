import 'package:flutter/services.dart';

// Copied from https://stackoverflow.com/questions/64117471/inputformatter-should-allow-just-decimal-numbers-and-negative-numbers
class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({this.decimalRange})
      : assert(decimalRange == null || decimalRange > 0);

  final int? decimalRange;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    TextEditingValue _newValue = sanitize(newValue);
    String text = _newValue.text;

    if (decimalRange == null) {
      return _newValue;
    }

    if (text == '.') {
      return TextEditingValue(
        text: '0.',
        selection: _newValue.selection.copyWith(baseOffset: 2, extentOffset: 2),
        composing: TextRange.empty,
      );
    }

    return isValid(text) ? _newValue : oldValue;
  }

  bool isValid(String text) {
    int dots = '.'.allMatches(text).length;

    if (dots == 0) {
      return true;
    }

    if (dots > 1) {
      return false;
    }

    return text.substring(text.indexOf('.') + 1).length <= decimalRange!;
  }

  TextEditingValue sanitize(TextEditingValue value) {
    if (false == value.text.contains('-')) {
      return value;
    }

    String text = '-' + value.text.replaceAll('-', '');

    return TextEditingValue(
        text: text, selection: value.selection, composing: TextRange.empty);
  }
}

class IntegerTextFormatter extends TextInputFormatter {
  final int maxIntegerDigits;

  IntegerTextFormatter({this.maxIntegerDigits = 4});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final oldValueValid = _isValidNumber(oldValue.text);
    bool newValueValid = _isValidNumber(newValue.text);

    if (oldValueValid && !newValueValid) {
      return oldValue;
    }
    return newValue;
  }

  /// Tests whether input is valid number based on constraints provided to [IntegerTextFormatter]
  bool _isValidNumber(String value) {
    final regexSource = '^\$|^(0|[1-9][0-9]{0,${maxIntegerDigits - 1}})\$';

    final regex = RegExp(regexSource);
    final matches = regex.allMatches(value);
    for (Match match in matches) {
      if (match.start == 0 && match.end == value.length) {
        return true;
      }
    }

    return false;
  }
}
