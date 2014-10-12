part of entity_component_client;

class ClientWorld extends World {
  ClientWorld() : super() {}

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
