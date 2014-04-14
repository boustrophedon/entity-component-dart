part of entity_component;

class Entity {

  World world;
  Map<Component, Component> components;

  Entity(World world) {
    this.world = world;
    components = new Map();
  }

  void add_to_world() {
    world._add_to_world(this);
  }

  void add_component(Component c) {
    components[c.runtimeType] = c;
  }

  Component get_component(Component c) {
    return components[c];
  }

  bool has_component(Component c) {
    if (components.containsKey(c)) {
      return true;
    } else {
      return false;
    }
  }

}
