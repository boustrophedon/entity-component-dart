part of entity_component;

typedef void EventCallback(Map event);

class World {
  Set<Entity> entities;
  Map<Type, Set<Entity>> comp_map;

  List<System> systems;

  EventQueue events;
  Map<String, Set<EventCallback>> event_subs;

  Map<String, Object> globaldata;

  static const Duration refresh_rate = const Duration(milliseconds: 16);

  bool stop = false;

  Timer clock;

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

  void _add_to_world(Entity e) {
    for (var c in e.components.keys) {
      register_component(e, c);
    }
    entities.add(e);
  }

  void register_component(Entity e, Type c) {
    comp_map.putIfAbsent(c, ()=> new Set<Entity>());
    comp_map[c].add(e);
  }

  void register_system(System syst) {
    systems.add(syst);
  }

  Set<Entity> gather_entities(Set<Type> wanted) {
    // there should be an easier way to do this, i feel
    Set<Entity> cur;
    Set<Entity> all = comp_map[wanted.first];
    for (var c in wanted) {
      cur = comp_map[c];
      all = all.intersection(cur);
    }
    return all;
  }

  void process_systems() {
    for (var s in systems) {
      s.entities = gather_entities(s.components_wanted);
      s.process();
    }
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
    for (EventCallback callback in event_subs[event['EVENT_TYPE']]) {
      callback(event);
    }
  }

  void process_events() {
    for (var e in events.get()) {
      process_event(e);
    }
  }

  void _run(Timer t) {
    process_systems();
    process_events();
    if (this.stop) {
      clock.cancel();
    }
  } 

  void run() {
    clock = new Timer.periodic(refresh_rate, _run);
  }
}
