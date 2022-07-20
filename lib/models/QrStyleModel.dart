class QrStyleModel {
  String? styleName;

  QrStyleModel({this.styleName});

  static List<QrStyleModel> getQrStyleList() {
    List<QrStyleModel> data = [];
    data.add(QrStyleModel(styleName: "Style 1"));
    data.add(QrStyleModel(styleName: "Style 2"));
    data.add(QrStyleModel(styleName: "Style 3"));

    return data;
  }
}
