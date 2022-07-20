import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_menu_laravel_flutter/main.dart';
import 'package:qr_menu_laravel_flutter/models/GetCategoryListResponse.dart';
import 'package:qr_menu_laravel_flutter/models/MenuCategoryModel.dart';
import 'package:qr_menu_laravel_flutter/models/RestaurantDetailResponse.dart';

part 'MenuStore.g.dart';

class MenuStore = MenuStoreBase with _$MenuStore;

abstract class MenuStoreBase with Store {
  @observable
  Category? selectedCategoryData;

  @observable
  List<QuantityMenuModel> cartList = <QuantityMenuModel>[].asObservable();

  @action
  Future<void> setSelectedCategoryData(Category? val) async {
    selectedCategoryData = val;

    appStore.setLoading(true);
    if (val != null) {
      List<Menu> list = [];
      menuListMain.forEach((element) {
        if (element.categoryId == val.id) {
          list.add(element);
        }
      });

      List<MenuCategoryModel> menus = [];
      list.forEach((element) {
        List<Menu> temp = list.where((e) {
          return e.categoryId == element.categoryId!.validate();
        }).toList();

        List<QuantityMenuModel> temp1 = [];
        temp.forEach((element) {
          temp1.add(QuantityMenuModel(menu: element,quantity: 0));
        });

        menus.add(MenuCategoryModel(categoryId: element.categoryId.validate(), menu: temp1,category: element.category));
      });

      appStore.setMenuByCategoryList(menus);
    } else {
      List<Menu> list = menuListMain;
      List<MenuCategoryModel> menus = [];

      list.forEach((menu) {
        if (menus.isNotEmpty) {
          if (menus.every((e) => menu.categoryId.validate() != e.categoryId.validate())) {
            List<Menu> temp = list.where((e) => e.categoryId == menu.categoryId.validate()).toList();

            List<QuantityMenuModel> temp1 = [];
            temp.forEach((element) {
              temp1.add(QuantityMenuModel(menu: element,quantity: 0));
            });

            menus.add(MenuCategoryModel(categoryId: menu.categoryId, menu: temp1,category: menu.category));
          }
        } else {
          List<Menu> temp = list.where((e) => e.categoryId == menu.categoryId.validate()).toList();

          List<QuantityMenuModel> temp1 = [];
          temp.forEach((element) {
            temp1.add(QuantityMenuModel(menu: element,quantity: 0));
          });

          menus.add(MenuCategoryModel(categoryId: menu.categoryId, menu: temp1,category: menu.category));
        }
      });
      appStore.setMenuByCategoryList(menus);
    }
    appStore.setLoading(false);
  }

  @action
  void setCartList(Menu element,int quantity){
    cartList.add(QuantityMenuModel(quantity: quantity,menu: element));
  }

}
