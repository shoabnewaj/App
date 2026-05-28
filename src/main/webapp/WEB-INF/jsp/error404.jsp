<%@ page contentType="text/html; charset=UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="icon" type="image/png" href="<%=request.getContextPath()%>/icons/icon-192.png">
    <title>Page Not Found | Y-ChatApp</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap');
        body { 
            font-family: 'Plus Jakarta Sans', sans-serif; 
            background: radial-gradient(circle at 10% 20%, rgba(243, 244, 246, 1) 0%, rgba(219, 234, 254, 0.5) 90%);
        }
        .glass-card { 
            background: rgba(255, 255, 255, 0.45); 
            backdrop-filter: blur(20px); 
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.4); 
        }
        .btn-gradient { 
            background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%); 
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); 
        }
        .btn-gradient:hover { 
            transform: translateY(-3px); 
            box-shadow: 0 12px 30px -5px rgba(37, 99, 235, 0.5); 
        }
        .floating-bubble {
            animation: float 6s ease-in-out infinite;
        }
        @keyframes float {
            0%, 100% { transform: translateY(0) scale(1); }
            50% { transform: translateY(-15px) scale(1.05); }
        }
    </style>
</head>
<body class="min-h-screen flex items-center justify-center p-6 overflow-hidden relative">

    <!-- Decorative background elements -->
    <div class="absolute w-96 h-96 -top-20 -left-20 bg-blue-300/30 rounded-full blur-3xl floating-bubble" style="animation-delay: 0s;"></div>
    <div class="absolute w-96 h-96 -bottom-20 -right-20 bg-indigo-300/30 rounded-full blur-3xl floating-bubble" style="animation-delay: 3s;"></div>

    <div class="glass-card max-w-md w-full rounded-3xl p-8 text-center shadow-2xl relative z-10">
        <div class="w-24 h-24 bg-blue-50 rounded-full flex items-center justify-center mx-auto mb-6 shadow-inner">
            <i class="fa-solid fa-compass-drafting text-4xl text-blue-500 animate-pulse"></i>
        </div>
        
        <h1 class="text-8xl font-black text-blue-600 mb-2">404</h1>
        <h2 class="text-2xl font-bold text-gray-800 mb-4">Lost in Space?</h2>
        <p class="text-gray-600 mb-8 leading-relaxed">
            The page you are looking for might have been removed, had its name changed, or is temporarily unavailable.
        </p>

        <a href="<%=request.getContextPath()%>/main.jsp" class="btn-gradient inline-flex items-center gap-2 text-white font-semibold px-8 py-4 rounded-2xl shadow-lg">
            <i class="fa-solid fa-house-chimney"></i>
            Take Me Home
        </a>
    </div>

</body>
</html>