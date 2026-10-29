<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Y-Ads Manager | Y-ChatApp</title>
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- FontAwesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap');
        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
        }
        .glass-card {
            background: rgba(255, 255, 255, 0.75);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.4);
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.05);
        }
    </style>
</head>
<body class="p-4 md:p-8">

    <div class="max-w-6xl mx-auto space-y-8">
        
        <!-- Header -->
        <header class="flex flex-col md:flex-row md:items-center justify-between gap-4">
            <div>
                <h1 class="text-3xl font-extrabold tracking-tight bg-gradient-to-r from-blue-600 via-indigo-600 to-purple-600 bg-clip-text text-transparent">
                    Y-Ads Manager
                </h1>
                <p class="text-sm text-gray-600 mt-1">Create, launch, and manage sponsored ads across Y-ChatApp.</p>
            </div>
            
            <a href="UsersPostServlet" class="self-start md:self-auto flex items-center gap-2 px-5 py-2.5 bg-white hover:bg-gray-50 text-gray-700 font-bold rounded-2xl shadow-sm border border-gray-200 transition">
                <i class="fa fa-arrow-left"></i>
                Return to Newsfeed
            </a>
        </header>

        <!-- Message Alerts -->
        <c:if test="${param.msg == 'success'}">
            <div class="p-4 bg-green-100 border border-green-200 text-green-700 rounded-2xl flex items-center gap-3">
                <i class="fa-solid fa-circle-check text-lg"></i>
                <span class="text-sm font-semibold">Ad created successfully and launched on the sidebar feed!</span>
            </div>
        </c:if>
        <c:if test="${param.msg == 'error'}">
            <div class="p-4 bg-red-100 border border-red-200 text-red-700 rounded-2xl flex items-center gap-3">
                <i class="fa-solid fa-circle-xmark text-lg"></i>
                <span class="text-sm font-semibold">Error occurred while creating the ad. Please try again.</span>
            </div>
        </c:if>
        <c:if test="${param.msg == 'empty_title'}">
            <div class="p-4 bg-amber-100 border border-amber-200 text-amber-700 rounded-2xl flex items-center gap-3">
                <i class="fa-solid fa-triangle-exclamation text-lg"></i>
                <span class="text-sm font-semibold">Ad Title cannot be empty.</span>
            </div>
        </c:if>

        <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
            
            <!-- Left Pane: Creator Form -->
            <div class="lg:col-span-2 glass-card p-6 md:p-8 rounded-3xl space-y-6">
                <h2 class="text-xl font-bold text-gray-800 flex items-center gap-2">
                    <i class="fa-solid fa-square-plus text-blue-600"></i>
                    Launch New Campaign
                </h2>
                
                <form action="yads" method="POST" enctype="multipart/form-data" class="space-y-4">
                    <div>
                        <label class="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-2">Campaign Title *</label>
                        <input type="text" id="formTitle" name="title" required placeholder="e.g. Y-Chat Premium Features" 
                               class="w-full px-4 py-3 bg-white/60 border border-gray-200 rounded-2xl focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 outline-none transition text-sm text-gray-850"
                               oninput="updatePreview()">
                    </div>

                    <div>
                        <label class="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-2">Campaign Description</label>
                        <textarea id="formDescription" name="description" placeholder="e.g. Grow your audience and connect with people globally..." rows="3"
                                  class="w-full px-4 py-3 bg-white/60 border border-gray-200 rounded-2xl focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 outline-none transition text-sm text-gray-850"
                                  oninput="updatePreview()"></textarea>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div>
                            <label class="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-2">Target Link URL</label>
                            <input type="url" id="formLink" name="linkUrl" placeholder="e.g. https://website.com" 
                                   class="w-full px-4 py-3 bg-white/60 border border-gray-200 rounded-2xl focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 outline-none transition text-sm text-gray-850"
                                   oninput="updatePreview()">
                        </div>

                        <div>
                            <label class="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-2">Ad Image Upload</label>
                            <input type="file" id="formFile" name="adFile" accept="image/*"
                                   class="w-full px-3 py-2 bg-white/60 border border-gray-200 rounded-2xl focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 outline-none transition text-sm text-gray-500 file:mr-4 file:py-1.5 file:px-3 file:rounded-xl file:border-0 file:text-xs file:font-semibold file:bg-blue-50 file:text-blue-700 hover:file:bg-blue-100 cursor-pointer"
                                   onchange="previewImage(this)">
                        </div>
                    </div>

                    <div class="pt-4">
                        <button type="submit" class="w-full py-3 bg-gradient-to-r from-blue-600 to-indigo-600 hover:from-blue-700 hover:to-indigo-700 text-white font-bold rounded-2xl shadow-md shadow-blue-200 hover:shadow-lg transition duration-200 flex items-center justify-center gap-2">
                            <i class="fa-solid fa-rocket"></i>
                            Publish Sponsored Campaign
                        </button>
                    </div>
                </form>
            </div>

            <!-- Right Pane: Real-time Live Preview -->
            <div class="space-y-6">
                <h2 class="text-xl font-bold text-gray-800 flex items-center gap-2">
                    <i class="fa-solid fa-eye text-blue-600"></i>
                    Sidebar Preview
                </h2>
                
                <!-- Preview Card -->
                <div class="glass-card p-5 rounded-3xl border border-white shadow-xl max-w-sm">
                    <div class="flex items-center justify-between mb-4">
                        <span class="text-xs font-bold text-gray-400 uppercase tracking-widest">Sponsored</span>
                        <i class="fa fa-ellipsis-h text-gray-300"></i>
                    </div>
                    <div class="rounded-2xl overflow-hidden mb-3 relative">
                        <img id="prevImg" src="https://images.unsplash.com/photo-1611162617474-5b21e879e113?q=80&w=1000&auto=format&fit=crop" 
                             class="w-full h-32 object-cover transition duration-300">
                        <div class="absolute inset-0 bg-gradient-to-t from-black/50 to-transparent"></div>
                        <div class="absolute bottom-2 left-3 text-white text-[10px] font-bold bg-blue-600 px-2 py-0.5 rounded-full uppercase tracking-tighter">Campaign</div>
                    </div>
                    <div class="flex items-center justify-between">
                        <div class="truncate max-w-[85%]">
                            <p id="prevTitle" class="text-sm font-bold text-gray-800 truncate">Y-Ads Manager</p>
                            <p id="prevDescription" class="text-[11px] text-gray-500 truncate">Grow your business today</p>
                        </div>
                        <i class="fa fa-arrow-right text-blue-500"></i>
                    </div>
                </div>
            </div>
            
        </div>

        <!-- Section: Active Ads List -->
        <div class="glass-card p-6 md:p-8 rounded-3xl space-y-6">
            <h2 class="text-xl font-bold text-gray-800 flex items-center gap-2">
                <i class="fa-solid fa-rectangle-ad text-blue-600"></i>
                Active Campaigns
            </h2>
            
            <c:if test="${empty allAds}">
                <div class="p-8 text-center text-gray-500 italic">
                    No active sponsored campaigns currently running. Be the first to create one!
                </div>
            </c:if>
            
            <c:if test="${not empty allAds}">
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                    <c:forEach var="ad" items="${allAds}">
                        <div class="bg-white/50 border border-gray-100 rounded-3xl p-4 flex flex-col justify-between shadow-sm hover:shadow-md transition">
                            <div class="space-y-3">
                                <div class="rounded-2xl overflow-hidden relative">
                                    <img src="${ad.imageUrl}" class="w-full h-32 object-cover">
                                    <div class="absolute bottom-2 left-3 text-white text-[9px] font-bold bg-blue-600 px-2 py-0.5 rounded-full uppercase">Active</div>
                                </div>
                                <div>
                                    <h3 class="font-bold text-gray-800 text-sm truncate">${ad.title}</h3>
                                    <p class="text-xs text-gray-500 mt-1 line-clamp-2">${ad.description}</p>
                                </div>
                            </div>
                            
                            <div class="border-t border-gray-100 pt-3 mt-4 flex items-center justify-between">
                                <span class="text-[10px] text-gray-400 font-semibold">${ad.createdAt}</span>
                                <c:if test="${not empty ad.linkUrl}">
                                    <a href="${ad.linkUrl}" target="_blank" class="text-xs font-bold text-blue-600 hover:text-blue-800 transition flex items-center gap-1">
                                        Visit Link <i class="fa fa-external-link text-[10px]"></i>
                                    </a>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:if>
        </div>

    </div>

    <!-- Live Preview Script -->
    <script>
        function updatePreview() {
            const title = document.getElementById("formTitle").value.trim();
            const desc = document.getElementById("formDescription").value.trim();
            
            document.getElementById("prevTitle").innerText = title ? title : "Y-Ads Manager";
            document.getElementById("prevDescription").innerText = desc ? desc : "Grow your business today";
        }

        function previewImage(input) {
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById("prevImg").src = e.target.result;
                };
                reader.readAsDataURL(input.files[0]);
            } else {
                document.getElementById("prevImg").src = "https://images.unsplash.com/photo-1611162617474-5b21e879e113?q=80&w=1000&auto=format&fit=crop";
            }
        }
    </script>
    <script src="js/theme.js"></script>
</body>
</html>
