part of entity_component_client;

class ClientWorld extends World {
  int cur_id = 1;
  ClientWorld(List<Type> component_types) : super(component_types) {}

  void update_timestamp_and_run(num timestamp) {
    this.dt = timestamp - this.time;
    this.time = timestamp;
    this.run();
    do_frame();
  }
  void do_frame() {
    if (!this.stop) {
      window.requestAnimationFrame(update_timestamp_and_run);
    }
  }
}
