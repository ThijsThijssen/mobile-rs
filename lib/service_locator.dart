import 'package:get_it/get_it.dart';
import 'package:mobile_rs/dao/item_dao.dart';
import 'package:mobile_rs/dao/skill_dao.dart';
import 'package:mobile_rs/dao/user_dao.dart';
import 'package:mobile_rs/services/activity_service.dart';
import 'package:mobile_rs/services/item_service.dart';
import 'package:mobile_rs/services/skill_service.dart';
import 'package:mobile_rs/services/user_service.dart';

GetIt locator = GetIt.instance;

setupServiceLocator() {
  // services
  locator.registerLazySingleton<ActivityService>(() => ActivityService());
  locator.registerLazySingleton<SkillService>(() => SkillService());
  locator.registerLazySingleton<ItemService>(() => ItemService());
  locator.registerLazySingleton<UserService>(() => UserService());

  // DAOs
  locator.registerLazySingleton<SkillDAO>(() => SkillDAO());
  locator.registerLazySingleton<ItemDAO>(() => ItemDAO());
  locator.registerLazySingleton<UserDAO>(() => UserDAO());
}
