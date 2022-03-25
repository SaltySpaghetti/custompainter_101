import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          brightness: Brightness.dark),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),
            Center(
              child: SizedBox(
                width: 270,
                height: 300,
                child: CustomPaint(
                  painter: HystogramChartPainter(),
                ),
              ),
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: 270,
              height: 300,
              child: CustomPaint(
                painter: PieChartPainter(),
              ),
            ),
            SizedBox(
              width: 270,
              height: 400,
              child: CustomPaint(
                painter: LineChartPainter(),
              ),
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: 270,
              height: 300,
              child: CustomPaint(
                painter: FlutterLogoPainter(),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

class HystogramChartPainter extends CustomPainter {
  final columnsPadding = 10;

  @override
  void paint(Canvas canvas, Size size) {
    final maxValue = Constants.data.reduce(math.max);
    for (var i = 0; i < Constants.data.length; i++) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            i * (size.width / Constants.data.length - columnsPadding + columnsPadding),
            size.height - (size.height / maxValue * Constants.data[i]),
            size.width / Constants.data.length - columnsPadding,
            size.height / maxValue * Constants.data[i],
          ),
          const Radius.circular(20),
        ),
        Paint()..color = Constants.colors[i],
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class PieChartPainter extends CustomPainter {
  double degToRad(double degree) => degree * math.pi / 180;

  @override
  void paint(Canvas canvas, Size size) {
    final total = Constants.data.fold(0, (int v1, int v2) => v1 + v2);
    var angle = 0.0;

    for (var i = 0; i < Constants.data.length; i++) {
      final sliceSize = degToRad(-(360 / total * Constants.data[i]));

      canvas.drawArc(
        Rect.fromLTWH(0, 0, size.height, size.height),
        angle,
        sliceSize,
        true,
        Paint()..color = Constants.colors[i],
      );

      angle += sliceSize;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class LineChartPainter extends CustomPainter {
  final columnsPadding = 10;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    final pointsOffset = size.width / (Constants.data.length - 1);
    var drawOffset = 0.0;
    var path = Path();

    path.moveTo(drawOffset, size.height - (size.height / Constants.data[0]));

    for (var i = 0; i < Constants.data.length; i++) {
      path.lineTo(drawOffset, size.height - (size.height / Constants.data[i]));

      drawOffset += pointsOffset;
    }

    canvas.drawPath(path, paint..color = Constants.colors[8]);

    drawOffset = 0.0;
    for (var i = 0; i < Constants.data.length; i++) {
      final circlePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..color = Constants.colors[i];

      canvas.drawCircle(
        Offset(drawOffset, size.height - (size.height / Constants.data[i])),
        10,
        circlePaint..style = PaintingStyle.fill,
      );
      drawOffset += pointsOffset;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class FlutterLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var midPartPath = Path();
    var lowerPartPath = Path();
    var squarePath = Path();

    var bluePaint = Paint()..color = const Color(0xFF01B5F8);

    var darkBluePaint = Paint()..color = const Color(0xFF01569E);
    var upperPartPath = Path();
    var lightBluePaint = Paint()..color = const Color(0xFF46C4FB);

    upperPartPath.moveTo(0, size.height / 2);
    upperPartPath.lineTo(size.width / 1.6, 0);
    upperPartPath.lineTo(size.width, 0);
    upperPartPath.lineTo(size.width / 5.4, size.height / 1.55);
    upperPartPath.close();

    lowerPartPath.moveTo(size.width / 3.5, size.height / 1.37);
    lowerPartPath.lineTo(size.width / 2.1, size.height / 1.74);
    lowerPartPath.lineTo(size.width, size.height);
    lowerPartPath.lineTo(size.width / 1.63, size.height);
    lowerPartPath.close();

    midPartPath.moveTo(size.width / 3.5, size.height / 1.37);
    midPartPath.lineTo(size.width / 1.63, size.height / 2.17);
    midPartPath.lineTo(size.width, size.height / 2.17);
    midPartPath.lineTo(size.width / 2.1, size.height / 1.13);
    midPartPath.close();

    squarePath.moveTo(size.width / 3.5, size.height / 1.37);
    squarePath.lineTo(size.width / 2.1, size.height / 1.74);
    squarePath.lineTo(size.width / 1.5, size.height / 1.37);
    squarePath.lineTo(size.width / 2.1, size.height / 1.13);
    squarePath.close();

    canvas.drawPath(upperPartPath, lightBluePaint);
    canvas.drawPath(lowerPartPath, darkBluePaint);
    canvas.drawPath(midPartPath, lightBluePaint);
    canvas.drawPath(squarePath, bluePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
