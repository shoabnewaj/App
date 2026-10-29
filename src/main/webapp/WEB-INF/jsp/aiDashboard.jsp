<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ychat AI | Y-ChatApp</title>
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- FontAwesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="icon" type="image/png" href="img/gemini.png">
    
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap');
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            background-color: #ffffff;
        }
        /* Custom Scrollbar for Message Container */
        #chatMessageList::-webkit-scrollbar {
            width: 6px;
        }
        #chatMessageList::-webkit-scrollbar-track {
            background: transparent;
        }
        #chatMessageList::-webkit-scrollbar-thumb {
            background: rgba(156, 163, 175, 0.2);
            border-radius: 4px;
        }
        #chatMessageList::-webkit-scrollbar-thumb:hover {
            background: rgba(156, 163, 175, 0.4);
        }
    </style>
</head>
<body class="h-screen w-screen flex bg-white text-gray-800 antialiased overflow-hidden">

    <!-- ─── SIDEBAR (Left Panel) ─── -->
    <aside id="sidebarPanel" class="w-[280px] bg-white border-r border-gray-100 flex flex-col justify-between flex-shrink-0 h-full p-4 transition-all duration-300">
        <div class="flex flex-col h-full">
            
            <!-- Branding Header -->
            <div class="flex items-center justify-between mb-6 px-1">
                <div class="flex items-center gap-3">
                    <!-- Glowing Torus ychat AI Logo representation -->
                    <svg class="w-8 h-8 flex-shrink-0" viewBox="0 0 100 100" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <circle cx="50" cy="50" r="38" stroke="url(#ychatGlow)" stroke-width="16" />
                        <defs>
                            <linearGradient id="ychatGlow" x1="0%" y1="0%" x2="100%" y2="100%">
                                <stop offset="0%" stop-color="#00C6FF" />
                                <stop offset="30%" stop-color="#0072FF" />
                                <stop offset="60%" stop-color="#7A22FF" />
                                <stop offset="100%" stop-color="#FF007A" />
                            </linearGradient>
                        </defs>
                    </svg>
                    <span class="font-bold text-lg text-gray-900 tracking-tight">ychat AI</span>
                </div>
                <!-- Hide Sidebar Button -->
                <button onclick="toggleSidebar()" class="w-8 h-8 rounded-lg flex items-center justify-center hover:bg-gray-50 text-gray-500 transition-colors">
                    <i class="fa-solid fa-bars-staggered text-sm"></i>
                </button>
            </div>

            <!-- Top Actions -->
            <div class="space-y-1 mb-6">
                <button onclick="startNewChat()" class="w-full flex items-center justify-between px-3.5 py-2.5 rounded-xl hover:bg-gray-50 text-sm font-semibold text-gray-700 transition duration-150">
                    <span class="flex items-center gap-3">
                        <i class="fa-regular fa-pen-to-square text-gray-500 text-base"></i>
                        New Chat (নতুন চ্যাট)
                    </span>
                    <i class="fa-solid fa-plus text-xs text-gray-400"></i>
                </button>
                <button onclick="useSuggestion('Create a story or generate copy')" class="w-full flex items-center gap-3 px-3.5 py-2.5 rounded-xl hover:bg-gray-50 text-sm font-semibold text-gray-700 transition duration-150">
                    <i class="fa-solid fa-wand-magic-sparkles text-gray-500 text-base"></i>
                    Create (নতুন কিছু লিখুন)
                </button>
            </div>

            <!-- History List Area -->
            <div class="flex-1 flex flex-col min-h-0">
                <p class="px-3.5 text-[10px] font-bold text-gray-400 uppercase tracking-widest mb-2">Recent</p>
                <div id="sidebarHistoryList" class="space-y-1 overflow-y-auto flex-1 pr-1">
                    <!-- History entries rendered dynamically -->
                    <div class="flex items-center gap-3 px-3.5 py-2 rounded-xl text-xs text-gray-400 italic">
                        No recent chats
                    </div>
                </div>
            </div>

            <!-- Bottom Section -->
            <div class="border-t border-gray-100 pt-4 space-y-2 mt-auto">
                <!-- Back home link -->
                <a href="UsersPostServlet" class="flex items-center gap-3 px-3.5 py-2.5 rounded-xl hover:bg-gray-50 text-xs font-bold text-gray-700 transition-colors">
                    <div class="w-7 h-7 flex items-center justify-center rounded-lg bg-blue-50 text-[#1b74e4]">
                        <i class="fa-solid fa-house"></i>
                    </div>
                    Return to Newsfeed
                </a>

                <!-- Logged User Card -->
                <div class="flex items-center justify-between px-3.5 py-2 border-t border-gray-50 mt-2">
                    <div class="flex items-center gap-3 overflow-hidden">
                        <img src="img/${ub.getProfile_pic()}" class="w-8 h-8 rounded-full object-cover border border-gray-200">
                        <div class="truncate">
                            <p class="text-xs font-bold text-gray-800 truncate">${ub.getName()}</p>
                            <p class="text-[10px] text-gray-400 truncate">${ub.getEmail()}</p>
                        </div>
                    </div>
                    <button onclick="openSettingsModal()" class="text-gray-400 hover:text-gray-600 transition-colors" title="AI Settings">
                        <i class="fa-solid fa-gear text-sm"></i>
                    </button>
                </div>
            </div>
            
        </div>
    </aside>

    <!-- Sidebar Toggle Floating Trigger (when collapsed) -->
    <button id="sidebarTrigger" class="hidden absolute top-4 left-4 z-50 w-9 h-9 bg-white border border-gray-200 hover:bg-gray-50 text-gray-600 rounded-full items-center justify-center shadow-sm transition-transform duration-200">
        <i class="fa-solid fa-bars text-sm"></i>
    </button>

    <!-- ─── MAIN CONTENT PANEL ─── -->
    <main class="flex-1 flex flex-col h-full bg-white relative overflow-hidden">
        
        <!-- Welcome state (Meta AI Style Landing) -->
        <div id="landingContainer" class="flex-1 flex flex-col justify-center items-center p-6 space-y-8 select-none max-w-2xl mx-auto w-full">
            
            <c:if test="${not isApiKeyConfigured}">
                <div id="apiKeyWarningBanner" class="w-full bg-amber-50 border border-amber-200 text-amber-800 rounded-2xl p-4 flex flex-col md:flex-row justify-between items-start md:items-center gap-3 shadow-sm select-text">
                    <div>
                        <p class="text-sm font-bold flex items-center gap-2"><i class="fa-solid fa-triangle-exclamation text-amber-600 text-base animate-bounce"></i> Gemini API Key Required</p>
                        <p class="text-xs text-amber-600 mt-1">To chat with ychat AI, please configure your Gemini API Key. Get a free key from Google AI Studio.</p>
                    </div>
                    <button onclick="openSettingsModal()" class="px-4 py-2 bg-amber-600 hover:bg-amber-700 text-white font-bold text-xs rounded-xl shadow transition whitespace-nowrap">
                        Configure Key
                    </button>
                </div>
            </c:if>

            <div class="text-center space-y-4">
                <!-- Glowing Torus ychat AI Logo -->
                <svg class="w-16 h-16 mx-auto animate-pulse" viewBox="0 0 100 100" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <circle cx="50" cy="50" r="38" stroke="url(#ychatGlowLg)" stroke-width="16" />
                    <defs>
                        <linearGradient id="ychatGlowLg" x1="0%" y1="0%" x2="100%" y2="100%">
                            <stop offset="0%" stop-color="#00C6FF" />
                            <stop offset="30%" stop-color="#0072FF" />
                            <stop offset="60%" stop-color="#7A22FF" />
                            <stop offset="100%" stop-color="#FF007A" />
                        </linearGradient>
                    </defs>
                </svg>
                <h1 class="text-3xl sm:text-4xl font-semibold text-gray-900 tracking-tight">How can I help you today?</h1>
            </div>

            <!-- Input Box -->
            <div class="w-full bg-white border border-gray-200 shadow-[0_2px_12px_rgba(0,0,0,0.04)] hover:shadow-[0_4px_16px_rgba(0,0,0,0.06)] focus-within:shadow-[0_4px_18px_rgba(0,0,0,0.08)] focus-within:border-gray-300 rounded-full p-1.5 flex items-center transition-all duration-300">
                <button onclick="triggerFileUpload()" class="w-9 h-9 rounded-full bg-gray-100 text-gray-500 hover:bg-gray-200 flex items-center justify-center flex-shrink-0 cursor-pointer transition" type="button">
                    <i class="fa-solid fa-plus text-sm"></i>
                </button>
                <input type="text" id="landingPromptInput" placeholder="Ask ychat AI... (প্রশ্ন করুন...)" class="flex-1 bg-transparent border-none outline-none text-base text-gray-800 font-normal px-3 py-2 placeholder-gray-400" onkeydown="if(event.key==='Enter') submitLandingPrompt()">
                <button onclick="submitLandingPrompt()" class="w-9 h-9 rounded-full bg-[#1b74e4] hover:bg-blue-600 text-white flex items-center justify-center flex-shrink-0 cursor-pointer shadow-sm transition">
                    <i class="fa-solid fa-arrow-up text-sm"></i>
                </button>
            </div>

            <!-- Vertical Suggestions List -->
            <div class="w-full divide-y divide-gray-100 border border-gray-100 rounded-2xl overflow-hidden shadow-sm bg-white">
                <!-- Suggestion 1 -->
                <div onclick="useSuggestion('Translate the following into clear, fluent Bengali:\n')" class="flex items-center justify-between px-5 py-4 hover:bg-gray-50 cursor-pointer transition group">
                    <div class="flex items-center gap-4">
                        <i class="fa-solid fa-language text-purple-500 text-lg group-hover:scale-110 transition-transform"></i>
                        <div class="text-left">
                            <p class="text-sm font-semibold text-gray-800 group-hover:text-blue-600 transition-colors">Bengali Translator (বাংলায় অনুবাদ করুন)</p>
                            <p class="text-xs text-gray-400 font-light">যে কোনো লেখা সহজে বাংলায় অনুবাদ করুন</p>
                        </div>
                    </div>
                    <i class="fa-solid fa-chevron-right text-gray-300 group-hover:translate-x-0.5 group-hover:text-blue-500 transition-all text-xs"></i>
                </div>
                <!-- Suggestion 2 -->
                <div onclick="useSuggestion('Write an engaging social media post in Bengali and English with trending hashtags about:\n')" class="flex items-center justify-between px-5 py-4 hover:bg-gray-50 cursor-pointer transition group">
                    <div class="flex items-center gap-4">
                        <i class="fa-solid fa-hashtag text-blue-500 text-lg group-hover:scale-110 transition-transform"></i>
                        <div class="text-left">
                            <p class="text-sm font-semibold text-gray-800 group-hover:text-blue-600 transition-colors">Create Social Post with Hashtags</p>
                            <p class="text-xs text-gray-400 font-light">হ্যাশট্যাগসহ সোশ্যাল মিডিয়ার পোস্ট তৈরি করুন</p>
                        </div>
                    </div>
                    <i class="fa-solid fa-chevron-right text-gray-300 group-hover:translate-x-0.5 group-hover:text-blue-500 transition-all text-xs"></i>
                </div>
                <!-- Suggestion 3 -->
                <div onclick="useSuggestion('Summarize the following topic into 3 key bullet points with emojis:\n')" class="flex items-center justify-between px-5 py-4 hover:bg-gray-50 cursor-pointer transition group">
                    <div class="flex items-center gap-4">
                        <i class="fa-solid fa-list-check text-green-500 text-lg group-hover:scale-110 transition-transform"></i>
                        <div class="text-left">
                            <p class="text-sm font-semibold text-gray-800 group-hover:text-blue-600 transition-colors">Summarize Topic (সংক্ষিপ্ত সারসংক্ষেপ)</p>
                            <p class="text-xs text-gray-400 font-light">যে কোনো বিষয়ের মূল পয়েন্টগুলো সহজে জানুন</p>
                        </div>
                    </div>
                    <i class="fa-solid fa-chevron-right text-gray-300 group-hover:translate-x-0.5 group-hover:text-blue-500 transition-all text-xs"></i>
                </div>
                <!-- Suggestion 4 -->
                <div onclick="useSuggestion('Fix grammar and polish tone for:\n')" class="flex items-center justify-between px-5 py-4 hover:bg-gray-50 cursor-pointer transition group">
                    <div class="flex items-center gap-4">
                        <i class="fa-solid fa-wand-magic-sparkles text-pink-500 text-lg group-hover:scale-110 transition-transform"></i>
                        <div class="text-left">
                            <p class="text-sm font-semibold text-gray-800 group-hover:text-blue-600 transition-colors">Fix Grammar & Polish Text (ব্যাকরণ সঠিক করুন)</p>
                            <p class="text-xs text-gray-400 font-light">লেখা প্রফেশনাল ও নির্ভুল করুন</p>
                        </div>
                    </div>
                    <i class="fa-solid fa-chevron-right text-gray-300 group-hover:translate-x-0.5 group-hover:text-blue-500 transition-all text-xs"></i>
                </div>
            </div>

            <!-- Footer Links -->
            <div class="text-center text-xs text-gray-400 flex items-center justify-center gap-4 pt-4 border-t border-gray-50 w-full">
                <a href="UsersPostServlet" class="hover:text-blue-600 font-semibold transition">Home Feed</a>
                <span>•</span>
                <a href="yads" class="hover:text-blue-600 font-semibold transition">Y-Ads Manager</a>
                <span>•</span>
                <a href="messages.jsp" class="hover:text-blue-600 font-semibold transition">Messenger</a>
            </div>
        </div>

        <!-- Chat Output state (Active Chat screen) -->
        <div id="chatActiveContainer" class="hidden flex-1 flex flex-col overflow-hidden h-full">
            <!-- Messages List Container -->
            <div id="chatMessageList" class="flex-1 overflow-y-auto p-6 space-y-6 max-w-3xl mx-auto w-full" style="scroll-behavior: smooth;">
                <!-- Dynamically populated messages -->
            </div>

            <!-- Active Typing Indicator -->
            <div id="aiTypingIndicator" class="hidden max-w-3xl mx-auto w-full px-6 py-2 flex items-start gap-4">
                <div class="w-8 h-8 rounded-full flex items-center justify-center flex-shrink-0 bg-white shadow-sm border border-gray-100">
                    <svg class="w-5 h-5 animate-spin" viewBox="0 0 100 100" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <circle cx="50" cy="50" r="38" stroke="url(#ychatTypingGlow)" stroke-width="16" />
                        <defs>
                            <linearGradient id="ychatTypingGlow" x1="0%" y1="0%" x2="100%" y2="100%">
                                <stop offset="0%" stop-color="#00C6FF" />
                                <stop offset="100%" stop-color="#FF007A" />
                            </linearGradient>
                        </defs>
                    </svg>
                </div>
                <div class="bg-gray-50 text-gray-800 text-sm p-4 rounded-2xl rounded-tl-none flex items-center gap-1.5 border border-gray-100 shadow-sm">
                    <span class="w-2 h-2 bg-blue-500 rounded-full animate-bounce" style="animation-delay: 0s;"></span>
                    <span class="w-2 h-2 bg-blue-500 rounded-full animate-bounce" style="animation-delay: 0.15s;"></span>
                    <span class="w-2 h-2 bg-blue-500 rounded-full animate-bounce" style="animation-delay: 0.3s;"></span>
                </div>
            </div>

            <!-- Bottom sticky chat input bar -->
            <div class="border-t border-gray-100 p-4 bg-white">
                <div class="max-w-3xl mx-auto w-full bg-white border border-gray-200 shadow-sm focus-within:border-gray-300 focus-within:shadow-md focus-within:ring-2 focus-within:ring-blue-100/50 rounded-full p-1.5 flex items-center transition-all duration-300">
                    <button onclick="triggerFileUpload()" class="w-9 h-9 rounded-full bg-gray-100 text-gray-500 hover:bg-gray-200 flex items-center justify-center flex-shrink-0 cursor-pointer transition" type="button">
                        <i class="fa-solid fa-plus text-sm"></i>
                    </button>
                    <input type="text" id="activePromptInput" placeholder="Ask ychat AI... (প্রশ্ন করুন...)" class="flex-1 bg-transparent border-none outline-none text-base text-gray-800 font-normal px-3 py-2 placeholder-gray-400" onkeydown="if(event.key==='Enter') submitActivePrompt()">
                    <button onclick="submitActivePrompt()" class="w-9 h-9 rounded-full bg-[#1b74e4] hover:bg-blue-600 text-white flex items-center justify-center flex-shrink-0 cursor-pointer shadow-sm transition">
                        <i class="fa-solid fa-arrow-up text-sm"></i>
                    </button>
                </div>
                <p class="text-center text-[10px] text-gray-400 mt-2">ychat AI can make mistakes. Verify important info.</p>
            </div>
        </div>

    </main>

    <!-- ─── JAVASCRIPT LOGIC ─── -->
    <script>
        const loggedInUser = "${ub.getName()}";
        const contextPath = "${pageContext.request.contextPath}";
        let socket = null;

        document.addEventListener("DOMContentLoaded", () => {
            initializeWebSocket();
            checkAndLoadHistory();
            
            // Wire up Floating Sidebar trigger
            const trigger = document.getElementById("sidebarTrigger");
            trigger.addEventListener("click", toggleSidebar);
        });

        function toggleSidebar() {
            const sidebar = document.getElementById("sidebarPanel");
            const trigger = document.getElementById("sidebarTrigger");
            
            if (sidebar.classList.contains("hidden")) {
                sidebar.classList.remove("hidden");
                trigger.classList.add("hidden");
            } else {
                sidebar.classList.add("hidden");
                trigger.classList.remove("hidden");
                trigger.classList.add("flex");
            }
        }

        function initializeWebSocket() {
            const protocol = window.location.protocol === "https:" ? "wss://" : "ws://";
            const host = window.location.host;
            const wsUrl = protocol + host + contextPath + "/ws/user/" + encodeURIComponent(loggedInUser);

            socket = new WebSocket(wsUrl);

            socket.onopen = function() {
                console.log("WebSocket connected on AI Dashboard");
            };

            socket.onmessage = function(event) {
                const data = event.data;
                if (data.startsWith("CHAT|")) {
                    const parts = data.split("|", 3);
                    const sender = parts[1];
                    const msg = parts[2];

                    if (sender === "Gemini AI") {
                        hideTypingIndicator();
                        appendMessage("ychat AI", msg);
                        checkAndLoadHistory(); // refresh sidebar history
                    }
                }
            };

            socket.onerror = function(err) {
                console.error("WebSocket error:", err);
            };

            socket.onclose = function() {
                console.log("WebSocket closed. Reconnecting...");
                setTimeout(initializeWebSocket, 3000);
            };
        }

        // Lightweight Markdown and rich text formatting helper
        function formatMarkdown(text) {
            if (!text) return "";
            
            // Escape HTML tags to protect against script execution/injection
            let formatted = text
                .replace(/&/g, "&amp;")
                .replace(/</g, "&lt;")
                .replace(/>/g, "&gt;");
            
            // Format Code Blocks (fenced ```code```)
            formatted = formatted.replace(/```([\s\S]*?)```/g, (match, code) => {
                return `<pre class="bg-gray-900 text-gray-100 p-4 rounded-xl font-mono text-xs overflow-x-auto my-3 border border-gray-800 shadow-inner"><code>\${code.trim()}</code></pre>`;
            });
            
            // Format Inline Code (`code`)
            formatted = formatted.replace(/`([^`]+)`/g, '<code class="bg-gray-100 text-pink-600 px-1.5 py-0.5 rounded font-mono text-xs">$1</code>');
            
            // Format Bold Text (**bold**)
            formatted = formatted.replace(/\*\*([^*]+)\*\*/g, '<strong>$1</strong>');
            
            // Bullet list items
            formatted = formatted.replace(/^\*\s+(.+)$/gm, '<li class="ml-4 list-disc text-sm my-1">$1</li>');
            
            // Replace remaining line breaks
            formatted = formatted.replace(/\n/g, '<br>');
            
            return formatted;
        }

        function checkAndLoadHistory() {
            fetch("loadMessages?user1=" + encodeURIComponent(loggedInUser) + "&user2=Gemini%20AI")
            .then(res => res.json())
            .then(messages => {
                const historyList = document.getElementById("sidebarHistoryList");
                historyList.innerHTML = "";
                
                if (messages && messages.length > 0) {
                    switchToActiveChatMode();
                    const list = document.getElementById("chatMessageList");
                    list.innerHTML = "";
                    
                    messages.forEach(m => {
                        appendMessage(m.sender === "Gemini AI" ? "ychat AI" : m.sender, m.message);
                    });

                    // Add one entry in sidebar history representing this thread
                    const historyItem = document.createElement("div");
                    historyItem.className = "flex items-center gap-3 px-3.5 py-2.5 rounded-xl hover:bg-gray-50 cursor-pointer transition text-xs font-semibold text-gray-700 hover:text-blue-600";
                    historyItem.onclick = () => {
                        switchToActiveChatMode();
                        checkAndLoadHistory();
                    };
                    historyItem.innerHTML = `
                        <i class="fa-regular fa-comments text-gray-400"></i>
                        <span class="truncate">ychat AI Chat</span>
                    `;
                    historyList.appendChild(historyItem);
                } else {
                    switchToLandingMode();
                    const emptyItem = document.createElement("div");
                    emptyItem.className = "flex items-center gap-3 px-3.5 py-2 rounded-xl text-xs text-gray-400 italic";
                    emptyItem.innerText = "No recent chats";
                    historyList.appendChild(emptyItem);
                }
            })
            .catch(err => console.error("Error loading chat history:", err));
        }

        function startNewChat() {
            // Tell server/WebSocket to clear or just switch back to fresh UI landing
            switchToLandingMode();
            document.getElementById("chatMessageList").innerHTML = "";
        }

        function switchToActiveChatMode() {
            document.getElementById("landingContainer").classList.add("hidden");
            document.getElementById("chatActiveContainer").classList.remove("hidden");
        }

        function switchToLandingMode() {
            document.getElementById("chatActiveContainer").classList.add("hidden");
            document.getElementById("landingContainer").classList.remove("hidden");
        }

        function useSuggestion(text) {
            switchToActiveChatMode();
            sendPrompt(text);
        }

        function submitLandingPrompt() {
            const input = document.getElementById("landingPromptInput");
            const val = input.value.trim();
            if (!val) return;
            input.value = "";
            switchToActiveChatMode();
            sendPrompt(val);
        }

        function submitActivePrompt() {
            const input = document.getElementById("activePromptInput");
            const val = input.value.trim();
            if (!val) return;
            input.value = "";
            sendPrompt(val);
        }

        function sendPrompt(text) {
            appendMessage(loggedInUser, text);
            showTypingIndicator();

            if (socket && socket.readyState === WebSocket.OPEN) {
                socket.send("CHAT|Gemini AI|" + text);
            } else {
                fetch("aiWrite?prompt=" + encodeURIComponent(text))
                .then(res => res.json())
                .then(data => {
                    hideTypingIndicator();
                    if (data.content) {
                        appendMessage("ychat AI", data.content);
                        checkAndLoadHistory();
                    } else {
                        appendMessage("ychat AI", "Error connecting to backend AI service.");
                    }
                })
                .catch(err => {
                    hideTypingIndicator();
                    appendMessage("ychat AI", "Error: " + err.message);
                });
            }
        }

        function appendMessage(sender, text) {
            const list = document.getElementById("chatMessageList");
            const item = document.createElement("div");
            item.className = "flex items-start gap-4 mb-4";

            const isMe = (sender === loggedInUser);
            
            // Check if text is image or video file path
            let contentHtml = "";
            const isImg = text && text.startsWith("img/") && (
                text.toLowerCase().endsWith(".png") || 
                text.toLowerCase().endsWith(".jpg") || 
                text.toLowerCase().endsWith(".jpeg") || 
                text.toLowerCase().endsWith(".gif") || 
                text.toLowerCase().endsWith(".webp") || 
                text.toLowerCase().endsWith(".avif")
            );
            const isVid = text && text.startsWith("img/") && (
                text.toLowerCase().endsWith(".mp4") || 
                text.toLowerCase().endsWith(".webm") || 
                text.toLowerCase().endsWith(".mov") || 
                text.toLowerCase().endsWith(".ogg")
            );

            if (isImg) {
                contentHtml = `<img src="\${text}" class="max-w-[250px] max-h-[250px] rounded-xl cursor-pointer shadow-sm border border-gray-100" onclick="window.open('\${text}', '_blank')">`;
            } else if (isVid) {
                contentHtml = `<video src="\${text}" controls class="max-w-[250px] max-h-[250px] rounded-xl shadow-sm border border-gray-100"></video>`;
            } else {
                contentHtml = `<p class="\${isMe ? 'text-gray-800' : 'text-gray-850'}">\${formatMarkdown(text)}</p>`;
            }
            
            if (isMe) {
                item.classList.add("justify-end");
                item.innerHTML = `
                    <div class="bg-gray-100 text-gray-800 text-sm py-2.5 px-4 rounded-2xl rounded-tr-none shadow-sm leading-relaxed max-w-[80%] border border-gray-200/50">
                        \${contentHtml}
                    </div>
                    <img src="img/\${isMe ? '${ub.getProfile_pic()}' : 'noimage_user_160.jpg'}" class="w-8 h-8 rounded-full object-cover flex-shrink-0 border border-gray-200" alt="User">
                `;
            } else {
                // ychat AI glowing logo SVG
                item.innerHTML = `
                    <div class="w-8 h-8 rounded-full flex items-center justify-center flex-shrink-0 bg-white border border-gray-150 shadow-sm">
                        <svg class="w-5 h-5" viewBox="0 0 100 100" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <circle cx="50" cy="50" r="38" stroke="url(#ychatGlowMsg)" stroke-width="16" />
                            <defs>
                                <linearGradient id="ychatGlowMsg" x1="0%" y1="0%" x2="100%" y2="100%">
                                    <stop offset="0%" stop-color="#00C6FF" />
                                    <stop offset="30%" stop-color="#0072FF" />
                                    <stop offset="60%" stop-color="#7A22FF" />
                                    <stop offset="100%" stop-color="#FF007A" />
                                </linearGradient>
                            </defs>
                        </svg>
                    </div>
                    <div class="flex-1">
                        <p class="text-xs font-bold text-gray-700 mb-1">ychat AI</p>
                        <div class="text-sm leading-relaxed text-gray-850 max-w-[90%]">
                            \${contentHtml}
                        </div>
                    </div>
                `;
            }

            list.appendChild(item);
            list.scrollTop = list.scrollHeight;
        }

        function showTypingIndicator() {
            document.getElementById("aiTypingIndicator").classList.remove("hidden");
            const list = document.getElementById("chatMessageList");
            list.scrollTop = list.scrollHeight;
        }

        function hideTypingIndicator() {
            document.getElementById("aiTypingIndicator").classList.add("hidden");
        }

        function triggerFileUpload() {
            document.getElementById("aiChatFileInput").click();
        }

        function handleFileSelected(input) {
            if (input.files && input.files[0]) {
                const file = input.files[0];
                const formData = new FormData();
                formData.append("chatFile", file);
                
                showTypingIndicator();
                
                fetch('ChatFileUploadServlet', {
                    method: 'POST',
                    body: formData
                })
                .then(res => res.json())
                .then(data => {
                    hideTypingIndicator();
                    if (data.success) {
                        switchToActiveChatMode();
                        sendPrompt(data.filePath);
                    } else {
                        alert("File upload failed: " + data.message);
                    }
                })
                .catch(err => {
                    hideTypingIndicator();
                    console.error("Upload error:", err);
                    alert("Error uploading file.");
                });
                
                // Clear input so selecting the same file triggers change event again
                input.value = "";
            }
        }

        function openSettingsModal() {
            document.getElementById("settingsModal").classList.remove("hidden");
        }

        function closeSettingsModal() {
            document.getElementById("settingsModal").classList.add("hidden");
        }

        function toggleKeyVisibility() {
            const input = document.getElementById("modalApiKeyInput");
            if (input.type === "password") {
                input.type = "text";
            } else {
                input.type = "password";
            }
        }

        function saveApiKey() {
            const key = document.getElementById("modalApiKeyInput").value.trim();
            if (!key) {
                alert("Please enter a valid Gemini API Key.");
                return;
            }

            const params = new URLSearchParams();
            params.append("apiKey", key);

            fetch("aiDashboard", {
                method: "POST",
                body: params,
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded"
                }
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    alert("Gemini API Key saved successfully and activated!");
                    closeSettingsModal();
                    
                    // Hide the warning banner if it exists
                    const banner = document.getElementById("apiKeyWarningBanner");
                    if (banner) banner.remove();
                    
                    // Reload page to re-initialize or dynamically update state
                    window.location.reload();
                } else {
                    alert("Error saving API Key: " + data.message);
                }
            })
            .catch(err => {
                console.error("Error saving API Key:", err);
                alert("Error saving API Key.");
            });
        }
    </script>
    <!-- Hidden input for file/image uploads -->
    <input type="file" id="aiChatFileInput" accept="image/*,video/*" class="hidden" onchange="handleFileSelected(this)">

    <!-- Settings Modal -->
    <div id="settingsModal" class="hidden fixed inset-0 bg-black/60 backdrop-blur-sm z-[9999] flex items-center justify-center p-4">
        <div class="bg-white rounded-[2rem] shadow-2xl p-8 max-w-md w-full space-y-6 transform scale-95 transition-all duration-300">
            <div class="flex items-center justify-between border-b pb-4">
                <h3 class="text-xl font-extrabold text-gray-900 flex items-center gap-2">
                    <i class="fa-solid fa-gears text-blue-600"></i>
                    ychat AI Settings
                </h3>
                <button onclick="closeSettingsModal()" class="w-8 h-8 rounded-full bg-gray-100 hover:bg-gray-200 flex items-center justify-center text-gray-500 transition">
                    <i class="fa fa-times"></i>
                </button>
            </div>
            
            <div class="space-y-4">
                <div class="space-y-2">
                    <label class="text-xs font-bold text-gray-500 uppercase tracking-wider block">Google Gemini API Key</label>
                    <input type="password" id="modalApiKeyInput" placeholder="Paste your API Key here (AI Studio)" value="${currentApiKey}"
                           class="w-full px-4 py-3 bg-gray-50 border border-gray-200 rounded-2xl focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 outline-none transition text-sm text-gray-800 font-mono">
                    <div class="flex justify-between items-center text-[11px] text-gray-400">
                        <span>Get a free key at <a href="https://aistudio.google.com/" target="_blank" class="text-blue-500 hover:underline">Google AI Studio</a></span>
                        <button onclick="toggleKeyVisibility()" class="text-gray-500 hover:text-blue-500 font-semibold"><i class="fa-regular fa-eye mr-1"></i>Show Key</button>
                    </div>
                </div>
            </div>

            <div class="flex items-center gap-3 pt-2">
                <button onclick="closeSettingsModal()" class="flex-1 py-3 bg-gray-100 hover:bg-gray-200 text-gray-700 font-bold rounded-2xl text-sm transition">
                    Cancel
                </button>
                <button onclick="saveApiKey()" class="flex-1 py-3 bg-gradient-to-r from-blue-600 to-indigo-600 hover:from-blue-700 hover:to-indigo-700 text-white font-bold rounded-2xl text-sm shadow transition">
                    Save Changes
                </button>
            </div>
        </div>
    </div>
    <script src="js/theme.js"></script>
</body>
</html>
