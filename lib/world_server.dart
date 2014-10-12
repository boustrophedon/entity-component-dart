part of entity_component_server;

class ServerWorld extends World {
  Stopwatch clock;
  ServerWorld() : super() {
    clock = new Stopwatch();
  }

  void do_frame() {
    if (!this.stop) {
      int timestamp = clock.elapsedMicroseconds;

      this.dt = timestamp - this.time;
      this.time = timestamp;
      clock.reset();
      this.run();

      new Future.delayed(const Duration(milliseconds: 16), do_frame);
    }
  }
}
