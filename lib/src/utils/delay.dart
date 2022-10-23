Future<void> delay(bool addDelay, [int millisecond = 2000]) {
  if (addDelay) {
    return Future.delayed(Duration(milliseconds: millisecond));
  } else {
    return Future.value();
  }
}