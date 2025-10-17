//================== exten on string isEmpty or null ==========
extension StringExtensions on String? {
  bool isStringNullOrEmpty() {
    //this refers to the string on which the method is called
    return this == null || this == '';
  }
}
//fixing onPressed btn to check if form current state is validate or not and adding vaildation to password  done ?????