part of entity_component;

abstract class System {
  World world;

  Set<Type> components_wanted;
  Set<Entity> entities; 

  System(World world) {
      this.world = world;
      components_wanted = new Set<Type>();
      entities = new Set<Entity>();
  }

  void initialize();

  void process() {
    for (Entity e in entities) {
      process_entity(e);
    }
  }
  void process_entity(Entity e);
}
