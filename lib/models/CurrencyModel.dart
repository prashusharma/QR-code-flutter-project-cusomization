class CurrencyModel {
  String? symbol;
  String? name;
  String? code;
  CurrencyModel({this.symbol, this.name,this.code});

  static List<CurrencyModel> getCurrencyList() {
    List<CurrencyModel> data = [];

    data.add(CurrencyModel(symbol: "₹", name: "Indian Rupee", code: 'inr'));
    data.add(CurrencyModel(symbol: "\$", name: "Us Dollar", code: 'usd'));
    data.add(CurrencyModel(symbol: "€", name: "Euro", code: 'eur'));
    data.add(CurrencyModel(symbol: "£", name: "British Pound", code: 'gbp'));

    return data;
  }
}
