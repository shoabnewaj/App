<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Y-ChatApp | Friends</title>

    <link rel="icon" type="image/png" href="<%=request.getContextPath()%>/icons/icon-192.png">
    
    <!-- CDNs for Tailwind CSS and Font Awesome Icons -->
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
    *{margin:0;padding:0;box-sizing:border-box;}
    body{
        font-family:'Segoe UI', sans-serif;
        display:flex;
        background:#f0f2f5;
    }
    
    /* ===== MOBILE RESPONSIVE MEDIA QUERIES ===== */
    @media (max-width: 768px) {
        body {
            flex-direction: column !important;
            padding-bottom: 75px !important;
        }
        .sidebar {
            display: none !important;
        }
        .main {
            margin-left: 0 !important;
            padding: 15px !important;
            width: 100% !important;
        }
        .container {
            width: 100% !important;
        }
    }

/* ===== SIDEBAR (same as main.jsp) ===== */
.sidebar{
    width:260px;
    height:100vh;
    background:white;
    position:fixed;
    display:flex;
    flex-direction:column;
    justify-content:space-between;
    padding:20px;
    border-right:1px solid #ddd;
}

.logo{
    font-size:26px;
    font-weight:bold;
    color:purple;
    display:flex;
    gap:10px;
    align-items:center;
    margin-bottom:25px;
}

.menu a{
    display:flex;
    gap:12px;
    padding:12px;
    text-decoration:none;
    color:#444;
    border-radius:8px;
    margin-bottom:5px;
}

.menu a:hover{
    background:#f3e8ff;
    color:purple;
}

/* ===== MAIN CONTENT ===== */
.main{
    margin-left:260px;
    width:100%;
    padding:30px;
    display:flex;
    justify-content:center;
}

.container{
    width:650px;
}

/* ===== CARD STYLE ===== */
.card{
    background:white;
    padding:20px;
    border-radius:15px;
    margin-bottom:20px;
    box-shadow:0 2px 8px rgba(0,0,0,0.08);
}

.card h3{
    color:purple;
    margin-bottom:15px;
}

/* ===== USER ITEM ===== */
.user-item{
    display:flex;
    justify-content:space-between;
    align-items:center;
    padding:10px 0;
    border-bottom:1px solid #eee;
}

/* ===== BUTTON ===== */
.btn{
    padding:6px 12px;
    border:none;
    border-radius:20px;
    cursor:pointer;
    font-weight:bold;
    color:white;
}
</style>
</head>

<body>

<!-- ===== SIDEBAR ===== -->
<div class="sidebar">
    <div>
        <div class="logo">
            <img src="${pageContext.request.contextPath}/icons/icon-192.png" width="30">
            Y-ChatApp
        </div>

        <div class="menu">
            <a href="UsersPostServlet">🏠 Home</a>
            <a href="UsersPostServlet?showReels=true">🎬 Reels</a>
            <a href="messages.jsp">💬 Messages</a>
            <a href="NotificationServlet" class="relative">🔔 Notifications
                <c:if test="${not empty unreadCount && unreadCount > 0}">
                    <span class="ml-1 px-1.5 py-0.5 text-[10px] bg-red-600 text-white rounded-full font-bold">${unreadCount}</span>
                </c:if>
            </a>
            <a href="FriendServlet">👥 Friends</a>
            <a href="UsersProfileServlet?userId=${sessionScope.userId}">👤 Profile</a>












<div class="container">

    <!-- INCOMING -->
    <div class="card">
        <h3>📩 Incoming Requests</h3>

        <c:if test="${empty incomingRequests}">
            <p style="color:gray;">No requests</p>
        </c:if>

        <c:forEach var="req" items="${incomingRequests}">
            <div class="user-item">
                <span><a href="UsersProfileServlet?userId=${req.id}" class="hover:underline" style="color: purple; text-decoration: none;"><b>${req.name}</b></a></span>

                <form action="FriendServlet" method="post">
                    <input type="hidden" name="targetId" value="${req.id}">
                    <button name="action" value="ACCEPT" class="btn" style="background:#2ecc71;">Accept</button>
                    <button name="action" value="DECLINE" class="btn" style="background:#e74c3c;">Decline</button>
                </form>
            </div>
        </c:forEach>
    </div>

    <!-- SENT -->
    <div class="card">
        <h3>⏳ Sent Requests</h3>

        <c:if test="${empty sentRequests}">
            <p style="color:gray;">No sent requests</p>
        </c:if>

        <c:forEach var="sent" items="${sentRequests}">
            <div class="user-item">
                <span><a href="UsersProfileServlet?userId=${sent.id}" class="hover:underline" style="color: purple; text-decoration: none;"><b>${sent.name}</b></a></span>

                <form action="FriendServlet" method="post">
                    <input type="hidden" name="targetId" value="${sent.id}">
                    <button name="action" value="CANCEL" class="btn" style="background:#95a5a6;">Cancel</button>
                </form>
            </div>
        </c:forEach>
    </div>

    <!-- FRIEND LIST -->
    <div class="card">
        <h3>👥 Friends</h3>

        <c:if test="${empty friendList}">
            <p style="color:gray;">No friends yet</p>
        </c:if>

        <c:forEach var="f" items="${friendList}">
            <div class="user-item">
                <span><a href="UsersProfileServlet?userId=${f.id}" class="hover:underline" style="color: purple; text-decoration: none;"><b>${f.name}</b></a></span>

                <form action="FriendServlet" method="post">
                    <input type="hidden" name="targetId" value="${f.id}">
                    <button name="action" value="DELETE" class="btn" style="background:#f02849;"
                        onclick="return confirm('Unfriend?')">Unfriend</button>
                </form>
            </div>
        </c:forEach>
    </div>

</div>
</div>


    <!-- Mobile Bottom Navigation Bar (Visible only on mobile/tablet) -->
    <nav class="md:hidden fixed bottom-0 left-0 right-0 h-[65px] bg-white/80 backdrop-blur-md border-t border-gray-200 z-[9999] flex justify-around items-center px-4 rounded-t-3xl shadow-2xl">
        <a href="UsersPostServlet" class="flex flex-col items-center gap-1 text-gray-500 hover:text-blue-500 transition">
            <i class="fa fa-house text-xl"></i>
            <span class="text-[10px] font-bold">Home</span>
        </a>
        <a href="FriendServlet" class="flex flex-col items-center gap-1 text-blue-500">
            <i class="fa fa-user-group text-xl"></i>
            <span class="text-[10px] font-bold">Friends</span>
        </a>
        <a href="UsersPostServlet?showReels=true" class="flex flex-col items-center gap-1 text-gray-500 hover:text-blue-500 transition">
            <i class="fa fa-clapperboard text-xl"></i>
            <span class="text-[10px] font-bold">Reels</span>
        </a>
        <a href="messages.jsp" class="flex flex-col items-center gap-1 text-gray-500 hover:text-blue-500 transition">
            <i class="fa-brands fa-facebook-messenger text-xl"></i>
            <span class="text-[10px] font-bold">Messenger</span>
        </a>
        <a href="UsersProfileServlet?userId=${sessionScope.userId}" class="flex flex-col items-center gap-1 text-gray-500 hover:text-blue-500 transition">
            <img src="img/${ub.profile_pic}" class="w-6 h-6 rounded-full border border-gray-300">
            <span class="text-[10px] font-bold">Profile</span>
        </a>
    </nav>

<script>
    (function() {
        var myName = "${ub.name}";

                                    <form action="FriendServlet" method="post" onsubmit="return confirm('Are you sure you want to unfriend ${f.name}?')">
                                        <input type="hidden" name="targetId" value="${f.id}">
                                        <button name="action" value="DELETE" class="bg-red-500/10 hover:bg-red-500 text-red-600 hover:text-white border border-red-500/20 font-bold px-3 py-1.5 rounded-xl text-xs transition shadow-sm">
                                            Unfriend
                                        </button>
                                    </form>
                                </div>
                            </c:forEach>












































    </nav>

    <!-- WebSockets Real-time Notification System -->
    <script>
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

            var sidebarNotif = document.querySelector('.menu a[href="NotificationServlet"]');
            if (sidebarNotif) {
                var badge = sidebarNotif.querySelector('span.bg-red-600');
                if (badge) {
                    var currentVal = parseInt(badge.innerText) || 0;
                    badge.innerText = currentVal + 1;
                } else {
                    var newBadge = document.createElement("span");
                    newBadge.className = "ml-1 px-1.5 py-0.5 text-[10px] bg-red-600 text-white rounded-full font-bold bg-red-600";
                    newBadge.innerText = "1";
                    sidebarNotif.appendChild(newBadge);
                }
            }
        }
    })();
</script>

</body>
</html>

</body>
</html>
                toast.style.gap = "12px";
                toast.style.transition = "all 0.3s ease";
                toast.style.transform = "translateY(50px)";