import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/settings_provider.dart';
import '../providers/resume_provider.dart';
import '../providers/location_provider.dart';
import '../widgets/color_picker_dialog.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  static const apiName = 'insert-your-name-here'; // per assignment: don't add a form

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final resumeAsync = ref.watch(resumeProvider(apiName));
    final locAsync = ref.watch(locationProvider);

    return Scaffold(
      backgroundColor: Color(settings.bgColorValue),
      appBar: AppBar(
        title: const Text('Resume Generator'),
        backgroundColor: Color(settings.bgColorValue),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: locAsync.when(
              data: (pos) => Text('${pos.latitude.toStringAsFixed(4)}, ${pos.longitude.toStringAsFixed(4)}'),
              loading: () => const Text('...GPS'),
              error: (_,__) => const Text('GPS off'),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Controls
            Row(
              children: [
                const Text('Font size'),
                Expanded(
                  child: Slider(
                    min: 10,
                    max: 36,
                    value: settings.fontSize,
                    onChanged: (v) => ref.read(settingsProvider.notifier).setFontSize(v),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.format_color_text),
                  onPressed: () async {
                    final c = await showColorPickerDialog(context, Color(settings.fontColorValue));
                    if (c != null) ref.read(settingsProvider.notifier).setFontColor(c);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.format_color_fill),
                  onPressed: () async {
                    final c = await showColorPickerDialog(context, Color(settings.bgColorValue));
                    if (c != null) ref.read(settingsProvider.notifier).setBgColor(c);
                  },
                ),
              ],
            ),

            // regenerate button
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // force re-fetch (regenerate)
                    ref.invalidate(resumeProvider(apiName));
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Regenerate Resume'),
                ),
              ],
            ),

            const SizedBox(height: 12),
            // Resume area
            Expanded(
              child: resumeAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Failed to load resume: $e')),
                data: (resume) {
                  final sb = StringBuffer();
                  sb.writeln(resume.name);
                  sb.writeln('\nSkills: ${resume.skills.join(', ')}\n');
                  sb.writeln('Projects:');
                  for (final p in resume.projects) {
                    sb.writeln('- ${p['title'] ?? p['name'] ?? ''}');
                    if (p['description'] != null) sb.writeln('  ${p['description']}');
                  }

                  return SingleChildScrollView(
                    child: Text(
                      sb.toString(),
                      style: TextStyle(
                        fontSize: settings.fontSize,
                        color: Color(settings.fontColorValue),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
