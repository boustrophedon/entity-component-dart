part of entity_component_common;

class System {
  var world; // var and not World because otherwise dartanalyzer complains that World doesn't have setters/getters for subclasses' data
  // eg I make a ClientWorldSubclass subclass with an int client_id and dartanalyzer complains World doesn't have a client_id setter
  // the proper way to fix this is to do System<T> and then define my classes like class System<ClientWorldSubclass> {
  // but that's a bit silly

  Set<Type> components_wanted;
  Set<int> entities; 

  Set<int> new_entities;

  System(World world) {
      this.world = world;
      components_wanted = new Set<Type>();
      entities = new Set<int>();
      new_entities = new Set<int>();
  }

  void initialize() {}

  void process() {
    for (int e in entities) {
      process_entity(e);
    }
  }

  void process_new() {
    for (int e in new_entities) {
      process_new_entity(e);
    }
    new_entities.clear();
  }

  void remove_entities(Set<int> removed_entities) {
    for (int e in removed_entities) {
      remove_entity(e);
    }
    entities.removeAll(removed_entities);
    new_entities.removeAll(removed_entities); 
    // i think removing from new_entities is in fact necessary
    // but I'm having a little bit of a difficult time figuring out exactly when it would happen
    // because it's like 5am and I shouldn't be writing code
    // so i am being safe
  }

  void process_entity(int e) {}

  void process_new_entity(int e) {}

  void remove_entity(int e) {}
}
