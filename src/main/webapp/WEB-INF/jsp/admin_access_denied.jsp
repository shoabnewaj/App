<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Access Denied | Y-ChatApp Admin</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/icons/icon-192.png">
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;800&display=swap" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(-45deg, #1e293b, #0f172a, #312e81, #1e1b4b);
            background-size: 400% 400%;
            animation: gradient 12s ease infinite;
            font-family: 'Outfit', sans-serif;
            min-height: 100vh;
        }
        @keyframes gradient {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }
    </style>
</head>
<body class="flex items-center justify-center p-4">
    <div class="max-w-md w-full bg-slate-900/80 backdrop-blur-xl border border-white/10 rounded-3xl p-8 text-center shadow-2xl text-white space-y-6">
        <div class="w-20 h-20 mx-auto rounded-3xl bg-rose-500/20 border border-rose-500/40 flex items-center justify-center shadow-lg shadow-rose-500/20">
            <i class="fa-solid fa-shield-halved text-4xl text-rose-400"></i>
        </div>

        <div class="space-y-2">
            <h1 class="text-2xl font-black tracking-tight text-white">Administrator Access Required</h1>
            <p class="text-sm text-slate-300">
                You are signed in as <span class="font-bold text-rose-400"><c:out value="${userEmail}"/></span>. This account does not possess administrator permissions to access the Admin Dashboard.
            </p>
        </div>

        <div class="p-4 rounded-2xl bg-white/5 border border-white/10 text-xs text-slate-300 text-left space-y-1.5">
            <p class="font-bold text-white flex items-center gap-1.5">
                <i class="fa-solid fa-circle-info text-blue-400"></i> Administrator Accounts:
            </p>
            <p class="font-mono text-slate-300">• admin@gmail.com</p>
            <p class="font-mono text-slate-300">• shoabnewaj81@gmail.com</p>
            <p class="font-mono text-slate-300">• newaj@xxx.jp</p>
        </div>

        <div class="space-y-3 pt-2">
            <a href="${pageContext.request.contextPath}/UsersLogoutServlet" 
               class="w-full py-3.5 px-4 bg-gradient-to-r from-rose-500 to-amber-500 hover:from-rose-600 hover:to-amber-600 text-white font-bold rounded-2xl shadow-lg shadow-rose-500/25 flex items-center justify-center gap-2 transition-all">
                <i class="fa-solid fa-right-to-bracket"></i> Switch to Admin Account
            </a>

            <a href="${pageContext.request.contextPath}/UsersPostServlet" 
               class="w-full py-3 px-4 bg-white/10 hover:bg-white/20 text-slate-200 font-semibold rounded-2xl border border-white/10 flex items-center justify-center gap-2 transition-all">
                <i class="fa-solid fa-house"></i> Return to Feed
            </a>
        </div>
    </div>
</body>
</html>
