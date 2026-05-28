<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Y-Chat Marketplace</title>
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
                <input name="query" placeholder="Search Y-Chat" class="bg-transparent outline-none w-full text-sm font-medium">
            </form>
        </div>

        <!-- CENTER SECTION (Navigation Links) -->
        <div class="hidden lg:flex flex-1 justify-center gap-12 text-[24px] text-gray-500">























































































































                                            <c:otherwise>
                                                <div class="w-full h-full flex items-center justify-center text-gray-400 bg-gray-100/30">
                                                    <i class="fa fa-image text-4xl"></i>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                        <span class="absolute top-3 right-3 bg-blue-600 text-white font-extrabold px-3 py-1 rounded-full text-xs shadow-md">
                                            $${item.price}
                                        </span>
                                    </div>
                                    
                                    <!-- Content -->
                                    <div class="p-4">
                                        <h3 class="text-base font-extrabold text-gray-800 line-clamp-1">${item.title}</h3>
                                        <p class="text-gray-600 text-xs mt-1.5 line-clamp-2 leading-relaxed">${item.description}</p>
                                    </div>
                                </div>

                                <!-- Footer/Seller Details -->
                                <div class="p-4 border-t border-white/20 bg-white/20 flex items-center justify-between">
                






























                <i class="fa fa-times"></i>
            </button>
            <h2 class="text-2xl font-extrabold text-gray-800 mb-4 flex items-center gap-2">
                🛍️ List Product for Sale
            </h2>
            <form action="MarketServlet" method="post" enctype="multipart/form-data" class="space-y-4">
                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-1">Product Title</label>
                    <input type="text" name="title" required placeholder="e.g. iPhone 15 Pro Max" class="w-full px-4 py-2.5 rounded-xl bg-white/60 border border-gray-200 outline-none focus:border-blue-500 focus:bg-white transition">
                </div>
                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-1">Price ($)</label>
                    <input type="number" step="0.01" name="price" required placeholder="0.00" class="w-full px-4 py-2.5 rounded-xl bg-white/60 border border-gray-200 outline-none focus:border-blue-500 focus:bg-white transition">
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
