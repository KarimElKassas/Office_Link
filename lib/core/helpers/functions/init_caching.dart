import 'package:hive/hive.dart';

import '../../../data/models/user_model.dart';

void registerAdapters() {
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(UserModelAdapter());
  }
}
Future<void> initCaching() async {
  registerAdapters();
  await Hive.openBox<Map<String, dynamic>>('Users');
}
