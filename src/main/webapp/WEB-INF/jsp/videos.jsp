<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Y-Chat Watch</title>
    <link rel="icon" type="image/png" href="<%=request.getContextPath()%>/icons/icon-192.png">
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;800&display=swap" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(-45deg, #ee7752, #e73c7e, #23a6d5, #23d5ab);
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
            background: rgba(255, 255, 255, 0.75) !important;
            backdrop-filter: blur(12px) !important;
            border: 1px solid rgba(255, 255, 255, 0.3) !important;
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.15) !important;
       


































    <!-- HEADER -->
    <header class="glass-nav h-[56px] sticky top-0 z-[5000] flex items-center justify-between px-4">
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
        </div>














































































































































































































































































            <span class="text-[10px] font-bold">Friends</span>
        </a>
        <a href="UsersPostServlet?showReels=true" class="flex flex-col items-center gap-1 text-gray-500 hover:text-blue-500 transition">
            <i class="fa fa-clapperboard text-xl"></i>
            <span class="text-[10px] font-bold">Reels</span>
        </a>
        <a href="UsersPostServlet?showCreateReel=true" class="flex flex-col items-center justify-center -mt-5 w-11 h-11 bg-gradient-to-tr from-orange-500 via-pink-500 to-red-500 rounded-full text-white shadow-lg border-2 border-white hover:scale-110 active:scale-95 transition-all" title="Create Reel">
            <i class="fa fa-plus text-lg"></i>
        </a>
        <a href="messages.jsp" class="flex flex-col items-center gap-1 text-gray-500 hover:text-blue-500 transition">
            <i class="fa-brands fa-facebook-messenger text-xl"></i>
            <span class="text-[10px] font-bold">Messenger</span>
        </a>
        <a href="UsersProfileServlet?userId=${sessionScope.userId}" class="flex flex-col items-center gap-1 text-gray-500 hover:text-blue-500 transition">
            <img src="img/${ub.profile_pic}" class="w-6 h-6 rounded-full border border-gray-300 font-bold">
            <span class="text-[10px] font-bold">Profile</span>
        </a>
    </nav>

    <!-- Scripts -->
    <script>
        function previewFile(e) {
            const file = e.target.files[0];
            if (file) {
                document.getElementById('uploadPlaceholder').classList.add('hidden');
                document.getElementById('filePreview').classList.remove('hidden');
                document.getElementById('fileNameSpan').innerText = file.name;
            }
        }

        function reactPost(postId, reactionType) {
            const formData = new FormData();
            formData.append("postId", postId);
            formData.append("action", reactionType);

            fetch('InteractionServlet', {
                method: 'POST',
                body: formData
            })
            .then(res => res.json())
            .then(data => {
                if (data.status === 'ok') {
                    document.getElementById(`reactCount-${postId}`).innerText = `${data.newCount} reactions`;
                }
            })
            .catch(err => console.error(err));
        }

        function sharePost(postId) {
            const formData = new FormData();
            formData.append("postId", postId);
            formData.append("action", "SHARE");

            fetch('InteractionServlet', {
                method: 'POST',
                body: formData
            })
            .then(res => res.json())
            .then(data => {
                if (data.status === 'shared') {
                    alert("Post shared successfully to your feed!");
                    window.location.reload();
                }
            })
            .catch(err => console.error(err));
        }

        function handleAJAXReact(id, type, level, event) {
            if (event) event.stopPropagation();
            let targetUrl = '${pageContext.request.contextPath}/CommentServlet';
            let formData = new FormData();
            formData.append('commentId', id);
            formData.append('action', type);
            formData.append('level', level);

            let emojiMap = {
                'Like': '👍', 'Love': '❤️', 'Care': '🥰', 'Haha': '😆', 
                'Wow': '😮', 'Sad': '😢', 'Angry': '😡', 'Dislike': '👎'
            };

            fetch(targetUrl, { 
                method: 'POST', 
                body: formData
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    let countsHtml = '';
                    if (data.counts) {
                        for (let key in data.counts) {
                            if (data.counts[key] > 0) {
                                let mappedKey = key === 'Dislikes' ? 'Dislike' : key;
                                countsHtml += `${emojiMap[mappedKey]} <span class="text-gray-600">${data.counts[key]}</span>&nbsp;&nbsp;`;
                            }
                        }
                        countsHtml = countsHtml.trim();
                    }
                    let container = document.getElementById(`comment-react-container-${id}`);
                    if (container) {
                        container.innerHTML = countsHtml || '';
                    }
                }
            })
            .catch(err => console.error(err));
        }

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
                    badge.innerText = currentVal + 1;
                } else {
                    var newBadge = document.createElement("span");
                    newBadge.className = "absolute -top-1 -right-1 bg-red-600 text-white text-[11px] px-1.5 rounded-full border-2 border-white font-bold";
                    newBadge.innerText = "1";
                    link.appendChild(newBadge);
                }
            });
        }
    })();
</script>

</body>
</html>

                                        </div>
                                        <div id="comment-react-container-${data.commentId}" class="text-[9px] font-normal text-gray-400"></div>
                                    </div>
                                </div>
                            </div>`;
                        list.insertAdjacentHTML('beforeend', html);
                        list.scrollTop = list.scrollHeight;
                    }
                    input.value = '';
                }
            })
            .catch(err => console.error(err));
        }
    </script>

    <!-- WebSockets Real-time Notification System -->
    <script>
        (function() {
            var myName = "${ub.name}";
            var contextPath = "${pageContext.request.contextPath}";