import 'package:flutter/material.dart';
import 'package:lineup/src/lineup_dependencies.dart';

/// Makes [LineupDependencies] reachable from every screen of the module.
///
/// Screens are pushed on the host's navigator, which sits above this scope,
/// so use [LineupScope.route] to carry the scope onto each new route.
class LineupScope extends InheritedWidget {
  const LineupScope({
    super.key,
    required this.dependencies,
    required super.child,
  });

  final LineupDependencies dependencies;

  static LineupDependencies of(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<LineupScope>();
    assert(scope != null, 'No LineupScope above this context');
    return scope!.dependencies;
  }

  static Route<T> route<T>(BuildContext context, WidgetBuilder builder) {
    final dependencies = of(context);
    return MaterialPageRoute<T>(
      builder: (routeContext) =>
          LineupScope(dependencies: dependencies, child: builder(routeContext)),
    );
  }

  @override
  bool updateShouldNotify(LineupScope oldWidget) =>
      dependencies != oldWidget.dependencies;
}
