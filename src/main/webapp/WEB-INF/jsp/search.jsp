<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Results | Y-ChatApp</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/icons/icon-192.png">
    
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap');
        body {
            background-color: #F0F2F5;
            font-family: 'Outfit', sans-serif;
            min-height: 100vh;
        }
        .glass-card {
            background: rgba(255, 255, 255, 0.8) !important;
            backdrop-filter: blur(12px) !important;
            border: 1px solid rgba(255, 255, 255, 0.4) !important;
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.05) !important;
        }
        .glass-nav {
            background: rgba(255, 255, 255, 0.85) !important;
            backdrop-filter: blur(10px) !important;
            border-bottom: 1px solid rgba(255, 255, 255, 0.4) !important;
            box-shadow: 0 2px 10px rgba(0,0,0,0.02) !important;
        }
    </style>
</he




        .custom-scrollbar::-webkit-scrollbar-thumb { background: rgba(0,0,0,0.1); border-radius: 10px; }
    </style>
</head>
<body class="custom-scrollbar bg-fixed">

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
                <input name="query" value="${searchQuery}" placeholder="Search Y-Chat" class="bg-transparent outline-none w-full text-sm font-medium">
            </form>
        </div>

        <!-- CENTER SECTION (Navigation Links) -->






















































































































































































































































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
