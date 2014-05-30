part of entity_component;

class Entity {

  World world;
  Map<Type, Component> components;

  int id;

  Entity(World world, int id) {
    this.world = world;
    this.id = id;
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
