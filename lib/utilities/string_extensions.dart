/// Created by Yunus Emre Yıldırım
/// on 6.10.2022

extension StringExtensions on String {
  String get removeUnAlphanumericCharacters {
    List<String> tempCharacters = [];
    RegExp regexp = RegExp(r'[a-zA-Z0-9öçşığüÖÇŞIĞÜ]+', multiLine: true);
    Iterable<RegExpMatch> matches = regexp.allMatches(toLowerCase());

    for (RegExpMatch item in matches) {
      tempCharacters.add(item[0]!.toLowerCase());
    }

    return tempCharacters.join();
  }
}
