library draw;

import 'dart:html';
import 'dart:math' as math;

import 'package:entity_component/entity_component.dart';

part 'src/systems/InputSystem.dart';
part 'src/systems/RenderSystem.dart';


World create_world() {
  World world = new World();
  world.register_system(new InputSystem(world));
  world.register_system(new RenderSystem(world));
  return world;
}

