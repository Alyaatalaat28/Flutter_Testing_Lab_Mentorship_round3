//================== exten on string isEmpty or null ==========
extension StringExtensions on String? {
  bool isStringNullOrEmpty() {
    //this refers to the string on which the method is called
    return this == null || this == '';
  }
}