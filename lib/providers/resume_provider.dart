import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/resume.dart';
import '../services/api_service.dart';

final resumeProvider = FutureProvider.family<Resume, String>((ref, name) {
  return fetchResume(name);
});
