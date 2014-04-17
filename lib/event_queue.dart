part of entity_component;

class EventQueue {
  ListQueue current;
  ListQueue back;
  ListQueue tmp;

  EventQueue() {
    current = new ListQueue();
    back = new ListQueue();
  }

  ListQueue get() {
    current.clear();
    
    tmp = back;
    back = current;
    current = tmp;
    return current;
  }

  void add(Object e) {
    back.add(e); 
  }

}
