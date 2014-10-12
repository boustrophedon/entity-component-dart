import 'package:ecs_server_test/server_test.dart';
import 'package:entity_component/entity_component_common.dart';
import 'package:entity_component/entity_component_server.dart';


void main() {
  ServerWorld world = create_world();
 
  world.start();
} 
