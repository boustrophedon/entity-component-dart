part of entity_component_common;

typedef void EventCallback(Map event);

class World {
  Map<int, Set<Type>> entities;
  Set<int> removed_entities;
  Map<Type, ComponentMapper> component_mappers;
  List<System> systems;

  num time = 0;
  num dt = 0;

  int cur_id = 0;

  EventQueue events;
  Map<String, Set<EventCallback>> event_subs;

  Map<String, dynamic> globaldata;

  Map<String, int> tagged_entities;

  bool stop = false;

  World(List<Type> component_types) {
    entities = new Map<int, Set<Type>>();
    removed_entities = new Set<int>();

    component_mappers = new Map<Type, ComponentMapper>();
    for (Type t in component_types) {
      component_mappers[t] = new ComponentMapper();
    }
    systems = new List<System>();

    events = new EventQueue();
    event_subs = new Map<String, Set<EventCallback>>();

    // not really a difference here
    globaldata = new Map<String, dynamic>();
    tagged_entities = new Map<String, int>();

  }

  int new_entity() {
    return new_entity_id();
  }
  
  int new_entity_id() {
    // XXX this is simple for now, can probably be optimized in some way
    cur_id+=2;
    return cur_id;
  }

  void add_component(int e, Component c) {
    entities.putIfAbsent(e, ()=>(new Set<Type>())).add(c.runtimeType);
    component_mappers[c.runtimeType].add_component(e, c);
  }

  void add_to_world(int e) {
    add_to_systems(e);
  }

  void add_to_systems(int e) {
    for (System s in systems) {
      if (s.components_wanted == null) {
        continue;
      }
      var comps = entities[e];
      if (comps.containsAll(s.components_wanted)) {
        s.entities.add(e);
        s.new_entities.add(e);
      }
    }
  }

  void remove_entity(int e) {
    removed_entities.add(e);
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
      s.process();
    }
  }

  void process_events() {
    for (var e in events.get()) {
      process_event(e);
    }
  }

  void remove_entities() {
    for (System s in systems) {
      s.remove_entities(removed_entities);
      s.entities.removeAll(removed_entities);
    }
    for (int e in removed_entities) {
      for (Type c in entities[e]) {
        component_mappers[c].remove(e);
      }
    }
    if (removed_entities.isNotEmpty) {
      removed_entities.clear();
    }
  }

  void run() {
    process_systems();
    process_events();
    remove_entities();
  } 

  void start() {
    for (var s in systems) {
      s.initialize();
    }
    do_frame();
  }

  void do_frame() {}

}
