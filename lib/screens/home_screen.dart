import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/settings_provider.dart';
import '../providers/resume_provider.dart';
import '../providers/location_provider.dart';
import '../widgets/color_picker_dialog.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  static const apiName = "insert-your-name-here"; // assignment requirement

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final resumeAsync = ref.watch(resumeProvider(apiName));
    final locAsync = ref.watch(locationProvider);

    return Scaffold(
      backgroundColor: Colors.black, // dark background as in screenshot
      appBar: AppBar(
        title: const Text("Resume Generator"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: locAsync.when(
              data: (pos) => Text(
                "${pos.latitude.toStringAsFixed(2)}, ${pos.longitude.toStringAsFixed(2)}",
                style: const TextStyle(color: Colors.white),
              ),
              loading: () => const Text("...GPS", style: TextStyle(color: Colors.white)),
              error: (_, __) => const Text("GPS off", style: TextStyle(color: Colors.red)),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Resume card
            Expanded(
              child: resumeAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(
                  child: Text("Error: $e", style: const TextStyle(color: Colors.red)),
                ),
                data: (resume) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(settings.bgColorValue),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           // name Section
                          Text(
                            "NAME",
                            style: TextStyle(
                              fontSize: settings.fontSize,
                              fontWeight: FontWeight.bold,
                              color: Color(settings.fontColorValue),
                            ),
                          ),
                          const Divider(),
                          
                            Text(
                              "• ${resume.name ?? ''}",
                              style: TextStyle(
                                fontSize: settings.fontSize,
                                color: Color(settings.fontColorValue),
                              ),
                            ),
                          
                          const SizedBox(height: 16),

                          // Skills Section
                          Text(
                            "SKILLS",
                            style: TextStyle(
                              fontSize: settings.fontSize,
                              fontWeight: FontWeight.bold,
                              color: Color(settings.fontColorValue),
                            ),
                          ),
                          const Divider(),
                          ...resume.skills.map(
                            (s) => Text(
                              "• $s",
                              style: TextStyle(
                                fontSize: settings.fontSize,
                                color: Color(settings.fontColorValue),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Projects Section
                          Text(
                            "PROJECTS",
                            style: TextStyle(
                              fontSize: settings.fontSize,
                              fontWeight: FontWeight.bold,
                              color: Color(settings.fontColorValue),
                            ),
                          ),
                          const Divider(),
                          ...resume.projects.map(
                            (p) => Text(
                              "• ${p['title'] ?? ''} - ${p['description'] ?? ''}",
                              style: TextStyle(
                                fontSize: settings.fontSize,
                                color: Color(settings.fontColorValue),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // Font size slider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Font Size: ${settings.fontSize.toInt()}",
                    style: const TextStyle(color: Colors.white)),
                Expanded(
                  child: Slider(
                    min: 12,
                    max: 28,
                    value: settings.fontSize,
                    onChanged: (v) => ref.read(settingsProvider.notifier).setFontSize(v),
                  ),
                ),
              ],
            ),

            // Controls row (Font Color, Bg Color, Regenerate)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Font Color button
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[900], // dark button
                        foregroundColor: Colors.white,     // text/icon color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4), // flat rectangle look
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () async {
                        final c = await showColorPickerDialog(
                            context, Color(settings.fontColorValue));
                        if (c != null) {
                          ref.read(settingsProvider.notifier).setFontColor(c);
                        }
                      },
                      icon: const Icon(Icons.format_color_text),
                      label: const Text("Font Color"),
                    ),
                  ),
                ),

                // Background Color button
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[900],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () async {
                        final c = await showColorPickerDialog(
                            context, Color(settings.bgColorValue));
                        if (c != null) {
                          ref.read(settingsProvider.notifier).setBgColor(c);
                        }
                      },
                      icon: const Icon(Icons.format_color_fill),
                      label: const Text("Bg Color"),
                    ),
                  ),
                ),

                // Regenerate button
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[900],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        ref.invalidate(resumeProvider(apiName));
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text("Regenerate"),
                    ),
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
