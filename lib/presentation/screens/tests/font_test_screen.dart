import 'package:flutter/material.dart';

class FontTestScreen extends StatelessWidget {
  const FontTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Accessing your theme's text styles
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('NataSans Typography Showcase'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildFontSection('Display Styles (Heads)', [
            _fontRow('Display Large (w900)', textTheme.displayLarge),
            _fontRow('Display Medium (w800)', textTheme.displayMedium),
            _fontRow('Display Small (w100)', textTheme.displaySmall),
          ]),
          const Divider(),
          _buildFontSection('Headline & Title Styles', [
            _fontRow('Headline Large (w700)', textTheme.headlineLarge),
            _fontRow('Title Large (w600)', textTheme.titleLarge),
            _fontRow('Title Medium (Medium)', textTheme.titleMedium),
          ]),
          const Divider(),
          _buildFontSection('Body Styles (Regular Use)', [
            _fontRow('Body Large (w400)', textTheme.bodyLarge),
            _fontRow('Body Medium (Regular)', textTheme.bodyMedium),
            _fontRow('Body Small (w300)', textTheme.bodySmall),
          ]),
          const Divider(),
          _buildFontSection('Label Styles', [
            _fontRow('Label Large (Bold/Medium)', textTheme.labelLarge),
            _fontRow('Label Small (w200)', textTheme.labelSmall),
          ]),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Example Button Text'),
          ),
        ],
      ),
    );
  }

  Widget _buildFontSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(title,
              style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12)
          ),
        ),
        ...children,
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _fontRow(String label, TextStyle? style) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.blueGrey)),
          Text('The quick brown fox jumps over the lazy dog', style: style),
        ],
      ),
    );
  }
}