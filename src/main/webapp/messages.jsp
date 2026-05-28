<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Messenger | Y-ChatApp</title>
    <link rel="icon" type="image/png" href="<%=request.getContextPath()%>/icons/icon-192.png">
    <link rel="manifest" href="<%=request.getContextPath()%>/manifest.json">
    <script>
        if ('serviceWorker' in navigator) {
            window.addEventListener('load', () => {
                navigator.serviceWorker.register('<%=request.getContextPath()%>/sw.js')
                    .then(reg => console.log('Service Worker registered', reg))
                    .catch(err => console.error('Service Worker registration failed', err));
            });
        }
    </script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', sans-serif; }
        body { background-color: #f0f2f5; display: flex; height: 100vh; overflow: hidden; }

        /* Sidebar Design */
        .sidebar { width: 360px; background: white; border-right: 1px solid #ddd; display: flex; flex-direction: column; }
        .sidebar-header { padding: 20px; background: purple; color: white; }
        
  
        
        body { 
            background: linear-gradient(-45deg, #ee7752, #e73c7e, #23a6d5, #23d5ab);
            background-size: 400% 400%;
            animation: gradient 15s ease infinite;
            font-family: 'Outfit', sans-serif; 
            display: flex; 
            height: 100vh; 
            overflow: hidden; 
            justify-content: center;
            align-items: center;
            padding: 16px;
        }

        /* Glassmorphism card utility */
        .glass-card {
            background: rgba(255, 255, 255, 0.45);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.35);
        }

















            if (camOff) {































            flex-direction: column;
            align-items: center;
            position: relative;
            animation: zoomInCall 0.4s cubic-bezier(0.16, 1, 0.3, 1);
            overflow: hidden;
            transition: all 0.4s ease;
        }

        .call-container.video-active {
            max-width: 640px;
            height: 480px;
            padding: 0;
        }

        @keyframes zoomInCall {
            from { transform: scale(0.9) translateY(20px); opacity: 0; }
            to { transform: scale(1) translateY(0); opacity: 1; }
        }

        .call-avatar {
            width: 130px; height: 130px;
            border-radius: 50%;
            background: linear-gradient(135deg, #a855f7, #c084fc);
            display: flex; align-items: center; justify-content: center;
            font-size: 54px; font-weight: bold;
            margin-bottom: 25px;
            box-shadow: 0 15px 35px rgba(168, 85, 247, 0.4);
            position: relative;
            z-index: 2;
        }

        .pulsing-rings {
            position: absolute;
            width: 130px; height: 130px;
            top: 50px;
            border-radius: 50%;
            border: 2px solid rgba(168, 85, 247, 0.5);
            animation: pulseRingCall 2s infinite cubic-bezier(0.25, 0, 0, 1);
            z-index: 1;
            pointer-events: none;
        }

        .pulsing-rings:nth-child(2) {
            animation-delay: 0.6s;
        }

        @keyframes pulseRingCall {
            0% { transform: scale(1); opacity: 1; }
            100% { transform: scale(2.5); opacity: 0; }
        }















            display: flex; align-items: center; justify-content: center;
            font-size: 26px; cursor: pointer; transition: all 0.25s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            border: none; outline: none; color: white;
            box-shadow: 0 8px 20px rgba(0,0,0,0.2);
        }

        .call-btn-decline { background: #ef4444; }
        .call-btn-decline:hover { background: #dc2626; transform: scale(1.15) rotate(-10deg); }

        .call-btn-accept { background: #10b981; }
        .call-btn-accept:hover { background: #059669; transform: scale(1.15) rotate(10deg); }

        .call-btn-mute { background: rgba(255,255,255,0.25); }
        .call-btn-mute:hover { background: rgba(255,255,255,0.4); transform: scale(1.12); }
        .call-btn-mute.active { background: #ef4444; box-shadow: 0 8px 20px rgba(239, 68, 68, 0.4); }

        .video-grid {
            position: absolute; top: 0; left: 0; width: 100%; height: 100%;
            display: none; border-radius: 32px; overflow: hidden; z-index: 10;
        }

        .remote-video-container {
            width: 100%; height: 100%; background: #0f0a19;
            display: flex; align-items: center; justify-content: center;
            position: relative;
        }

        .remote-video-container video {
            width: 100%; height: 100%; object-fit: cover;
        }

        .local-video-container {
            position: absolute; top: 25px; right: 25px;
            width: 110px; height: 150px; background: rgba(25, 20, 35, 0.8);
            border-radius: 16px; overflow: hidden; border: 2px solid rgba(255,255,255,0.8);
            box-shadow: 0 10px 25px rgba(0,0,0,0.5);


















            width: 5px; height: 100%; background: #c084fc;
            border-radius: 3px;
            animation: wavePulseCall 1.4s infinite ease-in-out;
            box-shadow: 0 0 10px rgba(192, 132, 252, 0.5);
        }
        .voice-wave-bar:nth-child(1) { animation-delay: 0.1s; height: 30%; }
        .voice-wave-bar:nth-child(2) { animation-delay: 0.3s; height: 60%; }
        .voice-wave-bar:nth-child(3) { animation-delay: 0.5s; height: 90%; }
        .voice-wave-bar:nth-child(4) { animation-delay: 0.2s; height: 50%; }
        .voice-wave-bar:nth-child(5) { animation-delay: 0.4s; height: 20%; }

        @keyframes wavePulseCall {
            0%, 100% { transform: scaleY(0.2); }
            50% { transform: scaleY(1); }
        }

        /* Mobile responsive styling */
        .mobile-back-btn { display: none; margin-right: 15px; font-size: 20px; color: purple; cursor: pointer; border: none; background: none; }

        @media (max-width: 768px) {
            .sidebar {
                width: 100%;
                display: flex;
                padding-bottom: 65px !important;
            }
            .main-chat {
                display: none;
                width: 100%;
                padding-bottom: 65px !important;
            }
            .mobile-back-btn {
                display: block;
            }

            body.chat-open .sidebar {
                display: none;
            }
            body.chat-open .main-chat {
                display: flex;
            }
        }
    </style>
</head>
<body>

    <div class="sidebar">
        <div class="sidebar-header">
            <h3>Chats</h3>
            <small>Logged in as: <b>${ub.name}</b></small>
        </div>

        <div class="search-container">
            <input type="text" id="userSearch" class="search-box" placeholder="Search friends..." onkeyup="filterUsers()">
        </div>
        
        <div id="friendListContainer">
            <p style="padding:20px; color:#999; text-align:center;">Connecting...</p>
        </div>

        <a href="UsersPostServlet" class="back-link">← Home</a>
    </div>

    <div class="main-chat">
        <div class="chat-header">
            <div style="display: flex; align-items: center;">
                <button class="mobile-back-btn" onclick="backToSidebar()"><i class="fa fa-arrow-left"></i></button>
                <div>
                    Chatting with: <span id="chattingWith">None</span>
                    <input type="hidden" id="targetFriendName" value="None">
                </div>
            </div>
            <div class="call-buttons" id="callButtons">
                <i class="fa-solid fa-phone" onclick="startVoiceCall()" title="Voice Call"></i>
                <i class="fa-solid fa-video" onclick="startVideoCall()" title="Video Call"></i>
            </div>
        </div>

        <div id="chatBox">
            <div style="text-align:center; color:#999; margin-top:150px;">Select a user to chat</div>
        </div>

        <div class="input-area">
            <input type="text" id="messageText" placeholder="Type a message..." onkeypress="if(event.key==='Enter') sendToFriend()">
            <button class="btn-send" onclick="sendToFriend()">Send</button>
        </div>
    </div>

    <!-- 📞 Calling System HTML Overlay -->
    <div id="callOverlay" class="call-overlay">
        <audio id="remoteAudio" autoplay></audio>
        <div class="call-container" id="callContainer">
            <!-- Pulsing Rings (Only during Calling/Ringing) -->
            <div id="callingRings" style="position: absolute; width: 130px; height: 130px; top: 50px; display: none; z-index: 1;">
                <div class="pulsing-rings"></div>
                <div class="pulsing-rings"></div>
            </div>

            <!-- Call Info Display -->
            <div id="callInfoBox" style="position: relative; z-index: 2;">
                <div class="call-avatar" id="callAvatar">Y</div>
                <h2 class="call-username" id="callUsername">Username</h2>
                <div class="call-status" id="callStatus">Calling...</div>
            </div>

            <!-- Voice Waves (Only active during voice call) -->
            <div class="voice-waves" id="voiceWaves" style="position: relative; z-index: 2;">
                <div class="voice-wave-bar"></div>
                <div class="voice-wave-bar"></div>
                <div 




















































                display: none !important;
            }
            body.chat-open .main-chat {
                display: flex !important;
            }
        }
    </style>
</head>
<body>

    <!-- Centralized App Panel Container -->
            left: 16px;
            width: 300px;
            height: 220px;
            border-radius: 20px;
            background: rgba(255, 255, 255, 0.7);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.6);
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
            display: flex;
            flex-direction: column;
            z-index: 100;
            overflow: hidden;
            animation: fadeInScaleEmoji 0.2s cubic-bezier(0.34, 1.56, 0.64, 1);
        }
        @keyframes fadeInScaleEmoji {
            from { opacity: 0; transform: scale(0.9) translateY(10px); }
            to { opacity: 1; transform: scale(1) translateY(0); }
        }
        .emoji-picker-panel.hidden {
                        <span class="text-[10px] text-gray-500 font-semibold">Logged in</span>
                    </div>
                </div>
            </div>

            <div class="search-container p-3 border-b border-white/15">
                <div class="relative flex items-center bg-white/40 rounded-2xl border border-white/50 focus-within:border-purple-500/50 focus-within:bg-white/60 transition-all duration-300 px-3.5 py-2">
                    <i class="fa fa-search text-gray-400 mr-2 text-xs"></i>
                    <input type="text" id="userSearch" class="bg-transparent outline-none w-full text-xs font-semibold text-gray-700 placeholder-gray-400" placeholder="Search friends..." onkeyup="filterUsers()">
                </div>
            </div>
            
            <div id="friendListContainer" class="custom-scrollbar">
                <p style="padding:20px; color:#999; text-align:center;">Connecting...</p>
            </div>

            <a href="UsersPostServlet" class="flex items-center justify-center gap-2 p-3.5 m-3 rounded-2xl bg-white/20 hover:bg-white/60 border border-white/30 text-purple-700 hover:text-purple-900 font-bold transition-all duration-300 text-xs shadow-sm hover:shadow-md">
                <i class="fa fa-house-chimney text-xs"></i> Back to Home Feed
            </a>
        </div>

        <div class="main-chat">
            <div class="chat-header glass-nav px-6 py-4 flex ite

























































                <div class="pulsing-rings"></div>
                <div class="pulsing-rings"></div>
            </div>

            <!-- Call Info Display -->
            <div id="callInfoBox" style="position: relative; z-index: 2;">
                <div class="call-avatar" id="callAvatar">Y</div>
                <h2 class="call-username" id="callUsername">Username</h2>
                <div class="call-status" id="callStatus">Calling...</div>
            </div>

            <!-- Voice Waves (Only active during voice call) -->
            <div class="voice-waves" id="voiceWaves" style="position: relative; z-index: 2;">
                <div class="voice-wave-bar"></div>
                <div class="voice-wave-bar"></div>
                <div class="voice-wave-bar"></div>
                <div class="voice-wave-bar"></div>
                <div class="voice-wave-bar"></div>
            </div>

            <!-- Call Action Controls (Accept/Decline) -->
            <div class="call-actions" id="callActions" style="position: relative; z-index: 2;">
                <button class="call-btn call-btn-decline" id="declineBtn" onclick="declineCall()"><i class="fa-solid fa-phone-slash"></i></button>
                <button class="call-btn call-btn-accept" id="acceptBtn" onclick="acceptCall()"><i class="fa-solid fa-phone"></i></button>
            </div>

            <!-- Video Session Grid -->
            <div class="video-grid" id="videoGrid">
                <div class="remote-video-container">
                    <video id="remoteVideo" autoplay playsinline muted></video>
                    <!-- Fallback simulated remote avatar/canvas if no feed -->
                    <div id="remoteAvatarFallback" style="display: none; position: absolute; font-size: 80px; font-weight: bold; color: rgba(255,255,255,0.2);">Remote</div>
                </div>
                <div class="local-video-container">
                    <video id="localVideo" autoplay playsinline muted></video>
                </div>
            </div>

            <!-- Active Call Controls (Visible for both Voice & Video) -->
            <div class="active-call-controls" id="activeCallControls" style="display: none;">
                <button class="call-btn call-btn-mute" id="muteMicBtn" onclick="toggleMuteMic()"><i class="fa-solid fa-microphone"></i></button>
                <button class="call-btn call-btn-mute" id="toggleCamBtn" onclick="toggleCamera()"><i class="fa-solid fa-video"></i></button>
                <button class="call-btn call-btn-decline" onclick="endCall()"><i class="fa-solid fa-phone-slash"></i></button>
            </div>
        </div>
    </div>

    <script>
        var socket;
        var myName = "${ub.name}";
        var contextPath = "${pageContext.request.contextPath}";

        window.onload = function() {
            var protocol = window.location.protocol === "https:" ? "wss://" : "ws://";
            var host = window.location.host;
            var wsUrl = protocol + host + contextPath + "/ws/user/" + encodeURIComponent(myName);
            socket = new WebSocket(wsUrl);

            socket.onopen = function(event) {
                console.log("WebSocket Connected successfully to: " + wsUrl);
            };

            socket.onerror = function(event) {
                console.error("WebSocket Error:", event);
                document.getElementById("friendListContainer").innerHTML = "<p style='text-align:center; padding:20px; color:red;'>WebSocket Connection Failed!</p>";
            };

            socket.onclose = function(event) {
                console.log("WebSocket Closed:", event);
                document.getElementById("friendListContainer").innerHTML = "<p style='text-align:center; padding:20px; color:red;'>WebSocket Disconnected</p>";
            };

            socket.onmessage = function(event) {
                var data = event.data;
                if (data.startsWith("ONLINE_USERS|")) {
                    updateFriendList(data.substring(13).split(","));
                } else if (data.startsWith("CHAT|")) {
                    var parts = data.split("|", 3);
       

            <!-- Call Info Display -->





























            }
        };

        // 🔥 SEARCH FILTER LOGIC
        function filterUsers() {
            var input = document.getElementById('userSearch').value.toLowerCase();
            var items = document.getElementsByClassName('friend-item');

            for (var i = 0; i < items.length; i++) {
                var name = items[i].getElementsByTagName('b')[0].innerText.toLowerCase();
                if (name.includes(input)) {
                    items[i].style.display = "flex";
                } else {
                    items[i].style.display = "none";
                }
            }
        }

        function updateFriendList(users) {
            var container = document.getElementById("friendListContainer");
            var usersSet = new Set(users.map(u => u.trim()).filter(u => u !== "" && u !== myName));
            
            if (window.targetToOpen && !usersSet.has(window.targetToOpen)) {
                usersSet.add(window.targetToOpen);
            }

            var html = "";
            usersSet.forEach(function(user) {
                html += `
                    <div class="friend-item" id="friend-item-\${user}" onclick="openChat('\${user}', this)">
                        <div class="avatar">\${user.charAt(0).toUpperCase()}<div class="online-dot"></div></div>
                        <div class="friend-info"><b>\${user}</b><br><small style="color































                    });
                }
            })
            .catch(err => {
                console.error("Error loading messages:", err);
                document.getElementById("chatBox").innerHTML = "<p style='text-align:center; padding-top:50px; color:red;'>Failed to load history</p>";
            });
        }

        function sendToFriend() {
            var friend = document.getElementById("targetFriendName").value;
            var msgInput = document.getElementById("messageText");
            if (friend !== "None" && msgInput.value.trim() !== "") {
                socket.send("CHAT|" + friend + "|" + msgInput.value);
                displayMessage(msgInput.value, 'sent');
                msgInput.value = "";
            }
        }

        function backToSidebar() {
            document.body.classList.remove('chat-open');
            document.querySelectorAll('.friend-item').forEach(i => i.classList.remove('active'));
            document.getElementById("targetFriendName").value = "None";
            document.getElementById("chattingWith").innerText = "None";
            document.getElementById("callButtons").classList.remove("active");
        }

        function displayMessage(msg, type) {
            var chatBox = document.getElementById("chatBox");
            var div = document.createElement("div");
            div.className = "msg " + type;
            div.innerText = msg;
            chatBox.appendChild(div);
            chatBox.scrollTop = chatBox.scrollHeight;
        }

        // ==========================================
        // 📞 PREMIUM CALLING & WEBRTC SIGNALING SYSTEM
        // ==========================================
        let audioCtx = null;
        let ringInterval = null;
        let toneOscillators = [];
        
        let peerConnection = null;
        let localStream = null;
        let currentCallFriend = null;
        let callType = null;
        let isCaller = false;
                <input type="text" id="messageText" placeholder="Type a message..." class="flex-1 bg-white/40 backdrop-blur-sm border border-white/50 rounded-full px-5 py-3 text-sm outline-none text-gray-700 placeholder-gray-400 focus:border-purple-500/50 focus:bg-white/60 transition-all font-medium" onkeypress="if(event.key==='Enter') sendToFriend()">
                <button class="w-10 h-10 rounded-full bg-gradient-to-r from-blue-600 via-indigo-500 to-purple-600 text-white flex items-center justify-






































            <div class="video-grid" id="videoGrid">
                <div class="remote-video-container">
                    <video id="remoteVideo" autoplay playsinline muted></video>
                    <!-- Fallback simulated remote avatar/canvas if no feed -->
                    <div id="remoteAvatarFallback" style="display: none; position: absolute; font-size: 80px; font-weight: bold; color: rgba(255,255,255,0.2);">Remote</div>
                </div>
                <div class="local-video-container">
                    <video id="localVideo" autoplay playsinline muted></video>
                </div>
            </div>
            document.getElementById("callStatus").innerText = "Connecting...";

            socket.send("CALL_ANSWER|" + currentCallFriend + "|" + JSON.stringify({ status: "accepted" }));

            startPeerConnection();
        }

        function handleCallAnswer(sender, answerData) {
            stopRingtone();
            if (callTimer) clearTimeout(callTimer);

            if (answerData.status === "accepted") {
                document.getElementById("callingRings").style.display = "none";
                document.getElementById("callStatus").innerText = "Connecting...";
                startPeerConnection();
            }
        }

        async function startPeerConnection() {
            playConnectedTone();
            
            let audioFallbackUsed = false;
            try {
                const constraints = {
                    audio: true,
                    video: callType === 'video'
                };
                
                try {
                    localStream = await navigator.mediaDevices.getUserMedia(constraints);
                } catch (mediaErr) {
                    console.warn("Primary media access failed:", mediaErr);
                    if (callType === 'video') {
                        // Fallback to audio-only
                        console.log("Attempting audio-only fallback...");
                        localStream = await navigator.mediaDevices.getUserMedia({ audio: true, video: false });
                        audioFallbackUsed = true;
                    } else {
                        throw mediaErr;
                    }
                }
                
                const localVideo = document.getElementById("localVideo");
                if (localVideo) {
                    localVideo.srcObject = localStream;
                }
                
                peerConnection = new RTCPeerConnection(rtcConfig);
                
                localStream.getTracks().forEach(track => {
                    peerConnection.addTrack(track, localStream);
                });
                
                peerConnection.ontrack = (event) => {
                    const remoteVideo = document.getElementById("remoteVideo");
                    const remoteAudio = document.getElementById("remoteAudio");
                    if (remoteVideo) remoteVideo.srcObject = event.streams[0];
                    if (remoteAudio) remoteAudio.srcObject = event.streams[0];
                    switchToActiveCallUI(audioFallbackUsed);
                };
                
                peerConnection.onicecandidate = (event) => {
                    if (event.candidate) {
                        socket.send("ICE_CANDIDATE|" + currentCallFriend + "|" + JSON.stringify(event.candidate));
                    }
                };
                
                if (isCaller) {
                    const offer = await peerConnection.createOffer();
                    await peerConnection.setLocalD
                    handleIceCandidate(parts[1], JSON.parse(parts[2]));
                } else if (data.startsWith("CALL_REJECT|")) {
                    var parts = data.split("|", 3);
                    handleCallReject(parts[1]);
                } else if (data.startsWith("CALL_END|")) {
                    var parts = data.split("|", 3);
                    handleCallEnd(parts[1]);
                } else if (data.startsWith("WEBRTC_ANSWER|")) {
                    var parts = data.split("|", 3);
                    handleWebRTCAnswer(parts[1], JSON.parse(parts[2]));
                }
            };

            // 🔥 Check for deep link
            const urlParams = new URLSearchParams(window.location.search);
            const targetUser = urlParams.get('userName');
            if (targetUser) {
                window.targetToOpen = targetUser;
            }
        };









            }
        };

        // 🔥 SEARCH FILTER LOGIC
        function filterUsers() {
            var input = document.getElementById('userSearch').value.toLowerCase();
            var items = document.getElementsByClassName('friend-item');

            for (var i = 0; i < items.length; i++) {
                var nameElement = items[i].querySelector('.friend-name');
                if (nameElement) {
                    var name = nameElement.innerText.toLowerCase();
                    if (name.includes(input)) {
                        items[i].style.display = "flex";
                    } else {
                        items[i].style.display = "none";
                        </div>
                        <div class="text-[10px] text-gray-400 font-bold self-start mt-1">Active</div>
                    </div>`;
            });
            container.innerHTML = html || "<p style='text-align:center; padding:20px; color:#999; font-weight: 600; font-size: 13px;'>No friends online</p>";
            
            if (window.targetToOpen) {
                let item = document.getElementById("friend-item-" + window.targetToOpen);
                if (item) openChat(window.targetToOpen, item);
                window.targetToOpen = null; // Reset
            }
            filterUsers();
        }

        function openChat(friend, element) {
            document.body.classList.add('chat-open');
            document.getElementById("chattingWith").innerText = friend;
            document.getElementById("targetFriendName").value = friend;
            document.getElementById("headerAvatar").innerText = friend.charAt(0).toUpperCase();
            document.getElementById("activeStatusText").innerHTML = `<span class="w-1.5 h-1.5 rounded-full bg-green-500"></span>Active`;
            document.getElementById("callButtons").classList.add("active");
            document.getElementById("chatBox").innerHTML = `
                <div class="flex-1 flex flex-col items-center justify-center p-6 text-center text-gray-500 my-auto">
                    <div class="w-8 h-8 border-4 border-purple-600 border-t-transparent rounded-full animate-spin mb-4"></div>
                    <span class="text-xs font-bold text-gray-500">Loading conversation...</span>
            // Ensure any online users that are not in database friends are also listed
            usersSet.forEach(user => {
                if (!friendsMap.has(user)) {
                    </div>`;
            });
            container.innerHTML = html || "<p style='text-align:center; padding:20px; color:#999; font-weight: 600; font-size: 13px;'>No friends online</p>";
            
            if (window.targetToOpen) {
                let item = document.getElementById("friend-item-" + window.targetToOpen);
                if (item) openChat(window.targetToOpen, item);
                window.targetToOpen = null; // Reset
            }
            filterUsers();
        }

        function openChat(friend, element) {
            document.body.classList.add('chat-open');
            document.getElementById("chattingWith").innerText = friend;
            document.getElementById("targetFriendName").value = friend;
            document.getElementById("headerAvatar").innerText = friend.charAt(0).toUpperCase();
            document.getElementById("activeStatusText").innerHTML = `<span class="w-1.5 h-1.5 rounded-full bg-green-500"></span>Active`;
            document.getElementById("callButtons").classList.add("active");
            document.getElementById("chatBox").innerHTML = `
                <div class="flex-1 flex flex-col items-center justify-center p-6 text-center text-gray-500 my-auto">
                    <div class="w-8 h-8 border-4 border-purple-600 border-t-transparent rounded-full animate-spin mb-4"></div>
                    <span class="text-xs font-bold text-gray-500">Loading conversation...</span>
                </div>`;
            document.querySelectorAll('.friend-item').forEach(i => i.classList.remove('active'));
            if(element) element.classList.add('active');

            fetch(`loadMessages?user1=\${encodeURIComponent(myName)}&user2=\${encodeURIComponent(friend)}`)
            .then(res => res.json())
            .then(data => {
                const chatBox = document.getElementById("chatBox");
                chatBox.innerHTML = "";
                if (data.length === 0) {
                    chatBox.innerHTML = `
                        <div class="flex-1 flex flex-col items-center justify-center p-6 text-center text-gray-500 my-auto">
                            <div class="w-16 h-16 rounded-full bg-indigo-500/10 flex items-center justify-center mb-4">
                                <i class="fa-regular fa-message text-indigo-600 text-xl animate-bounce" style="animation-duration: 2s;"></i>
                            </div>
                            <h4 class="font-extrabold text-gray-800 text-sm mb-1">No previous messages</h4>
                            <p class="text-[11px] text-gray-500">Send a message below to start your conversation.</p>
                        </div>`;
                } else {
                    data.forEach(m => {
                        displayMessage(m.message, m.sender === myName ? 'sent' : 'received');
                    });
                }
            document.getElementById("headerAvatar").innerText = "N";
            document.getElementById("activeStatusText").innerHTML = `<span class="w-1.5 h-1.5 rounded-full bg-gray-400"></span>Offline`;
            document.getElementById("callButtons").classList.remove("active");
            
            // Restore empty chat placeholder
            document.getElementById("chatBox").innerHTML = `
                <div id="emptyChatPlaceholder" class="flex-1 flex flex-col items-center justify-center p-6 text-center text-gray-500 my-auto">
                    <div class="w-20 h-20 rounded-3xl bg-gradient-to-tr from-purple-500/10 to-blue-500/10 flex items-center justify-center border border-white/30 shadow-inner mb-6 animate-bounce" style="animation-duration: 3s;">
                        <i class="fa-solid fa-comments text-3xl text-purple-600 animate-pulse"></i>
                    </div>
                    <h3 class="text-xl font-extrabold text-transparent bg-clip-text bg-gradient-to-r from-blue-600 via-indigo-500 to-purple-600 mb-2">Welcome to YchatApp Messenger</h3>
                    <p class="text-xs font-semibold text-gray-500 max-w-[280px]">Select any active friend from the sidebar list to start chatting with them in real-time!</p>
                </div>`;
        }

        function displayMessage(msg, type) {
            var chatBox = document.getElementById("chatBox");
            var div = document.createElement("div");
            div.className = "msg " + type;
            div.innerText = msg;
            chatBox.appendChild(div);
            chatBox.scrollTop = chatBox.scrollHeight;
        }

        // ==========================================
        // 📞 PREMIUM CALLING & WEBRTC SIGNALING SYSTEM
        // ==========================================
        let audioCtx = null;
        let ringInterval = null;
        let toneOscillators = [];
        
                <div class="flex-1 flex flex-col items-center justify-center p-6 text-center text-gray-500 my-auto">
                    <div class="w-8 h-8 border-4 border-purple-600 border-t-transparent rounded-full animate-spin mb-4"></div>
                    <span class="text-xs font-bold text-gray-500">Loading conversation...</span>
                </div>`;
            document.querySelectorAll('.friend-item').forEach(i => i.classList.remove('active'));
            if(element) element.classList.add('active');

            fetch(`loadMessages?user1=\${encodeURIComponent(myName)}&user2=\${encodeURIComponent(friend)}`)
            .then(res => res.json())
            .then(data => {
                const chatBox = document.getElementById("chatBox");
                chatBox.innerHTML = "";
                if (data.length === 0) {
                    chatBox.innerHTML = `
                        <div class="flex-1 flex flex-col items-center justify-center p-6 text-center text-gray-500 my-auto">
                            <div class="w-16 h-16 rounded-full bg-indigo-500/10 flex items-center justify-center mb-4">
                                <i class="fa-regular fa-message text-indigo-600 text-xl animate-bounce" style="animation-duration: 2s;"></i>
                            </div>
                            <h4 class="font-extrabold text-gray-800 text-sm mb-1">No previous messages</h4>
                            <p class="text-[11px] text-gray-500">Send a message below to start your conversation.</p>
                        </div>`;
                } else {
                    data.forEach(m => {
                        displayMessage(m.message, m.sender === myName ? 'sent' : 'received');
                    });
                }
            })
            .catch(err => {
                console.error("Error loading messages:", err);
                document.getElementById("chatBox").innerHTML = `
                    <div class="flex-1 flex flex-col items-center justify-center p-6 text-center text-red-500 my-auto">
                        <i class="fa fa-triangle-exclamation text-2xl text-red-500 mb-2"></i>
                        <span class="text-xs font-bold">Failed to load message history</span>
                    </div>`;
            });





















































                btn.classList.add("active");
                btn.innerHTML = '<i class="fa-solid fa-video-slash"></i>';
            } else {
                btn.classList.remove("active");
                btn.innerHTML = '<i class="fa-solid fa-video"></i>';
            }
        }
    </script>

    <!-- Mobile Bottom Navigation Bar (Visible only on mobile/tablet) -->
    <nav class="md:hidden fixed bottom-0 left-0 right-0 h-[65px] bg-white/80 backdrop-blur-md border-t border-gray-200 z-[9999] flex justify-around items-center px-4 rounded-t-3xl shadow-2xl">
        <a href="UsersPostServlet" class="flex flex-col items-center gap-1 text-gray-500 hover:text-blue-500 transition">
            <i class="fa fa-house text-xl"></i>
            <span class="text-[10px] font-bold">Home</span>
        </a>
        <a href="FriendServlet" class="flex flex-col items-center gap-1 text-gray-500 hover:text-blue-500 transition">
            <i class="fa fa-user-group text-xl"></i>
            <span class="text-[10px] font-bold">Friends</span>
        </a>
        <a href="messages.jsp" class="flex flex-col items-center gap-1 text-blue-500">
            <i class="fa-brands fa-facebook-messenger text-xl"></i>
            <span class="text-[10px] font-bold">Messenger</span>
        </a>
        <a href="UsersProfileServlet?userId=${sessionScope.userId}" class="flex flex-col items-center gap-1 text-gray-500 hover:text-blue-500 transition">
            <img src="img/${ub.profile_pic}" class="w-6 h-6 rounded-full border border-gray-300">
            <span class="text-[10px] font-bold">Profile</span>
        </a>
    </nav>

</body>
</html>
            <img src="img/${ub.profile_pic}" class="w-6 h-6 rounded-full border border-gray-300">
            <span class="text-[10px] font-bold">Profile</span>
        </a>
    </nav>

</body>
</html>