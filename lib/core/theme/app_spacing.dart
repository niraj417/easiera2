class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;
  static const double huge = 48.0;
}

class AppRadius {
  static const double card = 12.0;
  static const double button = 8.0;
  static const double chip = 20.0;
  static const double modal = 20.0;
  static const double small = 6.0;
  static const double large = 16.0;
  static const double circle = 100.0;
}

class AppShadows {
  static const List<dynamic> card = [
    {
      'offset': [0, 2],
      'blurRadius': 8.0,
      'color': 'rgba(0,0,0,0.08)',
    }
  ];
}

class AppDurations {
  static const int gaugeAnimation = 600; // ms
  static const int buttonPress = 120; // ms
  static const int modalSlide = 300; // ms
  static const int shimmerLoop = 1500; // ms
  static const int pageTransition = 250; // ms
}
