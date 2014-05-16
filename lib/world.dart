part of entity_component;

typedef void EventCallback(Map event);

class World {
  Set<Entity> entities;
  Map<Type, Set<Entity>> comp_map;

  List<System> systems;

  EventQueue events;
  Map<String, Set<EventCallback>> event_subs;

  Map<String, dynamic> globaldata;

  bool stop = false;

  World() {
    entities = new Set<Entity>();
    comp_map = new Map<Type, Set<Entity>>();

    systems = new List<System>();

    events = new EventQueue();
    event_subs = new Map<String, Set<EventCallback>>();

    globaldata = new Map<String, Object>();

  }

  Entity new_entity() {
    Entity e = new Entity(this);
    return e;
  }

  // XXX need to add code for removing an entity from world
  void _add_to_world(Entity e) {
    for (var c in e.components.keys) {
      register_component(e, c);
    }
    entities.add(e);
    add_to_systems(e);
  }

  void add_to_systems(Entity e) {
    for (System s in systems) {
      if (s.components_wanted == null) {
        continue;
      }
      var comps = new Set.from(e.components.keys);
      if (comps.containsAll(s.components_wanted)) {
        s.entities.add(e);
        s.new_entities.add(e);
      }
    }
  }

  void register_component(Entity e, Type c) {
    comp_map.putIfAbsent(c, ()=> new Set<Entity>());
    comp_map[c].add(e);
  }

  void register_system(System syst) {
    systems.add(syst);
  }

  void subscribe_event(String event_type, EventCallback callback) {
    event_subs.putIfAbsent(event_type, ()=>new Set<EventCallback>());
    event_subs[event_type].add(callback);
  }
    
  void send_event(String event_type, Map event) {
    event['EVENT_TYPE'] = event_type;
    events.add(event);
  }

  void process_event(Map event) {
    var subs = event_subs[event['EVENT_TYPE']];
    if (subs != null) {
      for (EventCallback callback in event_subs[event['EVENT_TYPE']]) {
        callback(event);
      }
    }
  }

  void process_systems() {
    for (var s in systems) {
      if (s.new_entities.isNotEmpty) {
        s.process_new();
        s.new_entities.clear();
      }
      if (s.entities.isNotEmpty) {
        s.process();
      }
    }
  }

  void process_events() {
    for (var e in events.get()) {
      process_event(e);
    }
  }

  void _run(num hiResTimer) {
    process_systems();
    process_events();
    if (!this.stop) {
      window.requestAnimationFrame(_run);
    }
  } 

  void run() {
    for (var s in systems) {
      s.initialize();
    }
    window.requestAnimationFrame(_run);
  }
}
