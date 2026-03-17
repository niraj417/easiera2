import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class GaugeChart extends StatefulWidget {
  final double score;
  final double maxScore;
  final String label;
  final Color? color;
  final double size;
  final bool showAnimation;

  const GaugeChart({
    super.key,
    required this.score,
    this.maxScore = 100,
    required this.label,
    this.color,
    this.size = 180,
    this.showAnimation = true,
  });

  @override
  State<GaugeChart> createState() => _GaugeChartState();
}

class _GaugeChartState extends State<GaugeChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation = Tween<double>(begin: 0, end: widget.score / widget.maxScore)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    if (widget.showAnimation) {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) _controller.forward();
      });
    } else {
      _controller.value = 1.0;
    }
  }

  Color get _gaugeColor {
    if (widget.color != null) return widget.color!;
    final ratio = widget.score / widget.maxScore;
    if (ratio >= 0.8) return AppColors.statusGreen;
    if (ratio >= 0.6) return AppColors.statusAmber;
    return AppColors.statusRed;
  }

  String get _grade {
    final ratio = widget.score / widget.maxScore;
    if (ratio >= 0.9) return 'AAA';
    if (ratio >= 0.8) return 'AA';
    if (ratio >= 0.7) return 'A';
    if (ratio >= 0.5) return 'B';
    return 'C';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SizedBox(
          width: widget.size,
          height: widget.size * 0.8,
          child: CustomPaint(
            painter: _GaugePainter(
              progress: _animation.value,
              color: _gaugeColor,
              backgroundColor: AppColors.borderLight,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    '${(widget.score * _animation.value).toInt()}',
                    style: AppTypography.displayLarge.copyWith(
                      color: _gaugeColor,
                      fontWeight: FontWeight.w800,
                      fontSize: widget.size * 0.18,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: _gaugeColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _grade,
                      style: AppTypography.labelLarge.copyWith(
                        color: _gaugeColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.label,
                    style: AppTypography.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;

  _GaugePainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.75);
    final radius = size.width * 0.42;
    const startAngle = math.pi;
    const sweepAngle = math.pi;

    final bgPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      bgPaint,
    );

    final fgPaint = Paint()
      ..shader = LinearGradient(
        colors: [color.withOpacity(0.7), color],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle * progress,
      false,
      fgPaint,
    );

    // Tick marks
    for (int i = 0; i <= 10; i++) {
      final angle = math.pi + (math.pi * i / 10);
      final isLong = i % 5 == 0;
      final tickLength = isLong ? 10.0 : 6.0;
      final tickPaint = Paint()
        ..color = Colors.white.withOpacity(isLong ? 0.8 : 0.4)
        ..strokeWidth = isLong ? 2.0 : 1.0;
      
      final tickStart = Offset(
        center.dx + (radius - 8) * math.cos(angle),
        center.dy + (radius - 8) * math.sin(angle),
      );
      final tickEnd = Offset(
        center.dx + (radius - 8 - tickLength) * math.cos(angle),
        center.dy + (radius - 8 - tickLength) * math.sin(angle),
      );
      canvas.drawLine(tickStart, tickEnd, tickPaint);
    }
  }

  @override
  bool shouldRepaint(_GaugePainter oldDelegate) => oldDelegate.progress != progress;
}

class MiniScoreBar extends StatelessWidget {
  final String label;
  final int score;
  final int maxScore;
  final Color color;

  const MiniScoreBar({
    super.key,
    required this.label,
    required this.score,
    required this.maxScore,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTypography.bodySmall),
            Text('$score/$maxScore', style: AppTypography.dataMonoSmall.copyWith(color: color)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: score / maxScore,
            backgroundColor: color.withOpacity(0.15),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}
