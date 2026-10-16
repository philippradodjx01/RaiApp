import 'dart:async';
import 'dart:js_interop';

@JS('speechSynthesis')
external SpeechEngine? get _engine;

extension type SpeechEngine(JSObject _) implements JSObject {
  external void speak(SpeechUtterance utterance);
  external void cancel();
}

@JS('SpeechSynthesisUtterance')
extension type SpeechUtterance._(JSObject _) implements JSObject {
  external factory SpeechUtterance(String text);
  external set lang(String value);
  external set rate(double value);
  external set onend(JSFunction callback);
  external set onerror(JSFunction callback);
}

bool get pronunciationAvailable => _engine != null;
void stopPronunciation() => _engine?.cancel();

Future<bool> pronounce(String word) async {
  if (!pronunciationAvailable) return false;
  final result = Completer<bool>();
  void finish(bool success) {
    if (!result.isCompleted) result.complete(success);
  }
  try {
    _engine!.cancel();
    final utterance = SpeechUtterance(word)
      ..lang = 'en-US'
      ..rate = 0.8
      ..onend = ((JSAny? event) => finish(true)).toJS
      ..onerror = ((JSAny? event) => finish(false)).toJS;
    _engine!.speak(utterance);
    return await result.future.timeout(const Duration(seconds: 15), onTimeout: () {
      _engine?.cancel();
      return false;
    });
  } catch (_) {
    return false;
  }
}
