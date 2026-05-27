<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Notifications | Y-ChatApp</title>
    <link rel="icon" type="image/png" href="<%=request.getContextPath()%>/icons/icon-192.png">
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family: 'Segoe UI', sans-serif; display: flex; background: #f0f2f5; height: 100vh; overflow: hidden; }
        .sidebar { width: 260px; height: 100vh; background: white; padding: 20px; border-right: 1px solid #ddd; position: fixed; display: flex; flex-direction: column; justify-content: space-between; }
        .logo { font-size: 22px; font-weight: bold; color: purple; margin-bottom: 25px; }
        .menu a { display: block; padding: 12px; text-decoration: none; color: #555; border-radius: 10px; margin-bottom: 5px; }
        .menu a:hover, .active-menu { background: #f3e8ff; color: purple !important; }
        .main { flex: 1; margin-left: 260px; padding: 40px; overflow-y: auto; display: flex; flex-direction: column; align-items: center; }
        .notif-container { width: 100%; max-width: 600px; background: white; padding: 25px; border-radius: 15px; box-shadow: 0 4px 10px rgba(0,0,0,0.05); }
        .notif-item { display: flex; justify-content: space-between; align-items: center; padding: 15px; border-bottom: 1px solid #eee; }
        .notif-lef



















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
                <input name="query" placeholder="Search Y-Chat" class="bg-transparent outline-none w-full text-sm font-medium">
            </form>
        </div>

        <!-- CENTER SECTION (Navigation Links) -->






























































































                var emptyMsg = container.querySelector('p');
                if (emptyMsg && emptyMsg.innerText.includes("No new notifications")) {
                    emptyMsg.remove();
                }

                var item = document.createElement("div");
                item.className = "notif-item";
                
                var emoji = "🔔";
                if (message.includes("reacted") || message.includes("liked")) emoji = "👍";
                else if (message.includes("friend request")) emoji = "👥";
                else if (message.includes("accepted")) emoji = "🤝";
                else if (message.includes("message")) emoji = "💬";
                else if (message.includes("commented")) emoji = "📝";
                else if (message.includes("replied")) emoji = "↩️";
                else if (message.includes("shared")) emoji = "🔄";

                item.innerHTML = `
                    <div class="notif-left">
                        <div class="notif-icon">\${emoji}</div>
                        <div>
                            <p style="color: #333; font-size: 15px;">\${message}</p>
                            <small style="color: #999;">Just now</small>
                        </div>
                    </div>
                    <a href="NotificationServlet?action=delete&msg=\${encodeURIComponent(message)}" class="delete-btn" onclick="return confirm('Delete this notification?')">×</a>
                `;
                
                // Insert after the h2 header
                var h2 = container.querySelector('h2');
                h2.insertAdjacentElement('afterend', item);
            }
        }
    })();
</script>

</body>
</html>