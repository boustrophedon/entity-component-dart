part of entity_component_common;

class ComponentMapper<T> {
  // cleverer data structure in the future
  // or just simpler/faster array-based one
  HashMap<int, T> comps;
  ComponentMapper() {
    comps = new HashMap<int, T>();
  }

  void add_component(int entity, T c) {
    comps[entity] = c;
  }

  T get_component(int entity) {
    return comps[entity];
  }

  void remove(int entity) {
    comps.remove(entity);
  }
}
