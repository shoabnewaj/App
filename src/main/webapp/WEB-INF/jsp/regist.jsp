<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Registration | Y-Chat</title>
    <link rel="icon" type="image/png" href="<%=request.getContextPath()%>/icons/icon-192.png">
    
    <!-- Tailwind CSS & FontAwesome -->
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;800&display=swap" rel="stylesheet">

    <style>
        body {
            background: linear-gradient(-45deg, #ee7752, #e73c7e, #23a6d5, #23d5ab);
            background-size: 400% 400%;
            animation: gradient 15s ease infinite;
            font-family: 'Outfit', sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            padding: 30px 0;
        }

        @keyframes gradient {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        .glass-card {
            background: rgba(255, 255, 255, 0.75) !important;
            backdrop-filter: blur(20px) !important;
            border: 1px solid rgba(255, 255, 255, 0.4) !important;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15) !important;
        }

        .custom-file-upload {
            border: 2px dashed #1877f2;
            background: rgba(24, 119, 242, 0.05);
            transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
        }

        .custom-file-upload:hover {
            background: rgba(24, 119, 242, 0.12);
            border-color: #166fe5;
            transform: scale(1.02);
        }
    </style>
</head>
<body>

<div class="flex flex-col md:flex-row items-center justify-center gap-12 max-w-[960px] w-[95%] p-4">
    <!-- Left Section -->
    <div class="text-white text-center md:text-left md:max-w-[400px]">
        <h1 class="text-6xl font-extrabold tracking-tight mb-4 drop-shadow-md">Y-Chat</h1>
        <p class="text-xl font-medium opacity-90 leading-relaxed drop-shadow-sm">Create your account and start sharing with your new friends! 🚀</p>
    </div>

    <!-- Right Section (Card) -->
    <div class="glass-card w-full max-w-[460px] p-8 rounded-3xl relative overflow-hidden">
        <!-- Glow Ornaments -->
        <div class="absolute -top-10 -right-10 w-24 h-24 bg-pink-300 rounded-full blur-2xl opacity-40"></div>
        <div class="absolute -bottom-10 -left-10 w-24 h-24 bg-blue-300 rounded-full blur-2xl opacity-40"></div>

        <h2 class="text-2xl font-bold text-gray-800 text-center mb-6 relative z-10">Sign Up</h2>

        <form action="UsersRegistServlet" method="post" enctype="multipart/form-data" class="space-y-4 relative z-10">
            <div>
                <input type="text" name="name" placeholder="Your Name" value="${usersBeans.name}" required
                       class="w-full px-4 py-3 rounded-xl border border-gray-300/80 outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500 bg-white/70 transition-all text-sm">
                <div class="text-red-500 text-xs font-semibold mt-1 pl-1">${errorMsg_name}</div>
            </div>

            <div>
                <input type="email" name="email" placeholder="Email address" value="${usersBeans.email}" required
                       class="w-full px-4 py-3 rounded-xl border border-gray-300/80 outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500 bg-white/70 transition-all text-sm">
            </div>

            <div>
                <input type="password" name="pass" placeholder="Password (4-12 characters)" required
                       class="w-full px-4 py-3 rounded-xl border border-gray-300/80 outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500 bg-white/70 transition-all text-sm">
                <div class="text-red-500 text-xs font-semibold mt-1 pl-1">${errorMsg_pass}</div>
            </div>

            <!-- Country & City Grid -->
            <div class="grid grid-cols-2 gap-3">
                <div>
                    <label class="text-xs font-bold text-gray-600 block mb-1">Country</label>
                    <div class="relative">
                        <i class="fa fa-earth-americas absolute left-3 top-1/2 -translate-y-1/2 text-gray-400 text-xs"></i>
                        <input type="text" name="country" placeholder="e.g. Bangladesh" required
                               class="w-full pl-8 pr-3 py-2.5 rounded-xl border border-gray-300/80 outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500 bg-white/70 transition-all text-xs">
                    </div>
                </div>
                <div>
                    <label class="text-xs font-bold text-gray-600 block mb-1">City</label>
                    <div class="relative">
                        <i class="fa fa-city absolute left-3 top-1/2 -translate-y-1/2 text-gray-400 text-xs"></i>
                        <input type="text" name="city" placeholder="e.g. Dhaka" required
                               class="w-full pl-8 pr-3 py-2.5 rounded-xl border border-gray-300/80 outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500 bg-white/70 transition-all text-xs">
                    </div>
                </div>
            </div>

            <!-- Gender (Male / Female / Another) -->
            <div>
                <label class="text-xs font-bold text-gray-600 block mb-1">Gender</label>
                <div class="grid grid-cols-3 gap-2">
                    <label class="flex items-center justify-center gap-1.5 p-2 rounded-xl border border-gray-300/80 bg-white/70 cursor-pointer hover:border-blue-500 transition-all text-xs font-bold text-gray-700 select-none">
                        <input type="radio" name="gender" value="male" required class="accent-blue-600">
                        <span>Male</span>
                    </label>
                    <label class="flex items-center justify-center gap-1.5 p-2 rounded-xl border border-gray-300/80 bg-white/70 cursor-pointer hover:border-pink-500 transition-all text-xs font-bold text-gray-700 select-none">
                        <input type="radio" name="gender" value="female" required class="accent-pink-600">
                        <span>Female</span>
                    </label>
                    <label class="flex items-center justify-center gap-1.5 p-2 rounded-xl border border-gray-300/80 bg-white/70 cursor-pointer hover:border-purple-500 transition-all text-xs font-bold text-gray-700 select-none">
                        <input type="radio" name="gender" value="another" required class="accent-purple-600">
                        <span>Another</span>
                    </label>
                </div>
            </div>

            <!-- Birthday -->
            <div>
                <label class="text-xs font-bold text-gray-600 block mb-1">Birthday</label>
                <div class="relative">
                    <i class="fa fa-cake-candles absolute left-3 top-1/2 -translate-y-1/2 text-gray-400 text-xs"></i>
                    <input type="date" name="birthday" required
                           class="w-full pl-8 pr-3 py-2.5 rounded-xl border border-gray-300/80 outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500 bg-white/70 transition-all text-xs text-gray-700">
                </div>
            </div>

            <!-- Beautiful File Upload Input -->
            <div class="space-y-2">
                <label class="text-xs font-bold text-gray-600 uppercase tracking-wider block">Profile Picture (Optional)</label>
                
                <label for="profile_pic_input" class="custom-file-upload flex flex-col items-center justify-center py-5 px-4 rounded-2xl cursor-pointer text-blue-600 select-none">
                    <div id="upload-icon-container" class="flex flex-col items-center gap-2">
                        <i class="fa fa-camera text-2xl animate-bounce"></i>
                        <span class="text-xs font-bold">Choose a Profile Photo</span>
                    </div>
                    
                    <!-- Preview Container -->
                    <div id="preview-container" class="hidden flex-col items-center gap-2">
                        <img id="profile-pic-preview" src="#" alt="Preview" class="w-16 h-16 rounded-full object-cover border-2 border-blue-500 shadow-md">
                        <span id="file-name-text" class="text-xs text-gray-600 font-semibold truncate max-w-[200px]"></span>
                        <span class="text-[10px] text-blue-600 font-bold underline">Change Photo</span>
                    </div>
                </label>
                <input type="file" id="profile_pic_input" name="profile_pic" accept="image/*" onchange="previewProfilePic(this)" class="hidden">
            </div>

            <div class="text-red-500 text-xs font-semibold text-center">${errorMsg}</div>

            <!-- Privacy Policy & Terms Agreement Checkbox -->
            <div class="flex items-start gap-2 pt-1 text-left">
                <input type="checkbox" id="agree_terms" name="agree_terms" required
                       class="mt-1 w-4 h-4 rounded border-gray-300 text-blue-600 focus:ring-blue-500 cursor-pointer accent-blue-600">
                <label for="agree_terms" class="text-xs text-gray-700 cursor-pointer select-none leading-relaxed">
                    I agree to the 
                    <button type="button" onclick="openPolicyModal('privacy')" class="text-blue-600 font-bold hover:underline inline p-0 m-0 bg-transparent border-none cursor-pointer">Privacy Policy</button> 
                    and 
                    <button type="button" onclick="openPolicyModal('terms')" class="text-blue-600 font-bold hover:underline inline p-0 m-0 bg-transparent border-none cursor-pointer">Terms of Service</button>
                </label>
            </div>

            <button type="submit" class="w-full bg-gradient-to-r from-green-500 to-green-600 hover:from-green-600 hover:to-green-700 text-white font-bold py-3.5 rounded-2xl shadow-md hover:shadow-lg active:scale-95 transition-all duration-150 text-sm">
                Create Account
            </button>
        </form>

        <div class="w-full h-[1px] bg-gray-200/60 my-5 relative z-10"></div>

        <div class="flex items-center justify-between text-xs font-semibold text-gray-600 relative z-10">
            <a href="UsersLoginServlet" class="text-blue-600 hover:text-blue-700 hover:underline transition-colors">
                竊・Back to Login
            </a>
            <a href="PolicyServlet" target="_blank" class="text-gray-500 hover:text-blue-600 hover:underline transition-colors flex items-center gap-1.5">
                <i class="fa fa-shield-halved text-xs text-blue-500"></i> Privacy &amp; Policy
            </a>
        </div>
    </div>
</div>

<!-- Privacy Policy & Terms Modal -->
<div id="policyModal" class="fixed inset-0 z-50 bg-black/50 backdrop-blur-sm hidden items-center justify-center p-4">
    <div class="bg-white/95 backdrop-blur-md w-full max-w-lg rounded-3xl shadow-2xl border border-white/60 p-6 flex flex-col max-h-[85vh] relative">
        <!-- Close Button -->
        <button type="button" onclick="closePolicyModal()" class="absolute top-4 right-4 w-8 h-8 rounded-full bg-gray-100 hover:bg-gray-200 text-gray-500 hover:text-gray-800 flex items-center justify-center transition-colors">
            <i class="fa fa-times"></i>
        </button>

        <!-- Header -->
        <div class="flex items-center gap-3 mb-4">
            <div class="w-10 h-10 rounded-2xl bg-blue-50 text-blue-600 flex items-center justify-center text-lg">
                <i class="fa fa-shield-halved"></i>
            </div>
            <div>
                <h3 class="text-lg font-bold text-gray-800">Policy &amp; Terms</h3>
                <p class="text-xs text-gray-500">Y-ChatApp Community Guidelines</p>
            </div>
        </div>

        <!-- Tabs -->
        <div class="flex gap-2 p-1 bg-gray-100/80 rounded-2xl mb-4 text-xs font-bold">
            <button type="button" id="modalPrivacyTabBtn" onclick="switchModalTab('privacy')"
                    class="flex-1 py-2 px-3 rounded-xl transition-all bg-white text-blue-600 shadow-sm">
                <i class="fa fa-lock mr-1"></i> Privacy Policy
            </button>
            <button type="button" id="modalTermsTabBtn" onclick="switchModalTab('terms')"
                    class="flex-1 py-2 px-3 rounded-xl transition-all text-gray-500 hover:text-gray-800">
                <i class="fa fa-file-contract mr-1"></i> Terms of Service
            </button>
        </div>

        <!-- Scrollable Content -->
        <div class="overflow-y-auto pr-2 space-y-4 text-xs text-gray-600 flex-1 max-h-[45vh] leading-relaxed">
            <!-- Privacy Tab Content -->
            <div id="modalPrivacyContent" class="space-y-3">
                <div class="p-3 bg-blue-50/50 rounded-xl border border-blue-100/50">
                    <h4 class="font-bold text-gray-800 text-sm mb-1">Privacy Policy / 爬ｪ爰財ｦｰ爬ｾ爬・ｦｭ爰・ｦｸ爬ｿ 爬ｨ爰爬､爬ｿ</h4>
                    <p class="text-gray-600">At Y-ChatApp, we prioritize your privacy. This policy outlines how we collect, use, and safeguard your data.</p>
                </div>
                <div>
                    <h5 class="font-bold text-gray-800">1. Information Collection / 爬､爬･爰財ｦｯ 爬ｸ爬もｦ伶ｧ財ｦｰ爬ｹ</h5>
                    <p>We collect essential account details such as your name, email address, and profile picture to provide a personalized user profile and chat experience.</p>
                </div>
                <div>
                    <h5 class="font-bold text-gray-800">2. Real-Time Communication / 爬ｲ爬ｾ爬・ｦｭ 爬壟ｧ財ｦｯ爬ｾ爬・爬｡爰・ｦ游ｦｾ</h5>
                    <p>All message data and WebRTC connection metadata are used solely to establish real-time messaging, video calls, and notification delivery via secure WebSocket channels.</p>
                </div>
                <div>
                    <h5 class="font-bold text-gray-800">3. Data Protection / 爬､爬･爰財ｦｯ 爬ｸ爰≒ｦｰ爬歩ｧ財ｦｷ爬ｾ</h5>
                    <p>Your passwords are encrypted using industry-standard hashing algorithms (SHA-256 / BCrypt). We never sell or share your personal data with third-party advertisers.</p>
                </div>
            </div>

            <!-- Terms Tab Content -->
            <div id="modalTermsContent" class="space-y-3 hidden">
                <div class="p-3 bg-indigo-50/50 rounded-xl border border-indigo-100/50">
                    <h4 class="font-bold text-gray-800 text-sm mb-1">Terms of Service / 爬ｬ爰財ｦｯ爬ｬ爬ｹ爬ｾ爬ｰ爰・ｦｰ 爬ｶ爬ｰ爰財ｦ､爬ｾ爬ｬ爬ｲ爰</h4>
                    <p class="text-gray-600">By creating an account on Y-ChatApp, you agree to comply with our community standards and conditions.</p>
                </div>
                <div>
                    <h5 class="font-bold text-gray-800">1. Acceptable Behavior / 爬伶ｧ財ｦｰ爬ｹ爬｣爬ｯ爰金ｦ伶ｧ財ｦｯ 爬・ｦ壟ｦｰ爬｣</h5>
                    <p>Users must not engage in abusive behavior, harassment, hate speech, spamming, or uploading malicious code to the service.</p>
                </div>
                <div>
                    <h5 class="font-bold text-gray-800">2. Account Termination / 爬・ｧ財ｦｯ爬ｾ爬歩ｦｾ爬霞ｦｨ爰財ｦ・爬ｬ爬ｾ爬､爬ｿ爬ｲ爬歩ｦｰ爬｣</h5>
                    <p>We reserve the right to suspend or permanently remove accounts that violate community rules or perform harmful activities.</p>
                </div>
                <div>
                    <h5 class="font-bold text-gray-800">3. Disclaimer of Warranties / 爬ｦ爬ｾ爰游ｦｮ爰≒ｦ歩ｧ財ｦ､爬ｿ</h5>
                    <p>Y-ChatApp is provided "as is" and "as available". We continuously maintain uptime and security for seamless communication.</p>
                </div>
            </div>
        </div>

        <!-- Modal Footer -->
        <div class="mt-4 pt-3 border-t border-gray-100 flex items-center justify-between gap-3">
            <a href="PolicyServlet" target="_blank" class="text-xs text-blue-600 hover:underline font-semibold flex items-center gap-1">
                Full Page <i class="fa fa-arrow-up-right-from-square text-[10px]"></i>
            </a>
            <button type="button" onclick="acceptPolicyAndClose()" class="bg-gradient-to-r from-blue-600 to-indigo-600 hover:from-blue-700 hover:to-indigo-700 text-white text-xs font-bold py-2.5 px-5 rounded-xl shadow-md transition-all active:scale-95">
                I Agree &amp; Accept
            </button>
        </div>
    </div>
</div>

<script>
    function previewProfilePic(input) {
        const iconContainer = document.getElementById('upload-icon-container');
        const previewContainer = document.getElementById('preview-container');
        const previewImage = document.getElementById('profile-pic-preview');
        const fileNameText = document.getElementById('file-name-text');
        
        if (input.files && input.files[0]) {
            const reader = new FileReader();
            
            reader.onload = function(e) {
                previewImage.src = e.target.result;
                fileNameText.textContent = input.files[0].name;
                iconContainer.classList.add('hidden');
                previewContainer.classList.remove('hidden');
                previewContainer.classList.add('flex');
            }
            
            reader.readAsDataURL(input.files[0]);
        } else {
            iconContainer.classList.remove('hidden');
            previewContainer.classList.add('hidden');
            previewContainer.classList.remove('flex');
        }
    }

    function openPolicyModal(tab) {
        const modal = document.getElementById('policyModal');
        modal.classList.remove('hidden');
        modal.classList.add('flex');
        switchModalTab(tab || 'privacy');
    }

    function closePolicyModal() {
        const modal = document.getElementById('policyModal');
        modal.classList.add('hidden');
        modal.classList.remove('flex');
    }

    function switchModalTab(tab) {
        const privacyBtn = document.getElementById('modalPrivacyTabBtn');
        const termsBtn = document.getElementById('modalTermsTabBtn');
        const privacyContent = document.getElementById('modalPrivacyContent');
        const termsContent = document.getElementById('modalTermsContent');

        if (tab === 'privacy') {
            privacyContent.classList.remove('hidden');
            termsContent.classList.add('hidden');
            privacyBtn.className = "flex-1 py-2 px-3 rounded-xl transition-all bg-white text-blue-600 shadow-sm";
            termsBtn.className = "flex-1 py-2 px-3 rounded-xl transition-all text-gray-500 hover:text-gray-800";
        } else {
            privacyContent.classList.add('hidden');
            termsContent.classList.remove('hidden');
            privacyBtn.className = "flex-1 py-2 px-3 rounded-xl transition-all text-gray-500 hover:text-gray-800";
            termsBtn.className = "flex-1 py-2 px-3 rounded-xl transition-all bg-white text-blue-600 shadow-sm";
        }
    }

    function acceptPolicyAndClose() {
        const agreeCheckbox = document.getElementById('agree_terms');
        if (agreeCheckbox) {
            agreeCheckbox.checked = true;
        }
        closePolicyModal();
    }

    window.addEventListener('click', function(e) {
        const modal = document.getElementById('policyModal');
        if (e.target === modal) {
            closePolicyModal();
        }
    });
</script>
<script src="js/theme.js"></script>
</body>
</html>