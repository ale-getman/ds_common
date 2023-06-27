import 'package:flutter_test/flutter_test.dart';

void main() {
  test('yandexId', () async {
    expect((BigInt.tryParse('11123350579615527802')! % BigInt.from(100)).toInt(), 2);
    expect((BigInt.tryParse('032511123350579615527899')! % BigInt.from(100)).toInt(), 99);
  });
}
