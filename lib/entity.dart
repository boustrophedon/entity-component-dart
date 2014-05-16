part of entity_component;

class Entity {

  World world;
  Map<Type, Component> components;

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

  dynamic get_component(Type t) {
    return components[t];
  }

  bool has_component(Type t) {
    if (components.containsKey(t)) {
      return true;
    } else {
      return false;
    }
  }

}
