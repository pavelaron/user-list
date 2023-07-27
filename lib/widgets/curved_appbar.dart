import 'package:flutter/material.dart';

class CurvedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Text _title;

  const CurvedAppBar({
    required Text title,
    Key? key
  }) :
    _title = title,

    preferredSize = const Size.fromHeight(kToolbarHeight),
    super(key: key);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: _title,
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      shape: _CurvedAppBarShape(context),
      centerTitle: true,
    );
  }
}

class _CurvedAppBarShape extends ContinuousRectangleBorder {
  final BuildContext _context;

  const _CurvedAppBarShape(this._context);
  
  @override
  Path getOuterPath(Rect rect, { TextDirection? textDirection }) {
    Size size = rect.size;
    Path path = Path();

    Orientation currentOrientation = MediaQuery.of(_context).orientation;
    double curveHeight = currentOrientation == Orientation.portrait ? 30.0 : 0.0;

    path.lineTo(0.0, size.height + curveHeight);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height);
    path.lineTo(size.width, 0.0);

    path.close();
    return path;
  }
}
