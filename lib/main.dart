import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/app.dart';
import 'core/constants/hive_boxes.dart';
import 'core/models/item_hive_dto.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  Hive.registerAdapter(ItemHiveDtoAdapter());
  await Future.wait([
    Hive.openBox<ItemHiveDto>(HiveBoxes.items),
    Hive.openBox(HiveBoxes.meta),
    Hive.openBox(HiveBoxes.settings),
  ]);

  runApp(const ProviderScope(child: EucharystkiApp()));
}
