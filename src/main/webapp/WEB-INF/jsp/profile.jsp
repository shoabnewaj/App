<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${profileUser.name} | Profile</title>
<link rel="icon" type="image/png" href="<%=request.getContextPath()%>/icons/icon-192.png">

<script src="https://cdn.tailwindcss.com"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <style>
        :root {
            --glass-bg: rgba(255, 255, 255, 0.7);
            --glass-border: rgba(255, 255, 255, 0.3);
            --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        body {
            background: linear-gradient(-45deg, #f3f4f7, #e2e8f0, #f8fafc, #f1f5f9);
            background-size: 400% 400%;
            animation: gradient 15s ease infinite;
            font-family: 'Outfit', sans-serif;
            min-height: 100vh;
        }
        @keyframes gradient {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }
        .glass-card {
            background: var(--glass-bg);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid var(--glass-border);
            box-shadow: 0 8px 3

























    </style>
</head>
<body class="custom-scrollbar bg-fixed">

    <!-- HEADER -->
    <header class="glass-nav h-[56px] sticky top-0 z-[5000] flex items-center justify-between px-4 mb-6">
        <!-- LEFT SECTION (Logo and Search) -->
        <div class="flex items-center gap-2 flex-1">
            <a href="UsersPostServlet" class="flex items-center gap-2 group">
                <img src="${pageContext.request.contextPath}/icons/icon-192.png" width="38" alt="Logo" class="group-hover:rotate-12 transition-transform">
                <span class="font-extrabold text-xl tracking-tight hidden sm:inline text-gray-800">Y-ChatApp</span>
            </a>
            
            <form action="SearchServlet" method="get" class="bg-gray-100/50 backdrop-blur-md px-4 py-2 rounded-full hidden md:flex items-center gap-2 ml-4 border border-transparent focus-within:border-gray-200 transition-all duration-300 w-[240px]">
                <i class="fa fa-search text-gray-400"></i>
                <input name="query" placeholder="Search Y-Chat" class="bg-transparent outline-none w-full text-sm font-medium">
            </form>





                <a href="FriendServlet" class="text-gray-500 hover:text-blue-600 transition-colors text-xl" title="Friends"><i class="fa fa-user-group"></i></a>
                <a href="VideosServlet" class="text-gray-500 hover:text-blue-600 transition-colors text-xl" title="Videos"><i class="fa fa-video"></i></a>
                <a href="UsersPostServlet?showReels=true" class="text-gray-500 hover:text-blue-600 transition-colors text-xl" title="Reels"><i class="fa fa-clapperboard"></i></a>
                <a href="MarketServlet" class="text-gray-500 hover:text-blue-600 transition-colors text-xl" title="Market"><i class="fa fa-shop"></i></a>
            </nav>

            <div class="flex items-center gap-4">
                <a href="NotificationServlet" class="w-10 h-10 bg-gray-100 rounded-full flex items-center justify-center relative hover:bg-gray-200 transition-colors">
                    <i class="fa fa-bell text-gray-600"></i>
                    <c:if test="${not empty unreadCount && unreadCount > 0}">
                        <span class="absolute -top-1 -right-1 bg-red-600 text-white text-[10px] px-1.5 rounded-full border-2 border-white font-bold">${unreadCount}</span>
                    </c:if>
                </a>
                <div class="w-10 h-10 bg-gray-100 rounded-full flex items-center justify-center cursor-pointer hover:bg-gray-200 transition-colors" onclick="location.href='UsersLogoutServlet'"><i class="fa fa-right-from-bracket"></i></div>
                <img src="img/${ub.profile_pic}" class="w-10 h-10 rounded-full border-2 border-blue-500 p-0.5 cursor-pointer hover:scale-105 transition-transform" onclick="location.href='UsersProfileServlet?userId=${ub.id}'">
            </div>
        </div>





























                <a href="messages.jsp" class="flex items-center gap-4 p-3.5 rounded-2xl hover:bg-pink-50/50 hover:text-pink-600 transition-all group font-bold text-gray-600">
                    <div class="w-10 h-10 bg-pink-100/50 text-pink-600 rounded-xl flex items-center justify-center group-hover:bg-pink-600 group-hover:text-white transition-all shadow-sm">
                        <i class="fa fa-message text-lg"></i>
                    </div>
                    <span>Messenger</span>
                </a>

                <a href="UsersPostServlet?showReels=true" class="flex items-center gap-4 p-3.5 rounded-2xl hover:bg-orange-50/50 hover:text-orange-600 transition-all group font-bold text-gray-600">
                    <div class="w-10 h-10 bg-orange-100/50 text-orange-600 rounded-xl flex items-center justify-center group-hover:bg-orange-600 group-hover:text-white transition-all shadow-sm">
                        <i class="fa fa-video text-lg"></i>
                    </div>
                    <span>Short Videos</span>
                </a>

                <div class="pt-4 mt-4 border-t border-gray-100/50">
                    <p class="text-[10px] font-black text-gray-400 uppercase tracking-widest px-4 mb-2">Social Hub</p>
                    <a href="SearchServlet?query=" class="flex items-center gap-4 p-3.5 rounded-2xl bg-blue-600 text-white shadow-lg shadow-blue-200 hover:bg-blue-700 transition-all font-bol



                        <span>Discover People</span>
                    </a>
                    <a href="#" class="flex items-center gap-4 p-3.5 rounded-2xl hover:bg-gray-100/50 transition-all font-bold text-gray-500 mt-2">
                        <i class="fa fa-calendar-star text-pink-500"></i> Events
                    </a>
                </div>
            </div>
        </aside>

        <!-- MIDDLE CONTENT -->
        <main class="space-y-6">
            
            <!-- COVER PHOTO -->
            <div class="relative w-full h-[450px] overflow-hidden group rounded-3xl shadow-2xl glass-card !p-0">
                <img src="${not empty profileUser.cover_pic ? 'img/' : ''}${not empty profileUser.cover_pic ? profileUser.cover_pic : 'https://images.unsplash.com/photo-1557683316-973673baf926?q=80&w=2000&auto=format&fit=crop'}"
                     class="w-full h-full object-cover transition-transform duration-700 group-hover:scale-105"
                     alt="Cover Image">
                <div class="absolute inset-0 bg-gradient-to-t from-black/60 via-transparent to-transparent"></div>
                
                <c:if test="${profileUser.id == ub.id}">
                    <div class="absolute bottom-6 right-6">
                        <form action="UploadCoverServlet" method="post" enctype="multipart/form-data" id="coverForm">
                            <label for="coverInput" class="bg-white/20 hover:bg-white/40 backdrop-blur-xl text-white px-6 py-2.5 rounded-2xl font-bold shadow-2xl cursor-pointer flex items-center gap-3 transition-all active:scale-95 border border-white/30">
                                <i class="fa fa-camera text-xl"></i>
                                <span>Edit Cover Photo</span>
                            </label>
                            <input type="file" name="coverPic" id="coverInput" accept="image/*" hidden onchange="document.getElementById('coverForm').submit()">
                        </form>
                    </div>
                </c:if>
            </div>



















































                                        <c:when test="${friendshipStatus == 'INCOMING'}">
                                            <button onclick="handleUserAction('${profileUser.id}', 'ACCEPT', this)" class="bg-green-600 text-white px-6 py-2.5 rounded-xl font-bold shadow-lg hover:bg-green-700 transition-all active:scale-95">
                                                <i class="fa fa-user-plus mr-2"></i> Accept Request
                                            </button>
                                        </c:when>
                                        <c:otherwise>
                                            <button onclick="handleUserAction('${profileUser.id}', 'ADD', this)" class="bg-blue-600 text-white px-6 py-2.5 rounded-xl font-bold shadow-lg hover:bg-blue-700 transition-all active:scale-95">
                                                <i class="fa fa-user-plus mr-2"></i> Add Friend
                                            </button>
                                        </c:otherwise>
                                    </c:choose>
                                    
                                    <c:choose>
                                        <c:when test="${isFollowing}">
                                            <button onclick="handleUserAction('${profileUser.id}', 'UNFOLLOW', this)" class="bg-purple-50 text-purple-600 px-6 py-2.5 rounded-xl font-bold shadow-sm border border-purple-200 hover:bg-purple-100 transition-all">
                                                <i class="fa fa-user-minus mr-2"></i> Unfollow
                                            </button>
                                        </c:when>
                                        <c:otherwise>
                                            <button onclick="handleUserAction('${profileUser.id}', 'FOLLOW', this)" class="bg-purple-600 text-white px-6 py-2.5 rounded-xl font-bold shadow-lg hover:bg-purple-700 transition-all active:scale-95">
                                                <i class="fa fa-user-plus mr-2"></i> Follow
                                            </button>
                                        </c:otherwise>
                                    </c:choose>

                                    <button onclick="location.href='messages.jsp?userId=${profileUser.id}'" class="bg-gray-100 text-gray-800 px-6 py-2.5 rounded-xl font-bold hover:bg-gray-200 transition-all">
                                        <i class="fa-brands fa-facebook-messenger mr-2 text-lg"></i> Message
                                    </button>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <!-- STATS & TABS -->
                <div class="flex flex-col md:flex-row items-center justify-between gap-6 mt-8 pt-6 border-t border-gray-100">
                    <div class="flex gap-8">
                        <div class="text-center group cursor-pointer">
                            <b class="block text-2xl text-




































































                <c:forEach var="post" items="${userPosts}" varStatus="status">
                    <!-- Post Card #${status.count} -->
                    <div class="glass-card rounded-3xl p-6 hover:shadow-xl transition-all duration-300 mb-6">
                        <div class="flex justify-between items-start">
                            <div class="flex gap-4">
                                <img src="img/${post.profile_pic}" class="w-11 h-11 rounded-2xl object-cover border-2 border-white shadow-md">
                                <div>
                                    <p class="font-black text-gray-800 hover:text-blue-600 transition-colors cursor-pointer">${post.name}</p>
                                    <c:if test="${not empty post.feeling}">
                                        <span class="text-gray-400 text-[12px]"> is feeling <span class="font-bold text-gray-600">${post.feeling}</span></span>
                                    </c:if>
                                    <div class="text-[11px] text-gray-400 font-bold flex items-center gap-1.5 mt-0.5">
                                        <span>${post.time}</span> • <i class="fa fa-earth-americas"></i>
                                    </div>
                                </div>
                            </div>
                            <div class="relative">
                                <div onclick="togglePostMenu(event, ${post.id})" class="p-2 hover:bg-gray-100 rounded-full transition-colors cursor-pointer"><i class="fa fa-ellipsis-h text-gray-500"></i></div>
                                <div id="post-menu-${post.id}" class="hidden absolute right-0 top-8 bg-white border shadow-lg rounded-xl z-50 min-w-[150px] overflow-hidden">
                                    <div onclick="toggleSavePost(${post.id}, this)" class="px-4 py-3 hover:bg-blue-50 text-blue-600 cursor-pointer font-bold transition flex items-center gap-2">
                                        <i class="fa fa-bookmark"></i> Save Post
                                    </div>
                                    <c:if test="${post.userId == sessionScope.userId}">
                                        <div onclick="deletePost(${post.id})" class="px-4 py-3 hover:bg-red-50 text-red-600 cursor-pointer font-bold transition flex items-center gap-2">
                                            <i class="fa fa-trash"></i> Delete Post
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </div>

                        <div class="mt-4 text-gray-700 leading-relaxed">${post.content}</div>

















                                        <c:set var="tc" value="${post.likeCount + post.loveCount + post.careCount + post.hahaCount + post.wowCount + post.sadCount + post.angryCount + post.dislikes}"/>
                                        <c:choose>
                                            <c:when test="${tc > 0}">
                                                <c:if test="${post.likeCount > 0}">👍 <span class="text-gray-600">${post.likeCount}</span>&nbsp;&nbsp;</c:if>
                                                <c:if test="${post.loveCount > 0}">❤️ <span class="text-gray-600">${post.loveCount}</span>&nbsp;&nbsp;</c:if>
                                                <c:if test="${post.careCount > 0}">🥰 <span class="text-gray-600">${post.careCount}</span>&nbsp;&nbsp;</c:if>
                                                <c:if test="${post.hahaCount > 0}">😆 <span class="text-gray-600">${post.hahaCount}</span>&nbsp;&nbsp;</c:if>
                                                <c:if test="${post.wowCount > 0}">😮 <span class="text-gray-600">${post.wowCount}</span>&nbsp;&nbsp;</c:if>
                                                <c:if test="${post.sadCount > 0}">😢 <span class="text-gray-600">${post.sadCount}</span>&nbsp;&nbsp;</c:if>
                                                <c:if test="${post.angryCount > 0}">😡 <span class="text-gray-600">${post.angryCount}</span>&nbsp;&nbsp;</c:if>
                                                <c:if test="${post.dislikes > 0}">👎 <span class="text-gray-600">${post.dislikes}</span>&nbsp;&nbsp;</c:if>
                                            </c:when>
                                            <c:otherwise>0</c:otherwise>
























































































































































































        <!-- TAB CONTENT: ABOUT -->
        <div id="tab-content-about" class="tab-content hidden space-y-6">
            <div class="glass-card p-8 rounded-3xl space-y-6">
                <h3 class="text-2xl font-black text-gray-800 flex items-center gap-3">
                    <i class="fa fa-circle-info text-blue-600"></i> About ${profileUser.name}
                </h3>
                
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <!-- Contact Info -->
                    <div class="bg-white/40 p-6 rounded-2xl border border-white/30 space-y-4">
                        <h4 class="font-bold text-gray-700 uppercase tracking-widest text-xs">Contact & Basic Info</h4>
                        <div class="space-y-3 font-medium">
                            <div class="flex items-center gap-3 text-gray-600">
                                <i class="fa fa-envelope text-gray-400 w-5"></i>
                                <span>${profileUser.email}</span>
                            </div>
                            <div class="flex items-center gap-3 text-gray-600">
                                <i class="fa fa-user-tag text-gray-400 w-5"></i>
                                <span>@${profileUser.name.toLowerCase().replace(' ', '')}</span>
                            </div>
                            <div class="flex items-center gap-3 text-gray-600">























































        <!-- TAB CONTENT: PHOTOS -->
        <div id="tab-content-photos" class="tab-content hidden space-y-6">
            <div class="glass-card p-8 rounded-3xl">
                <h3 class="text-2xl font-black text-gray-800 flex items-center gap-3 mb-6">
                    <i class="fa fa-image text-pink-600"></i> Photos & Videos
                </h3>
                
                <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 gap-4">
                    <c:set var="hasPhotos" value="false"/>
                    <c:forEach var="post" items="${userPosts}">
                        <c:if test="${not empty post.file_name}">
                            <c:set var="hasPhotos" value="true"/>
                            <div class="relative group aspect-square rounded-2xl overflow-hidden border border-white/30 shadow-md bg-gray-50 cursor-pointer hover:shadow-lg transition-all">
                                <c:choose>
                                    <c:when test="${post.post_type == 'video'}">
                                        <video class="w-full h-full object-cover">
                                            <source src="img/${post.file_name}" type="video/mp4">
                                        </video>
                                        <div class="absolute inset-0 bg-black/30 flex items-center justify-center text-white opacity-90 group-hover:bg-black/45 transition-colors">
                                            <i class="fa fa-play text-2xl"></i>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <img src="img/${post.file_name}" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500">
                                        <div class="absolute inset-0 bg-gradient-to-t from-black/40 to-transparent opacity-0 group-hover:opacity-100 transition-opacity"></div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </c:if>
                    </c:forEach>
                    
                    <c:if test="${!hasPhotos}">
                        <div class="col-span-full text-center py-12">
                            <div class="w-16 h-16 bg-gray-50 rounded-full flex items-center justify-center mx-auto mb-4">
                                <i class="fa fa-images text-2xl text-gray-300"></i>
































































        </div>
    </div>

    <!-- JS -->
    <script>
        var contextPath = "${pageContext.request.contextPath}";
        // Tab Switching Logic
        function switchTab(tabName) {
            // Hide all tab content
            document.querySelectorAll('.tab-content').forEach(el => {
                el.classList.add('hidden');
            });
            
            // Show target tab content
            const targetTab = document.getElementById('tab-content-' + tabName);
            if (targetTab) {
                targetTab.classList.remove('hidden');
            }
            
            // Update tab buttons style
            document.querySelectorAll('.tab-btn').forEach(btn => {
                btn.className = 'tab-btn px-6 py-2 rounded-xl hover:bg-white/50 font-bold text-gray-500 text-sm transition-all';
            });
            
            // Highlight active tab button
            const activeBtn = document.getElementById('btn-tab-' + tabName);
            if (activeBtn) {
                activeBtn.className = 'tab-btn px-6 py-2 rounded-xl bg-white shadow-sm font-black text-blue-600 text-sm transition-all';
            }
        }

        function openModal() {
            document.getElementById('postModal').classList.remove('hidden');
            document.getElementById('postModal').classList.































            formData.append('id', id);
            formData.append('action', type);
        } else {
            formData.append('commentId', id);
            formData.append('action', type);
            formData.append('level', level);
        }

        let emojiMap = {
            'Like': '👍', 'Love': '❤️', 'Care': '🥰', 'Haha': '😆', 
            'Wow': '😮', 'Sad': '😢', 'Angry': '😡', 'Dislike': '👎', 'Dislikes': '👎'
        };
        let colorMap = {
            'Like': 'text-blue-600', 'Love': 'text-red-500', 'Care': 'text-yellow-500', 
            'Haha': 'text-yellow-500', 'Wow': 'text-yellow-500', 'Sad': 'text-yellow-500', 
            'Angry': 'text-red-600', 'Dislike': 'text-gray-800', 'Dislikes': 'text-gray-800'
        };
        let activeEmoji = emojiMap[type] || '👍';
        let activeColor = colorMap[type] || 'text-blue-600';

        fetch(targetUrl, { 
            method: 'POST', 
            body: formData  // Content-Type header সেট করা উচিত নয়, browser নিজে multipart boundary দেবে
        })
        .then(res => {
            const contentType = res.headers.get('content-type');
            if (contentType && contentType.includes('application/json')) {
                return res.json();
            }
            return res.text().then(txt => { throw new Error('Non-JSON: ' + txt.substring(0, 200)); });
        })
        .then(data => {
            if (data.status === 'ok' || data.success) {
                // Build granular count string
                let countsHtml = '';
                if (data.counts) {
                    for (let key in data.counts) {
                        if (data.counts[key] > 0) {
                            let mappedKey = key === 'Dislikes' ? 'Dislike' : key;
                            countsHtml += `\${emojiMap[mappedKey]} <span class="text-gray-600">\${data.counts[key]}</span>&nbsp;&nbsp;`;
                        }
                    }
                    countsHtml = countsHtml.trim();
                } else {
                    countsHtml = `\${activeEmoji} <span class="text-blue-500">\${data.newCount}</span>`;
                }

                if (level === 'post') {
                    let countSpan = document.getElementById(`post-react-count-\${id}`);
                    if (countSpan) {
                        if (data.newCount > 0) {
                            countSpan.innerHTML = countsHtml;
                        } else {
                            countSpan.innerText = '0';
                        }
                    }
                    // পোস্ট বাটনে visual feedback
                    let actionBtnContent = document.getElementById(`post-action-btn-content-\${id}`);
                    if (actionBtnContent && data.newCount > 0) {
                        actionBtnContent.innerHTML = `\${activeEmoji} <span class="\${activeColor}">\${type}</span>`;
               














































                if (list) {
                    let escapedName = data.userName.replace(/'/g, "\\'");
                    let html = `
                        <div class="comment-level-1">
                            <div class="flex gap-2">
                                <a href="UsersProfileServlet?userId=\${data.userId}">
                                    <img src="img/\${data.userPic}" class="w-8 h-8 rounded-full border clickable" width="30px">
                                </a>
                                <div class="bg-[#f0f2f5] px-3 py-2 rounded-2xl max-w-[90%]">
                                    <p class="font-bold text-[13px]"><a href="UsersProfileServlet?userId=\${data.userId}" class="clickable hover:underline">\${data.userName}</a></p>
                                    <p class="text-[14px]">\${data.text}</p>
                                    \${data.fileName ? '<img src="img/' + data.fileName + '" class="w-full h-auto rounded-lg mt-2 border">' : ''}
                                </div>
                            </div>
                            <div class="flex gap-4 ml-10 mt-1 text-[12px] font-bold text-gray-500 items-center">
                                <div class="react-container clickable">
                                    <span class="hover:text-blue-600 transition" onclick="handleAJAXReact(\${data.commentId}, 'Like', 'comment', event)">Like</span>
                                    <div class="react-box !-top-12 !p-1 !rounded-full">
                                        <span class="hover:scale-150 transition" onclick="handleAJAXReact(\${data.commentId}, 'Like', 'comment', event)">👍</span>
                                        <span class="hover:scale-150 transition" onclick="handleAJAXReact(\${data.commentId}, 'Love', 'comment', event)">❤️</span>
                                        <span class="hover:scale-150 transition" onclick="handleAJAXReact(\${data.commentId}, 'Care', 'comment', event)">🥰</span>
                                        <span class="hover:scale-150 transition" onclick="handleAJAXReact(\${data.commentId}, 'Haha', 'comment', event)">😆</span>
                                        <span class="hover:scale-150 transition" onclick="handleAJAXReact(\${data.commentId}, 'Wow', 'comment', event)">😮</span>
                                        <span class="hover:scale-150 transition" onclick="handleAJAXReact(\${data.commentId}, 'Sad', 'comment', event)">😢</span>
                                        <span class="hover:scale-150 transition" onclick="handleAJAXReact(\${data.commentId}, 'Angry', 'comment', event)">😡</span>
                                        <span class="hover:scale-150 transition" onclick="handleAJAXReact(\${data.commentId}, 'Dislike', 'comment', event)">👎</span>
                                    </div>
                                </div>
                                <span class="clickable hover:text-blue-6


































































































                removeReplyMedia(commentId);
            }
        });
    }

    // ৪. শেয়ার লজিক
    function shareAJAX(postId) {
        if(!confirm("Share this post?")) return;
        let formData = new FormData();
        formData.append("action", "SHARE");
        formData.append("postId", postId);
        fetch('InteractionServlet', { method: 'POST', body: formData })
        .then(res => res.json())
        .then(data => {
            if(data.status === 'shared') {
                alert("Shared Successfully!");
                let shareEl = document.getElementById('post-share-count-text-' + postId);
                if (shareEl) {
                    let count = parseInt(shareEl.innerText) || 0;
                    shareEl.innerText = (count + 1) + " Shares";
                }
            } else {
                alert("Share failed!");
            }
        })
        .catch(err => {
            console.error("Share error", err);
            // Fallback
            let shareEl = document.getElementById('post-share-count-text-' + postId);
            if (shareEl) {
                let count = parseInt(shareEl.innerText) || 0;
                shareEl.innerText = (count + 1) + " Shares";
            }
            alert("Shared Successfully!");
        });
    }

    // ৫. ইউআই ফাংশন
    function showReplyBox(id, targetName) {
        let el = document.getElementById('replyInputContainer-' + id);
        if(el) {
            el.classList.remove('hidden');



























    function handleUserAction(targetId, action, btn) {
        console.log("Friend Action:", action, "on Target:", targetId);
        let formData = new URLSearchParams();
        formData.append("targetId", targetId);
        formData.append("action", action);
        formData.append("ajax", "true");

        // UI Feedback
        if (btn) {
            btn.innerHTML = '<i class="fa fa-spinner fa-spin mr-2"></i> Processing...';
            btn.disabled = true;
        }

        fetch('FriendServlet', {
            method: 'POST',
            body: formData
        })
        .then(res => res.json())
        .then(data => {
            if(data.success) {
                // সাকসেস হলে ফুল রিলোড যাতে ডাটাবেজ থেকে ফ্রেশ ডাটা আসে
                location.reload();
            } else {
                alert("Action failed: " + (data.message || "Unknown error"));
                location.reload();
            }
        })
        .catch(err => {
            console.error("Action error", err);
            location.reload();
        });
    }














































































































            const file = fileInput.files[0];
            if (file) preview.src = URL.createObjectURL(file);
        });
    }
</script>


	<!-- Mobile Bottom Navigation Bar (Visible only on mobile/tablet) -->
	<nav class="lg:hidden fixed bottom-0 left-0 right-0 h-[65px] bg-white/80 backdrop-blur-md border-t border-white/20 z-[9999] flex justify-around items-center px-4 rounded-t-3xl shadow-2xl">
		<a href="UsersPostServlet" class="flex flex-col items-center gap-1 text-gray-500 hover:text-blue-500 transition">
			<i class="fa fa-house text-xl"></i>
			<span class="text-[10px] font-bold">Home</span>
		</a>
		<a href="FriendServlet" class="flex flex-col items-center gap-1 text-gray-500 hover:text-blue-500 transition">
			<i class="fa fa-user-group text-xl"></i>
			<span class="text-[10px] font-bold">Friends</span>
		</a>
		<a href="messages.jsp" class="flex flex-col items-center gap-1 text-gray-500 hover:text-blue-500 transition">
			<i class="fa-brands fa-facebook-messenger text-xl"></i>
			<span class="text-[10px] font-bold">Messenger</span>
		</a>
		<a href="UsersProfileServlet?userId=${sessionScope.userId}" class="flex flex-col items-center gap-1 text-blue-500">
			<img src="img/${ub.profile_pic}" class="w-6 h-6 rounded-full border-2 border-blue-500">
			<span class="text-[10px] font-bold">Profile</span>
		</a>
	</nav>

<script>
    (function() {
        var myName = "${ub.name}";
        var contextPath = "${pageContext.request.contextPath}";
        if (!myName || myName === "") return;

        var protocol = window.location.protocol === "https:" ? "wss://" : "ws://";
        var host = window.location.host;
        var wsUrl = protocol + host + contextPath + "/ws/user/" + encodeURIComponent(myName);
        var myName = "${ub.name}";
        var contextPath = "${pageContext.request.contextPath}";
        if (!myName || myName === "") return;

        var protocol = window.location.protocol === "https:" ? "wss://" : "ws://";
        var host = window.location.host;
        var wsUrl = protocol + host + contextPath + "/ws/user/" + encodeURIComponent(myName);
        var socket = new WebSocket(wsUrl);

        socket.onopen = function() {
            console.log("Global Real-time Notification WebSocket connected.");
        };

        socket.onmessage = function(event) {
            var data = event.data;
            if (data.startsWith("NOTIF|")) {
                var content = data.substring(6);
                showToastNotification(content);
                incrementNotificationBadge();
            } else if (data.startsWith("CHAT|")) {
                var parts = data.split("|", 3);
                var sender = parts[1];
                var msgText = parts[2];
                showToastNotification("New message from " + sender + ": " + msgText);
                incrementNotificationBadge();
            }
        };

            toast.style.padding = "16px 24px";
            toast.style.borderRadius = "16px";
            toast.style.boxShadow = "0 10px 25px rgba(0,0,0,0.2)";
            toast.style.zIndex = "999999";
            toast.style.fontFamily = "'Outfit', sans-serif";
            toast.style.fontSize = "14px";
            toast.style.display = "flex";
            toast.style.alignItems = "center";
            toast.style.gap = "12px";
            toast.style.transition = "all 0.3s ease";
            toast.style.transform = "translateY(50px)";
            toast.style.opacity = "0";
            
            toast.innerHTML = `<i class="fa fa-bell text-yellow-400 text-lg"></i> <span>\${message}</span>`;
            document.body.appendChild(toast);
            
            setTimeout(function() {
                toast.style.transform = "translateY(0)";
                toast.style.opacity = "1";
            }, 100);
            
            setTimeout(function() {
                toast.style.transform = "translateY(50px)";
                toast.style.opacity = "0";
                setTimeout(function() {
                    toast.remove();
                }, 300);
            }, 5000);
        }

        function incrementNotificationBadge() {
            var notificationLinks = document.querySelectorAll('a[href="NotificationServlet"]');
            notificationLinks.forEach(function(link) {
                var badge = link.querySelector('span.bg-red-600');
                if (badge) {
                    var currentVal = parseInt(badge.innerText) || 0;
                    badge.
        function incrementNotificationBadge() {
            var notificationLinks = document.querySelectorAll('a[href="NotificationServlet"]');
            notificationLinks.forEach(function(link) {
                var badge = link.querySelector('span.bg-red-600');
                if (badge) {
                    var currentVal = parseInt(badge.innerText) || 0;
                    badge.innerText = currentVal + 1;
                } else {
                    var newBadge = document.createElement("span");
                    newBadge.className = "absolute -top-1 -right-1 bg-red-600 text-white text-[10px] px-1.5 rounded-full border-2 border-white font-bold";
                    newBadge.innerText = "1";
                    link.appendChild(newBadge);
                }
            });
        }
    })();
</script>

</body>
</html>

















                                        action: 'VIEW_POST',
                                        postId: postId
                                    })
                                }).then(response => response.json())
                                  .then(data => {
                                      const viewsSpan = document.getElementById('post-views-' + postId);
                                      if (viewsSpan) {
                                          const currentViews = parseInt(viewsSpan.innerText) || 0;
                                          viewsSpan.innerText = currentViews + 1;
                                      }
                                  }).catch(err => console.error("Error logging view for post " + postId, err));
                            }, 1000);
                        }
                    } else {
                        const postCard = entry.target;
                        if (postCard.viewTimeout) {
                            clearTimeout(postCard.viewTimeout);
                            postCard.viewTimeout = null;
                            const postId = postCard.getAttribute('data-post-id');
                            if (postId) {
                                viewedPosts.delete(postId);
                            }
                        }
                    }
                });
            }, observerOptions);

            document.querySelectorAll('.post-card').forEach(card => {
                observer.observe(card);
            });
        });
    })();
</script>

</body>
</html>
