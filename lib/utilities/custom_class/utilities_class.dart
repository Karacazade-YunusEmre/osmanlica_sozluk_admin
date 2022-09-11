/// Created by Yunus Emre Yıldırım
/// on 8.09.2022

class UtilitiesClass {
  static RegExp get emailRegExp => RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  static String getCoTitle(String title) {
    String temp = title;

    List<String> patternList = [' ', '-', "'", '(', ')', '.', ':', ',', ';', '{', '}', '[', ']', '!', '?'];

    for (String item in patternList) {
      temp = temp.split(item).join();
    }

    return temp.toLowerCase();
  }
}
