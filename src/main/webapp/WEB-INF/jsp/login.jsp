<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="icon" type="image/png" href="<%=request.getContextPath()%>/icons/icon-192.png">
    <link rel="manifest" href="<%=request.getContextPath()%>/manifest.json">
    <script>
        if ('serviceWorker' in navigator) {
            window.addEventListener('load', () => {
                navigator.serviceWorker.register('<%=request.getContextPath()%>/sw.js')
                    .then(reg => console.log('Service Worker registered', reg))
                    .catch(err => console.error('Service Worker registration failed', err));
            });
        }
    </script>
    <title>Login | Y-ChatApp</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap');
        body { font-family: 'Plus Jakarta Sans', sans-serif; background: #f8fafc; }
        .glass-card { background: rgba(255, 255, 255, 0.95); backdrop-filter: blur(10px); border: 1px solid rgba(255, 255, 255, 0.2); }
        .btn-gradient { background: linear-gradient(135deg, #3b82f6 0%


    </style>
</head>

<body class="min-h-screen flex items-center justify-center p-4 bg-slate-50">
    
    <div class="max-w-6xl w-full grid lg:grid-cols-2 gap-12 items-center">
        
        <!-- Left Side: Branding -->
        <div class="hidden lg:block space-y-6">
            <div class="inline-flex items-center gap-2 text-blue-600 mb-2">
                <div class="bg-blue-600 p-1 rounded-xl">
                    <img src="<%=request.getContextPath()%>/icons/icon-192.png" alt="Logo" class="w-10 h-10 object-contain">
                </div>
                <span class="text-3xl font-bold tracking-tight text-slate-900">Y-ChatApp</span>
            </div>
            <h1 class="text-6xl font-extrabold text-slate-900 leading-[1.1]">
                Connect with the <br> 
                <span class="text-transparent bg-clip-text bg-gradient-to-r from-blue-600 to-indigo-600">World Around You.</span>
            </h1>
            <p class="text-xl text-slate-600 max-w-lg leading-relaxed">
                Experience the next generation of social interaction. Share, chat, and connect in a faster, more secure environment.
            </p>
            <div class="flex items-center gap-8 pt-6">
                <div class="flex -space-x-3">
                    <img class="w-12 h-12 rounded-full border-4 border-white shadow-sm" src="https://i.pravatar.cc/150?u=1" alt="">
                    <img class="w-12 h-12 rounded-full border-4 border-white shadow-sm" src="https://i.pravatar.cc/150?u=2" alt="">
                    <img class="w-12 h-12 rounded-full border-4 border-white shadow-sm" src="https://i.pravatar.cc/150?u=3" alt="">
                    <div class="w-12 h-12 rounded-full border-4 border-white bg-slate-100 flex items-center justify-center text-slate-500 font-bold text-xs shadow-sm">+10k</div>
                </div>
                <p class="text-slate-500 font-medium">Join 10,000+ active users today!</p>
            </div>











































































        <p class="font-bold text-xl animate-pulse">Authenticating...</p>
    </div>

    <script>
        document.getElementById('loginForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const submitBtn = document.getElementById('submitBtn');
            const errorBox = document.getElementById('errorBox');
            const errorMessage = document.getElementById('errorMessage');
            const loadingOverlay = document.getElementById('loadingOverlay');
            
            errorBox.classList.add('hidden');
            loadingOverlay.classList.remove('hidden');
            
            const formData = new FormData(this);
            formData.append('ajax', 'true');
            
            const params = new URLSearchParams(formData);

            fetch('UsersLoginServlet', {
                method: 'POST',
                body: params,
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                }
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    window.location.href = data.redirect;
                } else {
                    loadingOverlay.classList.add('hidden');
                    errorMessage.textContent = data.message;
                    errorBox.classList.remove('hidden');
                }
            })
            .catch(error => {
                loadingOverlay.classList.add('hidden');
                errorMessage.textContent = "An error occurred. Please try again.";
                errorBox.classList.remove('hidden');
            });
        });
    </script>

</body>
</html>