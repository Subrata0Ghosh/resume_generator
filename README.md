# 📱 Customizable Text Resume Generator

A Flutter app that displays resumes fetched from an API, with customizable **font size, font color, background color**, and built-in **GPS location display**.  
The app also supports **regenerating random resume data** from the API.

---

## ✨ Features
- Fetch resume data from API:  
  `https://expressjs-api-resume-random.onrender.com/resume?name=<your-name>`
- Random skills & projects generated each time (on regenerate).
- Customize:
  - Font Size (slider)
  - Font Color (picker)
  - Background Color (picker)
- Persistent settings using **Hive** (saved across restarts).
- Location support using **Geolocator** (latitude & longitude in AppBar).
- Built with **Flutter + Riverpod** for state management.

---
