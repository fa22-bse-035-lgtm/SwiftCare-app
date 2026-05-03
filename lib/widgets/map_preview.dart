import 'dart:math' as math;
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class MapPreview extends StatefulWidget {
  final double lat;
  final double lng;

  const MapPreview({super.key, required this.lat, required this.lng});

  @override
  State<MapPreview> createState() => _MapPreviewState();
}

class _MapPreviewState extends State<MapPreview> {
  PointAnnotationManager? _annotationManager;
  bool _isLoading = true;

  // -------------------------------------------------------------------------
  // Custom red teardrop pin — drawn via Canvas, no asset file needed
  // -------------------------------------------------------------------------

  Future<Uint8List> _buildPinImage({
    double width = 80,
    double height = 100,
    Color pinColor = const Color(0xFFE53935),
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final size = Size(width: width, height: height);

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.25)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    final bodyPaint = Paint()..color = pinColor;

    final cx = size.width / 2;
    final radius = size.width / 2;
    final tipY = size.height;
    final circleY = radius;

    // Shadow
    canvas.drawPath(
      _pinPath(cx + 2, circleY + 2, radius, tipY + 2),
      shadowPaint,
    );

    // Pin body
    final pinPath = _pinPath(cx, circleY, radius, tipY);
    canvas.drawPath(pinPath, bodyPaint);

    // Gradient sheen for 3D look
    final sheenPaint = Paint()
      ..shader =
          RadialGradient(
            center: const Alignment(-0.3, -0.4),
            radius: 0.75,
            colors: [Colors.white.withOpacity(0.45), Colors.transparent],
          ).createShader(
            Rect.fromCircle(center: Offset(cx, circleY), radius: radius),
          );
    canvas.drawPath(pinPath, sheenPaint);

    // White hollow circle in the center
    canvas.drawCircle(
      Offset(cx, circleY),
      radius * 0.38,
      Paint()..color = Colors.white,
    );

    final picture = recorder.endRecording();
    final image = await picture.toImage(width.toInt(), height.toInt());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  /// Builds the teardrop path: circle on top tapering to a point at [tipY].
  Path _pinPath(double cx, double circleY, double radius, double tipY) {
    final path = Path();
    final halfAngle = math.asin((radius * 0.45) / radius);
    final startAngle = math.pi / 2 + halfAngle;

    path.moveTo(cx, tipY);
    path.lineTo(
      cx - radius * math.cos(halfAngle),
      circleY + radius * math.sin(halfAngle),
    );
    path.arcTo(
      Rect.fromCircle(center: Offset(cx, circleY), radius: radius),
      startAngle,
      (2 * math.pi) - 2 * halfAngle,
      false,
    );
    path.lineTo(cx, tipY);
    path.close();
    return path;
  }

  // -------------------------------------------------------------------------
  // Map setup
  // -------------------------------------------------------------------------

  Future<void> _onMapCreated(MapboxMap controller) async {
    // Disable all gestures — this is a static preview, not interactive
    await controller.gestures.updateSettings(
      GesturesSettings(
        scrollEnabled: false,
        quickZoomEnabled: false,
        rotateEnabled: false,
        pitchEnabled: false,
        doubleTapToZoomInEnabled: false,
        doubleTouchToZoomOutEnabled: false,
      ),
    );

    // Create annotation manager
    _annotationManager = await controller.annotations
        .createPointAnnotationManager();

    // Build the pin image from Canvas
    final pinBytes = await _buildPinImage();

    // Register it as a named image in the Mapbox style
    await controller.style.addStyleImage(
      'custom-red-pin',
      2.0,
      MbxImage(width: 80, height: 100, data: pinBytes),
      false, // sdf = false → full-color bitmap
      [],
      [],
      null,
    );

    // Place the annotation — tip anchored exactly on the coordinate
    await _annotationManager!.create(
      PointAnnotationOptions(
        geometry: Point(coordinates: Position(widget.lng, widget.lat)),
        iconImage: 'custom-red-pin',
        iconSize: 1.0,
        iconAnchor: IconAnchor.BOTTOM,
      ),
    );

    if (mounted) setState(() => _isLoading = false);
  }

  // -------------------------------------------------------------------------
  // Open in Google Maps on tap
  // -------------------------------------------------------------------------

  Future<void> _openInGoogleMaps() async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${widget.lat},${widget.lng}',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  // -------------------------------------------------------------------------
  // Build
  // -------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openInGoogleMaps,
      child: Container(
        height: 160,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.black12),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            children: [
              // ── Map ───────────────────────────────────────────────────────
              MapWidget(
                key: const ValueKey('mapWidget'),
                styleUri: MapboxStyles.MAPBOX_STREETS,
                cameraOptions: CameraOptions(
                  center: Point(coordinates: Position(widget.lng, widget.lat)),
                  zoom: 14,
                ),
                onMapCreated: _onMapCreated,
              ),

              // ── Loading overlay ───────────────────────────────────────────
              if (_isLoading)
                Container(
                  color: Colors.white.withOpacity(0.6),
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
