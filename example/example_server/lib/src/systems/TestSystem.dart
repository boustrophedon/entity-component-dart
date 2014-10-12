part of ecs_server_test;

class TestSystem extends System {
  TestSystem(World world) : super(world) {
    components_wanted = new Set.from([Whatever,]);
  }
  void initialize() {
    Entity e = world.new_entity();
    e.add_component(new Whatever());
    e.add_to_world();
  }

  void process_entity(Entity entity) {
    print(entity.get_component(Whatever).s);
  }
  void remove_entity(Entity e) {}
}
