import 'package:get_it/get_it.dart';
import 'package:mobile_rs/dao/item_dao.dart';
import 'package:mobile_rs/services/item_service.dart';

GetIt locator = GetIt.instance;

setupServiceLocator() {
  locator.registerSingleton<ItemDAO>(ItemDAO());
  locator.registerSingleton<ItemService>(ItemService());
}
