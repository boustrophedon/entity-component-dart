part of entity_component;

abstract class System {
  World world;

  Set<Component> components_wanted;
  Set<Entity> entities; 

  void process() {
    for (Entity e in entities) {
      process_entity(e);
    }
  }
  void process_entity(Entity e);
}
