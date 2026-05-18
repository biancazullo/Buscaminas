enum NumberStyle { classic, colorful, retro, minimalist }

extension NumberStyleDetails on NumberStyle {
  String get label {
    return switch (this) {
      NumberStyle.classic => 'Clasico',
      NumberStyle.colorful => 'Colorido',
      NumberStyle.retro => 'Retro',
      NumberStyle.minimalist => 'Minimalista',
    };
  }

  static NumberStyle fromName(String value) {
    for (final style in NumberStyle.values) {
      if (style.name == value) {
        return style;
      }
    }

    return NumberStyle.classic;
  }
}
