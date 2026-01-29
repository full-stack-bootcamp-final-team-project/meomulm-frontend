class KeyboardConverter {
  // 한글 자음/모음 -> 영어 키보드 매핑
  static const Map<String, String> _koreanToEnglish = {
    // 자음
    'ㄱ': 'r', 'ㄲ': 'R',
    'ㄴ': 's',
    'ㄷ': 'e', 'ㄸ': 'E',
    'ㄹ': 'f',
    'ㅁ': 'a',
    'ㅂ': 'q', 'ㅃ': 'Q',
    'ㅅ': 't', 'ㅆ': 'T',
    'ㅇ': 'd',
    'ㅈ': 'w', 'ㅉ': 'W',
    'ㅊ': 'c',
    'ㅋ': 'z',
    'ㅌ': 'x',
    'ㅍ': 'v',
    'ㅎ': 'g',

    // 모음
    'ㅏ': 'k',
    'ㅐ': 'o',
    'ㅑ': 'i',
    'ㅒ': 'O',
    'ㅓ': 'j',
    'ㅔ': 'p',
    'ㅕ': 'u',
    'ㅖ': 'P',
    'ㅗ': 'h',
    'ㅘ': 'hk',
    'ㅙ': 'ho',
    'ㅚ': 'hl',
    'ㅛ': 'y',
    'ㅜ': 'n',
    'ㅝ': 'nj',
    'ㅞ': 'np',
    'ㅟ': 'nl',
    'ㅠ': 'b',
    'ㅡ': 'm',
    'ㅢ': 'ml',
    'ㅣ': 'l',
  };

  /// 한글 자모를 영어 키보드로 변환
  /// 예: "ㅜ무ㅛ" -> "nans"
  static String convertToEnglish(String text) {
    if (text.isEmpty) return text;

    StringBuffer result = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      String char = text[i];

      // 한글 자모인 경우 변환
      if (_koreanToEnglish.containsKey(char)) {
        result.write(_koreanToEnglish[char]);
      }
      // 완성된 한글인 경우 자모 분리 후 변환
      else if (_isCompleteKorean(char)) {
        result.write(_decomposeKorean(char));
      }
      // 그 외는 그대로 유지
      else {
        result.write(char);
      }
    }

    return result.toString();
  }

  /// 완성된 한글인지 확인
  static bool _isCompleteKorean(String char) {
    int code = char.codeUnitAt(0);
    return code >= 0xAC00 && code <= 0xD7A3;
  }

  /// 완성된 한글을 자모로 분리하고 영어로 변환
  static String _decomposeKorean(String char) {
    const int base = 0xAC00;
    const int choBase = 588;
    const int jungBase = 28;

    // 초성 리스트
    const List<String> chosung = [
      'ㄱ', 'ㄲ', 'ㄴ', 'ㄷ', 'ㄸ', 'ㄹ', 'ㅁ', 'ㅂ', 'ㅃ',
      'ㅅ', 'ㅆ', 'ㅇ', 'ㅈ', 'ㅉ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ'
    ];

    // 중성 리스트
    const List<String> jungsung = [
      'ㅏ', 'ㅐ', 'ㅑ', 'ㅒ', 'ㅓ', 'ㅔ', 'ㅕ', 'ㅖ', 'ㅗ', 'ㅘ',
      'ㅙ', 'ㅚ', 'ㅛ', 'ㅜ', 'ㅝ', 'ㅞ', 'ㅟ', 'ㅠ', 'ㅡ', 'ㅢ', 'ㅣ'
    ];

    // 종성 리스트
    const List<String> jongsung = [
      '', 'ㄱ', 'ㄲ', 'ㄳ', 'ㄴ', 'ㄵ', 'ㄶ', 'ㄷ', 'ㄹ', 'ㄺ',
      'ㄻ', 'ㄼ', 'ㄽ', 'ㄾ', 'ㄿ', 'ㅀ', 'ㅁ', 'ㅂ', 'ㅄ', 'ㅅ',
      'ㅆ', 'ㅇ', 'ㅈ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ'
    ];

    int code = char.codeUnitAt(0) - base;
    int cho = code ~/ choBase;
    int jung = (code % choBase) ~/ jungBase;
    int jong = code % jungBase;

    StringBuffer result = StringBuffer();

    // 초성 변환
    result.write(_koreanToEnglish[chosung[cho]] ?? chosung[cho]);

    // 중성 변환
    result.write(_koreanToEnglish[jungsung[jung]] ?? jungsung[jung]);

    // 종성 변환 (있는 경우만)
    if (jong > 0) {
      result.write(_koreanToEnglish[jongsung[jong]] ?? jongsung[jong]);
    }

    return result.toString();
  }

  /// 텍스트에 한글이 포함되어 있는지 확인
  static bool containsKorean(String text) {
    for (int i = 0; i < text.length; i++) {
      String char = text[i];
      int code = char.codeUnitAt(0);

      // 한글 자모 (ㄱ-ㅎ, ㅏ-ㅣ)
      if ((code >= 0x3131 && code <= 0x318E) ||
          // 완성된 한글 (가-힣)
          (code >= 0xAC00 && code <= 0xD7A3)) {
        return true;
      }
    }
    return false;
  }
}