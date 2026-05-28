var socket;

window.onload = function() {

    if (!myName) return;

    var protocol = window.location.protocol === "https:" ? "wss://" : "ws://";
    var host = window.location.host;
    var wsUrl = protocol + host + contextPath + "/ws/user/" + myName;

    console.log("Connecting to:", wsUrl);

    socket = new WebSocket(wsUrl);

    socket.onopen = function() {
        console.log("WebSocket Connected!");
        document.getElementById("friendListContainer").innerHTML =
            "<p style='padding:15px; color:#999;'>Waiting for users...</p>";
    };

    // ✅ SINGLE onmessage (ALL HANDLED HERE)
    socket.onmessage = function(event) {

        var data = event.data;
        console.log("Server:", data);

        // ONLINE USERS
        if (data.startsWith("ONLINE_USERS|")) {
            var users = data.substring(13).split(",");
            updateFriendList(users);
        }

        // CHAT
        else if (data.startsWith("CHAT|")) {
            var parts = data.split("|", 3);
            var sender = parts[1];
            var msg = parts[2];

            var currentChat = document.getElementById("targetFriendName").value;

            if (currentChat === sender) {
                displayMessage(msg, 'received');
            } else {
                alert("New message from " + sender);
            }
        }

        // NOTIFICATION
    



























































    var msg = msgInput.value.trim();

    if (!friend) {
        alert("Select a friend!");
        return;
    }

    if (msg) {
        socket.send("CHAT|" + friend + "|" + msg);
        displayMessage(msg, 'sent');
        msgInput.value = "";
    }
}

// DISPLAY MESSAGE
function displayMessage(msg, type) {
    var chatBox = document.getElementById("chatBox");

    var div = document.createElement("div");
    div.className = "msg " + type;
    div.innerText = msg;

    chatBox.appendChild(div);
    chatBox.scrollTop = chatBox.scrollHeight;
}

// ================= COMMENT SYSTEM =================

// LIKE / DISLIKE
function commentAction(commentId, action){
    fetch("CommentInteractionServlet",{
        method:"POST",
        headers:{"Content-Type":"application/x-www-form-urlencoded"},
        body:"commentId="+commentId+"&action="+action
    })
    .then(r=>r.json())
    .then(data=>{
        document.getElementById("clike-"+commentId).innerText=data.likes;
        document.getElementById("cdislike-"+commentId).innerText=data.dislikes;
    });
}

// TOGGLE REPLY
function toggleReply(id){
    let box=document.getElementById("replyBox-"+id);
    box.style.display = box.style.display==="none"?"block":"none";
}

// SEND REPLY
function sendReply(commentId){
    let input=document.getElementById("reply-"+commentId);
    let text=input.value.trim();
    if(!text)return;

    fetch("ReplyServlet",{
        method:"POST",
        headers:{"Content-Type":"application/x-www-form-urlencoded"},
        body:"commentId="+commentId+"&replyText="+encodeURIComponent(text)
    }).then(()=>location.reload());
}