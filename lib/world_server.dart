part of entity_component_server;

class ServerWorld extends World {
  Stopwatch clock;
  ServerWorld(List<Type> component_types) : super(component_types) {
    clock = new Stopwatch();
    clock.start();
  }

  void do_frame() {
    if (!this.stop) {
      int timestamp = clock.elapsedMilliseconds;

      this.dt = (timestamp - this.time);
      this.time = timestamp;
      this.run();
      new Future.delayed(const Duration(milliseconds: 16), do_frame);
    }
  }
}
