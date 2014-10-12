part of entity_component_common;

abstract class System {
  World world;

  Set<Type> components_wanted;
  Set<Entity> entities; 

  Set<Entity> new_entities;

  System(World world) {
      this.world = world;
      components_wanted = new Set<Type>();
      entities = new Set<Entity>();
      new_entities = new Set<Entity>();
  }

  void initialize();

  void process() {
    for (Entity e in entities) {
      process_entity(e);
    }
  }

  void process_new() {
    for (Entity e in entities) {
      process_new_entity(e);
    }
  }

  void remove_entities(Set<Entity> removed_entities) {
    for (Entity e in removed_entities) {
      remove_entity(e);
    }
    entities.removeAll(removed_entities);
    new_entities.removeAll(removed_entities); 
    // i think removing from new_entities is in fact necessary
    // but I'm having a little bit of a difficult time figuring out exactly when it would happen
    // because it's like 5am and I shouldn't be writing code
    // so i am being safe
  }

  void process_entity(Entity e);

  void process_new_entity(Entity e) {}

  void remove_entity(Entity e);
}
