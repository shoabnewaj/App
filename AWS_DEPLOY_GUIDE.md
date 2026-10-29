# ☁️ Amazon AWS-এ Y-ChatApp লাইভ করার সম্পূর্ণ গাইড (Step-by-Step)

আপনার **Y-ChatApp** (Java Servlet, JSP, WebSocket, WebRTC ও MySQL ডাটাবেজ) অ্যাপ্লিকেশনটি **Amazon Web Services (AWS)** ক্লাউডে লাইভ করার জন্য সবচেয়ে সহজ, প্রফেশনাল এবং সাশ্রয়ী উপায় হলো **AWS EC2 (Elastic Compute Cloud)** ব্যবহার করা।

AWS-এর **Free Tier** সুবিধার আওতায় আপনি টানা **১২ মাস সম্পূর্ণ ফ্রিতে** (৭৫০ ঘণ্টা/প্রতি মাসে) সার্ভার চালাতে পারবেন।

---

## 📋 সংক্ষেপে কাজের ধাপগুলো:
1. **AWS EC2 Instance তৈরি করা** (Ubuntu 24.04 বা 22.04 LTS)।
2. **Security Group-এ পোর্ট ওপেন করা** (Port 80, 8080, 443 এবং 22)।
3. **সার্ভারে লগইন করা** (AWS ব্রাউজার কনসোল বা SSH দিয়ে)।
4. **প্রোজেক্ট ফাইল আপলোড বা Git Clone করা**।
5. **এক ক্লিকে `bash aws-deploy.sh` কমান্ড চালানো**!

---

## 🛠️ বিস্তারিত ধাপসমূহ:

### ধাপ ১: AWS EC2 Instance তৈরি করুন
1. [AWS Management Console](https://aws.amazon.com/console/)-এ আপনার অ্যাকাউন্টে লগইন করুন।
2. সার্চ বারে লিখুন **EC2** এবং EC2 ড্যাশবোর্ডে প্রবেশ করুন।
3. **Launch Instance** বাটনে ক্লিক করুন।
4. কনফিগারেশন এভাবে সিলেক্ট করুন:
   - **Name**: `ychat-production-server`
   - **Application and OS Images (Amazon Machine Image)**: `Ubuntu` (Ubuntu Server 24.04 LTS অথবা 22.04 LTS, Free tier eligible).
   - **Instance type**: `t2.micro` (বা `t3.micro`) — Free tier eligible.
   - **Key pair (login)**: **Create new key pair**-এ ক্লিক করে একটি নাম দিন (যেমন: `ychat-key`), `.pem` সিলেক্ট করে ডাউনলোড করে আপনার কম্পিউটারে নিরাপদে রাখুন।
   - **Network settings**:
     - ✅ Allow SSH traffic from (Anywhere `0.0.0.0/0` বা My IP)
     - ✅ **Allow HTTP traffic from the internet**
     - ✅ **Allow HTTPS traffic from the internet**
   - **Configure storage**: `8 GiB` বা `15 GiB` (gp3/gp2 - Free tier-এ 30GB পর্যন্ত ফ্রি)।
5. নিচে **Launch Instance** বাটনে ক্লিক করুন। ২ মিনিটের মধ্যে আপনার সার্ভার রানিং হয়ে যাবে।

---

### ধাপ ২: Security Group-এ পোর্ট ৮0৮0 যুক্ত করা
1. EC2 ড্যাশবোর্ড থেকে বাম পাশের মেনু থেকে **Security Groups**-এ যান।
2. আপনার তৈরি করা instance-এর Security Group টি সিলেক্ট করুন এবং **Edit inbound rules**-এ ক্লিক করুন।
3. **Add rule**-এ ক্লিক করুন:
   - **Type**: `Custom TCP`
   - **Port range**: `8080`
   - **Source**: `Anywhere-IPv4` (`0.0.0.0/0`)
4. **Save rules** বাটনে ক্লিক করুন।

> 📌 **কেন?** যাতে যে কেউ আপনার পাবলিক আইপিতে `http://<YOUR-EC2-IP>` বা `http://<YOUR-EC2-IP>:8080` দিয়ে সরাসরি সাইটে ঢুকতে পারে।

---

### ধাপ ৩: সার্ভারে লগইন করুন
সবচেয়ে সহজ উপায় হলো **AWS ব্রাউজার কানেক্ট**:
1. EC2 Instances লিস্টে গিয়ে আপনার instance-টির পাশে টিক দিয়ে উপরে **Connect** বাটনে ক্লিক করুন।
2. **EC2 Instance Connect** ট্যাবে থাকা অবস্থায় নিচে সরাসরি **Connect** বাটনে ক্লিক করুন।
3. সাথে সাথে আপনার ব্রাউজারেই একটি ব্ল্যাক টার্মিনাল/কনসোল ওপেন হয়ে যাবে!

*(বিকল্পভাবে, আপনি আপনার পিসির PowerShell থেকে `ssh -i "ychat-key.pem" ubuntu@<YOUR-EC2-PUBLIC-IP>` দিয়েও ঢুকতে পারেন)*

---

### ধাপ ৪: প্রোজেক্ট কোড সার্ভারে নেওয়া
ব্রাউজারের টার্মিনালে কোড নেওয়ার ২টি সহজ উপায় আছে:

#### উপায় ক: GitHub-এর মাধ্যমে (সবচেয়ে সেরা ও দ্রুত)
আপনার বর্তমান প্রোজেক্ট যদি GitHub-এ আপলোড করা থাকে:
```bash
git clone https://github.com/<আপনার-ইউজারনেম>/ychatApp.git
cd ychatApp
```

#### উপায় খ: সরাসরি তৈরি করা বা কোড আনা
যদি এখনো GitHub না থাকে, আপনার পিসিতে টার্মিনাল থেকে ফাইলগুলো `scp` দিয়ে পাঠাতে পারেন, অথবা গিটহাবে পুশ করে `git clone` করে নিতে পারেন।

---

### ধাপ ৫: অটোমেটেড ডিপ্লয়মেন্ট রান করা (ম্যাজিক কমান্ড)
সার্ভারে `ychatApp` ফোল্ডারের ভেতর ঢুকে মাত্র এই কমান্ডটি দিন:

```bash
chmod +x aws-deploy.sh
./aws-deploy.sh
```

### এই স্ক্রিপ্টটি স্বয়ংক্রিয়ভাবে যা যা করবে:
1. তড়িৎ গতিতে **2GB Swap Memory** তৈরি করবে (যাতে AWS Free tier t2.micro মেমোরি ক্র্যাশ না করে)।
2. **Docker** এবং **Docker Compose** ইনস্টল করবে।
3. **MySQL 8** ডাটাবেজ কনটেইনার চালু করে আপনার `schema_production.sql` ফাইলের সব টেবিল ইমপোর্ট করে দেবে।
4. **Tomcat 10 / Jakarta EE** কনটেইনার বিল্ড করে Y-ChatApp চালু করে দেবে।
5. শেষে আপনার লাইভ ওয়েবসাইটের **পাবলিক আইপি লিঙ্ক** স্ক্রিনে প্রিন্ট করে দেবে!

---

## 🌐 আপনার সাইট ভিজিট করুন!
স্ক্রিপ্ট শেষ হলে আপনার ব্রাউজারে লিখুন:
```text
http://<YOUR-EC2-PUBLIC-IP>
```
অথবা:
```text
http://<YOUR-EC2-PUBLIC-IP>:8080
```
🎉 **আপনার সম্পূর্ণ Y-ChatApp এখন ইন্টারনেটে সারা বিশ্বের জন্য লাইভ!**

---

## 🔧 দরকারি কিছু কমান্ড (সার্ভার ম্যানেজমেন্ট):

- **লাইভ লগ দেখার জন্য:**
  ```bash
  sudo docker compose logs -f
  ```
- **সার্ভার বন্ধ করতে চাইলে:**
  ```bash
  sudo docker compose down
  ```
- **সার্ভার পুনরায় চালু করতে চাইলে:**
  ```bash
  sudo docker compose up -d
  ```

---

## 🔒 ডোমেইন এবং ফ্রি HTTPS (SSL) যুক্ত করার নিয়ম (ঐচ্ছিক):
আপনার যদি একটি কাস্টম ডোমেইন থাকে (যেমন: `mychatapp.com`):
1. ডোমেইন কন্ট্রোল প্যানেলে গিয়ে `A Record` হিসেবে আপনার EC2-এর **Elastic IP / Public IP** সেট করুন।
2. সার্ভারে Nginx এবং Let's Encrypt Certbot দিয়ে এক লাইনে সম্পূর্ণ ফ্রি SSL সেট করে নিতে পারবেন:
   ```bash
   sudo apt install -y certbot python3-certbot-nginx
   sudo certbot --nginx -d mychatapp.com
   ```
