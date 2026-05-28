<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Y-ChatApp | Admin Dashboard</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/icons/icon-192.png">
    
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
            min-height: 100vh;
        }

        @keyframes gradient {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        /* Glassmorphism utility */
        .glass-panel {
            background: rgba(15, 23, 42, 0.85);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.3), 0 10px 10px -5px rgba(0, 0, 0, 0.3);
        }
        
        .glass-card {
            background: rgba(30, 41, 59, 0.7);
            backdrop-filter: blur(8px);
            -webkit-backdrop-filter: blur(8px);
            border: 1px solid rgba(255, 255, 255, 0.08);
            transition: all 0.3s ease;
        }

        .glass-card:hover {
            transform: translateY(-5px);
            background: rgba(30, 41, 59, 0.85);
            border-color: rgba(255, 255, 255, 0.15);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.4);
        }
    </style>
</head>
<body class="text-white p-4 md:p-8">
    <div class="max-w-7xl mx-auto space-y-8">
        
        <!-- HEADER PANEL -->
        <header class="glass-panel rounded-2xl p-6 flex flex-col md:flex-row justify-between items-center gap-4">
            <div class="flex items-center gap-3">
                <div class="w-12 h-12 rounded-xl bg-gradient-to-tr from-rose-500 to-amber-500 flex items-center justify-center shadow-lg shadow-rose-500/20">
                    <i class="fa-solid fa-user-shield text-2xl text-white animate-pulse"></i>
                </div>
                <div>
                    <h1 class="text-2xl font-bold tracking-tight bg-gradient-to-r from-white to-white/70 bg-clip-text text-transparent">
                        Admin Dashboard
                    </h1>
                    <p class="text-xs text-white/50">Manage users, view stats, and handle policy claims</p>
                </div>
            </div>
            <div class="flex items-center gap-4">
                <div class="flex items-center gap-2 bg-white/5 px-3 py-1.5 rounded-xl border border-white/10">
                    <img src="${pageContext.request.contextPath}/uploads/${not empty ub.profile_pic ? ub.profile_pic : 'default.png'}" 
                         class="w-7 h-7 rounded-full object-cover border border-white/20" alt="Admin">
                    <span class="text-sm font-semibold text-white/90"><c:out value="${ub.name}"/></span>
                </div>
                <a href="${pageContext.request.contextPath}/UsersPostServlet" 
                   class="px-4 py-2 bg-gradient-to-r from-blue-500 to-indigo-600 hover:from-blue-600 hover:to-indigo-700 text-white rounded-xl text-sm font-semibold transition-all shadow-md shadow-blue-500/10 flex items-center gap-2">
                    <i class="fa-solid fa-house"></i> Home Feed
                </a>
            </div>
        </header>

        <!-- STATS GRID -->
        <section class="grid grid-cols-2 md:grid-cols-5 gap-4">
            <!-- Total Users -->
            <div class="glass-card rounded-2xl p-5 flex flex-col justify-between min-h-[120px]">
                <div class="flex justify-between items-start">
                    <span class="text-sm font-semibold text-white/50">Total Users</span>
                    <span class="p-2 rounded-lg bg-blue-500/10 border border-blue-500/20 text-blue-400">
                        <i class="fa-solid fa-users"></i>
                    </span>
                </div>
                <span class="text-3xl font-extrabold tracking-tight mt-2"><c:out value="${totalUsers}"/></span>
            </div>
            <!-- Total Posts -->
            <div class="glass-card rounded-2xl p-5 flex flex-col justify-between min-h-[120px]">
                <div class="flex justify-between items-start">
                    <span class="text-sm font-semibold text-white/50">Total Posts</span>
                    <span class="p-2 rounded-lg bg-pink-500/10 border border-pink-500/20 text-pink-400">
                        <i class="fa-solid fa-file-invoice"></i>
                    </span>
                </div>
                <span class="text-3xl font-extrabold tracking-tight mt-2"><c:out value="${totalPosts}"/></span>
            </div>
            <!-- Total Reels -->
            <div class="glass-card rounded-2xl p-5 flex flex-col justify-between min-h-[120px]">
                <div class="flex justify-between items-start">
                    <span class="text-sm font-semibold text-white/50">Total Reels</span>
                    <span class="p-2 rounded-lg bg-amber-500/10 border border-amber-500/20 text-amber-400">
                        <i class="fa-solid fa-video"></i>
                    </span>
                </div>
                <span class="text-3xl font-extrabold tracking-tight mt-2"><c:out value="${totalReels}"/></span>
            </div>
            <!-- Total Groups -->
            <div class="glass-card rounded-2xl p-5 flex flex-col justify-between min-h-[120px]">
                <div class="flex justify-between items-start">
                    <span class="text-sm font-semibold text-white/50">Total Groups</span>
                    <span class="p-2 rounded-lg bg-emerald-500/10 border border-emerald-500/20 text-emerald-400">
                        <i class="fa-solid fa-people-group"></i>
                    </span>
                </div>
                <span class="text-3xl font-extrabold tracking-tight mt-2"><c:out value="${totalGroups}"/></span>
            </div>
            <!-- Total Market Items -->
            <div class="glass-card rounded-2xl p-5 flex flex-col justify-between min-h-[120px] col-span-2 md:col-span-1">
                <div class="flex justify-between items-start">
                    <span class="text-sm font-semibold text-white/50">Market Items</span>
                    <span class="p-2 rounded-lg bg-purple-500/10 border border-purple-500/20 text-purple-400">
                        <i class="fa-solid fa-store"></i>
                    </span>
                </div>
                <span class="text-3xl font-extrabold tracking-tight mt-2"><c:out value="${totalMarketItems}"/></span>
            </div>
        </section>

        <!-- USERS TABLE CONTAINER -->
        <main class="glass-panel rounded-2xl p-6">
            <div class="flex flex-col md:flex-row justify-between items-center gap-4 mb-6">
                <h2 class="text-xl font-bold flex items-center gap-2">
                    <i class="fa-solid fa-users-gear text-blue-400"></i> Registered Users
                </h2>
                <!-- Search Box -->
                <div class="relative w-full md:w-80">
                    <span class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none text-white/50">
                        <i class="fa-solid fa-magnifying-glass"></i>
                    </span>
                    <input type="text" id="userSearch" placeholder="Search by name or email..." 
                           class="w-full bg-slate-950/40 border border-white/10 rounded-xl py-2 pl-10 pr-4 text-white placeholder-white/40 focus:outline-none focus:ring-2 focus:ring-blue-500/50 text-sm">
                </div>
            </div>

            <!-- Success/Error Messages for Users -->
            <c:if test="${param.msg == 'success'}">
                <div class="bg-green-500/20 border border-green-500/40 text-green-200 px-4 py-3 rounded-xl mb-6 flex items-center gap-2 text-sm">
                    <i class="fa-solid fa-circle-check"></i> User deleted successfully.
                </div>
            </c:if>
            <c:if test="${param.msg == 'error'}">
                <div class="bg-red-500/20 border border-red-500/40 text-red-200 px-4 py-3 rounded-xl mb-6 flex items-center gap-2 text-sm">
                    <i class="fa-solid fa-circle-xmark"></i> An error occurred. Please try again.
                </div>
            </c:if>

            <!-- Table -->
            <div class="overflow-x-auto rounded-xl border border-white/10">
                <table class="w-full text-left border-collapse">
                    <thead>
                        <tr class="bg-white/10 text-white/80 text-xs font-semibold uppercase tracking-wider border-b border-white/10">
                            <th class="py-4 px-6">ID</th>
                            <th class="py-4 px-6">Name</th>
                            <th class="py-4 px-6">Email</th>
                            <th class="py-4 px-6">Role</th>
                            <th class="py-4 px-6 text-center">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="u" items="${allUsers}">
                            <tr class="border-b border-white/10 hover:bg-white/5 transition user-row">
                                <td class="py-4 px-6 text-white font-semibold">#<c:out value="${u.id}"/></td>
                                <td class="py-4 px-6">
                                    <div class="flex items-center gap-3">
                                        <img src="${pageContext.request.contextPath}/uploads/${not empty u.profile_pic ? u.profile_pic : 'default.png'}" 
                                             class="w-10 h-10 rounded-full object-cover border border-white/20" alt="Profile">
                                        <span class="text-white font-medium search-name"><c:out value="${u.name}"/></span>
                                    </div>
                                </td>
                                <td class="py-4 px-6 text-white/80 search-email"><c:out value="${u.email}"/></td>
                                <td class="py-4 px-6 text-white/60">
                                    <span class="px-2.5 py-1 rounded-full text-xs font-semibold bg-blue-500/20 text-blue-200 border border-blue-500/30">
                                        USER
                                    </span>
                                </td>
                                <td class="py-4 px-6 text-center">
                                    <div class="flex justify-center gap-2">
                                        <!-- View Profile -->
                                        <a href="${pageContext.request.contextPath}/UsersProfileServlet?userId=${u.id}" 
                                           class="bg-blue-600/20 hover:bg-blue-600/40 border border-blue-500/30 text-blue-200 px-3 py-1.5 rounded-lg text-xs font-semibold flex items-center gap-1.5 transition-colors">
                                            <i class="fa-solid fa-user"></i> Profile
                                        </a>
                                        <!-- Delete User -->
                                        <a href="AdminServlet?action=delete&userId=${u.id}" 
                                           onclick="return confirmDelete('${u.name}')" 
                                           class="px-3 py-1.5 rounded-lg bg-rose-500/20 hover:bg-rose-500 text-rose-200 hover:text-white border border-rose-500/30 transition text-sm flex items-center gap-1">
                                            <i class="fa-solid fa-trash-can"></i> Delete
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty allUsers}">
                            <tr>
                                <td colspan="5" class="py-8 text-center text-white/50">
                                    No registered users found.
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </main>

        <!-- CLAIMS CONTAINER -->
        <main class="glass-panel rounded-2xl p-6 mt-8">
            <div class="flex flex-col md:flex-row justify-between items-center gap-4 mb-6">
                <h2 class="text-xl font-bold flex items-center gap-2">
                    <i class="fa-solid fa-circle-exclamation text-rose-400"></i> User Policy Claims & Data Erasure Requests
                </h2>
            </div>

            <!-- Success/Error Messages for Claims -->
            <c:if test="${param.msg == 'claim_resolved'}">
                <div class="bg-green-500/20 border border-green-500/40 text-green-200 px-4 py-3 rounded-xl mb-6 flex items-center gap-2 text-sm">
                    <i class="fa-solid fa-circle-check"></i> Claim resolved successfully.
                </div>
            </c:if>
            <c:if test="${param.msg == 'claim_deleted'}">
                <div class="bg-blue-500/20 border border-blue-500/40 text-blue-200 px-4 py-3 rounded-xl mb-6 flex items-center gap-2 text-sm">
                    <i class="fa-solid fa-circle-check"></i> Claim deleted successfully.
                </div>
            </c:if>

            <!-- Table -->
            <div class="overflow-x-auto rounded-xl border border-white/10">
                <table class="w-full text-left border-collapse">
                    <thead>
                        <tr class="bg-white/10 text-white/80 text-xs font-semibold uppercase tracking-wider border-b border-white/10">
                            <th class="py-4 px-6">ID</th>
                            <th class="py-4 px-6">Submitter</th>
                            <th class="py-4 px-6">Email</th>
                            <th class="py-4 px-6">Type</th>
                            <th class="py-4 px-6">Description</th>
                            <th class="py-4 px-6">Status</th>
                            <th class="py-4 px-6 text-center">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="claim" items="${allClaims}">
                            <tr class="border-b border-white/10 hover:bg-white/5 transition">
                                <td class="py-4 px-6 text-white font-semibold">#<c:out value="${claim.id}"/></td>
                                <td class="py-4 px-6 text-white font-medium">
                                    <c:choose>
                                        <c:when test="${not empty claim.userName}">
                                            <c:out value="${claim.userName}"/>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-white/40 italic">Guest</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="py-4 px-6 text-white/80"><c:out value="${claim.email}"/></td>
                                <td class="py-4 px-6">
                                    <span class="px-2.5 py-1 rounded-full text-xs font-semibold bg-rose-500/20 text-rose-200 border border-rose-500/30">
                                        <c:out value="${claim.claimType}"/>
                                    </span>
                                </td>
                                <td class="py-4 px-6 text-white/70 max-w-xs truncate" title="${claim.description}">
                                    <c:out value="${claim.description}"/>
                                </td>
                                <td class="py-4 px-6">
                                    <c:choose>
                                        <c:when test="${claim.status == 'RESOLVED'}">
                                            <span class="px-2.5 py-1 rounded-full text-xs font-semibold bg-green-500/20 text-green-200 border border-green-500/30">
                                                RESOLVED
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="px-2.5 py-1 rounded-full text-xs font-semibold bg-yellow-500/20 text-yellow-200 border border-yellow-500/30">
                                                PENDING
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="py-4 px-6 text-center">
                                    <div class="flex justify-center gap-2">
                                        <!-- Resolve Action -->
                                        <c:if test="${claim.status != 'RESOLVED'}">
                                            <form action="AdminServlet" method="POST" class="inline">
                                                <input type="hidden" name="action" value="resolve_claim">
                                                <input type="hidden" name="claimId" value="${claim.id}">
                                                <button type="submit" 
                                                        class="bg-emerald-500/20 hover:bg-emerald-500 border border-emerald-500/30 text-emerald-200 hover:text-white px-3 py-1.5 rounded-lg text-xs font-semibold flex items-center gap-1 transition-colors">
                                                    <i class="fa-solid fa-circle-check"></i> Resolve
                                                </button>
                                            </form>
                                        </c:if>
                                        <!-- Delete Action -->
                                        <form action="AdminServlet" method="POST" onsubmit="return confirm('Are you sure you want to delete this claim record?');" class="inline">
                                            <input type="hidden" name="action" value="delete_claim">
                                            <input type="hidden" name="claimId" value="${claim.id}">
                                            <button type="submit" 
                                                    class="bg-white/10 hover:bg-rose-500 border border-white/20 hover:border-rose-500 text-white hover:text-white px-3 py-1.5 rounded-lg text-xs font-semibold flex items-center gap-1 transition-colors">
                                                <i class="fa-solid fa-trash-can"></i> Delete
                                            </button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty allClaims}">
                            <tr>
                                <td colspan="7" class="py-8 text-center text-white/50">
                                    No policy claims or data erasure requests submitted.
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </main>
    </div>

    <!-- Confirmation & Real-time Search Scripts -->
    <script>
        function confirmDelete(userName) {
            return confirm("Warning: Deleting user '" + userName + "' will also permanently delete their posts, comments, likes, and messages. This action CANNOT be undone. Are you sure you want to proceed?");
        }

        // Live client-side search/filter
        document.getElementById('userSearch').addEventListener('input', function(e) {
            const query = e.target.value.toLowerCase().trim();
            const rows = document.querySelectorAll('.user-row');
            
            rows.forEach(row => {
                const name = row.querySelector('.search-name').textContent.toLowerCase();
                const email = row.querySelector('.search-email').textContent.toLowerCase();
                
                if (name.includes(query) || email.includes(query)) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        });
    </script>
</body>
</html>
