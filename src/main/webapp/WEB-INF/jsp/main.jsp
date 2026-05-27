<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> --%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Y-ChatApp | Newsfeed</title>
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

<script src="https://cdn.tailwindcss.com"></script>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;800&display=swap" rel="stylesheet">

<style>
* {
	box-sizing: border-box;
	margin: 0;
	padding: 0;
}

/* --- আপনার আসল বডি স্টাইল (শুধু width এবং overflow-x যোগ করা হয়েছে) --- */
body {
	background: l
	background-size: 400% 400%;
	animation: gradient 15s ease infinite;
	font-family: 'Outfit', sans-serif;
	width: 100%;
	max-width: 100%;
	min-height: 100vh;
	overflow-x: hidden;
}




















/* --- ২. এই নতুন ফিক্সটি যোগ করা হয়েছে (ইমেজ স্ক্রিনে ফিক্স করার জন্য) --- */
img {
	max-width: 100%;
	height: auto;
	display: block;
}

/* --- আপনার বাকি সব আসল কোড হুবহু নিচে রইলো (কিছুই বাদ দেওয়া হয়নি) --- */
.fb-shadow {
	box-shadow: 0 1px 2px rgba(0, 0, 0, 0.2);
}

.logo {
	display: flex;
	align-items: center;
	gap: 8px;
	color: #0866FF;
	font-size: 24px;
	font-weight: bold;
}

.react-container {
	position: relative;
	display: inline-block;
}

.react-box {
	display: none;
	position: absolute;
	bottom: 25px;
	left: -10px;
	background: white;
	padding: 5px 12px;
	border-radius: 50px;
	box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
	z-index: 9999;
	gap: 10px;
	animation: pop 0.2s ease-out;
}

.react-box::after {
	content: '';
	position: absolute;
	bottom: -15px;
	left: 0;
	width: 100%;
	height: 20px;
}

.react-container:hover .react-box {
	display: flex;
}

.react-box span {
	font-size: 26px;
	cursor: pointer;
	transition: transform 0.1s;
}

.react-box span:hover {
	transform: scale(1.4);
}

@
keyframes pop {from { opacity:0;
	transform: translateY(10px);
}

to {
	opacity: 1;
	transform: translateY(0);
}

}
.comment-level-1 {
	margin-left: 0px;
}

.comment-level-2 {
	margin-left: 48px;
	border-left: 2px solid #ddd;
	padding-left: 10px;
}

.comment-level-3 {
	margin-left: 96px;
	border-left: 2px solid #ddd;
	padding-left: 10px;
}

.modal {
	display: none;
	position: fixed;
	inset: 0;
	background: rgba(255, 255, 255, 0.8);
	backdrop-filter: blur(5px);
	z-index: 9999;
	align-items: center;
	justify-content: center;
}

.clickable {
	cursor: pointer;
}

.clickable:hover {
	text-decoration: underline;
}

.media-icon {
	color: #65676b;
	cursor: pointer;
	padding: 8px;
	border-radius: 50%;
	transition: 0.2s;










































































}
.animate-slide-in {
    animation: slideInUp 0.4s ease-out forwards;
}

.custom-scrollbar::-webkit-scrollbar-thumb:hover { background: #6B7280; }

@media (max-width: 1023px) {
	body {
		padding-bottom: 80px !important;
	}
}
</style>
</head>
<body class="bg-fixed">

	<header class="glass-nav h-[56px] sticky top-0 z-[5000] flex items-center justify-between px-4">
		<!-- LEFT SECTION (Logo and Search) -->
		<div class="flex items-center gap-2 flex-1">
			<div class="logo"
				style="display: flex; align-items: center; gap: 10px;">
				<img src="<%=request.getContextPath()%>/icons/icon-192.png"
					width="40" alt="Logo"> <span
					style="font-weight: bold; font-size: 20px;">Y-ChatApp</span>
			</div>

			<form action="SearchServlet" method="get"
				class="bg-white/50 backdrop-blur-md px-4 py-2 rounded-full hidden md:flex items-center gap-2 ml-4 border border-white/30 focus-within:w-[250px] transition-all duration-300 group">
				<i class="fa fa-search text-gray-400 group-focus-within:text-blue-500"></i> <input
					name="query" placeholder="Search Y-Chat"
					class="bg-transparent outline-none w-[150px] text-sm font-medium">
			</form>
		</div>

		<!-- CENTER SECTION (Navigation Links) -->
		<div
			class="hidden lg:flex flex-1 justify-center gap-12 text-[24px] text-gray-500">
			<a href="UsersPostServlet" title="Home"><i
				class="fa fa-house text-[#0866FF]"></i></a> <a href="GroupsServlet"
				title="Groups" class="text-gray-500 hover:text-blue-500 transition"><i
				class="fa fa-user-group clickable"></i></a> <a href="VideosServlet"
				title="Videos" class="text-gray-500 hover:text-blue-500 transition"><i
				class="fa fa-video clickable"></i></a> <a href="#" onclick="openReelsFeed(); return false;"
				title="Reels" class="text-gray-500 hover:text-blue-500 transition"><i
				class="fa fa-clapperboard clickable"></i></a> <a href="MarketServlet"
				title="Market" class="text-gray-500 hover:text-blue-500 transition"><i
				class="fa fa-shop clickable"></i></a>
		</div>

		<!-- RIGHT SECTION (Actions & Profile) -->
		<div class="flex items-center gap-3 flex-1 justify-end">
			<!-- Notification Link -->
			<a href="NotificationServlet"
				class="w-10 h-10 bg-gray-200 rounded-full flex items-center justify-center relative clickable hover:bg-gray-300 transition">
				<i class="fa fa-bell text-black"></i>
				<c:if test="${not empty unreadCount && unreadCount > 0}">
					<span class="absolute -top-1 -right-1 bg-red-600 text-white text-[11px] px-1.5 rounded-full border-2 border-white font-bold">${unreadCount}</span>
				</c:if>
			</a>

			<!-- Profile Link -->
			<a href="UsersProfileServlet?userId=${sessionScope.userId}"
				class="flex items-center gap-2 p-1 hover:bg-gray-100 rounded-full clickable border border-transparent hover:border-gray-200 transition">
				<img src="img/${ub.profile_pic}" class="w-9 h-9 rounded-full border"
				width="45Px"> <span>${ub.name}</span>
			</a>

			<!-- Logout Link -->
			<a href="UsersLogoutServlet" title="Logout"
				class="w-10 h-10 bg-gray-200 rounded-full flex items-center justify-center hover:bg-red-100 hover:text-red-600 transition">
				<i class="fa fa-right-from-bracket"></i>
			</a>
		</div>
	</header>


	<div class="max-w-[1400px] mx-auto grid grid-cols-1 lg:grid-cols-[250px_1fr_280px] xl:grid-cols-[280px_1fr_320px] gap-6 mt-4 px-4">

		<!-- LEFT SIDEBAR -->
		<aside class="hidden lg:block sticky top-[70px] h-fit">
			<div class="glass-card p-4 rounded-3xl space-y-2">
				<div onclick="location.href='UsersProfileServlet?userId=${sessionScope.userId}'"
					class="flex items-center gap-3 p-3 rounded-xl hover:bg-white hover:shadow-[0_10px_20px_rgba(0,0,0,0.1)] hover:-translate-y-1 transition-all duration-300 cursor-pointer group">
					<div class="relative">
						<img src="img/${ub.profile_pic}" alt="${ub.name}" class="w-10 h-10 rounded-full border-2 border-blue-500 shadow-md">
						<div class="absolute bottom-0 right-0 w-3 h-3 bg-green-500 border-2 border-white rounded-full"></div>
					</div>
					<span class="font-bold text-gray-700 group-hover:text-blue-600">${ub.name}</span>
				</div>

				<a href="FriendServlet" class="flex items-center gap-4 p-3 rounded-xl hover:bg-white hover:shadow-lg hover:-translate-y-1 transition-all duration-300 group">
					<div class="w-10 h-10 flex items-center justify-center 
				</a>

				<a href="messages.jsp" class="flex items-center gap-4 p-3 rounded-xl hover:bg-white hover:shadow-lg hover:-translate-y-1 transition-all duration-300 group">
					<div class="w-10 h-10 flex items-center justify-center rounded-xl bg-gradient-to-br from-purple-400 to-purple-600 shadow-lg shadow-purple-200">
						<i class="fa fa-comment-dots text-white"></i>
					</div> <span class="font-bold text-gray-600 group-hover:text-purple-600">Messenger</span>
				</a>

				<div onclick="showMemoriesModal()" class="flex items-center gap-4 p-3 rounded-xl hover:bg-white hover:shadow-lg hover:-translate-y-1 transition-all duration-300 group cursor-pointer">
					<div class="w-10 h-10 flex items-center justify-center rounded-xl bg-gradient-to-br from-cyan-400 to-cyan-600 shadow-lg shadow-cyan-200">
						<i class="fa fa-clock text-white"></i>
					</div>
					<span class="font-bold text-gray-600 group-hover:text-cyan-600">Memories</span>
					</div>
					<span class="font-bold text-gray-600 group-hover:text-cyan-600">Memories</span>
				</div>

				<div onclick="showSavedPostsModal()" class="flex items-center gap-4 p-3 rounded-xl hover:bg-white hover:shadow-lg hover:-translate-y-1 transition-all duration-300 group cursor-pointer">
					<div class="w-10 h-10 flex items-center justify-center rounded-xl bg-gradient-to-br from-pink-400 to-pink-600 shadow-lg shadow-pink-200">
						<i class="fa fa-bookmark text-white"></i>
					</div>
					<span class="font-bold text-gray-600 group-hover:text-pink-600">Saved</span>
				</div>

				<div onclick="openReelsFeed()" class="flex items-center gap-4 p-3 rounded-xl bg-blue-50/50 border border-blue-100 hover:bg-white hover:shadow-lg hover:-translate-y-1 transition-all duration-300 group cursor-pointer">
					<div class="w-10 h-10 flex items-center justify-center rounded-xl bg-gradient-to-br from-blue-500 to-indigo-600 shadow-lg shadow-blue-200">
						<i class="fa fa-clapperboard text-white"></i>
					</div>
					<span class="font-bold text-gray-700 group-hover:text-blue-600">Watch Reels</span>
				</div>

				<div onclick="openReelModal()" class="flex items-center gap-4 p-3 rounded-xl bg-orange-50/50 border border-orange-100 hover:bg-white hover:shadow-lg hover:-translate-y-1 transition-all duration-300 group cursor-pointer">
					<div class="w-10 h-10 flex items-center justify-center rounded-xl bg-gradient-to-br from-orange-400 to-orange-600 shadow-lg shadow-orange-200">
						<i class="fa fa-plus text-white"></i>
					</div>
					<span class="font-bold text-gray-700 group-hover:text-orange-600">Create Reel</span>
				</div>

				<c:if test="${ub.email == 'admin@gmail.com' || ub.email == 'shoabnewaj81@gmail.com' || ub.email == 'newaj@xxx.jp'}">
					<a href="AdminServlet" class="flex items-center gap-4 p-3 rounded-xl bg-purple-50/50 border border-purple-100 hover:bg-white hover:shadow-lg hover:-translate-y-1 transition-all duration-300 group cursor-pointer">
						<div class="w-10 h-10 flex items-center justify-center rounded-xl bg-gradient-to-br from-indigo-500 to-purple-700 shadow-lg shadow-purple-200">
							<i class="fa fa-gauge-high text-white"></i>
						</div>
						<span class="font-bold text-gray-700 group-hover:text-purple-700">Admin Panel</span>
					</a>
				</c:if>

				<hr class="my-4 border-white/20">
				<p class="px-4 text-xs font-bold text-gray-400 uppercase tracking-widest">Shortcuts</p>
			</div>
		</aside>

		<!-- MAIN FEED -->
		<main class="space-y-6">
			<!-- STORIES SECTION (Facebook-style horizontal strip) -->
		<div class="glass-card rounded-3xl p-4">
			<div class="flex gap-3 overflow-x-auto pb-1 scroll-smooth" style="scrollbar-width: thin; scrollbar-color: #D1D5DB transparent;">

				<!-- Create Story Card -->
				<div onclick="openStoryModal()" class="flex-none w-[115px] h-[200px] rounded-2xl relative overflow-hidden cursor-pointer group shadow-md border border-white/30 select-none">
					<!-- Top: Profile pic -->
					<div class="h-[140px] overflow-hidden bg-gray-200">
						<img src="img/${ub.profile_pic}" alt="${ub.name}" class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500">
					</div>
					<!-- Bottom: Create button -->
					<div class="absolute bottom-0 left-0 right-0 bg-white flex flex-col items-center pt-5 pb-3 gap-1">
						<div class="absolute -top-5 left-1/2 -translate-x-1/2 w-10 h-10 rounded-full bg-blue-600 border-[3px] border-white flex items-center justify-center shadow-lg group-hover:scale-110 transition-transform">
							<i class="fa fa-plus text-white text-sm"></i>
						</div>
						<span class="text-[11px] font-bold text-gray-800 mt-1">Create Story</span>
					</div>
				</div>

				<!-- Story Cards from DB -->
				<c:forEach var="story" items="${storyList}">
					<div onclick="openStoryViewer('${story.name}', '${story.profilePic}', '${story.mediaUrl}', '${story.text}')"
					     class="flex-none w-[115px] h-[200px] rounded-2xl relative overflow-hidden cursor-pointer group shadow-md border border-white/20 select-none">

						<!-- Background: image or gradient -->
						<c:choose>
							<c:when test="${not empty story.mediaUrl}">
								<img src="img/${story.mediaUrl}" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500">
							</c:when>
							<c:otherwise>
								<div class="w-full h-full bg-gradient-to-br from-indigo-500 via-purple-500 to-pink-500 flex items-start justify-center pt-16 p-3 text-center">
									<p class="text-white text-xs font-bold leading-tight line-clamp-5">${story.text}</p>
								</div>
							</c:otherwise>
						</c:choose>

						<!-- Dark gradient overlay bottom -->
						<div class="absolute inset-0 bg-gradient-to-t from-black/70 via-black/10 to-transparent"></div>

						<!-- User avatar - top left with blue ring -->
						<div class="absolute top-2 left-2 w-9 h-9 rounded-full border-[3px] border-blue-500 overflow-hidden shadow-lg">
							<img src="img/${story.profilePic}" class="w-full h-full object-cover">
						</div>

						<!-- User name - bottom -->
						<div class="absolute bottom-2 left-2 right-2">
							<p class="text-[11px] font-bold text-white truncate drop-shadow">${story.name}</p>
						</div>
					</div>
				</c:forEach>

			</div>
		</div>

	

			<!-- REELS SECTION -->
			<div class="reels-container py-2">
				<div onclick="openReelModal()" class="reel-card glass-card flex flex-col items-center justify-center border-2 border-dashed border-white/50 group">
					<div class="w-14 h-14 bg-gradient-to-br from-blue-500 to-purple-600 rounded-full flex items-center justify-center mb-2 shadow-lg group-hover:scale-110 transition-transform">
						<i class="fa fa-plus text-white text-2xl"></i>
					</div>
					<span class="text-gray-800 font-extrabold text-xs uppercase tracking-wider">Create Reel</span>
				</div>

				<c:forEach var="reel" items="${reelsList}">
					<div onclick="openReelViewer(${reel.id})" class="reel-card">
						<video class="reel-video">
							<source src="img/${reel.file_name}" type="video/mp4">
						</video>
						<div class="reel-user">
							<img src="img/${reel.profile_pic}" alt="user">
						</div>
						<div class="reel-info">${reel.name}</div>
					</div>
				</c:forEach>
			</div>

			<!-- POST BOX -->
			<div class="glass-card p-5 rounded-3xl">
				<div class="flex gap-4">
					<a href="UsersProfileServlet?userId=${sessionScope.userId}" class="group relative"> 
                        <img src="img/${ub.profile_pic}" alt="${ub.name}" class="w-12 h-12 rounded-2xl object-cover ring-2 ring-white shadow-md group-hover:scale-105 transition-transform">
                        <div class="absolute -bottom-1 -right-1 w-4 h-4 bg-green-500 border-2 border-white rounded-full"></div>
					</a>
					<button onclick="openModal()"
						class="flex-1 bg-white/40 hover:bg-white/60 backdrop-blur-md rounded-2xl text-left px-6 text-gray-600 text-[16px] font-medium transition-all border border-white/20">
						What's on your mind, ${ub.name}?</button>
				</div>
				<div class="border-t border-white/20 mt-4 pt-3 flex flex-wrap justify-around gap-2">
					<div onclick="openLiveModal()"
						class="flex items-center gap-2 py-2 px-4 hover:bg-red-500/10 rounded-xl transition-all clickable text-red-500 font-semibold text-sm">
						<i class="fa fa-video text-lg"></i> Live
					</div>
					<div onclick="openModal(); document.getElementById('modalFileInput').click();"
						class="flex items-center gap-2 py-2 px-4 hover:bg-green-500/10 rounded-xl transition-all clickable text-green-500 font-semibold text-sm">
						<i class="fa fa-image text-lg"></i> Photo
					</div>
					<div onclick="openReelModal()"
						class="flex items-center gap-2 py-2 px-4 hover:bg-orange-500/10 rounded-xl transition-all clickable text-orange-500 font-semibold text-sm">
							<img onclick="location.href='UsersProfileServlet?userId=${post.userId}'"
								src="img/${post.profile_pic}" class="w-10 h-10 rounded-full clickable" width="30Px">
							<div>
								<a href="UsersProfileServlet?userId=${post.userId}" class="font-bold clickable group-hover/post:text-blue-600 transition-colors">${post.name}</a>
								<c:if test="${not empty post.feeling}">
									<span class="text-gray-500 text-[14px]"> is feeling <span class="font-bold text-gray-700">${post.feeling}</span></span>
								</c:if>
								<div class="text-[12px] text-gray-500 flex items-center gap-1">
									<span class="time-ago" data-time="${post.time}">${post.time}</span> • <i class="fa fa-earth-americas"></i>
								</div>
							</div>
						</div>
						<div class="relative">
							<div onclick="togglePostMenu(event, ${post.id})" class="p-2 hover:bg-gray-100 rounded-full transition-colors cursor-pointer"><i class="fa fa-ellipsis-h text-gray-500"></i></div>
							<div id="post-menu-${post.id}" class="hidden absolute right-0 top-8 bg-white border shadow-lg rounded-xl z-50 min-w-[150px] overflow-hidden">
								<div onclick="toggleSavePost(${post.id}, this)" class="px-4 py-3 hover:bg-blue-50 text-




										<i class="fa fa-trash"></i> Delete Post
									</div>
								</c:if>
							</div>
						</div>
					</div>

					<!-- Post Content -->
					<div class="mt-4">
						<p class="text-gray-800 leading-relaxed">${post.content}</p>
						<c:if test="${not empty post.file_name}">
							<div class="mt-4 rounded-2xl overflow-hidden border border-white/20 shadow-lg bg-gray-100/30">
								<c:choose>
									<c:when test="${post.post_type == 'video' || post.file_name.toLowerCase().endsWith('.webm') || post.file_name.toLowerCase().endsWith('.mp4') || post.file_name.toLowerCase().endsWith('.mov') || post.file_name.toLowerCase().endsWith('.ogg') || post.file_name.toLowerCase().endsWith('.avi') || post.file_name.toLowerCase().endsWith('.mkv')}">
										<video src="img/${post.file_name}" controls class="w-full max-h-[500px] object-contain bg-black"></video>
									</c:when>
									<c:otherwise>
										<img src="img/${post.file_name}" class="w-full max-h-[500px] object-cover hover:scale-[1.01] transition-transform duration-700">
									</c:otherwise>
								</c:choose>
							</div>
						</c:if>
					</div>

					<!-- Stats Section -->
					<div class="flex items-center justify-between mt-4 py-3 border-y border-white/10">
						<div class="flex items-center gap-1.5 text-gray-500 text-sm">
							<span id="react-count-${post.id}" class="font-bold ml-1">
								<c:set var="tc" value="${post.likeCount + post.loveCount + post.careCount + post.hahaCount + post.wowCount + post.sadCount + post.angryCount + post.dislikes}"/>
								<c:choose>

















































						<div id="comment-list-${post.id}" class="space-y-4 mb-4">
							<c:forEach var="cmt" items="${post.comments}">
								<div class="flex flex-col gap-2 group/cmt mb-4">
									<div class="flex gap-2">
										<img src="img/${cmt.profilePic}" class="w-8 h-8 rounded-full border shadow-sm cursor-pointer" onclick="location.href='UsersProfileServlet?userId=${cmt.userId}'">
										<div class="flex flex-col flex-1">
											<div class="bg-white/50 px-4 py-2 rounded-2xl shadow-sm inline-block max-w-fit">
												<p class="font-bold text-[13px] hover:underline cursor-pointer" onclick="location.href='UsersProfileServlet?userId=${cmt.userId}'">${cmt.name}</p>
												<p class="text-[14px] text-gray-700">${cmt.comment_text}</p>
												<c:if test="${not empty cmt.file_name}">
													<img src="img/${cmt.file_name}" class="mt-2 rounded-xl max-h-40 border shadow-sm">
												</c:if>
											</div>
											<div class="flex gap-4 ml-4 mt-1 text-[11px] font-bold text-gray-500 items-center">
												<div class="react-container clickable">
													<span class="hover:text-blue-600 transition" onclick="handleAJAXReact(${cmt.id}, 'Like', 'comment', event)">Like</span>
													<div class="react-box !p-1 !rounded-full">
														<span title="Like" onclick="handleAJAXReact(${cmt.id}, 'Like', 'comment', event)">👍</span>
														<span title="Love" onclick="handleAJAXReact(${cmt.id}, '











													<c:set var="tc" value="${cmt.likeCount + cmt.loveCount + cmt.careCount + cmt.hahaCount + cmt.wowCount + cmt.sadCount + cmt.angryCount + cmt.dislikes}"/>
													<c:if test="${tc > 0}">
														<c:if test="${cmt.likeCount > 0}">👍 <span class="text-gray-600">${cmt.likeCount}</span>&nbsp;&nbsp;</c:if>
														<c:if test="${cmt.loveCount > 0}">❤️ <span class="text-gray-600">${cmt.loveCount}</span>&nbsp;&nbsp;</c:if>
														<c:if test="${cmt.careCount > 0}">🥰 <span class="text-gray-600">${cmt.careCount}</span>&nbsp;&nbsp;</c:if>
														<c:if test="${cmt.hahaCount > 0}">😆 <span class="text-gray-600">${cmt.hahaCount}</span>&nbsp;&nbsp;</c:if>
														<c:if test="${cmt.wowCount > 0}">😮 <span class="text-gray-600">${cmt.wowCount}</span>&nbsp;&nbsp;</c:if>
														<c:if test="${cmt.sadCount > 0}">😢 <span class="text-gray-600">${cmt.sadCount}</span>&nbsp;&nbsp;</c:if>
														<c:if test="${cmt.angryCount > 0}">😡 <span class="text-gray-600">${cmt.angryCount}</span>&nbsp;&nbsp;</c:if>
														<c:if test="${cmt.dislikes > 0}">👎 <span class="text-gray-600">${cmt.dislikes}</span>&nbsp;&nbsp;</c:if>
													</c:if>
												</div>
											</div>

											<!-- Reply List -->
											<div id="reply-list-${cmt.id}" class="mt-2 space-y-2 ml-10">
												<c:forEach var="reply" items="${cmt.replies}">
													<div class="comment-level-2 mb-2 flex gap-2">
														<a href="UsersProfileServlet?userId=${reply.userId}">
															<img src="img/${reply.profilePic}" class="w-7 h-7 rounded-full border shadow-sm">
														</a>




















































































































								</div>
							</div>
						</form>
					</div>
				</div>
			</c:forEach>
		</main>

		<!-- RIGHT SIDEBAR (Dynamic & Colorful) -->
		<aside class="hidden lg:block sticky top-[70px] h-fit">
			<div class="space-y-6">
				<!-- Sponsored Card -->
				<div class="glass-card p-5 rounded-3xl group cursor-pointer transition-all hover:shadow-2xl">
					<div class="flex items-center justify-between mb-4">
						<h3 class="text-xs font-bold text-gray-500 uppercase tracking-widest">Sponsored</h3>
						<i class="fa fa-ellipsis-h text-gray-400 group-hover:text-blue-500 transition"></i>
					</div>
					<div class="rounded-2xl overflow-hidden mb-3 relative">
						<img src="https://images.unsplash.com/photo-1611162617474-5b21e879e113?q=80&w=1000&auto=format&fit=crop" class="w-full h-32 object-cover group-hover:scale-110 transition-transform duration-500">
						<div class="absolute inset-0 bg-gradient-to-t from-black/50 to-transparent"></div>
						<div class="absolute bottom-2 left-3 text-white text-[10px] font-bold bg-blue-600 px-2 py-0.5 rounded-full uppercase tracking-tighter">New</div>
					</div>
					<div class="flex items-center justify-between">
						<div>
							<p class="text-sm font-bold text-gray-800">Y-Ads Manager</p>
							<p class="text-[11px] text-gray-500">Grow your business today</p>
						</div>
						<i class="fa fa-arrow-right text-blue-500 group-hover:translate-x-1 transition-transform"></i>
					</div>
				</div>

				<!-- Contacts Section -->
				<div class="glass-card p-5 rounded-3xl">
					<div class="flex items-center justify-between mb-4">









		</aside>
	</div>

	<!-- Features (Saved/Memories) Modal -->
	<div id="featuresModal" class="modal !bg-black/85 z-[9999]">
		<div class="modal-content !max-w-[700px] !w-[95%] !bg-[#18191A] rounded-3xl shadow-2xl overflow-hidden border border-gray-700 p-0">
			<!-- Header -->
			<div class="flex items-center justify-between p-5 border-b border-gray-700">
				<h2 id="featuresModalTitle" class="text-xl font-bold text-white flex items-center gap-2"></h2>
				<button onclick="closeFeaturesModal()" class="w-8 h-8 rounded-full bg-gray-700 hover:bg-gray-600 flex items-center justify-center text-white transition">
                    <i class="fa fa-times"></i>
                </button>
			</div>
			<!-- Content Container -->
			<div id="featuresModalBody" class="p-6 max-h-[60vh] overflow-y-auto space-y-4 text-white">
				<!-- Content dynamically loaded via JS -->
			</div>
		</div>
	</div>

	<!-- Create Story Modal -->
	<div id="storyModal" class="modal">
		<div class="modal-content !max-w-[450px] !w-[95%] bg-white rounded-2xl shadow-2xl p-0 overflow-hidden">
			<div class="flex items-center justify-between p-4 border-b">
				<h2 class="text-xl font-bold text-gray-800">Create Story</h2>
				<button onclick="closeStoryModal()" class="w-8 h-8 rounded-full bg-gray-100 flex items-center justify-center hover:bg-red-100 hover:text-red-600 transition">
					<i class="fa fa-times"></i>
				</button
			<!-- Header -->
			<div class="flex items-center justify-between p-5 border-b border-gray-700 bg-[#242526]">
				<div>
					<label class="block text-sm font-bold text-gray-700 mb-1">Story Text (Optional)</label>
					<textarea name="text" placeholder="Write something in your story..." class="w-full p-3 border rounded-xl outline-none resize-none h-20 text-sm focus:ring-2 focus:ring-blue-500/20 transition-all"></textarea>
				</div>
				<div>
					<label class="block text-sm font-bold text-gray-700 mb-1">Upload Photo/Video</label>
					<div class="border-2 border-dashed border-gray-200 rounded-xl p-6 text-center cursor-pointer hover:bg-gray-50 transition" onclick="document.getElementById('storyMediaInput').click()">
						<i class="fa fa-image text-3xl text-blue-500 mb-2"></i>
						<p class="text-gray-500 text-sm font-medium">Click to select photo or video</p>
					</div>
					<input type="file" name="media" id="storyMediaInput" class="hidden" accept="image/*,video/*" onchange="previewStoryMedia(this)">
				</div>
				<!-- Preview Container -->
				<div id="storyPreviewContainer" class="hidden mt-3 rounded-xl overflow-hidden bg-gray-100 border relative max-h-[200px]">
					<button type="button" onclick="removeStoryPreview()" class="absolute top-2 right-2 bg-black/60 text-white rounded-full w-6 h-6 flex items-center justify-center text-xs">×</button>
					<img id="storyImagePreview" src="#" class="w-full h-auto object-contain max-h-[200px] hidden">
					<video id="storyVideoPreview" src="#" class="w-full h-auto object-contain max-h-[200px] hidden" controls></video>
				</div>
	<div id="storyViewerModal" class="modal !bg-black/95">
		<div class="relative w-full h-full flex items-center justify-center">
			<button onclick="closeStoryViewer()" class="absolute top-6 right-6 text-white text-3xl z-50 hover:scale-110 transition">
				<i class="fa fa-times"></i>
			</button>
			
			<div class="h-[80vh] w-[90%] max-w-[400px] bg-[#1c1c1e] rounded-2xl overflow-hidden relative shadow-2xl flex flex-col">
				<!-- Progress Bar -->
				<div class="absolute top-3 left-3 right-3 flex gap-1 z-50">
					<div class="h-1 flex-1 bg-white/30 rounded-full overflow-hidden">
						<div id="storyProgressBar" class="h-full bg-white w-0"></div>
					</div>
				</div>

				<!-- User Header -->
				<div class="absolute top-6 left-4 right-4 flex items-center gap-3 z-50 text-white">
					<img id="storyViewerUserPic" src="" class="w-9 h-9 rounded-full border-2 border-white object-cover">
					<div>
						<p id="storyViewerUserName" class="font-bold text-sm shadow-sm"></p>
					</div>
				</div>

				<!-- Story Content Body -->
				<div class="flex-1 flex items-center justify-center relative p-4">
					<img id="storyViewerImage" src="" class="w-full h-full object-contain hidden">
					<video id="storyViewerVideo" src="" class="w-full h-full object-contain hidden" autoplay controls></video>
					
					<!-- Text-only Story overlay -->

				<!-- Story Content Body -->
				<div class="flex-1 flex items-center justify-center relative p-4">
					<img id="storyViewerImage" src="" class="w-full h-full object-contain hidden">
					<video id="storyViewerVideo" src="" class="w-full h-full object-contain hidden" autoplay controls></video>
					
					<!-- Text-only Story overlay -->
					<div id="storyViewerTextContainer" class="w-full h-full bg-gradient-to-br from-indigo-600 via-purple-600 to-pink-600 rounded-2xl flex items-center justify-center p-6 text-center text-white hidden">
						<p id="storyViewerText" class="text-xl font-bold leading-normal"></p>
					</div>
				</div>
			</div>
		</div>
	</div>














































































































































































































































































			</div>
		</div>
	</div>

	<!-- Create Reel Modal -->
	<div id="reelModal" class="modal">
		<div class="modal-content !max-w-[450px] !w-[95%] bg-white rounded-2xl shadow-2xl p-0 overflow-hidden">
			<div class="flex items-center justify-between p-4 border-b">
				<h2 class="text-xl font-bold">Create Reel</h2>
				<button onclick="closeReelModal()" class="w-8 h-8 rounded-full bg-gray-100 flex items-center justify-center">×</button>
			</div>
			<form id="reelForm" action="UsersPostServlet" method="post" enctype="multipart/form-data" class="p-6">
				<input type="hidden" name="type" value="REEL">
				<div class="border-2 border-dashed border-gray-200 rounded-xl p-8 text-center cursor-pointer hover:bg-gray-50 transition"
					 onclick="document.getElementById('reelVideoInput').click()">
					<i class="fa fa-clapperboard text-4xl text-blue-500 mb-2"></i>
					<p class="text-gray-500 font-medium">Click to select a video for your Reel</p>
					<p class="text-xs text-gray-400 mt-1">Short vertical videos work best!</p>
				</div>
				<input type="file" name="media" id="reelVideoInput" class="hidden" accept="video/*" onchange="previewReel(this)">
				<div id="reelPreview" class="hidden mt-4 rounded-xl overflow-hidden bg-black aspect-[9/16]">
					<video id="reelVideoPreview" class="w-full h-full object-contain" controls></video>
				</div>
				<textarea name="content" placeholder="Describe your reel..." class="w-full mt-4 p-3 border rounded-xl outline-none resize-none h-20 text-sm"></textarea>
				<button type="submit" class="w-full bg-blue-600 text-white font-bold py-3 rounded-xl mt-6 shadow-lg hover:bg-blue-700">Share Reel</button>
			</form>
		</div>
	</div>

	<!-- Reel Viewer Modal -->
	<div id="reelViewer" class="modal !bg-black/98 z-[99999]">
		<div class="relative w-full max-w-6xl h-full md:h-[90vh] flex flex-col lg:flex-row items-center justify-center bg-black lg:rounded-3xl overflow-hidden shadow-2xl border border-white/10">
			
			<!-- Left Panel: Video & Nav (Floating controls on overlay) -->
			<div class="relative flex-1 h-full lg:h-[90vh] bg-black flex items-center justify-center overflow-hidden">
				<!-- Top Navigation Buttons Floating on Video -->
				<button onclick="closeReelViewer()" class="absolute top-4 left-4 bg-black/40 hover:bg-black/60 text-white rounded-full px-4 py-2 flex items-center gap-2 transition z-[1000] shadow-lg border border-white/10 hover:scale-105">
					<i class="fa fa-house text-sm"></i> 
					<span class="text-xs font-bold">Home</span>
				</button>
				<button onclick="closeReelViewer(); openReelModal()" class="absolute top-4 left-24 bg-gradient-to-r from-orange-500 to-pink-500 hover:opacity-90 text-white rounded-full px-4 py-2 flex items-center gap-2 transition z-[1000] shadow-lg border border-white/10 hover:scale-105">
					<i class="fa fa-plus text-xs"></i> 
					<span class="text-xs font-bold">Create</span>
				</button>
				<button onclick="closeReelViewer()" class="absolute top-4 right-4 bg-black/40 hover:bg-black/60 text-white rounded-full p-2.5 flex items-center justify-center tra
					<i class="fa fa-plus text-xs"></i> 
					<span class="text-xs font-bold">Create</span>
				</button>
				<button onclick="closeReelViewer()" class="absolute top-4 right-4 bg-black/40 hover:bg-black/60 text-white rounded-full p-2.5 flex items-center justify-center transition z-[1000] shadow-lg border border-white/10 hover:scale-105">
					<i class="fa fa-xmark text-lg"></i>
				</button>
				<!-- Previous Button -->
				<button onclick="prevReel(event)" class="absolute left-4 text-white/60 hover:text-white text-2xl z-50 transition bg-black/40 hover:bg-black/70 w-12 h-12 rounded-full flex items-center justify-center border border-white/10 hover:scale-105">
					<i class="fa fa-chevron-left"></i>
				</button>
				
				<!-- Video Element -->
				<video id="viewerVideo" class="h-full aspect-[9/16] object-contain bg-black" loop autoplay playsinline webkit-playsinline controls></video>
				
				<!-- Next Button -->
				<button onclick="nextReel(event)" class="absolute right-4 text-white/60 hover:text-white text-2xl z-50 transition bg-black/40 hover:bg-black/70 w-12 h-12 rounded-full flex items-center justify-center border border-white/10 hover:scale-105">
				<div class="lg:hidden absolute right-4 bottom-24 flex flex-col gap-5 items-center z-50">
					<!-- Reaction Toggle -->
					<div class="flex flex-col items-center">
						<div onclick="toggleMobileReactions()" class="w-12 h-12 rounded-full bg-white/20 backdrop-blur-md flex items-center justify-center text-white text-xl shadow-lg active:scale-95">
							<i class="fa fa-heart"></i>
						</div>
						<span id="viewerMobileReactCount" class="text-white text-xs font-bold mt-1">0</span>
					</div>
					<!-- Comment Trigger -->
					<div class="flex flex-col items-center">
						<div onclick="toggleMobileComments()" class="w-12 h-12 rounded-full bg-white/20 backdrop-blur-md flex items-center justify-center text-white text-xl shadow-lg active:scale-95">
					<div class="flex flex-col items-center">
						<div onclick="toggleMobileReactions()" class="w-12 h-12 rounded-full bg-white/20 backdrop-blur-md flex items-center justify-center text-white text-xl shadow-lg active:scale-95">
							<i class="fa fa-heart"></i>
						</div>
						<span id="viewerMobileReactCount" class="text-white text-xs font-bold mt-1">0</span>
					</div>
					<!-- Comment Trigger -->
					<div class="flex flex-col items-center">
						<div onclick="toggleMobileComments()" class="w-12 h-12 rounded-full bg-white/20 backdrop-blur-md flex items-center justify-center text-white text-xl shadow-lg active:scale-95">
							<i class="fa fa-comment"></i>
						</div>
						<span id="viewerMobileCommentCount" class="text-white text-xs font-bold mt-1">0</span>
					</div>
				</div>
			</div>

			<!-- Right Panel: Social Sidebar (Visible on desktop, drawer style on mobile) -->
			<div id="reelSidebar" class="hidden lg:flex w-full lg:w-[400px] h-[40vh] lg:h-[90vh] bg-[#18191A] border-t lg:border-t-0 lg:border-l border-white/10 flex-col text-white transition-all duration-300 z-50">
				<!-- Header with User Details -->
				<div class="p-4 border-b border-white/10 flex items-center justify-between">
					<div class="flex items-center gap-3">
						<img id="viewerUserPic" src="" class="w-10 h-10 rounded-full border-2 border-blue-500 object-cover">
						<div>
							<p id="viewerUserName" class="font-bold text-sm"></p>
							<p class="text-[10px] text-gray-400">Reels Creator</p>
						</div>
					</div>
					<button class="bg-blue-600 hover:bg-blue-700 text-white font-bold text-xs px-4 py-1.5 rounded-full transition">Follow</button>
				</div>
						</div>
					</div>
					<button class="bg-blue-600 hover:bg-blue-700 text-white font-bold text-xs px-4 py-1.5 rounded-full transition">Follow</button>
				</div>

				<!-- Description / Content -->
				<div class="p-4 border-b border-white/10 bg-[#242526]/50">
					<p id="viewerContent" class="text-sm text-gray-200 leading-relaxed"></p>
				</div>

				<!-- Reaction & Stats Panel -->
				<div class="p-4 border-b border-white/10 space-y-3">
					<!-- Granular reaction counts -->
					<div id="viewerReactStats" class="text-xs text-gray-400 flex flex-wrap gap-2">
						<!-- Loaded dynamically: e.g. 👍 5 ❤️ 2 -->
					</div>

					<!-- Actions (Reaction button, share) -->
					<div class="flex gap-4 items-center pt-2">
						<!-- Dynamic Reaction Button (Hover for 8 reactions) -->
						<div class="react-container relative flex-1">
							<button id="viewerReactBtn" onclick="handleReelReact('Like', event)" class="w-full bg-[#242526] hover:bg-[#3A3B3C] py-2 px-4 rounded-xl flex items-center justify-center gap-2 text-sm font-bold border border-white/5 transition-all">
								<i class="fa-regular fa-thumbs-up"></i> Like
							</button>
							<!-- Emojis Picker Box -->
							<div class="react-box !-top-12 !bg-[#242526] border border-white/10 !p-1.5 !rounded-full shadow-2xl gap-2">
								<span title="Like" class="cursor-pointer hover:scale-150 transition-transform text-lg" onclick="handleReelReact('Like', event)">👍</span>
								<span title="Love" class="cursor-pointer hover:scale-150 transition-transform text-lg" onclick="handleReelReact('Love', event)">❤️</span>
								<span title="Care" class="cursor-pointer hover:scale-150 transition-transform text-lg" onclick="handleReelReact('Care', event)">🥰</span>
								<span title="Haha" class="cursor-pointer hover:scale-150 transition-transform text-lg" onclick="handleReelReact('Haha', event)">😆</span>
								<span title="Wow" class="cursor-pointer hover:scale-150 transition-transform text-lg" onclick="handleRe
								<span title="Sad" class="cursor-pointer hover:scale-150 transition-transform text-lg" onclick="handleReelReact('Sad', event)">😢</span>
								<span title="Angry" class="cursor-pointer hover:scale-150 transition-transform text-lg" onclick="handleReelReact('Angry', event)">😡</span>
								<span title="Dislike" class="cursor-pointer hover:scale-150 transition-transform text-lg" onclick="handleReelReact('Dislike', event)">👎</span>
							</div>
						</div>

						<button class="flex-1 bg-[#242526] hover:bg-[#3A3B3C] py-2 px-4 rounded-xl flex items-center justify-center gap-2 text-sm font-bold border border-white/5 transition-all">
							<i class="fa-solid fa-share"></i> Share
						</button>
					</div>
				</div>

				<!-- Comments Section -->
				<div class="flex-1 overflow-y-auto p-4 space-y-4 custom-scrollbar bg-[#18191A]" id="viewerCommentsList">
					<!-- Comments loaded dynamically -->
				</div>

				<!-- Comment Input Area -->
				<div class="p-3 border-t border-white/10 bg-[#242526] flex gap-2 items-center relative">
					<img src="img/${ub.profile_pic}" class="w-8 h-8 rounded-full border border-white/10 object-cover">
					<div class="flex-1 bg-[#3A3B3C] rounded-full px-4 py-2 flex items-center gap-2 border border-white/5">
						<input type="text" id="viewerCommentInput" class="bg-transparent outline-none flex-1 text-sm text-white" placeholder="Write a comment..." onkeydown="if(event.key === 'Enter') submitReelComment()">
						<button onclick="submitReelComment()" class="text-blue-500 hover:scale-110 transition-transform">
							<i class="fa fa-paper-plane"></i>
						</button>
					</div>
				</div>
			</div>
		</div>
	</div>

	<div id="reelsDataContainer" style="display: none;">
		<c:forEach var="reel" items="${reelsList}">
			<div class="reel-data-item" 
				 data-id="${reel.id}"
				 data-video-src="img/${reel.file_name}"
				 data-user-name="<c:out value="${reel.name}"/>"
				 data-user-pic="img/${reel.profile_pic}"
				 data-content="<c:out value="${reel.content}"/>"
				 data-like-count="${reel.likeCount}"
				 data-love-count="${reel.loveCount}"
				 data-care-count="${reel.careCount}"
				 data-haha-count="${reel.hahaCount}"
				 data-wow-count="${reel.wowCount}"
				 data-sad-count="${reel.sadCount}"
				 data-angry-count="${reel.angryCount}"
				 data-dislike-count="${reel.dislikes}"
				 data-comment-count="${reel.commentCount}">
				 <div class="reel-comments-data">
					 <c:forEach var="cmt" items="${reel.comments}">
						 <div class="reel-comment-item"
							  data-id="${cmt.id}"
							  data-name="<c:out value="${cmt.name}"/>"
							  data-profile-pic="${cmt.profilePic}"
							  data-text="<c:out value="${cmt.comment_text}"/>">
						 </div>
					 </c:forEach>
				 </div>
			</div>
		</c:forEach>
	</div>

	<script>
    var contextPath = "${pageContext.request.contextPath}";
    
    // JS array containing all reels parsed safely from DOM
    const reelsData = [];
    document.querySelectorAll('#reelsDataContainer .reel-data-item').forEach(el => {
        const comments = [];
        el.querySelectorAll('.reel-comment-item').forEach(cmtEl => {
            comments.push({
                id: Number(cmtEl.getAttribute('data-id')),
                name: cmtEl.getAttribute('data-name'),
                profilePic: cmtEl.getAttribute('data-profile-pic'),
                text: cmtEl.getAttribute('data-text')
            });
        });
        
        reelsData.push({
            id: Number(el.getAttribute('data-id')),
            videoSrc: el.getAttribute('data-video-src'),
            userName: el.getAttribute('data-user-name'),
            userPic: el.getAttribute('data-user-pic'),
            content: el.getAttribute('data-content'),
            likeCount: Number(el.getAttribute('data-like-count')) || 0,
            loveCount: Number(el.getAttribute('data-love-count')) || 0,
            careCount: Number(el.getAttribute('data-care-count')) || 0,
            hahaCount: Number(el.getAttribute('data-haha-count')) || 0,
            wowCount: Number(el.getAttribute('data-wow-count')) || 0,
            sadCount: Number(el.getAttribute('data-sad-count')) || 0,
            angryCount: Number(el.getAttribute('data-angry-count')) || 0,
            dislikeCount: Number(el.getAttribute('data-dislike-count')) || 0,
            commentCount: Number(el.getAttribute('data-comment-count')) || 0,
            comments: comments
        });
    });

    // --- Live Stream Functions ---
    let liveStream = null;
    let liveInterval = null;
    let liveTimerSeconds = 0;
    let fakeViewers = 0;
    let fakeCommentsInterval = null;
    let mediaRecorder = null;
    let recordedChunks = [];

    function openLiveModal() {
        document.getElementById('liveModal').style.display = 'flex';
        document.body.style.overflow = 'hidden';
    }

    function closeLiveModal() {
        document.getElementById('liveModal').style.display = 'none';
        document.body.style.overflow = 'auto';
        if (liveStream && document.getElementById('endLiveBtn').classList.contains('hidden') == false) {
            endLiveStream();
        }
        
        if (liveStream) {













































































































































































































































































        document.getElementById('liveChatInputArea').classList.add('hidden');
        
        fakeViewers = 0;
    }

    // --- Reels Functions ---
    function openReelModal() {
        const modal = document.getElementById('reelModal');
        if (modal) {
            modal.style.display = 'flex';
            document.body.style.overflow = 'hidden';
        }
    }

    function closeReelModal() {
        const modal = document.getElementById('reelModal');
        if (modal) {
            modal.style.display = 'none';
            document.body.style.overflow = 'auto';
        }
    }

    function previewReel(input) {
        const preview = document.getElementById('reelPreview');
        const video = document.getElementById('reelVideoPreview');
        if (input.files && input.files[0]) {
            const url = URL.createObjectURL(input.files[0]);
            video.src = url;
            preview.classList.remove('hidden');
        }
    }




    // Keyboard listener for Arrow keys and Escape key
    document.addEventListener('keydown', function(event) {
        const viewer = document.getElementById('reelViewer');
        if (viewer && viewer.style.display === 'flex') {
            if (event.key === 'ArrowRight' || event.key === 'ArrowDown') {
                nextReel();



















































































































































































































































































































                    alert("Error sharing comment.");
                });
            }
        }
    }

    // ৪. শেয়ার লজিক (তোর UsersPostServlet এর SHARE একশনের জন্য)
    function shareAJAX(postId) {
        if(!confirm("Share this post?")) return;
        fetch('InteractionServlet', {
            method: 'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: "action=SHARE&postId=" + postId
        })
        .then(res => res.json())
        .then(data => {
            if(data.status === 'shared') {
                alert("Shared Successfully!");
                let shareEl = document.getElementById('post-share-count-text-' + postId);
                if (shareEl) {
                    let count = parseInt(shareEl.innerText) || 0;
                    shareEl.innerText = (count + 1) + " Shares";
        })
        .catch(err => console.error("Share error", err));
    }

    // ৫. নতুন পোস্ট সাবমিট (AJAX)
    document.getElementById('postForm')?.addEventListener('submit', function(e) {
        e.preventDefault();
        let formData = new FormData(this);
        formData.append("ajax", "true");
        
        const btn = this.querySelector('button[type="submit"]');
        const originalText = btn.innerText;
        btn.innerText = "Posting...";
        btn.disabled = true;

        fetch('UsersPostServlet?ajax=true', { method: 'POST', body: formData })
        .then(res => {
            if (!res.ok) {
                throw new Error("HTTP error " + res.status);
            }
            return res.json();
        })
        .then(data => {
            if(data.success) {
                closeModal();
                this.reset();
                removeModalPreview();
                refreshFeed(); // রিলোড ছাড়াই ফিড আপডেট
            } else {
                alert("Post failed!");
            }
        })
        .catch(err => {
            console.error("Post creation error:", err);
            alert("Post creation failed: " + err.message);
        })
        .finally(() => {
            btn.innerText = originalText;
            btn.disabled = false;
        });
    });

    // ৬. রিলস সাবমিট (AJAX)
    document.getElementById('reelForm')?.addEventListener('submit', function(e) {
        e.preventDefault();
        let formData = new FormData(this);
        formData.append("ajax", "true");
        
        const btn = this.querySelector('button[type="submit"]');
        btn.innerText = "Uploading...";
        btn.disabled = true;

        fetch('UsersPostServlet?ajax=true', { method: 'POST', body: formData })
        .then(res => {
            if (!res.ok) throw new Error("HTTP error " + res.status);
            return res.json();
        })
        .then(data => {
            if(data.success) {
                closeReelModal();
                this.reset();
                refreshFeed();
            } else {
                alert("Reel failed!");
            }
        })
        .catch(err => {
            console.error("Reel upload error:", err);
            alert("Reel upload failed: " + err.message);
        })
        .finally(() => {
            btn.innerText = "Share Reel";
            btn.disabled = false;
        });
    });

    // Delete Post Function
    function deletePost(postId) {
        if(!confirm("Are you sure you want to delete this post?")) return;
        
        let formData = new FormData();
        })
        .finally(() => {
            btn.innerText = "Share Reel";
            btn.disabled = false;
        });
    });

    // Delete Post Function
    function deletePost(postId) {
        if(!confirm("Are you sure you want to delete this post?")) return;
        
        let formData = new FormData();
        formData.append("action", "DELETE");
        formData.append("postId", postId);
        formData.append("ajax", "true");

        fetch('UsersPostServlet?ajax=true', { method: 'POST', body: formData })
        .then(res => {
            if (!res.ok) throw new Error("HTTP error " + res.status);
        });
    }

    // ৭. ফিড রিফ্রেশ ফাংশন (No Reload Logic)
    function refreshFeed() {
        fetch('UsersPostServlet')
        .then(res => res.text())
        .then(html => {
            const parser = new DOMParser();
            const doc = parser.parseFromString(html, 'text/html');
            const newMain = doc.querySelector('main').innerHTML;
            document.querySelector('main').innerHTML = newMain;
            // টাইম-এগো এবং অন্যান্য জেএস পুনরায় চালু করার প্রয়োজন হতে পারে
            initTimeAgo(); 
        });
    }

    function initTimeAgo() {
        // যদি আপনার কোনো টাইম-এগো লাইব্রেরি থাকে তবে এখানে কল করুন
        console.log("Feed Refreshed!");
    }

    // ৫. প্রিভিউ এবং টগল ফাংশন
    function showReplyBox(id, targetName) {
        let el = document.getElementById('replyInputContainer-' + id);
        if(el) {
            el.classList.remove('hidden');
            let input = document.getElementById('input-reply-' + id);
            if(input && targetName) {
                input.value = "@" + targetName + " ";
                input.focus();
            let input = document.getElementById('input-reply-' + id);
            if(input && targetName) {
                input.value = "@" + targetName + " ";
                input.focus();
            }
            }
            
            // Repopulate reels JS array
            if (typeof populateReelsData === 'function') {
                populateReelsData();
        .catch(err => {
            console.error("Delete error: ", err);
            window.location.reload();
        });
    }

    // ৭. ফিড রিফ্রেশ ফাংশন (No Reload Logic)
    function refreshFeed() {
        fetch('UsersPostServlet')
        .then(res => res.text())
        .then(html => {
            const parser = new DOMParser();
            const doc = parser.parseFromString(html, 'text/html');
            
            // Update main feed
            const newMain = doc.querySelector('main');
            if (newMain) {
                document.querySelector('main').innerHTML = newMain.innerHTML;
            }
            
            // Update reels data container
            const newReelsContainer = doc.getElementById('reelsDataContainer');
            if (newReelsContainer) {
                const oldReelsContainer = document.getElementById('reelsDataContainer');
                if (oldReelsContainer) {
                    oldReelsContainer.innerHTML = newReelsContainer.innerHTML;
                }
            }
            
            // Repopulate reels JS array
            if (typeof populateReelsData === 'function') {
                populateReelsData();
            }
            
            initTimeAgo(); 
        });
    }

    function initTimeAgo() {
        // যদি আপনার কোনো টাইম-এগো লাইব্রেরি থাকে তবে এখানে কল করুন
        console.log("Feed Refreshed!");
    }

    // ৫. প্রিভিউ এবং টগল ফাংশন
    function showReplyBox(id, targetName) {
        let el = document.getElementById('replyInputContainer-' + id);
        if(el) {
            el.classList.remove('hidden');
            let input = document.getElementById('input-reply-' + id);
            if(input && targetName) {






















































































































































































































        }
    }

    function addEmoji(inputId, emoji) {
        const input = document.getElementById(inputId);

    function closeFeaturesModal() {
        document.getElementById('featuresModal').style.display = 'none';
    }

    function showSavedPostsModal() {
        openFeaturesModal("Saved Posts");
        fetch('FeaturesServlet?action=GET_SAVED')
        .then(res => res.json())
        .then(posts => {
            renderFeaturePosts(posts, "No saved posts yet. Bookmarked posts will appear here!");
        })
        .catch(err => {
            document.getElementById('featuresModalBody').innerHTML = '<p class="text-red-500 text-center">Error loading saved posts.</p>';
        });
    }

    function showMemoriesModal() {
        openFeaturesModal("Throwback Memories");
        fetch('FeaturesServlet?action=GET_MEMORIES')
        .then(res => res.json())
        .then(posts => {
            renderFeaturePosts(posts, "No memories yet. Create some posts to see throwbacks!");
        })
        .catch(err => {
            document.getElementById('featuresModalBody').innerHTML = '<p class="text-red-500 text-center">Error loading memories.</p>';
        });
    }

    function renderFeaturePosts(posts, emptyMessage) {
        const container = document.getElementById('featuresModalBody');
        if (!posts || posts.length === 0) {
            container.innerHTML = '<div class="text-center py-12 text-gray-400"><i class="fa fa-folder-open text-4xl mb-3 text-gray-500"></i><p>' + emptyMessage + '</p></div>';
            return;
        }
        
        let html = '';
        posts.forEach(p => {
            let mediaHtml = '';
            if (p.fileName) {
                if (p.postType === 'video' || p.fileName.endsWith('.webm') || p.fileName.endsWith('.mp4') || p.fileName.endsWith('.mov') || p.fileName.endsWith('.ogg') || p.fileName.endsWith('.avi') || p.fileName.endsWith('.mkv')) {
        .then(res => res.json())
        .then(data => {
            if(data.success) {
                if(action === "SAVE") {
                    btn.innerHTML = '<i class="fa fa-bookmark"></i> Unsave Post';
                    alert("Post Saved successfully!");
                } else {
                    btn.innerHTML = '<i class="fa fa-bookmark"></i> Save Post';
                    alert("Post Unsaved successfully!");
                }
            } else {
                alert("Action failed!");
            }
        })
        .catch(err => {
            console.error("Save error:", err);
            alert("Error processing request");
        });
    }

    function openFeaturesModal(title) {
        document.getElementById('featuresModalTitle').innerText = title;
        document.getElementById('featuresModalBody').innerHTML = '<div class="text-center py-8"><i class="fa fa-spinner animate-spin text-2xl text-blue-500"></i><p class="mt-2 text-gray-400">Loading...</p></div>';
        document.getElementById('featuresModal').style.display = 'flex';
    }

    function closeFeaturesModal() {
        document.getElementById('featuresModal').style.display = 'none';
    }
        videoEl.pause();
        videoEl.src = "";
        
        if (storyTimeout) clearTimeout(storyTimeout);
    }
    
    let currentReelIndex = -1;

    function openReelsFeed() {
        if (reelsData.length > 0) {
            showReelAtIndex(0);
        } else {
            alert("No Reels available to watch!");
        }
    }

    function openReelViewer(reelId) {
        const index = reelsData.findIndex(r => r.id === reelId);
        if (index !== -1) {
            showReelAtIndex(index);
        }
    }

    function showReelAtIndex(index) {
        if (index < 0 || index >= reelsData.length) return;
        currentReelIndex = index;
        const reel = reelsData[index];

        const viewer = document.getElementById('reelViewer');
        const viewerVideo = document.getElementById('viewerVideo');
        
        viewerVideo.src = reel.videoSrc;
        
        // Desktop elements
        document.getElementById('viewerUserName').innerText = reel.userName;
        document.getElementById('viewerUserPic').src = reel.userPic;
        document.getElementById('viewerContent').innerText = reel.content || "";

        // Mobile overlay elements
        document.getElementById('viewerMobileUserName').innerText = reel.userName;
        document.getElementById('viewerMobileUserPic').src = reel.userPic;

        const viewer = document.getElementById('reelViewer');
        const viewerVideo = document.getElementById('viewerVideo');
        
        viewerVideo.src = reel.videoSrc;
        
        // Desktop elements
        document.getElementById('viewerUserName').innerText = reel.userName;
        document.getElementById('viewerUserPic').src = reel.userPic;
        document.getElementById('viewerContent').innerText = reel.content || "";

        // Mobile overlay elements
        document.getElementById('viewerMobileUserName').innerText = reel.userName;
        document.getElementById('viewerMobileUserPic').src = reel.userPic;
        document.getElementById('viewerMobileContent').innerText = reel.content || "";

        // Update counts
        const totalReacts = reel.likeCount + reel.loveCount + reel.careCount + reel.hahaCount + reel.wowCount + reel.sadCount + reel.angryCount + reel.dislikeCount;
        document.getElementById('viewerMobileReactCount').innerText = totalReacts;
        document.getElementById('viewerMobileCommentCount').innerText = reel.commentCount;
        const index = reelsData.findIndex(r => r.id === reelId);
        if (index !== -1) {
            showReelAtIndex(index);
        }
    }

    function showReelAtIndex(index) {
        if (index < 0 || index >= reelsData.length) return;
        currentReelIndex = index;
        const reel = reelsData[index];

        const viewer = document.getElementById('reelViewer');
        const viewerVideo = document.getElementById('viewerVideo');
        
        viewerVideo.src = reel.videoSrc;
        
        // Desktop elements
        document.getElementById('viewerUserName').innerText = reel.userName;
        document.getElementById('viewerUserPic').src = reel.userPic;
        document.getElementById('viewerContent').innerText = reel.content || "";

        // Mobile overlay elements
        document.getElementById('viewerMobileUserName').innerText = reel.userName;
        document.getElementById('viewerMobileUserPic').src = reel.userPic;
        document.getElementById('viewerMobileContent').innerText = reel.content || "";

        // Update counts
        const totalReacts = reel.likeCount + reel.loveCount + reel.careCount + reel.hahaCount + reel.wowCount + reel.sadCount + reel.angryCount + reel.dislikeCount;
        document.getElementById('viewerMobileReactCount').innerText = totalReacts;
        document.getElementById('viewerMobileCommentCount').innerText = reel.commentCount;

        // Render Stats & Reactions
        renderReelReactStats(reel);
        renderReelComments(reel);
        
        viewer.style.display = 'flex';
        document.body.style.overflow = 'hidden'; // Disable scroll under modal

        // Reset like button UI feedback
        document.getElementById('viewerReactBtn').innerHTML = `<i class="fa-regular fa-thumbs-up"></i> Like`;
            showReelAtIndex(index);
        }
    }

    function showReelAtIndex(index) {
        if (index < 0 || index >= reelsData.length) return;
        currentReelIndex = index;
        const reel = reelsData[index];

        const viewer = document.getElementById('reelViewer');
        const viewerVideo = document.getElementById('viewerVideo');
        
        viewerVideo.src = reel.videoSrc;
        
        // Desktop elements
        document.getElementById('viewerUserName').innerText = reel.userName;
        document.getElementById('viewerUserPic').src = reel.userPic;
        document.getElementById('viewerContent').innerText = reel.content || "";

        // Mobile overlay elements
        document.getElementById('view
        // Desktop elements
        document.getElementById('viewerUserName').innerText = reel.userName;
        document.getElementById('viewerUserPic').src = reel.userPic;
        document.getElementById('viewerContent').innerText = reel.content || "";

        // Mobile overlay elements
        document.getElementById('viewerMobileUserName').innerText = reel.userName;
        document.getElementById('viewerMobileUserPic').src = reel.userPic;
        document.getElementById('viewerMobileContent').innerText = reel.content || "";

        // Update counts
        const totalReacts = reel.likeCount + reel.loveCount + reel.careCount + reel.hahaCount + reel.wowCount + reel.sadCount + reel.angryCount + reel.dislikeCount;
        document.getElementById('viewerMobileReactCount').innerText = totalReacts;
        document.getElementById('viewerMobileCommentCount').innerText = reel.commentCount;

        // Render Stats & Reactions
        renderReelReactStats(reel);
        renderReelComments(reel);
        
        viewer.style.display = 'flex';
        document.body.style.overflow = 'hidden'; // Disable scroll under modal

        // Reset like button UI feedback
        document.getElementById('viewerReactBtn').innerHTML = `<i class="fa-regular fa-thumbs-up"></i> Like`;
                viewerVideo.play().catch(err => {
                    console.error("Muted playback also failed:", err);
                });
            });
        }
    }

    function closeReelViewer() {
        document.getElementById('reelViewer').style.display = 'none';
        document.body.style.overflow = 'auto'; // Restore scroll
        
        const videoEl = document.getElementById('viewerVideo');
        videoEl.pause();
        videoEl.src = "";
        currentReelIndex = -1;

        // Restore sidebar classes if it was opened in mobile layout
        const sidebar = document.getElementById('reelSidebar');
        sidebar.classList.add('hidden', 'lg:flex');
        sidebar.classList.remove('flex', 'absolute', 'bottom-0', 'left-0', 'right-0', 'h-[60vh]', 'rounded-t-3xl', 'shadow-2xl', 'animate-slide-in');
    }

    function nextReel(event) {
        if (event) event.stopPropagation();
        if (currentReelIndex < reelsData.length - 1) {
            showReelAtIndex(currentReelIndex + 1);
        } else {
            // Loop back to the first reel
            showReelAtIndex(0);
        }
    }

    function prevReel(event) {
        if (event) event.stopPropagation();
        if (currentReelIndex > 0) {
            showReelAtIndex(currentReelIndex - 1);
        } else {
            // Loop to the last reel
            showReelAtIndex(reelsData.length - 1);
        }
    }

    function renderReelReactStats(reel) {
        const statsContainer = document.getElementById('viewerReactStats');
        let html = '';
        // Render Stats & Reactions
        renderReelReactStats(reel);
        renderReelComments(reel);
        
        viewer.style.display = 'flex';
        document.body.style.overflow = 'hidden'; // Disable scroll under modal

        // Reset like button UI feedback
        document.getElementById('viewerReactBtn').innerHTML = `<i class="fa-regular fa-thumbs-up"></i> Like`;

        // Mobile-friendly play handler
        const playPromise = viewerVideo.play();
        if (playPromise !== undefined) {
            playPromise.catch(error => {
                console.log("Auto-play prevented, playing muted:", error);
                viewerVideo.muted = true;
                viewerVideo.play().catch(err => {
                    console.error("Muted playback also failed:", err);
                });
            });
        }
    }

    function closeReelViewer() {
        document.getElementById('reelViewer').style.display = 'none';
        document.body.style.overflow = 'auto'; // Restore scroll
        
        const videoEl = document.getElementById('viewerVideo');
        videoEl.pause();
        videoEl.src = "";
        currentReelIndex = -1;

        // Restore sidebar classes if it was opened in mobile layout
        const sidebar = document.getElementById('reelSidebar');
        sidebar.classList.add('hidden', 'lg:flex');
        sidebar.classList.remove('flex', 'absolute', 'bottom-0', 'left-0', 'right-0', 'h-[60vh]', 'rounded-t-3xl', 'shadow-2xl', 'animate-slide-in');
    }

    function nextReel(event) {
        if (event) event.stopPropagation();
        if (currentReelIndex < reelsData.length - 1) {
            showReelAtIndex(currentReelIndex + 1);
        } else {
            // Loop back to the first reel
            showReelAtIndex(0);
        }
    }

    function prevReel(event) {
            console.error("Comment error: ", err);
            alert("Error posting comment!");
        });
    }

    function toggleMobileComments() {
        const sidebar = document.getElementById('reelSidebar');
        if (sidebar.classList.contains('hidden')) {
            sidebar.classList.remove('hidden', 'lg:flex');
            sidebar.classList.add('flex', 'absolute', 'bottom-0', 'left-0', 'right-0', 'h-[60vh]', 'rounded-t-3xl', 'shadow-2xl', 'animate-slide-in');
        } else {
            sidebar.classList.add('hidden', 'lg:flex');
            sidebar.classList.remove('flex', 'absolute', 'bottom-0', 'left-0', 'right-0', 'h-[60vh]', 'rounded-t-3xl', 'shadow-2xl', 'animate-slide-in');
        }
    }

    function toggleMobileReactions() {
        handleReelReact('Like');
    }

    // Auto-trigger Reels Feed if URL contains showReels=true parameter
    window.addEventListener('DOMContentLoaded', () => {
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.get('showReels') === 'true') {
            const cleanUrl = window.location.protocol + "//" + window.location.host + window.location.pathname;
            window.history.replaceState({path: cleanUrl}, '', cleanUrl);
            setTimeout(openReelsFeed, 300);
        }
    });
</script>



	<!-- Mobile Bottom Navigation Bar (Visible only on mobile/tablet) -->
	<nav class="lg:hidden fixed bottom-0 left-0 right-0 h-[65px] glass-nav border-t border-white/20 z-[9999] flex justify-around items-center px-4 rounded-t-3xl shadow-2xl">
		<a href="UsersPostServlet" class="flex flex-col items-center gap-1 text-blue-500">
			<i class="fa fa-house text-xl"></i>
			<span class="text-[10px] font-bold">Home</span>
		</a>
		<a href="FriendServlet" class="flex flex-col items-center gap-1 text-gray-500 hover:text-blue-500 transition">
			<i class="fa fa-user-group text-xl"></i>
			<span class="text-[10px] font-bold">Friends</span>
		</a>
		<a href="#" onclick="openReelsFeed(); return false;" class="flex flex-col items-center gap-1 text-gray-500 hover:text-blue-500 transition">
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
        var contextPath = "${pageContext.request.contextPath}";
        if (!myName || myName === "") return;

        var protocol = window.location.protocol === "https:" ? "wss://" : "ws://";
        var host = window.location.host;
        var wsUrl = protocol + host + contextPath + "/ws/user/" + encodeURIComponent(myName);
        var socket = new WebSocket(wsUrl);

        socket.onopen = function() {
            console.log("Global Real-time Notification WebSocket connected.");
        };

        socket.onmessage = function(event) {
            var data = event.data;
            if (data.startsWith("NOTIF|")) {
                var content = data.substring(6);
                showToastNotification(content);
                incrementNotificationBadge();
            } else if (data.startsWith("CHAT|")) {
                var parts = data.split("|", 3);
                var sender = parts[1];























































































































            toast.style.bottom = "20px";
            toast.style.right = "20px";
            toast.style.backgroundColor = "rgba(15, 23, 42, 0.9)";
            toast.style.color = "white";
            toast.style.padding = "16px 24px";
            toast.style.borderRadius = "16px";
            toast.style.boxShadow = "0 10px 25px rgba(0,0,0,0.2)";
            toast.style.zIndex = "999999";
            toast.style.fontFamily = "'Outfit', sans-serif";
            toast.style.fontSize = "14px";
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
        
        for (let i = 0; i < 8; i++) {
            const el = document.createElement('div');
            el.innerText = emoji;
            el.style.position = 'absolute';
            el.style.bottom = '100px';
            const randomX = (Math.random() - 0.5) * 200; 
            el.style.left = `calc(50% + ${randomX}px)`;
            el.style.fontSize = `${24 + Math.random() * 16}px`;
            el.style.opacity = '1';
            el.style.zIndex = '9999';
<script>
    (function() {
        var myName = "${ub.name}";
        var contextPath = "${pageContext.request.contextPath}";
        if (!myName || myName === "") return;

        var protocol = window.location.protocol === "https:" ? "wss://" : "ws://";
        var host = window.location.host;
        var wsUrl = protocol + host + contextPath + "/ws/user/" + encodeURIComponent(myName);
        var socket = new WebSocket(wsUrl);

        socket.onopen = function() {
            console.log("Global Real-time Notification WebSocket connected.");
        };

        socket.onmessage = function(event) {
            var data = event.data;
            if (data.startsWith("NOTIF|")) {
                var content = data.substring(6);
                showToastNotification(content);
                incrementNotificationBadge();





































































































	<!-- Mobile Bottom Navigation Bar (Visible only on mobile/tablet) -->
	<nav class="lg:hidden fixed bottom-0 left-0 right-0 h-[65px] glass-nav border-t border-white/20 z-[9999] flex justify-around items-center px-4 rounded-t-3xl shadow-2xl">
		<a href="UsersPostServlet" class="flex flex-col items-center gap-1 text-blue-500">
			<i class="fa fa-house text-xl"></i>
			<span class="text-[10px] font-bold">Home</span>
		</a>
		<a href="FriendServlet" class="flex flex-col items-center gap-1 text-gray-500 hover:text-blue-500 transition">
			<i class="fa fa-user-group text-xl"></i>
			<span class="text-[10px] font-bold">Friends</span>
		</a>
		<a href="#" onclick="openReelsFeed(); return false;" class="flex flex-col items-center gap-1 text-gray-500 hover:text-blue-500 transition">
			<i class="fa fa-clapperboard text-xl"></i>
			<span class="text-[10px] font-bold">Reels</span>
		</a>
		<a href="#" onclick="openReelModal(); return false;" class="flex flex-col items-center justify-center -mt-5 w-11 h-11 bg-gradient-to-tr from-orange-500 via-pink-500 to-red-500 rounded-full text-white shadow-lg border-2 border-white hover:scale-110 active:scale-95 transition-all" title="Create Reel">
			<i class="fa fa-plus text-lg"></i>
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
        var contextPath = "${pageContext.request.contextPath}";
        if (!myName || myName === "") return;

        var protocol = window.location.protocol === "https:" ? "wss://" : "ws://";






















































































































































































































    function toggleMobileReactions() {
        handleReelReact('Like');
    }

    // Auto-trigger Reels Feed or Create Reel Modal if URL contains parameters
    window.addEventListener('DOMContentLoaded', () => {
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.get('showReels') === 'true') {
            const cleanUrl = window.location.protocol + "//" + window.location.host + window.location.pathname;
            window.history.replaceState({path: cleanUrl}, '', cleanUrl);
            setTimeout(openReelsFeed, 300);
        } else if (urlParams.get('showCreateReel') === 'true') {
            const cleanUrl = window.location.protocol + "//" + window.location.host + window.location.pathname;
            window.history.replaceState({path: cleanUrl}, '', cleanUrl);
            setTimeout(openReelModal, 300);
        }
    });
</script>



	<!-- Mobile Bottom Navigation Bar (Visible only on mobile/tablet) -->
	<nav class="lg:hidden fixed bottom-0 left-0 right-0 h-[65px] glass-nav border-t border-white/20 z-[9999] flex justify-around items-center px-4 rounded-t-3xl shadow-2xl">
		<a href="UsersPostServlet" class="flex flex-col items-center gap-1 text-blue-500">
			<i class="fa fa-house text-xl"></i>
			<span class="text-[10px] font-bold">Home</span>



















			<img src="img/${ub.profile_pic}" class="w-6 h-6 rounded-full border border-gray-300">
			<span class="text-[10px] font-bold">Profile</span>
		</a>
	</nav>

<script>
    (function() {
        var myName = "${ub.name}";
        var contextPath = "${pageContext.request.contextPath}";
        if (!myName || myName === "") return;

        var protocol = window.location.protocol === "https:" ? "wss://" : "ws://";
        var host = window.location.host;
        var wsUrl = protocol + host + contextPath + "/ws/user/" + encodeURIComponent(myName);
        var socket = new WebSocket(wsUrl);

        socket.onopen = function() {
            console.log("Global Real-time Notification WebSocket connected.");
        };

        socket.onmessage = function(event) {
            var data = event.data;
            if (data.startsWith("NOTIF|")) {
                var content = data.substring(6);
                showToastNotification(content);
                incrementNotificationBadge();
            } else if (data.startsWith("CHAT|")) {
                var parts = data.split("|", 3);
                var sender = parts[1];
                var msgText = parts[2];
                showToastNotification("New message from " + sender + ": " + msgText);
                incrementNotificationBadge();
            }
        };

        function showToastNotification(message) {
            var toast = document.createElement("div");
            toast.style.position = "fixed";
            toast.style.bottom = "20px";
            toast.style.right = "20px";
            toast.style.backgroundColor = "rgba(15, 23, 42, 0.9)";
            toast.style.color = "white";
            toast.style.padding = "16px 24px";
            toast.style.borderRadius = "16px";
            toast.style.boxShadow = "0 10px 25px rgba(0,0,0,0.2)";
            toast.style.zIndex = "999999";
            toast.style.fontFamily = "'Outfit', sans-serif";
            toast.style.fontSize = "14px";
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