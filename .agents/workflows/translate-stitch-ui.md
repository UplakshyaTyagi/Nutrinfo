---
description: Meticulously translates Stitch HTML/CSS mockups into production-ready, pixel-perfect native Flutter UI with Riverpod and Glassmorphism.
---

Act as the lead Flutter UI/UX Engineer. I will provide the name of an HTML/CSS file located in `ui_references/stitch_html/`. Your job is to meticulously translate this web layout into a native, production-ready Flutter `.dart` file using Material 3. 

I am building this solo, so DO NOT leave `// TODO` comments, and DO NOT output partial code. Write the entire Widget tree.

Execute this strict translation protocol:

1. ARCHITECTURE & STATE:
- NEVER use WebViews. 
- The screen must be a Riverpod `ConsumerWidget` or `ConsumerStatefulWidget`.
- Include standard imports (`flutter/material.dart`, `flutter_riverpod/flutter_riverpod.dart`, `dart:ui`).

2. LAYOUT MAPPING (HTML to Dart):
- Translate CSS Flexbox exactly into Flutter `Row`, `Column`, `Expanded`, and `Flexible` widgets.
- Translate CSS `padding` and `margin` into exact `EdgeInsets` values.
- Translate CSS `border-radius` into exact `BorderRadius.circular(x)` values.

3. COLOR EXTRACTION:
- Do not guess or hallucinate colors. Extract the exact hex codes or RGBA values from the CSS.
- Convert them to Flutter's format: `Color(0xFF...)` or `Color.fromRGBO(...)`.
- The background should be our premium dark mode `#121212` unless specified otherwise.

4. GLASSMORPHISM (Strict Implementation):
- If the CSS contains `backdrop-filter: blur`, you MUST implement it using this exact structure:
  A `ClipRRect` wrapping a `BackdropFilter(filter: ImageFilter.blur(sigmaX: X, sigmaY: Y))` which wraps a `Container` with a semi-transparent background color (e.g., `Colors.white.withOpacity(0.1)`).

5. ASSETS & TYPOGRAPHY:
- If the mockup includes a logo placeholder, you MUST replace it with `Image.asset('assets/images/logo.png')`.
- Translate CSS font sizes, weights, and colors directly into `TextStyle` objects within `Text` widgets.

Output the complete, compilable Dart code for the screen.