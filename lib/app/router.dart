import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/about/presentation/about_screen.dart';
import '../features/admin/presentation/admin_screen.dart';
import '../features/auth/presentation/auth_controller.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/items/presentation/item_edit_screen.dart';
import '../features/items/presentation/item_view_screen.dart';
import '../features/items/presentation/items_list_screen.dart';
import '../features/settings/presentation/settings_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final logged = auth.valueOrNull != null;
      final adminPath = state.matchedLocation.startsWith('/admin');
      final editPath = state.matchedLocation.contains('/edit') || state.matchedLocation == '/item/new';
      if ((adminPath || editPath) && !logged) return '/login';
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (_, __) => const ItemsListScreen()),
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
      GoRoute(path: '/about', builder: (_, __) => const AboutScreen()),
      GoRoute(path: '/admin', builder: (_, __) => const AdminScreen()),
      GoRoute(path: '/item/new', builder: (_, __) => const ItemEditScreen()),
      GoRoute(
        path: '/item/:id',
        builder: (_, s) => ItemViewScreen(id: s.pathParameters['id']!),
      ),
      GoRoute(
        path: '/item/:id/edit',
        builder: (_, s) => ItemEditScreen(itemId: s.pathParameters['id']!),
      ),
    ],
  );
});
