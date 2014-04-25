import 'package:entity_component/entity_component.dart';
import 'lib/draw.dart';

import 'dart:html';

void main() {
  World w = create_world();
  w.globaldata['canvas'] = querySelector('#area');
  w.run();
}
