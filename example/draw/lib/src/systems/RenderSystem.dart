part of draw;

class RenderSystem extends System {

  CanvasRenderingContext2D context;

  int size = 20;
  String color = 'rgb(200,0,0)';

  String shape = 'rect';

  bool drawing = false;

  RenderSystem(World world) : super(world) {
    components_wanted = null;
  }

  void initialize() {
    context = world.globaldata['canvas'].context2D;

    world.subscribe_event('SwapShape', swap);
    world.subscribe_event('StartDrawing', start);
    world.subscribe_event('StopDrawing', stop);
    world.subscribe_event('DrawAt', draw);
  }

  void start(Map event) {
    drawing = true;
  }

  void stop(Map event) {
    drawing = false;
  }

  void swap(Map event) {
    if (shape == 'rect') {
      shape = 'circle';
    }
    else if (shape == 'circle') {
      shape = 'rect';
    }
  }

  void draw(Map event) {
    int x = event['x']; int y = event['y'];
    if (shape == 'rect') {
      drawRect(x,y);
    }
    else if (shape == 'circle') {
      drawCircle(x,y);
    }
  }

  void drawRect(int x, int y) {
    if (drawing) {
      context.save();
      context.fillStyle = color;
      context.fillRect(x,y,size,size);
      context.restore();
    }
  }

  void drawCircle(int x, int y) {
    if (drawing) {
      context.save();
      context.fillStyle = color;
      context.beginPath();
      context.arc(x, y, size, 0, 2*math.PI);
      context.fill();
      context.restore();
    }
  }

  void process_entity(Entity entity) {

  }
}

