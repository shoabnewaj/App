# 📱 Y-ChatApp Android APK বিল্ড ও ইনস্টল গাইড

এই ফোল্ডারে (`ychat-android`) Y-ChatApp-এর সম্পূর্ণ নেটিভ অ্যান্ড্রয়েড অ্যাপ প্রজেক্ট রয়েছে।

---

## 🚀 Android Studio দিয়ে APK তৈরি করার নিয়ম (সহজ পদ্ধতি)

1. আপনার কম্পিউটারে **Android Studio** ওপেন করুন।
2. **Open Project**-এ ক্লিক করে এই ফোল্ডারটি সিলেক্ট করুন:  
   `c:\pleiades-2025-12-ultimate-win-64bit-jre_20251214\workspace\ychatApp\ychat-android`
3. Android Studio স্বয়ংক্রিয়ভাবে Gradle সিঙ্ক সম্পন্ন করবে।
4. **সার্ভার লিঙ্ক পরিবর্তন (ঐচ্ছিক):**  
   `app/src/main/java/com/ychat/app/MainActivity.java` ফাইলে গিয়ে `APP_URL` পরিবর্তন করে আপনার লাইভ ডোমেইন দিন (যেমন: `https://ychat-app.onrender.com/`).
5. উপরের মেনু থেকে ক্লিক করুন:  
   👉 **Build** > **Build Bundle(s) / APK(s)** > **Build APK(s)**
6. কিছুক্ষণের মধ্যে নিচে একটি নোটিফিকেশন আসবে: **"APK(s) generated successfully"**।
7. **locate** লিংকে ক্লিক করলে আপনার ফোনে ইনস্টলযোগ্য **`app-debug.apk`** ফাইলটি পেয়ে যাবেন!

---

## 📲 ফোনে ইনস্টল করার নিয়ম:
1. `app-debug.apk` ফাইলটি WhatsApp, Google Drive বা USB ক্যাবল দিয়ে আপনার অ্যান্ড্রয়েড ফোনে নিন।
2. ফাইলটিতে ট্যাপ করে **Install** দিন।
3. ক্যামেরা ও মাইক্রোফোন পারমিশন এলাউ (Allow) করুন।
4. এখন আপনার ফোনে সরাসরি ফুলস্ক্রিন রিয়েল অ্যাপ হিসেবে Y-Chat চলবে!
