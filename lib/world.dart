part of entity_component;

class World {
  Set<Entity> entities;
  Map<Component, Set<Entity>> comp_map;

  List<System> systems;

  Queue<Map> events;
  Map<String, Set<System>> event_subs;

  Map<String, Object> globaldata;

  static const Duration refresh_rate = const Duration(milliseconds: 16);

  bool stop = false;

  Timer clock;

  World() {
    entities = new Set<Entity>();
    comp_map = new Map<Component, Set<Entity>>();

    systems = new List<System>();

    events = new Queue<Map>();
    event_subs = new Map<String, Set<System>>();

    globaldata = new Map<String, Object>();

  }

  Entity new_entity() {
    Entity e = new Entity(this);

    return e;
  }

  void _add_to_world(Entity e) {
    for (var c in e.components.keys) {
      register_component(e, c);
    }
    entities.add(e);
  }

  void register_component(Entity e, Component c) {
    if (comp_map.containsKey(c)) {
      comp_map[c].add(e);
    }
    else {
      comp_map[c] = new Set<Component>();
      comp_map[c].add(e);
    }
  }

  void register_system(System syst) {
    systems.add(syst);
  }

  Set<Entity> gather_entities(Set<Component> wanted) {
    // there should be an easier way to do this, i feel
    Set<Entity> cur;
    Set<Entity> all = comp_map[wanted.first];
    for (var c in wanted) {
      cur = comp_map[c];
      all = all.intersection(cur);
    }
    return all;
  }

  void process_systems(Timer t) {
    for (var s in systems) {
      s.entities = gather_entities(s.components_wanted);
      s.process();
    }
    if (this.stop) {
      clock.cancel();
    }
  }

    

  void run() {
    clock = new Timer.periodic(refresh_rate, process_systems);
  }
}
