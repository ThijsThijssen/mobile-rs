import 'package:get_it/get_it.dart';
import 'package:mobile_rs/dao/item_dao.dart';
import 'package:mobile_rs/dao/user_dao.dart';
import 'package:mobile_rs/services/item_service.dart';
import 'package:mobile_rs/services/user_service.dart';

GetIt locator = GetIt.instance;

setupServiceLocator() {
  locator.registerLazySingleton<ItemService>(() => ItemService());
  locator.registerLazySingleton<UserService>(() => UserService());
  locator.registerLazySingleton<UserDAO>(() => UserDAO());
  locator.registerLazySingleton<ItemDAO>(() => ItemDAO());
}
