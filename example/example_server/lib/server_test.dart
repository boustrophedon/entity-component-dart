library ecs_server_test;

import 'dart:math' as math;

import 'package:entity_component/entity_component_common.dart';
import 'package:entity_component/entity_component_server.dart';

part 'src/components.dart';
part 'src/systems/TestSystem.dart';

ServerWorld create_world() {
  ServerWorld world = new ServerWorld();

  // register systems
  world.register_system(new TestSystem(world));

  return world;
}
