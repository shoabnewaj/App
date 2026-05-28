<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Privacy Policy & Terms of Service | Y-ChatApp</title>
    <link rel="icon" type="image/png" href="<%=request.getContextPath()%>/icons/icon-192.png">
    
    <!-- Tailwind CSS & FontAwesome -->
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background: linear-gradient(135deg, #0f172a 0%, #1e1b4b 50%, #0f172a 100%);
            color: #f8fafc;
            min-height: 100vh;
        }

        .glass-panel {
            background: rgba(30, 41, 59, 0.45);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.08);
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.3);
        }

        .active-tab {
            background: linear-gradient(135deg, #3b82f6 0%, #6366f1 100%);
            box-shadow: 0 4px 15px rgba(99, 102, 241, 0.4);
            color: #ffffff !important;
        }

        .tab-btn {
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .tab-content {
            display: none;
            animation: fadeIn 0.5s ease-out forwards;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body class="flex flex-col items-center py-12 px-4 sm:px-6 lg:px-8">

    <div class="max-w-4xl w-full">
        <!-- Logo & Header -->
        <div class="text-center mb-8">
            <div class="inline-flex items-center gap-3 mb-2">
                <img src="<%=request.getContextPath()%>/icons/icon-192.png" width="48" height="48" class="animate-pulse">
                <span class="text-3xl font-extrabold tracking-tight text-white">Y-ChatApp</span>
            </div>
            <p class="text-slate-400 text-sm">Please read our Privacy Policy and Terms of Service carefully.</p>
        </div>

        <!-- Glass Panel -->
        <div class="glass-panel rounded-[2rem] overflow-hidden p-8">
            <!-- Tabs -->
            <div class="flex gap-4 border-b border-white/10 pb-6 mb-6">
                <button onclick="switchTab('privacy-tab', this)" class="tab-btn active-tab px-6 py-2.5 rounded-2xl font-bold text-sm text-slate-400 hover:text-white cursor-pointer">
                    <i class="fa fa-shield-halved mr-2"></i> Privacy Policy
                </button>
                <button onclick="switchTab('terms-tab', this)" class="tab-btn px-6 py-2.5 rounded-2xl font-bold text-sm text-slate-400 hover:text-white cursor-pointer">
                    <i class="fa fa-file-contract mr-2"></i> Terms of Service
                </button>
            </div>

            <!-- Tab: Privacy Policy -->
            <div id="privacy-tab" class="tab-content" style="display: block;">
                <div class="space-y-6 text-sm text-slate-300 leading-relaxed">
                    <h2 class="text-xl font-bold text-white border-b border-white/5 pb-2">Privacy Policy</h2>
                    <p>At Y-ChatApp, we prioritize your privacy. This policy outlines how we collect, use, and safeguard your data.</p>
                    
                    <section class="space-y-2">
                        <h3 class="text-base font-bold text-white">1. Information Collection / তথ্য সংগ্রহ</h3>
                        <p>We collect essential account details such as your email address, profile picture, cover image, and biography to provide a fully personalized user profile page and chat interface.</p>
                    </section>

                    <section class="space-y-2">
                        <h3 class="text-base font-bold text-white">2. Real-Time Communication Data / লাইভ চ্যাট ডেটা</h3>
                        <p>All message data and WebRTC connection metadata are used solely to establish live video streams, real-time messaging, and notification delivery via WebSocket channels.</p>
                    </section>

                    <section class="space-y-2">
                        <h3 class="text-base font-bold text-white">3. Data Protection / তথ্য সুরক্ষা</h3>
                        <p>Your passwords are securely encrypted using state-of-the-art hashing algorithms. We do not sell or share your personal profile data with third-party advertising companies.</p>
                    </section>
                </div>
            </div>

            <!-- Tab: Terms of Service -->
            <div id="terms-tab" class="tab-content">
                <div class="space-y-6 text-sm text-slate-300 leading-relaxed">
                    <h2 class="text-xl font-bold text-white border-b border-white/5 pb-2">Terms of Service</h2>
                    <p>Welcome to Y-ChatApp. By using our platform, you agree to comply with the following terms and guidelines.</p>

                    <section class="space-y-2">
                        <h3 class="text-base font-bold text-white">1. Acceptable Behavior / গ্রহণযোগ্য আচরণ</h3>
                        <p>Users must not engage in abusive behavior, harassment, copyright infringement, or upload malicious code to the application servers.</p>
                    </section>

                    <section class="space-y-2">
                        <h3 class="text-base font-bold text-white">2. Account Termination / অ্যাকাউন্ট বাতিলকরণ</h3>
                        <p>We reserve the right to suspend, disable, or permanently delete accounts that violate our community guidelines, spread harassment, or perform illegal operations inside the application.</p>
                    </section>

                    <section class="space-y-2">
                        <h3 class="text-base font-bold text-white">3. Disclaimer of Warranties / দায়মুক্তি</h3>
                        <p>Y-ChatApp is provided "as is" and "as available". While we utilize secure SSL layers and WebRTC protocols, we do not warrant that the service will be entirely uninterrupted, error-free, or free from server latency.</p>
                    </section>
                </div>
            </div>
        </div>

        <!-- Footer Back Link -->
        <div class="text-center mt-8">
            <a href="javascript:window.history.back();" class="inline-flex items-center gap-2 text-sm font-bold text-slate-400 hover:text-white transition-colors">
                <i class="fa fa-arrow-left"></i> Go Back
            </a>
        </div>
    </div>

    <script>
        function switchTab(tabId, btn) {
            // Hide all tab contents
            const contents = document.querySelectorAll('.tab-content');
            contents.forEach(el => el.style.display = 'none');

            // Show selected tab content
            document.getElementById(tabId).style.display = 'block';

            // Reset tab button states
            const buttons = document.querySelectorAll('.tab-btn');
            buttons.forEach(el => el.classList.remove('active-tab'));

            // Set current active button
            btn.classList.add('active-tab');
        }
    </script>
</body>
</html>
