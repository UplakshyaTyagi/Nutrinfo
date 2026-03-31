import os
import re

MAPPINGS = {
    r'const Color\(0xFF131313\)': 'context.bgScreen',
    r'Color\(0xFF131313\)': 'context.bgScreen',
    r'const Color\(0xFF1C1B1B\)': 'context.bgCard',
    r'Color\(0xFF1C1B1B\)': 'context.bgCard',
    r'const Color\(0xFF0A0A0A\)': 'context.bgHeader',
    r'Color\(0xFF0A0A0A\)': 'context.bgHeader',
    r'const Color\(0xFF2A2A2A\)': 'context.bgInput',
    r'Color\(0xFF2A2A2A\)': 'context.bgInput',
    r'const Color\(0xFF353534\)': 'context.bgInput',  # similar to input
    r'Color\(0xFF353534\)': 'context.bgInput',
    r'const Color\(0xFFE5E2E1\)': 'context.textPrimary',
    r'Color\(0xFFE5E2E1\)': 'context.textPrimary',
    r'const Color\(0xFFB9CBB8\)': 'context.textSecondary',
    r'Color\(0xFFB9CBB8\)': 'context.textSecondary',
    r'const Color\(0xFF00FF7F\)': 'context.accentMint',
    r'Color\(0xFF00FF7F\)': 'context.accentMint',
    r'const Color\(0xFF00BFFF\)': 'context.accentCyan',
    r'Color\(0xFF00BFFF\)': 'context.accentCyan',
    r'const Color\(0xFFFFDF95\)': 'context.accentGold',
    r'Color\(0xFFFFDF95\)': 'context.accentGold',
    r'Colors.white.withAlpha\(20\)': 'context.borderWhite10',
    r'Colors.white.withAlpha\(25\)': 'context.borderWhite10',
    r'Colors.white.withAlpha\(51\)': 'context.borderWhite20',
}

def process_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    original = content
    for pattern, replacement in MAPPINGS.items():
        content = re.sub(pattern, replacement, content)

    if content != original:
        # Check if we need to add the import
        if 'import \'../../theme/app_colors.dart\';' not in content and 'import \'package:nutrinfo_app/theme/app_colors.dart\';' not in content:
            # simple hack to add import near the top
            content = content.replace("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';\nimport 'package:nutrinfo_app/theme/app_colors.dart';")
        
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"Updated {filepath}")

def main():
    lib_dir = "d:/STUDY/Project/Nutrinfo/nutrinfo_app/lib"
    for root, dirs, files in os.walk(lib_dir):
        for file in files:
            if file.endswith('.dart') and file != 'app_colors.dart':
                process_file(os.path.join(root, file))

if __name__ == '__main__':
    main()
