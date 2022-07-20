// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MenuStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$MenuStore on MenuStoreBase, Store {
  final _$selectedCategoryDataAtom =
      Atom(name: 'MenuStoreBase.selectedCategoryData');

  @override
  Category? get selectedCategoryData {
    _$selectedCategoryDataAtom.reportRead();
    return super.selectedCategoryData;
  }

  @override
  set selectedCategoryData(Category? value) {
    _$selectedCategoryDataAtom.reportWrite(value, super.selectedCategoryData,
        () {
      super.selectedCategoryData = value;
    });
  }

  final _$cartListAtom = Atom(name: 'MenuStoreBase.cartList');

  @override
  List<QuantityMenuModel> get cartList {
    _$cartListAtom.reportRead();
    return super.cartList;
  }

  @override
  set cartList(List<QuantityMenuModel> value) {
    _$cartListAtom.reportWrite(value, super.cartList, () {
      super.cartList = value;
    });
  }

  final _$setSelectedCategoryDataAsyncAction =
      AsyncAction('MenuStoreBase.setSelectedCategoryData');

  @override
  Future<void> setSelectedCategoryData(Category? val) {
    return _$setSelectedCategoryDataAsyncAction
        .run(() => super.setSelectedCategoryData(val));
  }

  final _$MenuStoreBaseActionController =
      ActionController(name: 'MenuStoreBase');

  @override
  void setCartList(Menu element, int quantity) {
    final _$actionInfo = _$MenuStoreBaseActionController.startAction(
        name: 'MenuStoreBase.setCartList');
    try {
      return super.setCartList(element, quantity);
    } finally {
      _$MenuStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectedCategoryData: ${selectedCategoryData},
cartList: ${cartList}
    ''';
  }
}
