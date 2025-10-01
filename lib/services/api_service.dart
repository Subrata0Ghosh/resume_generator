import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/resume.dart';

Future<Resume> fetchResume(String name) async {
  final url = Uri.parse(
    'https://expressjs-api-resume-random.onrender.com/resume?name=${Uri.encodeComponent(name)}'
  );
  final res = await http.get(url);
  if (res.statusCode == 200) {
    return Resume.fromJson(jsonDecode(res.body));
  } else {
    throw Exception('Failed to fetch resume: ${res.statusCode}');
  }
}
